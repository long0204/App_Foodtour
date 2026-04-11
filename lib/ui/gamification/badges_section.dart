import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../config/themes/text_style.dart';
import '../../../services/gamification_service.dart';
import '../../../providers/gamification_provider.dart';

/// Widget hiển thị badges của user
class BadgesSection extends ConsumerWidget {
  const BadgesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamificationAsync = ref.watch(userGamificationProvider);

    return gamificationAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Lỗi: $error', style: k2d400.s14.copyWith(color: Colors.red)),
      ),
      data: (gamification) {
        final userBadges = gamification.badges;
        final allBadges = Badges.allBadges;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Huy hiệu', style: k2d600.s18),
                  Text(
                    '${userBadges.length}/${allBadges.length}',
                    style: k2d500.s14.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Gap(16.h),

            // Badges grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.85,
                ),
                itemCount: allBadges.length,
                itemBuilder: (context, index) {
                  final badge = allBadges[index];
                  final isUnlocked = userBadges.contains(badge.id);

                  return _BadgeCard(
                    badge: badge,
                    isUnlocked: isUnlocked,
                    gamification: gamification,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Card cho mỗi badge
class _BadgeCard extends StatelessWidget {
  final Badge badge;
  final bool isUnlocked;
  final UserGamification gamification;

  const _BadgeCard({
    required this.badge,
    required this.isUnlocked,
    required this.gamification,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBadgeDetail(context),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.orange.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isUnlocked ? Colors.orange.shade200 : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Text(
              badge.icon,
              style: TextStyle(
                fontSize: 40.sp,
                color: isUnlocked ? null : Colors.grey.shade400,
              ),
            ),
            Gap(8.h),

            // Name
            Text(
              badge.name,
              style: k2d600.s13.copyWith(
                color: isUnlocked ? Colors.black : Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Lock icon if not unlocked
            if (!isUnlocked) ...[
              Gap(4.h),
              Icon(
                Icons.lock,
                size: 16.sp,
                color: Colors.grey.shade400,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Text(badge.icon, style: TextStyle(fontSize: 60.sp)),
            Gap(16.h),

            // Name
            Text(badge.name, style: k2d600.s18, textAlign: TextAlign.center),
            Gap(8.h),

            // Description
            Text(
              badge.description,
              style: k2d400.s14.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            Gap(16.h),

            // Status
            if (isUnlocked) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                    Gap(8.w),
                    Text(
                      'Đã mở khóa',
                      style: k2d600.s14.copyWith(color: Colors.green.shade800),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Progress
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    if (badge.requiredPoints > 0) ...[
                      Text(
                        'Cần ${badge.requiredPoints} điểm',
                        style: k2d500.s13.copyWith(color: Colors.grey[700]),
                      ),
                      Gap(4.h),
                      Text(
                        'Hiện có: ${gamification.points} điểm',
                        style: k2d400.s12.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                    if (badge.requiredAchievement != null && badge.requiredCount != null) ...[
                      Text(
                        'Cần ${badge.requiredCount} lần',
                        style: k2d500.s13.copyWith(color: Colors.grey[700]),
                      ),
                      Gap(4.h),
                      Text(
                        'Hiện có: ${gamification.achievements[badge.requiredAchievement] ?? 0} lần',
                        style: k2d400.s12.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng', style: k2d600.s14.copyWith(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}

/// Widget hiển thị tất cả badges trong một screen riêng
class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Huy hiệu', style: k2d600.s18),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(20.h),
            const BadgesSection(),
            Gap(40.h),
          ],
        ),
      ),
    );
  }
}
