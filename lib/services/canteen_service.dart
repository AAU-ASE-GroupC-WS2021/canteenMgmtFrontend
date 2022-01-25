import 'dart:convert';
import '../models/canteen.dart';
import 'abstract_service.dart';


class CanteenService extends AbstractService {
  static final CanteenService _instance = CanteenService._internal();

  factory CanteenService() {
    return _instance;
  }

  CanteenService._internal();

  Future<List<Canteen>> getCanteens() async {
    final response = await get('canteen');

    if (response.statusCode == 200) {
      final stringData = response.body;
      var responseJson = json.decode(stringData);

      return (responseJson as List).map((p) => Canteen.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load canteens');
    }
  }
}
