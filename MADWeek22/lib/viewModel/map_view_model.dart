import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/station_model.dart'; // 모델 클래스 정의

class MapViewModel extends ChangeNotifier {
  List<StationModel> _stations = [];
  bool _isLoading = false;

  List<StationModel> get stations => _stations;
  bool get isLoading => _isLoading;

  /// 지도 범위 내 자전거 정류소 정보를 가져오는 함수
  Future<void> fetchStationsInBounds({
    required double southWestLat,
    required double southWestLng,
    required double northEastLat,
    required double northEastLng,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final String baseUrl = dotenv.env['BASEURL'] ?? '';
      final url = Uri.parse('$baseUrl/get_stations_in_bounds');

      print('Request URL: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "latitude": southWestLat,
          "longitude": southWestLng
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final stationList = data['stations'] as List;

        _stations = stationList.map((json) => StationModel.fromJson(json)).toList();
        print('Fetched Stations: $_stations');
      } else {
        throw Exception('Failed to load stations: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
