import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/map.dart';

class StationService {
  final String _baseUrl = dotenv.env['BASEURL'] ?? '';

  Future<List<Station>> getStations(double north, double south, double east, double west) async {
    final url = Uri.parse('$_baseUrl/stations');
    print(url);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'north': north,
          'south': south,
          'east': east,
          'west': west,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Station.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
