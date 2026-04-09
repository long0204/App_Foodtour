import 'package:Foodtour/ui/home/providers/notifier.dart';
import 'package:Foodtour/ui/home/widget/home_app_bar.dart';
import 'package:Foodtour/ui/home/widget/home_map_section.dart';
import 'package:Foodtour/ui/home/widget/home_suggestion_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../config/themes/text_style.dart';
import '../../providers/community_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _scrollController;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final threshold = 200.h - kToolbarHeight;
      if (_scrollController.offset > threshold && !_isCollapsed) {
        setState(() => _isCollapsed = true);
      } else if (_scrollController.offset <= threshold && _isCollapsed) {
        setState(() => _isCollapsed = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(homeNotifierProvider);
    final userPosition = locationAsync.value;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          HomeAppBar(
            isCollapsed: _isCollapsed,
            isSearchFocused: false,
          ),
          SliverToBoxAdapter(child: Gap(40.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Địa điểm gần bạn", style: k2d500.s16),
                  Gap(12.h),
                  HomeMapSection(
                    userPosition: userPosition,
                    isLoadingLocation: locationAsync.isLoading,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Consumer(
                builder: (context, ref, child) {
                  final mealType =
                      ref.watch(suggestionProvider.notifier).currentMealType;
                  return Text(
                    mealType == 'bạn'
                        ? "Đề xuất cho bạn"
                        : "Gợi ý cho bạn nên chọn $mealType",
                    style: k2d500.s16,
                  );
                },
              ),
            ),
          ),
          const HomeSuggestionGrid(),
          SliverToBoxAdapter(child: Gap(120.h)),
        ],
      ),
    );
  }
}
