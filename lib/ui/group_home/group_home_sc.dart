import 'package:Foodtour/ui/group_home/provider/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupHomeScreen extends ConsumerWidget {
  const GroupHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groupHomeNotifierProvider);
    final notifier = ref.read(groupHomeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhóm của bạn"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => notifier.loadGroups(),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.groups.isEmpty
          ? const Center(child: Text("Chưa có nhóm nào"))
          : ListView.builder(
        itemCount: state.groups.length,
        itemBuilder: (context, index) {
          final group = state.groups[index];
          return ListTile(
            leading: const Icon(Icons.group),
            title: Text(group.groupName),
            subtitle: Text("Thành viên: ${group.invitedFriends}"),
            onTap: () {
              // TODO: Navigate to GroupDetailScreen
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to CreateGroupScreen
        },
        child: const Icon(Icons.add),
        tooltip: "Tạo nhóm mới",
      ),
    );
  }
}
