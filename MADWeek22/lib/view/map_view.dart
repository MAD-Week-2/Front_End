import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../viewModel/map_view_model.dart';
import '../model/station_model.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;

  LatLng _initialPosition = LatLng(36.3741101, 127.3656366);
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];
  Polyline? _routePolyline;
  String _totalDistance = '';

  @override
  void initState() {
    super.initState();
  }

  void _fetchStations(MapViewModel viewModel) {
    if (_mapController != null) {
      _mapController!.getVisibleRegion().then((bounds) async {
        await viewModel.fetchStationsInBounds(
          southWestLat: bounds.southwest.latitude,
          southWestLng: bounds.southwest.longitude,
          northEastLat: bounds.northeast.latitude,
          northEastLng: bounds.northeast.longitude,
        );
        _updateMarkers(viewModel.stations);
      });
    }
  }

  void _updateMarkers(List<StationModel> stations) async {
    Set<Marker> newMarkers = {};

    for (var station in stations) {
      final customMarker = await createCustomMarkerBitmap(
          station.availableBikes.toString());

      newMarkers.add(
        Marker(
          markerId: MarkerId(station.id),
          position: LatLng(station.latitude, station.longitude),
          icon: customMarker, // 커스텀 마커 설정
          infoWindow: InfoWindow(
            title: 'Available Bikes: ${station.availableBikes}',
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              _fetchStations(viewModel); // 맵 생성 후 데이터 로드
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 16.0,
            ),
            markers: _markers,
            polylines: _routePolyline != null ? {_routePolyline!} : {},
            zoomControlsEnabled: true,
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '목적지 검색',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchRoute,
                  ),
                ),
              ),
            ),
          ),
          if (_totalDistance.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '총 거리: $_totalDistance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap(String label) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..color = Colors.blue;

    const double size = 80; // 마커 크기
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final ui.Image image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> _searchRoute() async {
    final destination = _searchController.text;
    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('목적지를 입력하세요')),
      );
      return;
    }

    try {
      final destinationLatLng = await _getLatLngFromPlaceName(destination);
      final routeData = await _getWalkingRoute(_initialPosition, destinationLatLng);

      setState(() {
        _polylineCoordinates = routeData['polyline'];
        _totalDistance = routeData['distance'];
        _routePolyline = Polyline(
          polylineId: PolylineId('route'),
          points: _polylineCoordinates,
          color: Colors.blue,
          width: 5,
        );

        _markers = {
          Marker(markerId: MarkerId('start'), position: _initialPosition),
          Marker(markerId: MarkerId('end'), position: destinationLatLng),
        };
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(_getBounds(_polylineCoordinates), 50),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('경로를 찾을 수 없습니다.')),
      );
    }
  }

  Future<LatLng> _getLatLngFromPlaceName(String placeName) async {
    final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(placeName)}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      } else {
        throw Exception('Place not found');
      }
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  Future<Map<String, dynamic>> _getWalkingRoute(LatLng origin, LatLng destination) async {
    const String tmapUrl = 'https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1';
    final String tmapApiKey = dotenv.env['TMAP_API_KEY']!;

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'appKey': tmapApiKey,
    };

    final body = jsonEncode({
      "startX": origin.longitude,
      "startY": origin.latitude,
      "endX": destination.longitude,
      "endY": destination.latitude,
      "reqCoordType": "WGS84GEO",
      "resCoordType": "WGS84GEO",
      "startName": "출발지",
      "endName": "목적지",
    });

    final response = await http.post(Uri.parse(tmapUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['features'] != null && data['features'].isNotEmpty) {
        List<LatLng> polyline = [];
        String totalDistance = '';

        for (var feature in data['features']) {
          final geometry = feature['geometry'];
          if (geometry['type'] == 'LineString') {
            final coordinates = geometry['coordinates'];
            for (var coord in coordinates) {
              polyline.add(LatLng(coord[1], coord[0]));
            }
          } else if (geometry['type'] == 'Point' &&
              feature['properties']['pointType'] == 'SP') {
            totalDistance = feature['properties']['totalDistance'].toString();
          }
        }

        return {'polyline': polyline, 'distance': '${totalDistance}m'};
      } else {
        throw Exception('No route found');
      }
    } else {
      throw Exception('Failed to fetch walking route');
    }
  }

  LatLngBounds _getBounds(List<LatLng> coordinates) {
    double? minLat, maxLat, minLng, maxLng;

    for (LatLng coord in coordinates) {
      if (minLat == null || coord.latitude < minLat) minLat = coord.latitude;
      if (maxLat == null || coord.latitude > maxLat) maxLat = coord.latitude;
      if (minLng == null || coord.longitude < minLng) minLng = coord.longitude;
      if (maxLng == null || coord.longitude > maxLng) maxLng = coord.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }
}
