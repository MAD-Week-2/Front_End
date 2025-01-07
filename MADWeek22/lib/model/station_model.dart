class StationModel {
  final String id;
  final double latitude;
  final double longitude;
  final int availableBikes;

  StationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.availableBikes,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      availableBikes: json['available_bikes'],
    );
  }
}
