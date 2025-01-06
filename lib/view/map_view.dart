import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewModel/map_view_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapViewModel _viewModel = MapViewModel();
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(0, 0); // 초기 위치 예시 N1
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    // 실제로는 Geolocator 등을 사용하여 유저 위치 가져오기
    setState(() {
      _currentPosition = LatLng(36.3741101, 127.3656366); // 예시 위치
    });
  }

  void _onCameraIdle() async {
    if (_mapController == null) return;

    final bounds = await _mapController!.getVisibleRegion();
    await _viewModel.fetchStations(
      bounds.northeast.latitude,
      bounds.southwest.latitude,
      bounds.northeast.longitude,
      bounds.southwest.longitude,
    );

    setState(() {
      _markers = _viewModel.stations.map((station) {
        return Marker(
          markerId: MarkerId(station.st_id),
          position: LatLng(station.st_lat, station.st_lng),
          infoWindow: InfoWindow(
            title: station.st_name,
            snippet: 'Available bikes: ${station.availableBikes}',
          ),
        );
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16.0,
            ),
            markers: _markers,
            onCameraIdle: _onCameraIdle, // 카메라 이동 후 정거장 업데이트
            myLocationEnabled: true,
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
                    onPressed: _searchDestination,
                  ),
                ),
              ),
            ),
          ),
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 100,
              left: 15,
              right: 15,
              child: Container(
                height: 200,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return ListTile(
                      title: Text(result['name'] ?? 'Unknown Place'),
                      onTap: () {
                        final lat = result['geometry']['location']['lat'];
                        final lng = result['geometry']['location']['lng'];
                        _setDestinationMarker(LatLng(lat, lng));
                        setState(() {
                          _searchResults.clear();
                        });
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '길찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: '가야지'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        ],
      ),
    );
  }
  Future<void> _searchDestination() async {
    final searchQuery = _searchController.text;
    if (searchQuery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색어를 입력하세요')),
      );
      return;
    }

    try {
      List<Map<String, dynamic>> results = await _getSearchResults(searchQuery);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('목적지를 찾을 수 없습니다.')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _getSearchResults(String searchQuery) async {
    final String apiKey = 'AIzaSyA'; // Google Places API 키
    final String url = 'https://places.googleapis.com/v1/places:searchText?fields=formatted_address,geometry&key=$apiKey';
    // final response = await http.get(Uri.parse(url));
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer -_5w-9meFz2m03hzhVaWoHX_c_u-8G-2FL87UopqMrfWtNqszzr6LCMz12bmkmPoJG_2f47vZOcQSsi3ZwsqiHATFPiMzwiGuTfUIrcOp9kJyG5_kNL2VaCgYKAfISARISFQHGX2MiDfndisFIRAYRuioLzOnX6Q0175',
      },
      body: jsonEncode({
        'textQuery': searchQuery,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('No results found');
      }
    } else {
      throw Exception('Failed to fetch search results');
    }
  }

  void _setDestinationMarker(LatLng destination) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('destination'),
        position: destination,
        infoWindow: InfoWindow(title: '목적지'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));

      _mapController?.animateCamera(CameraUpdate.newLatLng(destination));
    });
  }
}
