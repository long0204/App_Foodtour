import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/model/restaurant.dart';
import '../../providers/community_provider.dart';
import '../../core/route.dart';
import '../../services/location_service.dart';

class CommunityListScreen extends ConsumerStatefulWidget {
  final String categoryName;

  const CommunityListScreen({super.key, required this.categoryName});

  @override
  ConsumerState<CommunityListScreen> createState() => _CommunityListScreenState();
}

class _CommunityListScreenState extends ConsumerState<CommunityListScreen> {
  String _searchQuery = "";
  String _selectedFilter = "Đánh giá";
  Position? _userPosition;
  bool _isLoadingLocation = false;

  Future<void> _onFilterTapped(String title) async {
    setState(() {
      _selectedFilter = title;
    });

    if (title == "Gần tôi" && _userPosition == null) {
      setState(() => _isLoadingLocation = true);
      try {
        final position = await locationService.getCurrentPosition();
        setState(() {
          _userPosition = position;
          _isLoadingLocation = false;
        });
      } catch (e) {
        setState(() => _isLoadingLocation = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantsAsync = ref.watch(communityProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Quán ${widget.categoryName}"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Tìm kiếm tên quán...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _buildFilterButton("Gần tôi", Icons.near_me),
                SizedBox(width: 12.w),
                _buildFilterButton("Đánh giá", Icons.star),
                if (_isLoadingLocation)
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: SizedBox(width: 16.w, height: 16.w, child: const CircularProgressIndicator(strokeWidth: 2)),
                  )
              ],
            ),
          ),
          SizedBox(height: 12.h),

          Expanded(
            child: restaurantsAsync.when(
              data: (list) {
                var filteredList = list.where((res) {
                  final matchCategory = res.type == widget.categoryName;
                  final matchSearch = (res.name ?? "").toLowerCase().contains(_searchQuery.toLowerCase());
                  return matchCategory && matchSearch;
                }).toList();

                if (_selectedFilter == "Đánh giá") {
                  filteredList.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
                } else if (_selectedFilter == "Gần tôi" && _userPosition != null) {
                  filteredList.sort((a, b) {
                    if (a.latitude == null || a.longitude == null) return 1;
                    if (b.latitude == null || b.longitude == null) return -1;

                    double distA = Geolocator.distanceBetween(
                        _userPosition!.latitude, _userPosition!.longitude, a.latitude!, a.longitude!);
                    double distB = Geolocator.distanceBetween(
                        _userPosition!.latitude, _userPosition!.longitude, b.latitude!, b.longitude!);
                    return distA.compareTo(distB);
                  });
                }

                if (filteredList.isEmpty) {
                  return const Center(child: Text("Không tìm thấy quán nào phù hợp."));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final restaurant = filteredList[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: GestureDetector(
                        onTap: () {
                          push(detailRoute, extra: restaurant);
                        },
                        child: RestaurantCardVertical(restaurant: restaurant, userPosition: _userPosition),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Lỗi: $err")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title, IconData icon) {
    bool isSelected = _selectedFilter == title;
    return GestureDetector(
      onTap: () => _onFilterTapped(title),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.sp, color: isSelected ? Colors.white : Colors.black54),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantCardVertical extends StatelessWidget {
  final Restaurant restaurant;
  final Position? userPosition;

  const RestaurantCardVertical({super.key, required this.restaurant, this.userPosition});

  @override
  Widget build(BuildContext context) {
    String distanceStr = "";
    if (userPosition != null && restaurant.latitude != null && restaurant.longitude != null) {
      double dist = Geolocator.distanceBetween(
          userPosition!.latitude, userPosition!.longitude, restaurant.latitude!, restaurant.longitude!);
      distanceStr = dist < 1000 ? " • ${dist.toStringAsFixed(0)}m" : " • ${(dist / 1000).toStringAsFixed(1)}km";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Đảm bảo column thu gọn
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: Image.network(
              restaurant.imageUrls.isNotEmpty ? restaurant.imageUrls![0] : 'https://via.placeholder.com/150',
              height: 130.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 130.h, color: Colors.grey[300], child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        "${restaurant.address ?? ''}$distanceStr",
                        style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restaurant.price ?? '0',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        Text(" ${restaurant.rating}", style: TextStyle(fontSize: 12.sp)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}