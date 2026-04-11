import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../config/gen/assets.gen.dart';
import '../../../../config/themes/text_style.dart';
import '../../../../services/remote_config_service.dart';
import '../../../../utils/string.dart';
import '../../../../widgets/shared/cached_image.dart';
import '../../../../widgets/base/base.dart';
import '../../../providers/tab_provider.dart';
import '../../auth/providers/auth_notifier.dart';
import '../../list_address/restaurant_list_screen.dart';

class HomeAppBar extends ConsumerWidget {
  final bool isCollapsed;
  final bool isSearchFocused;

  const HomeAppBar({
    super.key,
    required this.isCollapsed,
    required this.isSearchFocused,
  });

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return Icons.wb_sunny_rounded;
    if (hour >= 12 && hour < 18) return Icons.wb_cloudy_rounded;
    return Icons.nightlight_round;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userFirestoreProvider).value;
    final greeting = getGreeting(context);
    final greetingIcon = _getGreetingIcon();

    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      title: isSearchFocused
          ? Text("Bạn muốn tìm địa điểm nào?", style: k2d500.s16.white)
          : (isCollapsed
              ? Text("Hôm nay bạn muốn ăn gì?", style: k2d500.s16.white)
              : null),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedImage(
              RemoteConfigService().imageAppbarHome,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: Assets.images.home.bestfood.image(),
              placeholder: Assets.images.home.bestfood.image(),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 70.h,
              left: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(greeting, style: k2d400.s16.white),
                      Gap(4.w),
                      Icon(greetingIcon,
                          color: Colors.amberAccent, size: 14.sp),
                    ],
                  ),
                  Text(" ${userData?['fullname'] ?? ''}",
                      style: k2d400.s16.white),
                  Text("Hôm nay bạn muốn ăn gì?", style: k2d500.s24.white),
                ],
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(30.h),
        child: ZoomTap(
          onTap: () {
            ref.read(autoFocusSearchProvider.notifier).state = true;
            ref.read(tabIndexProvider.notifier).state =
                3;
          },
          child: Transform.translate(
            offset: Offset(0, (isSearchFocused || isCollapsed) ? 0 : 30.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5))
                  ],
                ),
                child: IgnorePointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Tìm quán ăn, món ăn...",
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.redAccent),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
