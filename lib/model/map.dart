class Station {
  final String st_id;
  final String st_name;
  final double st_lat;
  final double st_lng;
  final int availableBikes;

  Station({
    required this.st_id,
    required this.st_name,
    required this.st_lat,
    required this.st_lng,
    required this.availableBikes,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      st_id: json['station_id'],
      st_name: json['station_name'],
      st_lat: json['location_lat'],
      st_lng: json['location_lng'],
      availableBikes: json['available_bikes'],
    );
  }
}
