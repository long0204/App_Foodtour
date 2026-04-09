import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkInfo {
  final Connectivity _connectivity;
  final InternetConnectionChecker _connectionChecker;

  NetworkInfo({
    Connectivity? connectivity,
    InternetConnectionChecker? connectionChecker,
  })  : _connectivity = connectivity ?? Connectivity(),
        _connectionChecker = connectionChecker ?? InternetConnectionChecker.instance;

  Future<bool> get isConnected async {
    try {
      final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
        return false;
      }

      return await _connectionChecker.hasConnection;
    } catch (e) {
      print('❌ Error checking network: $e');
      return false;
    }
  }

  Future<ConnectivityResult> get connectivityType async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      return results.isNotEmpty ? results.first : ConnectivityResult.none;
    } catch (e) {
      print('❌ Error getting connectivity type: $e');
      return ConnectivityResult.none;
    }
  }

  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) =>
    results.isNotEmpty ? results.first : ConnectivityResult.none
    );
  }

  Future<bool> get isConnectedToWiFi async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }

  Future<bool> get isConnectedToMobile async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile);
  }
}

final networkInfo = NetworkInfo();