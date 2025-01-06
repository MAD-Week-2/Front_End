import '../service/bikeStation_service.dart';
import '../model/map.dart';
import 'package:flutter/material.dart';

class MapViewModel extends ChangeNotifier { // ChangeNotifier 상속
  final StationService _stationService = StationService();

  List<Station> _stations = [];
  List<Station> get stations => _stations;

  Future<void> fetchStations(double north, double south, double east, double west) async {
    try {
      _stations = await _stationService.getStations(north, south, east, west);
      notifyListeners(); // 상태 변경 시 호출
    } catch (e) {
      print('Error fetching stations: $e');
    }
  }
}
