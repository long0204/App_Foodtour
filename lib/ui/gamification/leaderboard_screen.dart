import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/themes/text_style.dart';
import '../../../providers/gamification_provider.dart';
import '../../../config/gen/assets.gen.dart';

/// Leaderboard screen
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bảng xếp hạng', style: k2d600.s18),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: leaderboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
              Gap(16.h),
              Text(
                'Lỗi tải bảng xếp hạng',
                style: k2d500.s16.copyWith(color: Colors.red),
              ),
              Gap(8.h),
              Text(
                error.toString(),
                style: k2d400.s14.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (leaderboard) {
          if (leaderboard.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.leaderboard, size: 60.sp, color: Colors.grey[300]),
                  Gap(16.h),
                  Text(
                    'Chưa có dữ liệu',
                    style: k2d500.s16.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Top 3 podium
              if (leaderboard.length >= 3) _buildPodium(leaderboard.take(3).toList()),
              
              Gap(20.h),
              
              // Rest of the list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: leaderboard.length > 3 ? leaderboard.length - 3 : 0,
                  itemBuilder: (context, index) {
                    final user = leaderboard[index + 3];
                    return _LeaderboardItem(
                      rank: user['rank'],
                      userName: user['userName'],
                      userAvatar: user['userAvatar'],
                      points: user['points'],
                      level: user['level'],
                      badges: List<String>.from(user['badges']),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPodium(List<Map<String, dynamic>> topThree) {
    // Reorder: 2nd, 1st, 3rd
    final first = topThree[0];
    final second = topThree.length > 1 ? topThree[1] : null;
    final third = topThree.length > 2 ? topThree[2] : null;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orange.shade100,
            Colors.white,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          if (second != null)
            _PodiumItem(
              rank: 2,
              userName: second['userName'],
              userAvatar: second['userAvatar'],
              points: second['points'],
              level: second['level'],
              height: 100.h,
              color: Colors.grey.shade400,
            ),
          Gap(12.w),
          
          // 1st place
          _PodiumItem(
            rank: 1,
            userName: first['userName'],
            userAvatar: first['userAvatar'],
            points: first['points'],
            level: first['level'],
            height: 140.h,
            color: Colors.amber,
          ),
          Gap(12.w),
          
          // 3rd place
          if (third != null)
            _PodiumItem(
              rank: 3,
              userName: third['userName'],
              userAvatar: third['userAvatar'],
              points: third['points'],
              level: third['level'],
              height: 80.h,
              color: Colors.brown.shade400,
            ),
        ],
      ),
    );
  }
}

/// Podium item for top 3
class _PodiumItem extends StatelessWidget {
  final int rank;
  final String userName;
  final String userAvatar;
  final int points;
  final int level;
  final double height;
  final Color color;

  const _PodiumItem({
    required this.rank,
    required this.userName,
    required this.userAvatar,
    required this.points,
    required this.level,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with crown
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
              ),
              child: CircleAvatar(
                radius: rank == 1 ? 40.r : 32.r,
                backgroundImage: userAvatar.isNotEmpty
                    ? CachedNetworkImageProvider(userAvatar)
                    : Assets.images.user.avtDefault.provider() as ImageProvider,
              ),
            ),
            if (rank == 1)
              Positioned(
                top: -10.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Text('👑', style: TextStyle(fontSize: 32.sp)),
                ),
              ),
          ],
        ),
        Gap(8.h),
        
        // Name
        SizedBox(
          width: 80.w,
          child: Text(
            userName,
            style: k2d600.s13,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Gap(4.h),
        
        // Level
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'Lv.$level',
            style: k2d600.s11.copyWith(color: Colors.orange.shade800),
          ),
        ),
        Gap(8.h),
        
        // Podium
        Container(
          width: 80.w,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#$rank',
                style: k2d700.s24.copyWith(color: Colors.white),
              ),
              Text(
                '$points',
                style: k2d500.s12.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Leaderboard item for rank 4+
class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String userName;
  final String userAvatar;
  final int points;
  final int level;
  final List<String> badges;

  const _LeaderboardItem({
    required this.rank,
    required this.userName,
    required this.userAvatar,
    required this.points,
    required this.level,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 40.w,
            child: Text(
              '#$rank',
              style: k2d600.s16.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          Gap(12.w),
          
          // Avatar
          CircleAvatar(
            radius: 24.r,
            backgroundImage: userAvatar.isNotEmpty
                ? CachedNetworkImageProvider(userAvatar)
                : Assets.images.user.avtDefault.provider() as ImageProvider,
          ),
          Gap(12.w),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: k2d600.s14),
                Gap(4.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Lv.$level',
                        style: k2d500.s11.copyWith(color: Colors.orange.shade800),
                      ),
                    ),
                    Gap(8.w),
                    Text(
                      '${badges.length} huy hiệu',
                      style: k2d400.s12.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$points',
                style: k2d700.s16.copyWith(color: Colors.orange),
              ),
              Text(
                'điểm',
                style: k2d400.s11.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
