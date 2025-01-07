import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/station_model.dart';

class StationViewModel extends ChangeNotifier {
  List<StationModel> _stations = [];
  int _lateCount = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  List<StationModel> get stations => _stations;
  int get lateCount => _lateCount;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchNearbyStations(double latitude, double longitude, String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final baseUrl = dotenv.env['BASEURL'] ?? '';
    final url = Uri.parse('$baseUrl/get_nearby_stations');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'latitude': latitude, 'longitude': longitude, 'id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _stations = (data['nearby_stations'] as List)
            .map((station) => StationModel.fromJson(station))
            .toList();
      } else {
        _errorMessage = 'Failed to fetch stations';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchLateCount(String userId) async {
    final baseUrl = dotenv.env['BASEURL'] ?? '';
    final url = Uri.parse('$baseUrl/get_late_count?id=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _lateCount = data['late_count'];
      } else {
        _errorMessage = 'Failed to fetch late count';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    }

    notifyListeners();
  }
}
