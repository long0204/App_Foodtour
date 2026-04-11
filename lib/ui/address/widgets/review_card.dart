import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../config/gen/assets.gen.dart';
import '../../../../config/themes/text_style.dart';
import '../../../../data/model/review.dart';
import '../../../../widgets/shared/cached_image.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final difference = DateTime.now().difference(review.createdAt);
    String timeAgo = difference.inDays > 0 ? "${difference.inDays} ngày trước" : (difference.inHours > 0 ? "${difference.inHours} giờ trước" : "Vừa xong");

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundImage: (review.userAvatarUrl != null && review.userAvatarUrl!.isNotEmpty)
                ? CachedNetworkImageProvider(review.userAvatarUrl!) as ImageProvider
                : Assets.images.user.avtDefault.provider(),
            backgroundColor: Colors.grey[100],
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review.userName, style: k2d600.s14),
                    Text(timeAgo, style: k2d500.s12.grey600ts),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: List.generate(5, (index) => Icon(index < review.rating ? Icons.star_rounded : Icons.star_outline_rounded, color: Colors.amber[500], size: 16.sp)),
                ),
                if (review.comment.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(review.comment, style: k2d500.s14.copyWith(color: Colors.black87, height: 1.4)),
                ],
                if (review.image_urls != null && review.image_urls!.isNotEmpty) ...[
                  Gap(12.h),
                  Wrap(
                    spacing: 8.w, runSpacing: 8.h,
                    children: review.image_urls!.map((url) => ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedImage(url, width: 70.w, height: 70.w, fit: BoxFit.cover),
                    )).toList(),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}