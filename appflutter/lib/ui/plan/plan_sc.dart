import 'package:Foodtour/ui/plan/widget/create_plan.dart';
import 'package:Foodtour/widgets/base/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../services/auth_service.dart';

class PlansTab extends StatelessWidget {
  const PlansTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authService.getUsername();
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('plans')
              .where('userId', isEqualTo: user)
              //.orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              print(user);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('asset/images/shared/empty.png',
                        height: 120, width: 160),
                    const Gap(12),
                    const Text(
                      'Không có kế hoạch nào',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: -0.05,
                      ),
                    ),
                  ],
                ),
              );
            }
            final plans = snapshot.data!.docs;
            return ListView.builder(
                padding:  EdgeInsets.only(
                    bottom: 80, left: 12, right: 12, top: 48),
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  final planData = plan.data() as Map<String, dynamic>;
                  final name = planData['name'] ?? 'Không có tên';
                  final description =
                      'Kinh phí: ${planData['name']} ,số người :${planData['people']}, trong :${planData['people']} ngày';
                  // planData.containsKey('description')
                  //     ? planData['description']
                  //     : 'Không có mô tả';
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      subtitle: Text(
                        description,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.redAccent),
                        onPressed: () {},
                      ),
                    ),
                  );
                });
          },
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreatePlanScreen()),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
