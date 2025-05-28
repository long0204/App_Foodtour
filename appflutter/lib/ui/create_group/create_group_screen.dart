import 'package:Foodtour/ui/create_group/providers/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupScreen extends ConsumerWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groupNotifierProvider);
    final notifier = ref.read(groupNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Tạo Nhóm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Tên nhóm'),
            onChanged: notifier.updateGroupName,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(state.startDate == null
                    ? 'Từ ngày'
                    : 'Từ: ${state.startDate!.toLocal().toShortDateString()}'),
              ),
              Expanded(
                child: Text(state.endDate == null
                    ? 'Đến ngày'
                    : 'Đến: ${state.endDate!.toLocal().toShortDateString()}'),
              ),
              IconButton(
                icon: const Icon(Icons.date_range),
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    notifier.updateDateRange(picked.start, picked.end);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Số người:'),
              Expanded(
                child: Slider(
                  min: 1,
                  max: 20,
                  value: state.memberCount.toDouble(),
                  divisions: 19,
                  label: '${state.memberCount}',
                  onChanged: (val) => notifier.updateMemberCount(val.toInt()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Đã mời:'),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: state.invitedFriends
                      .map((friend) => Chip(
                    label: Text(friend),
                    onDeleted: () => notifier.removeFriend(friend),
                  ))
                      .toList(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  notifier.addFriend("Bạn A");
                },
              )
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(labelText: 'Ghi chú'),
            maxLines: 3,
            onChanged: notifier.updateNote,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                await notifier.createGroup();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tạo nhóm thành công')),
                  );
                  Navigator.pop(context);
                }
              },
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Tạo nhóm'),
            ),
          ),
        ]),
      ),
    );
  }
}

extension on DateTime {
  String toShortDateString() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year}';
  }
}
