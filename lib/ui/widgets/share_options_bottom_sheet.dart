import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../config/themes/text_style.dart';
import '../../data/model/restaurant.dart';
import '../../services/share_service.dart';
import '../../providers/gamification_provider.dart';
import 'share_card.dart';

/// Bottom sheet để chọn cách share
class ShareOptionsBottomSheet extends ConsumerWidget {
  final Restaurant restaurant;

  const ShareOptionsBottomSheet({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shareService = ref.watch(shareServiceProvider);

    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Gap(20.h),

          // Title
          Text(
            'Chia sẻ quán ăn',
            style: k2d600.s18,
          ),
          Gap(24.h),

          // Share options
          _ShareOption(
            icon: Icons.text_fields,
            title: 'Chia sẻ văn bản',
            subtitle: 'Chia sẻ thông tin quán dạng text',
            color: Colors.blue,
            onTap: () async {
              Navigator.pop(context);
              await shareService.shareRestaurant(restaurant);
              
              // Award points
              ref.read(gamificationNotifierProvider.notifier).awardPointsForShare();
            },
          ),
          Gap(12.h),

          _ShareOption(
            icon: Icons.image,
            title: 'Chia sẻ hình ảnh',
            subtitle: 'Tạo card đẹp với QR code',
            color: Colors.purple,
            onTap: () async {
              Navigator.pop(context);
              _showLoadingDialog(context);
              
              try {
                final deepLink = shareService.generateRestaurantDeepLink(restaurant);
                final shareCard = RestaurantShareCard(
                  restaurant: restaurant,
                  deepLink: deepLink,
                );
                
                await shareService.shareRestaurantWithImage(
                  restaurant,
                  shareCard,
                );
                
                // Award points
                ref.read(gamificationNotifierProvider.notifier).awardPointsForShare();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi khi chia sẻ: $e')),
                  );
                }
              } finally {
                if (context.mounted) {
                  Navigator.pop(context); // Close loading dialog
                }
              }
            },
          ),
          Gap(12.h),

          _ShareOption(
            icon: Icons.link,
            title: 'Chia sẻ link',
            subtitle: 'Gửi link trực tiếp đến quán',
            color: Colors.orange,
            onTap: () async {
              Navigator.pop(context);
              await shareService.shareRestaurantWithDeepLink(restaurant);
              
              // Award points
              ref.read(gamificationNotifierProvider.notifier).awardPointsForShare();
            },
          ),
          Gap(12.h),

          _ShareOption(
            icon: Icons.photo_library,
            title: 'Card nhỏ gọn',
            subtitle: 'Chia sẻ card nhỏ gọn hơn',
            color: Colors.green,
            onTap: () async {
              Navigator.pop(context);
              _showLoadingDialog(context);
              
              try {
                final deepLink = shareService.generateRestaurantDeepLink(restaurant);
                final shareCard = CompactRestaurantShareCard(
                  restaurant: restaurant,
                  deepLink: deepLink,
                );
                
                await shareService.shareRestaurantWithImage(
                  restaurant,
                  shareCard,
                );
                
                // Award points
                ref.read(gamificationNotifierProvider.notifier).awardPointsForShare();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi khi chia sẻ: $e')),
                  );
                }
              } finally {
                if (context.mounted) {
                  Navigator.pop(context); // Close loading dialog
                }
              }
            },
          ),

          Gap(20.h),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Gap(16.h),
              Text(
                'Đang tạo hình ảnh...',
                style: k2d500.s14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget cho mỗi share option
class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: k2d600.s15),
                  Gap(4.h),
                  Text(
                    subtitle,
                    style: k2d400.s13.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
