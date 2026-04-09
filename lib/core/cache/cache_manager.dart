// lib/core/cache/cache_manager.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple in-memory cache manager with TTL support
class CacheManager<T> {
  final Map<String, CacheEntry<T>> _cache = {};
  final Duration defaultTTL;
  final int maxSize;

  CacheManager({
    this.defaultTTL = const Duration(minutes: 10),
    this.maxSize = 100,
  });

  /// Get cached value if exists and not expired
  T? get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    
    return entry.value;
  }

  /// Set cache value with optional custom TTL
  void set(String key, T value, {Duration? ttl}) {
    // Implement LRU eviction if cache is full
    if (_cache.length >= maxSize) {
      _evictOldest();
    }
    
    _cache[key] = CacheEntry(
      value: value,
      expiresAt: DateTime.now().add(ttl ?? defaultTTL),
    );
  }

  /// Check if key exists and not expired
  bool has(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    
    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    
    return true;
  }

  /// Clear specific key
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
  }

  /// Clear expired entries
  void clearExpired() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }

  /// Get cache size
  int get size => _cache.length;

  /// Evict oldest entry (LRU)
  void _evictOldest() {
    if (_cache.isEmpty) return;
    
    // Find oldest entry by expiration time
    String? oldestKey;
    DateTime? oldestTime;
    
    _cache.forEach((key, entry) {
      if (oldestTime == null || entry.expiresAt.isBefore(oldestTime!)) {
        oldestKey = key;
        oldestTime = entry.expiresAt;
      }
    });
    
    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }
}

/// Cache entry with expiration
class CacheEntry<T> {
  final T value;
  final DateTime expiresAt;

  CacheEntry({
    required this.value,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// Global cache providers
final restaurantCacheProvider = Provider((ref) {
  return CacheManager<dynamic>(
    defaultTTL: Duration(minutes: 10),
    maxSize: 100,
  );
});

final suggestionCacheProvider = Provider((ref) {
  return CacheManager<dynamic>(
    defaultTTL: Duration(minutes: 5),
    maxSize: 50,
  );
});
