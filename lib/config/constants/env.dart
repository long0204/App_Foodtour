import 'package:flutter_dotenv/flutter_dotenv.dart';

class ENV {
  ENV._();

  // API Configuration
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://foodend.onrender.com/api';
  static String get baseImageUrl => dotenv.env['BASE_IMAGE_URL'] ?? 'https://s3.ap-southeast-1.amazonaws.com/storage.dinos.vn';

  // Google Sheets API
  static String get spreadsheetId => dotenv.env['SPREADSHEET_ID'] ?? '';
  static String get apiKey => dotenv.env['GOOGLE_SHEETS_API_KEY'] ?? '';
  static String get url => dotenv.env['GOOGLE_SHEETS_URL'] ?? 'https://sheets.googleapis.com/v4/spreadsheets';
  static String get urlscripts => dotenv.env['GOOGLE_SCRIPTS_URL'] ?? '';

  // Appwrite Configuration
  static String get appwriteProjectId => dotenv.env['APPWRITE_PROJECT_ID'] ?? 'foodtour-9112d';
  static String get appwriteProjectName => dotenv.env['APPWRITE_PROJECT_NAME'] ?? 'Foodtour';
  static String get appwritePublicEndpoint => dotenv.env['APPWRITE_ENDPOINT'] ?? 'https://sgp.cloud.appwrite.io/v1';

  // Legacy aliases (for backward compatibility)
  static String get ProUrl => baseUrl;
}
