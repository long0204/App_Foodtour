import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fetchAndSaveOnboardingData(String username) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(username).get();
  final data = doc.data();
  if (data == null) return;

  final prefs = await SharedPreferences.getInstance();

  if (data['start_date'] != null) {
    await prefs.setString('start_date', data['start_date']);
  }

  if (data['avatar_left_url'] != null) {
    final leftPath = await _downloadImageToFile(data['avatar_left_url'], '${username}_left.jpg');
    await prefs.setString('avatar_left', leftPath);
  }

  if (data['avatar_right_url'] != null) {
    final rightPath = await _downloadImageToFile(data['avatar_right_url'], '${username}_right.jpg');
    await prefs.setString('avatar_right', rightPath);
  }
}

Future<String> _downloadImageToFile(String url, String filename) async {
  final response = await http.get(Uri.parse(url));
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/$filename');
  await file.writeAsBytes(response.bodyBytes);
  return file.path;
}
