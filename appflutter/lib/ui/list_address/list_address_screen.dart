import 'package:Foodtour/ui/list_address/providers/notifier.dart';
import 'package:Foodtour/ui/list_address/widget/add_new_address.dart';
import 'package:Foodtour/ui/list_address/widget/empty.dart';
import 'package:Foodtour/ui/list_address/widget/item_tile.dart';
import 'package:Foodtour/ui/list_address/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../widgets/base/btn.dart';
import '../../widgets/helpers/showmanager.dart';

class RestaurantListScreen extends ConsumerWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restaurantNotifierProvider);
    final notifier = ref.read(restaurantNotifierProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              RestaurantSearchBar(onChanged: notifier.search),
              RestaurantTypeDropdown(
                selectedType: state.selectedType,
                restaurants: state.allRestaurants,
                onChanged: notifier.filterByType,
              ),
              const Gap(8),
              Expanded(
                child: RefreshIndicator(
                    onRefresh: () => notifier.refreshFromRemote(),
                    child: state.filteredRestaurants.isEmpty && !state.isLoading
                        ? const EmptyRestaurantPlaceholder()
                        : ListView.builder(
                            itemCount: state.filteredRestaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant =
                                  state.filteredRestaurants[index];
                              return RestaurantItemTile(restaurant: restaurant);
                            },
                          )),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ZoomTap(
                child: const Icon(Icons.add, color: Colors.red),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ScreenUtilInit(
                        designSize: const Size(375, 812),
                        builder: (context, child) => AddRestaurantDialog(
                          onSubmit: (type, name, address, price) async {
                            try {
                              await ref
                                  .read(restaurantNotifierProvider.notifier)
                                  .addNewRestaurant(
                                    type: type,
                                    name: name,
                                    address: address,
                                    price: price,
                                  );
                              showManager.showToast('Lưu thành công!',
                                  isSuccess: true);
                            } catch (e) {
                              showManager.showToast(
                                  'Lưu thất bại! Vui lòng thử lại.',
                                  isSuccess: false);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
