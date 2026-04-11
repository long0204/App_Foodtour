import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../config/themes/text_style.dart';
import '../../../providers/gamification_provider.dart';

/// Widget hiển thị points và level của user
class PointsLevelCard extends ConsumerWidget {
  const PointsLevelCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamificationAsync = ref.watch(userGamificationProvider);

    return gamificationAsync.when(
      loading: () => _buildLoadingCard(),
      error: (error, stack) => _buildErrorCard(error.toString()),
      data: (gamification) {
        final progress = gamification.getProgressToNextLevel();
        final nextLevelPoints = gamification.level < 10
            ? gamification.pointsForNextLevel(gamification.level)
            : gamification.points;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade400,
                Colors.deepOrange.shade600,
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Level badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level ${gamification.level}',
                        style: k2d700.s28.copyWith(color: Colors.white),
                      ),
                      Gap(4.h),
                      Text(
                        '${gamification.points} điểm',
                        style: k2d500.s16.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _getLevelIcon(gamification.level),
                      style: TextStyle(fontSize: 32.sp),
                    ),
                  ),
                ],
              ),
              Gap(20.h),

              // Progress bar
              if (gamification.level < 10) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tiến độ lên level ${gamification.level + 1}',
                          style: k2d500.s13.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: k2d600.s13.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    Gap(8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8.h,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Gap(6.h),
                    Text(
                      'Còn ${nextLevelPoints - gamification.points} điểm nữa',
                      style: k2d400.s12.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ] else ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.white, size: 20.sp),
                      Gap(8.w),
                      Text(
                        'Level tối đa!',
                        style: k2d600.s14.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text('Lỗi: $error', style: k2d400.s14.copyWith(color: Colors.red)),
    );
  }

  String _getLevelIcon(int level) {
    if (level >= 10) return '👑';
    if (level >= 8) return '💎';
    if (level >= 6) return '⭐';
    if (level >= 4) return '🔥';
    if (level >= 2) return '🌟';
    return '🌱';
  }
}

/// Compact version for profile screen
class CompactPointsLevelCard extends ConsumerWidget {
  const CompactPointsLevelCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamificationAsync = ref.watch(userGamificationProvider);

    return gamificationAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (gamification) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getLevelIcon(gamification.level),
                style: TextStyle(fontSize: 24.sp),
              ),
              Gap(8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Level ${gamification.level}',
                    style: k2d600.s14.copyWith(color: Colors.white),
                  ),
                  Text(
                    '${gamification.points} điểm',
                    style: k2d400.s12.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getLevelIcon(int level) {
    if (level >= 10) return '👑';
    if (level >= 8) return '💎';
    if (level >= 6) return '⭐';
    if (level >= 4) return '🔥';
    if (level >= 2) return '🌟';
    return '🌱';
  }
}
