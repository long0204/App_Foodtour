import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/model/group_model.dart';

part 'notifier.g.dart';
part 'state.dart';

@riverpod
class GroupNotifier extends _$GroupNotifier {
  @override
  GroupState build() => const GroupState();

  void updateGroupName(String name) => state = state.copyWith(groupName: name);

  void updateDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void updateMemberCount(int count) => state = state.copyWith(memberCount: count);

  void addFriend(String friend) {
    final updated = [...state.invitedFriends, friend];
    state = state.copyWith(invitedFriends: updated);
  }

  void removeFriend(String friend) {
    final updated = state.invitedFriends.where((f) => f != friend).toList();
    state = state.copyWith(invitedFriends: updated);
  }

  void updateNote(String note) => state = state.copyWith(note: note);

  Future<void> createGroup() async {
    state = state.copyWith(isLoading: true);
    try {
      final doc = FirebaseFirestore.instance.collection('groups').doc();
      final group = GroupModel(
        id: doc.id,
        groupName: state.groupName,
        startDate: state.startDate!,
        endDate: state.endDate!,
        memberCount: state.memberCount,
        invitedFriends: state.invitedFriends,
        note: state.note,
        createdAt: DateTime.now(),
      );

      await doc.set(group.toMap());

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Bạn có thể xử lý lỗi hiển thị ở UI
      debugPrint('Lỗi tạo nhóm: $e');
      rethrow;
    }
  }
}
