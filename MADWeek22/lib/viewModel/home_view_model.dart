import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/home.dart';

class HomeViewModel extends ChangeNotifier {
  HomeModel _bikeInfo = HomeModel(availableBikes: 0, totalBikes: 0, location: '');
  bool _isNearbyStationsLoading = false; // 변경: NearbyStations 로딩 상태
  bool _isLateCountLoading = false; // 변경: LateCount 로딩 상태
  int _lateCount = 0;

  HomeModel get bikeInfo => _bikeInfo;
  bool get isNearbyStationsLoading => _isNearbyStationsLoading;
  bool get isLateCountLoading => _isLateCountLoading;
  int get lateCount => _lateCount;

  Future<void> fetchNearbyStations() async {
    _isNearbyStationsLoading = true;
    notifyListeners();

    try {
      final String baseUrl = dotenv.env['BASEURL'] ?? '';
      final url = Uri.parse('$baseUrl/get_nearby_stations');
      print('Request URL: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": 1,
          "latitude": 36.3741101,
          "longitude": 127.3656366,
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final nearbyStation = data['nearby_stations'][0];
        print('Nearby Station Data: $nearbyStation');

        _bikeInfo = HomeModel.fromJson(nearbyStation);
        print('Updated Bike Info: $_bikeInfo');
      } else {
        throw Exception('Failed to load nearby stations: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      _isNearbyStationsLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchLateCount() async {
    _isLateCountLoading = true;
    notifyListeners();

    try {
      final String baseUrl = dotenv.env['BASEURL'] ?? '';
      final url = Uri.parse('$baseUrl/get_late_count?user_id=1');
      print('Request URL: $url');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '69420',},
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _lateCount = data['late_count'];
      } else {
        throw Exception('Failed to load late count: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLateCountLoading = false;
      notifyListeners();
    }
  }

  bool get isLoading => _isNearbyStationsLoading || _isLateCountLoading;
}
