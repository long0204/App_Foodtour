import 'dart:convert';

import 'package:Foodtour/config/constants/env.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<List<Map<String, dynamic>>> fetchGoogleSheetItems() async {
  const String range = 'Sheet1!A3:E1000';
  final url = Uri.parse(
      '${ENV.url}/${ENV.spreadsheetId}/values/$range?key=${ENV.apiKey}');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final List<List<dynamic>> rows = List<List<dynamic>>.from(json['values']);

    return rows.map((row) {
      return {
        "STT": row.isNotEmpty ? row[0] : '',
        "Loại": row.length > 1 ? row[1] : '',
        "Tên quán": row.length > 2 ? row[2] : '',
        "Địa chỉ": row.length > 3 ? row[3] : '',
        "Giá": row.length > 4 ? row[4] : '',
      };
    }).toList();
  } else {
    throw Exception('Không load được dữ liệu từ Google Sheets');
  }
}
Future<LatLng?> getCoordinatesFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return LatLng(locations.first.latitude, locations.first.longitude);
    }
  } catch (e) {
    print("Lỗi chuyển đổi địa chỉ: $e");
  }
  return null;
}
