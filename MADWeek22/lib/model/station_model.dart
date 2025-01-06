class StationModel {
  final String stationName;
  final int availableBikes;
  final int capacity;

  StationModel({
    required this.stationName,
    required this.availableBikes,
    required this.capacity,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      stationName: json['station_name'],
      availableBikes: json['available_bikes'],
      capacity: json['capacity'],
    );
  }
}
