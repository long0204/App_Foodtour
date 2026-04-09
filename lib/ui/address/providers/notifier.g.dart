// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$restaurantReviewsHash() => r'ae199028741e2c47a17e681b80a30a7798c53df0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$RestaurantReviews
    extends BuildlessAutoDisposeAsyncNotifier<List<Review>> {
  late final String restaurantId;

  FutureOr<List<Review>> build(
    String restaurantId,
  );
}

/// See also [RestaurantReviews].
@ProviderFor(RestaurantReviews)
const restaurantReviewsProvider = RestaurantReviewsFamily();

/// See also [RestaurantReviews].
class RestaurantReviewsFamily extends Family<AsyncValue<List<Review>>> {
  /// See also [RestaurantReviews].
  const RestaurantReviewsFamily();

  /// See also [RestaurantReviews].
  RestaurantReviewsProvider call(
    String restaurantId,
  ) {
    return RestaurantReviewsProvider(
      restaurantId,
    );
  }

  @override
  RestaurantReviewsProvider getProviderOverride(
    covariant RestaurantReviewsProvider provider,
  ) {
    return call(
      provider.restaurantId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'restaurantReviewsProvider';
}

/// See also [RestaurantReviews].
class RestaurantReviewsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    RestaurantReviews, List<Review>> {
  /// See also [RestaurantReviews].
  RestaurantReviewsProvider(
    String restaurantId,
  ) : this._internal(
          () => RestaurantReviews()..restaurantId = restaurantId,
          from: restaurantReviewsProvider,
          name: r'restaurantReviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$restaurantReviewsHash,
          dependencies: RestaurantReviewsFamily._dependencies,
          allTransitiveDependencies:
              RestaurantReviewsFamily._allTransitiveDependencies,
          restaurantId: restaurantId,
        );

  RestaurantReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.restaurantId,
  }) : super.internal();

  final String restaurantId;

  @override
  FutureOr<List<Review>> runNotifierBuild(
    covariant RestaurantReviews notifier,
  ) {
    return notifier.build(
      restaurantId,
    );
  }

  @override
  Override overrideWith(RestaurantReviews Function() create) {
    return ProviderOverride(
      origin: this,
      override: RestaurantReviewsProvider._internal(
        () => create()..restaurantId = restaurantId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        restaurantId: restaurantId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RestaurantReviews, List<Review>>
      createElement() {
    return _RestaurantReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestaurantReviewsProvider &&
        other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, restaurantId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RestaurantReviewsRef
    on AutoDisposeAsyncNotifierProviderRef<List<Review>> {
  /// The parameter `restaurantId` of this provider.
  String get restaurantId;
}

class _RestaurantReviewsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RestaurantReviews,
        List<Review>> with RestaurantReviewsRef {
  _RestaurantReviewsProviderElement(super.provider);

  @override
  String get restaurantId => (origin as RestaurantReviewsProvider).restaurantId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
