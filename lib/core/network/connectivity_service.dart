// lib/core/network/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to monitor network connectivity
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  
  final _controller = StreamController<bool>.broadcast();
  bool _isOnline = true;

  ConnectivityService() {
    _init();
  }

  /// Initialize connectivity monitoring
  Future<void> _init() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isOnline = _isConnected(result);
    _controller.add(_isOnline);

    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final wasOnline = _isOnline;
      _isOnline = _isConnected(results);
      
      // Only emit if status changed
      if (wasOnline != _isOnline) {
        _controller.add(_isOnline);
        print(_isOnline ? '✅ Back online' : '❌ Offline');
      }
    });
  }

  /// Check if connected
  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) => 
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet
    );
  }

  /// Get current connectivity status
  bool get isOnline => _isOnline;

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Dispose
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

/// Connectivity provider
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Stream provider for connectivity status
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

/// Simple provider for current status
final isOnlineProvider = Provider<bool>((ref) {
  final asyncStatus = ref.watch(connectivityStatusProvider);
  return asyncStatus.when(
    data: (isOnline) => isOnline,
    loading: () => true, // Assume online while loading
    error: (_, __) => true, // Assume online on error
  );
});
