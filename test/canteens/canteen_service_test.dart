import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/services/canteen_service.dart';
import 'package:canteen_mgmt_frontend/services/util/key_value_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Future<void> main() async {
  GetIt.I.registerSingleton(KeyValueStore());
  const _someCanteen =
      Canteen(address: 'SomeAddress', name: 'SomeCanteen', numTables: 44);
  const String _getCanteensBody =
      '[{"id":1,"name":"MyCanteen1","address":"MyAddress1","numTables":11}, {"id":2,"name":"MyCanteen2","address":"MyAddress2","numTables":22}]';
  const String _createCanteenBody =
      '{"id":1,"name":"MyCanteen1","address":"MyAddress1","numTables":11}';
  const String _updateCanteenBody =
      '{"id":1,"name":"MyCanteen1","address":"MyAddress1","numTables":11}';

  final MockClient client = MockClient((request) async {
    if (request.method == 'GET') return http.Response(_getCanteensBody, 200);
    if (request.method == 'POST') return http.Response(_createCanteenBody, 200);
    if (request.method == 'PUT') return http.Response(_updateCanteenBody, 200);
    return http.Response('', 404);
  });
  GetIt.I.registerLazySingleton<http.Client>(() => client);

  final CanteenService service = CanteenService();

  test(
    'When get canteens then return list of canteen objects',
    () async {
      List<Canteen> canteens = await service.getCanteens();
      expect(canteens.length, 2);
    },
  );

  test(
    'When create canteen then return created canteen with id',
    () async {
      Canteen canteen = await service.createCanteen(_someCanteen);
      expect(canteen.id, isNot(-1));
    },
  );

  test(
    'When update canteen then return created canteen  with id',
    () async {
      String? urlParam;
      var service =
          _getServiceWithMockClient(client, MockClient((request) async {
        if (request.method == 'PUT') {
          urlParam = request.url.pathSegments.last;
          return http.Response(_updateCanteenBody, 200);
        }
        return http.Response('', 404);
      }));

      Canteen canteen = await service.updateCanteen(_someCanteen);
      expect(canteen.id, isNot(-1));
      expect(urlParam, _someCanteen.id.toString());
    },
  );

  test(
    'When receive error status then throw exception',
    () async {
      CanteenService errorService = _getErrorService(client);
      expect(() => errorService.getCanteens(), throwsA(isA<Exception>()));
      expect(
        () => errorService.createCanteen(_someCanteen),
        throwsA(isA<Exception>()),
      );
      expect(
        () => errorService.updateCanteen(_someCanteen),
        throwsA(isA<Exception>()),
      );
    },
  );
}

CanteenService _getServiceWithMockClient(
  http.Client originalClient,
  MockClient mockClient,
) {
  GetIt.I.unregister<http.Client>();
  GetIt.I.registerLazySingleton<http.Client>(() => mockClient);
  CanteenService errorService = CanteenService();
  GetIt.I.unregister<http.Client>();
  GetIt.I.registerLazySingleton<http.Client>(() => originalClient);
  return errorService;
}

CanteenService _getErrorService(http.Client originalClient) {
  final MockClient errorClient = MockClient((request) async {
    if (request.method == 'GET') return http.Response('', 500);
    if (request.method == 'POST') return http.Response('', 500);
    if (request.method == 'PUT') return http.Response('', 500);
    return http.Response('', 500);
  });
  return _getServiceWithMockClient(originalClient, errorClient);
}
