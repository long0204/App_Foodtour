import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../config/themes/text_style.dart';
import '../../../core/providers/api_client_provider.dart';
import '../../../core/route.dart';
import '../../../data/model/restaurant.dart';
import '../../../providers/community_provider.dart';
import '../../../widgets/shared/back_btn.dart';
import '../../../widgets/shared/cached_image.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  final String uid;
  const HistoryScreen({super.key, required this.uid});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  List<dynamic> _historyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final data = await apiClient.get('/users/${widget.uid}/history');
      if (mounted) {
        setState(() {
          _historyList = data as List;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Màu nền đồng bộ
      appBar: AppBar(
        leading: const MyBackButton(),
        title: Text("Lịch sử đánh giá", style: k2d600.s18),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : _historyList.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: _historyList.length,
        itemBuilder: (context, index) {
          return _buildHistoryItem(_historyList[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu_outlined, size: 80.sp, color: Colors.grey[300]),
          Gap(16.h),
          Text(
            "Bạn chưa có đánh giá nào",
            style: k2d500.s16.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(dynamic item) {
    final resData = item['restaurants'];
    final Restaurant restaurant = parseRestaurantData(resData);

    final DateTime createdAt = item['created_at'] != null
        ? DateTime.parse(item['created_at'])
        : DateTime.now();
    final String formattedDate = DateFormat('dd/MM/yyyy • HH:mm').format(createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: InkWell(
        onTap: () => push(detailRoute, extra: restaurant),
        borderRadius: BorderRadius.circular(15.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh thu nhỏ của quán
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedImage(
                      restaurant.imageUrls.isNotEmpty ? restaurant.imageUrls.first : '',
                      width: 60.w,
                      height: 60.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name ?? 'Không rõ tên quán',
                          style: k2d600.s16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap(4.h),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < (item['rating'] ?? 0) ? Icons.star : Icons.star_border,
                                color: Colors.orange,
                                size: 16.sp,
                              );
                            }),
                            Gap(8.w),
                            Text(
                              formattedDate,
                              style: k2d400.s11.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              if (item['comment'] != null && item['comment'].toString().isNotEmpty) ...[
                const Divider(height: 20),
                Text(
                  "“${item['comment']}”",
                  style: k2d400.s13.copyWith(color: Colors.black87, fontStyle: FontStyle.italic),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}