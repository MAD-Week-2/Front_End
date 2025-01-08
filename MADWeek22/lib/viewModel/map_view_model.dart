import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/station_model.dart'; // 모델 클래스 정의

class MapViewModel extends ChangeNotifier {
  List<StationModel> _stations = [];
  List<StationModel> _visibleStations = []; // 현재 보이는 스테이션 데이터
  bool _isLoading = false;

  List<StationModel> get visibleStations => _visibleStations;
  bool get isLoading => _isLoading;

  /// 지도 범위 내 자전거 정류소 정보를 가져오는 함수 (더미 데이터 사용)
  Future<void> fetchAllStations() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 더미 데이터 생성
      final List<StationModel> dummyData = [
        StationModel(
          id: '1',
          latitude: 36.373505,
          longitude: 127.365859,
          availableBikes: 15,
        ),//N1
        StationModel(
          id: '2',
          latitude: 36.3689900,
          longitude: 127.36524220,
          availableBikes: 8,
        ),//정보전자공학동
        StationModel(
          id: '3',
          latitude: 36.3711910,
          longitude: 127.3661100,
          availableBikes: 5,
        ),//세종관
        StationModel(
          id: "4",
          latitude: 36.36618840,
          longitude: 127.36388010,
          availableBikes: 5
        ),//정문
        StationModel(
          id: "5",
          latitude: 36.37036950,
          longitude: 127.36258340,
          availableBikes: 12
        ),//창의학습관
        StationModel(
          id: "6",
          latitude: 36.37370810,
          longitude: 127.35922140,
          availableBikes: 18
        ),//카이마루
        StationModel(
          id: "7",
          latitude: 36.36826100,
          longitude: 127.35694030,
          availableBikes: 3
        ),//다솜관
      ];

      _stations = dummyData;
      print('Fetched ${_stations.length} stations (dummy data)');
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // VisibleRegion에 따라 스테이션 필터링
  void filterStationsByBounds(LatLngBounds bounds) {
    _visibleStations = _stations.where((station) {
      return station.latitude >= bounds.southwest.latitude &&
          station.latitude <= bounds.northeast.latitude &&
          station.longitude >= bounds.southwest.longitude &&
          station.longitude <= bounds.northeast.longitude;
    }).toList();
    notifyListeners();
  }
}
