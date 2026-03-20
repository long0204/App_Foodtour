import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import '../../config/constants/strings.dart';
import '../../core/route.dart';
import '../../services/auth_service.dart';
import 'package:Foodtour/ui/account/providers/notifier.dart';

import '../auth/provider/auth_notifier.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildProfileHeader(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.blue),
            title: const Text("Lịch sử ăn uống"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.star_outline, color: Colors.orange),
            title: const Text("Quán ăn đã đánh giá"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.card_membership, color: Colors.purple),
            title: const Text("Danh hiệu: Thánh Ăn Vặt"),
            subtitle: const Text("Bạn đã đóng góp 15 quán ăn"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
      child: Row(
        children: [
          const CircleAvatar(radius: 40, backgroundImage: AssetImage('asset/images/user/avatar_placeholder.png')),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nguyễn Văn A", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Cấp độ: Người sành ăn", style: TextStyle(color: Colors.grey[600])),
            ],
          )
        ],
      ),
    );
  }
}