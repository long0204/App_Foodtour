// lib/core/network/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Service để check network connectivity
class NetworkInfo {
  final Connectivity _connectivity;
  final InternetConnectionChecker _connectionChecker;

  NetworkInfo({
    Connectivity? connectivity,
    InternetConnectionChecker? connectionChecker,
  })  : _connectivity = connectivity ?? Connectivity(),
        _connectionChecker = connectionChecker ?? InternetConnectionChecker();

  /// Check if device has internet connection
  Future<bool> get isConnected async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      
      // If no connectivity, return false immediately
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      // Check actual internet connection (not just wifi/mobile connected)
      return await _connectionChecker.hasConnection;
    } catch (e) {
      print('❌ Error checking network: $e');
      return false;
    }
  }

  /// Get current connectivity type
  Future<ConnectivityResult> get connectivityType async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      print('❌ Error getting connectivity type: $e');
      return ConnectivityResult.none;
    }
  }

  /// Stream of connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  /// Check if connected to WiFi
  Future<bool> get isConnectedToWiFi async {
    final result = await connectivityType;
    return result == ConnectivityResult.wifi;
  }

  /// Check if connected to Mobile data
  Future<bool> get isConnectedToMobile async {
    final result = await connectivityType;
    return result == ConnectivityResult.mobile;
  }
}

// Global instance
final networkInfo = NetworkInfo();
