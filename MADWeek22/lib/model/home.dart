import 'dart:convert';

class HomeModel {
  final int availableBikes;
  final int totalBikes; // capacity로 변경
  final String location;

  HomeModel({
    required this.availableBikes,
    required this.totalBikes,
    required this.location,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      availableBikes: json['available_bikes'] ?? 0,
      totalBikes: json['capacity'] ?? 0, // capacity 데이터 추가
      location: json['station_name'] ?? '',
    );
  }
}
