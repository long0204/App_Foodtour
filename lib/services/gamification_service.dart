import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/logger.dart';

/// Model cho user gamification data
class UserGamification {
  final String userId;
  final int points;
  final int level;
  final List<String> badges;
  final Map<String, int> achievements;
  final DateTime lastUpdated;

  UserGamification({
    required this.userId,
    required this.points,
    required this.level,
    required this.badges,
    required this.achievements,
    required this.lastUpdated,
  });

  factory UserGamification.fromFirestore(Map<String, dynamic> data, String userId) {
    return UserGamification(
      userId: userId,
      points: data['points'] ?? 0,
      level: data['level'] ?? 1,
      badges: List<String>.from(data['badges'] ?? []),
      achievements: Map<String, int>.from(data['achievements'] ?? {}),
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'points': points,
      'level': level,
      'badges': badges,
      'achievements': achievements,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  UserGamification copyWith({
    int? points,
    int? level,
    List<String>? badges,
    Map<String, int>? achievements,
    DateTime? lastUpdated,
  }) {
    return UserGamification(
      userId: userId,
      points: points ?? this.points,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      achievements: achievements ?? this.achievements,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Calculate level from points
  static int calculateLevel(int points) {
    // Level formula: level = floor(sqrt(points / 100)) + 1
    // Level 1: 0-99 points
    // Level 2: 100-399 points
    // Level 3: 400-899 points
    // Level 4: 900-1599 points
    // Level 5: 1600+ points
    if (points < 100) return 1;
    if (points < 400) return 2;
    if (points < 900) return 3;
    if (points < 1600) return 4;
    if (points < 2500) return 5;
    if (points < 3600) return 6;
    if (points < 4900) return 7;
    if (points < 6400) return 8;
    if (points < 8100) return 9;
    return 10; // Max level
  }

  /// Get points needed for next level
  static int pointsForNextLevel(int currentLevel) {
    if (currentLevel >= 10) return 0; // Max level
    final levels = [0, 100, 400, 900, 1600, 2500, 3600, 4900, 6400, 8100, 10000];
    return levels[currentLevel];
  }

  /// Get progress to next level (0.0 - 1.0)
  double getProgressToNextLevel() {
    if (level >= 10) return 1.0; // Max level
    final currentLevelPoints = pointsForNextLevel(level - 1);
    final nextLevelPoints = pointsForNextLevel(level);
    final pointsInLevel = points - currentLevelPoints;
    final pointsNeeded = nextLevelPoints - currentLevelPoints;
    return (pointsInLevel / pointsNeeded).clamp(0.0, 1.0);
  }
}

/// Badge definitions
class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int requiredPoints;
  final String? requiredAchievement;
  final int? requiredCount;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.requiredPoints = 0,
    this.requiredAchievement,
    this.requiredCount,
  });
}

/// All available badges
class Badges {
  static const newbie = Badge(
    id: 'newbie',
    name: 'Người mới',
    description: 'Chào mừng đến với FoodTour!',
    icon: '🌱',
    requiredPoints: 0,
  );

  static const explorer = Badge(
    id: 'explorer',
    name: 'Nhà thám hiểm',
    description: 'Khám phá 10 quán ăn',
    icon: '🗺️',
    requiredAchievement: 'restaurants_visited',
    requiredCount: 10,
  );

  static const foodie = Badge(
    id: 'foodie',
    name: 'Tín đồ ẩm thực',
    description: 'Đạt 500 điểm',
    icon: '🍜',
    requiredPoints: 500,
  );

  static const reviewer = Badge(
    id: 'reviewer',
    name: 'Nhà phê bình',
    description: 'Viết 20 review',
    icon: '✍️',
    requiredAchievement: 'reviews_written',
    requiredCount: 20,
  );

  static const photographer = Badge(
    id: 'photographer',
    name: 'Nhiếp ảnh gia',
    description: 'Upload 50 ảnh',
    icon: '📸',
    requiredAchievement: 'photos_uploaded',
    requiredCount: 50,
  );

  static const influencer = Badge(
    id: 'influencer',
    name: 'Influencer',
    description: 'Chia sẻ 30 lần',
    icon: '📱',
    requiredAchievement: 'shares_count',
    requiredCount: 30,
  );

  static const master = Badge(
    id: 'master',
    name: 'Bậc thầy',
    description: 'Đạt level 10',
    icon: '👑',
    requiredPoints: 10000,
  );

  static const lucky = Badge(
    id: 'lucky',
    name: 'May mắn',
    description: 'Quay vòng quay 10 lần',
    icon: '🎰',
    requiredAchievement: 'spins_count',
    requiredCount: 10,
  );

  static const socialite = Badge(
    id: 'socialite',
    name: 'Người giao lưu',
    description: 'Kết bạn với 20 người',
    icon: '👥',
    requiredAchievement: 'friends_count',
    requiredCount: 20,
  );

  static const allBadges = [
    newbie,
    explorer,
    foodie,
    reviewer,
    photographer,
    influencer,
    master,
    lucky,
    socialite,
  ];
}

/// Service để quản lý gamification
class GamificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get user gamification data
  Future<UserGamification> getUserGamification(String userId) async {
    try {
      final doc = await _firestore.collection('user_gamification').doc(userId).get();
      
      if (!doc.exists) {
        // Create new gamification data
        final newData = UserGamification(
          userId: userId,
          points: 0,
          level: 1,
          badges: ['newbie'], // Everyone starts with newbie badge
          achievements: {},
          lastUpdated: DateTime.now(),
        );
        await _firestore.collection('user_gamification').doc(userId).set(newData.toFirestore());
        return newData;
      }

      return UserGamification.fromFirestore(doc.data()!, userId);
    } catch (e) {
      devLog('Error getting user gamification: $e');
      rethrow;
    }
  }

  /// Add points to user
  Future<void> addPoints(String userId, int points, String reason) async {
    try {
      final docRef = _firestore.collection('user_gamification').doc(userId);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        
        if (!doc.exists) {
          // Create new
          transaction.set(docRef, {
            'points': points,
            'level': UserGamification.calculateLevel(points),
            'badges': ['newbie'],
            'achievements': {},
            'lastUpdated': Timestamp.now(),
          });
        } else {
          final currentPoints = doc.data()?['points'] ?? 0;
          final newPoints = currentPoints + points;
          final newLevel = UserGamification.calculateLevel(newPoints);
          
          transaction.update(docRef, {
            'points': newPoints,
            'level': newLevel,
            'lastUpdated': Timestamp.now(),
          });
        }
      });

      // Log points history
      await _firestore.collection('points_history').add({
        'userId': userId,
        'points': points,
        'reason': reason,
        'timestamp': Timestamp.now(),
      });

      devLog('Added $points points to user $userId for: $reason');
    } catch (e) {
      devLog('Error adding points: $e');
      rethrow;
    }
  }

  /// Track achievement
  Future<void> trackAchievement(String userId, String achievementKey) async {
    try {
      final docRef = _firestore.collection('user_gamification').doc(userId);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        
        if (!doc.exists) return;
        
        final achievements = Map<String, int>.from(doc.data()?['achievements'] ?? {});
        achievements[achievementKey] = (achievements[achievementKey] ?? 0) + 1;
        
        transaction.update(docRef, {
          'achievements': achievements,
          'lastUpdated': Timestamp.now(),
        });
      });

      // Check for new badges
      await _checkAndAwardBadges(userId);
    } catch (e) {
      devLog('Error tracking achievement: $e');
      rethrow;
    }
  }

  /// Check and award badges
  Future<void> _checkAndAwardBadges(String userId) async {
    try {
      final gamification = await getUserGamification(userId);
      final newBadges = <String>[];

      for (final badge in Badges.allBadges) {
        // Skip if already has badge
        if (gamification.badges.contains(badge.id)) continue;

        // Check points requirement
        if (badge.requiredPoints > 0 && gamification.points >= badge.requiredPoints) {
          newBadges.add(badge.id);
          continue;
        }

        // Check achievement requirement
        if (badge.requiredAchievement != null && badge.requiredCount != null) {
          final count = gamification.achievements[badge.requiredAchievement] ?? 0;
          if (count >= badge.requiredCount!) {
            newBadges.add(badge.id);
          }
        }
      }

      // Award new badges
      if (newBadges.isNotEmpty) {
        await _firestore.collection('user_gamification').doc(userId).update({
          'badges': FieldValue.arrayUnion(newBadges),
          'lastUpdated': Timestamp.now(),
        });
        devLog('Awarded badges to $userId: $newBadges');
      }
    } catch (e) {
      devLog('Error checking badges: $e');
    }
  }

  /// Get leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 50}) async {
    try {
      final snapshot = await _firestore
          .collection('user_gamification')
          .orderBy('points', descending: true)
          .limit(limit)
          .get();

      final leaderboard = <Map<String, dynamic>>[];
      
      for (var i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        final data = doc.data();
        
        // Get user info
        final userDoc = await _firestore.collection('users').doc(doc.id).get();
        final userName = userDoc.data()?['name'] ?? 'Unknown';
        final userAvatar = userDoc.data()?['avatar'] ?? '';
        
        leaderboard.add({
          'rank': i + 1,
          'userId': doc.id,
          'userName': userName,
          'userAvatar': userAvatar,
          'points': data['points'] ?? 0,
          'level': data['level'] ?? 1,
          'badges': List<String>.from(data['badges'] ?? []),
        });
      }

      return leaderboard;
    } catch (e) {
      devLog('Error getting leaderboard: $e');
      rethrow;
    }
  }

  /// Award points for actions
  static const pointsForReview = 10;
  static const pointsForPhoto = 5;
  static const pointsForShare = 3;
  static const pointsForVisit = 2;
  static const pointsForSpin = 1;
  static const pointsForFriend = 5;
}

// Provider
final gamificationServiceProvider = Provider<GamificationService>((ref) {
  return GamificationService();
});
