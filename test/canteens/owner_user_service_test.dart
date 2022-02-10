import 'package:canteen_mgmt_frontend/models/users/user.dart';
import 'package:canteen_mgmt_frontend/services/util/key_value_store.dart';
import 'package:canteen_mgmt_frontend/services/owner_user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Future<void> main() async {
  GetIt.I.registerSingleton(KeyValueStore());
  const _someUser = User(
    id: 4,
    username: 'someUsername',
    password: 'somePassword',
    type: UserType.USER,
    canteenID: 3,
  );
  const String _getUsersBody =
      '[{"id":11,"username":"user8","type":"USER","canteenID":null},{"id":12,"username":"user9","type":"USER","canteenID":3}]';
  const String _createUserBody =
      '{"id":11,"username":"user8","type":"USER","canteenID":null}';
  const String _updateUserBody =
      '{"id":11,"username":"user8","type":"USER","canteenID":null}';

  final MockClient client = MockClient((request) async {
    if (request.method == 'GET') return http.Response(_getUsersBody, 200);
    if (request.method == 'POST') return http.Response(_createUserBody, 200);
    if (request.method == 'PUT') return http.Response(_updateUserBody, 200);
    return http.Response('', 404);
  });
  GetIt.I.registerLazySingleton<http.Client>(() => client);

  final OwnerUserService service = OwnerUserService();
  test(
    'When get users then return list of canteen objects',
    () async {
      List<User> users = await service.getAllUsers();
      expect(users.length, 2);
    },
  );

  test(
    'When get users by canteen then return list of canteen objects and set query param correctly',
    () async {
      String? queryParam;
      var service =
          _getServiceWithMockClient(client, MockClient((request) async {
        if (request.method == 'GET') {
          queryParam = request.url.queryParameters['canteenID'];
          return http.Response(_getUsersBody, 200);
        }
        return http.Response('', 404);
      }));

      const canteenID = 1;
      List<User> users = await service.getAllByCanteen(canteenID);
      expect(users.length, 2);
      expect(queryParam, canteenID.toString());
    },
  );

  test(
    'When get users by type then return list of canteen objects and set query param correctly',
    () async {
      String? queryParam;
      var service =
          _getServiceWithMockClient(client, MockClient((request) async {
        if (request.method == 'GET') {
          queryParam = request.url.queryParameters['type'];
          return http.Response(_getUsersBody, 200);
        }
        return http.Response('', 404);
      }));

      List<User> users = await service.getAllByType(UserType.USER);
      expect(users.length, 2);
      expect(queryParam, _someUser.type.name);
    },
  );

  test(
    'When get users by canteen and type then return list of canteen objects and set query param correctly',
    () async {
      String? queryParamID;
      String? queryParamType;
      var service =
          _getServiceWithMockClient(client, MockClient((request) async {
        if (request.method == 'GET') {
          queryParamID = request.url.queryParameters['canteenID'];
          queryParamType = request.url.queryParameters['type'];
          return http.Response(_getUsersBody, 200);
        }
        return http.Response('', 404);
      }));

      const canteenID = 1;
      List<User> users =
          await service.getAllByTypeAndCanteen(UserType.USER, canteenID);
      expect(users.length, 2);
      expect(queryParamID, canteenID.toString());
      expect(queryParamType, _someUser.type.name);
    },
  );

  test(
    'When create user then return created user with id',
    () async {
      User user = await service.createUser(_someUser);
      expect(user.id, isNot(-1));
    },
  );

  test(
    'When update user then return created user with id',
    () async {
      String? urlParam;
      var service =
          _getServiceWithMockClient(client, MockClient((request) async {
        if (request.method == 'PUT') {
          urlParam = request.url.pathSegments.last;
          return http.Response(_updateUserBody, 200);
        }
        return http.Response('', 404);
      }));

      User user = await service.updateUser(_someUser);
      expect(user.id, isNot(-1));
      expect(urlParam, _someUser.id.toString());
    },
  );

  test(
    'When receive error status then throw exception',
    () async {
      OwnerUserService errorService = _getErrorService(client);
      expect(() => errorService.getAllUsers(), throwsA(isA<Exception>()));
      expect(
        () => errorService.createUser(_someUser),
        throwsA(isA<Exception>()),
      );
      expect(
        () => errorService.updateUser(_someUser),
        throwsA(isA<Exception>()),
      );
    },
  );
}

OwnerUserService _getServiceWithMockClient(
  http.Client originalClient,
  MockClient mockClient,
) {
  GetIt.I.unregister<http.Client>();
  GetIt.I.registerLazySingleton<http.Client>(() => mockClient);
  OwnerUserService errorService = OwnerUserService();
  GetIt.I.unregister<http.Client>();
  GetIt.I.registerLazySingleton<http.Client>(() => originalClient);
  return errorService;
}

OwnerUserService _getErrorService(http.Client originalClient) {
  final MockClient errorClient = MockClient((request) async {
    if (request.method == 'GET') return http.Response('', 500);
    if (request.method == 'POST') return http.Response('', 500);
    if (request.method == 'PUT') return http.Response('', 500);
    return http.Response('', 500);
  });
  return _getServiceWithMockClient(originalClient, errorClient);
}
