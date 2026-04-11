import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/gamification_service.dart';
import '../services/auth_service.dart';

/// Provider for user gamification data
final userGamificationProvider = StreamProvider.autoDispose<UserGamification>((ref) {
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.uid;

  if (userId == null) {
    return Stream.value(UserGamification(
      userId: '',
      points: 0,
      level: 1,
      badges: [],
      achievements: {},
      lastUpdated: DateTime.now(),
    ));
  }

  final gamificationService = ref.watch(gamificationServiceProvider);
  
  // Listen to Firestore changes
  return FirebaseFirestore.instance
      .collection('user_gamification')
      .doc(userId)
      .snapshots()
      .map((doc) {
    if (!doc.exists) {
      return UserGamification(
        userId: userId,
        points: 0,
        level: 1,
        badges: ['newbie'],
        achievements: {},
        lastUpdated: DateTime.now(),
      );
    }
    return UserGamification.fromFirestore(doc.data()!, userId);
  });
});

/// Provider for leaderboard
final leaderboardProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final gamificationService = ref.watch(gamificationServiceProvider);
  return await gamificationService.getLeaderboard(limit: 50);
});

/// Notifier for gamification actions
class GamificationNotifier extends StateNotifier<AsyncValue<void>> {
  final GamificationService _service;
  final String? _userId;

  GamificationNotifier(this._service, this._userId) : super(const AsyncValue.data(null));

  /// Add points
  Future<void> addPoints(int points, String reason) async {
    if (_userId == null) return;
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.addPoints(_userId, points, reason);
    });
  }

  /// Track achievement
  Future<void> trackAchievement(String achievementKey) async {
    if (_userId == null) return;
    
    await _service.trackAchievement(_userId, achievementKey);
  }

  /// Award points for review
  Future<void> awardPointsForReview() async {
    await addPoints(GamificationService.pointsForReview, 'Viết review');
    await trackAchievement('reviews_written');
  }

  /// Award points for photo
  Future<void> awardPointsForPhoto() async {
    await addPoints(GamificationService.pointsForPhoto, 'Upload ảnh');
    await trackAchievement('photos_uploaded');
  }

  /// Award points for share
  Future<void> awardPointsForShare() async {
    await addPoints(GamificationService.pointsForShare, 'Chia sẻ');
    await trackAchievement('shares_count');
  }

  /// Award points for visit
  Future<void> awardPointsForVisit() async {
    await addPoints(GamificationService.pointsForVisit, 'Ghé thăm quán');
    await trackAchievement('restaurants_visited');
  }

  /// Award points for spin
  Future<void> awardPointsForSpin() async {
    await addPoints(GamificationService.pointsForSpin, 'Quay vòng quay');
    await trackAchievement('spins_count');
  }

  /// Award points for friend
  Future<void> awardPointsForFriend() async {
    await addPoints(GamificationService.pointsForFriend, 'Kết bạn');
    await trackAchievement('friends_count');
  }
}

final gamificationNotifierProvider = StateNotifierProvider.autoDispose<GamificationNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(gamificationServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.uid;
  
  return GamificationNotifier(service, userId);
});
