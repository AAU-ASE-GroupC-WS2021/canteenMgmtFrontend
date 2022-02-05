import 'dart:convert';
import '../models/canteen.dart';
import 'abstract_service.dart';


class CanteenService extends AbstractService {
  Future<List<Canteen>> getCanteens() async {
    final response = await get('api/canteen');

    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));

      return (responseJson as List).map((p) => Canteen.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load canteens');
    }
  }

  Future<Canteen> createCanteen(Canteen canteen) async {
    final response = await post('api/canteen', jsonEncode(canteen));

    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));

      return Canteen.fromJson(responseJson);
    } else {
      throw Exception('Failed to create canteen');
    }
  }

  Future<Canteen> updateCanteen(Canteen canteen) async {
    final response = await put('api/canteen/'+canteen.id.toString(), jsonEncode(canteen));

    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));

      return Canteen.fromJson(responseJson);
    } else {
      throw Exception('Failed to update canteen');
    }
  }
}
