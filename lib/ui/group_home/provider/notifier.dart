import 'package:Foodtour/ui/group_home/provider/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/model/group_model.dart';

class GroupHomeNotifier extends Notifier<GroupHomeState> {
  final _groupCollection = FirebaseFirestore.instance.collection('groups');

  @override
  GroupHomeState build() {
    return GroupHomeState.initial();
  }

  Future<void> loadGroups() async {
    state = state.copyWith(isLoading: true);
    try {
      final snapshot = await _groupCollection.orderBy('createdAt', descending: true).get();
      final groups = snapshot.docs.map((doc) => GroupModel.fromMap(doc.data())).toList();
      state = state.copyWith(groups: groups, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addGroup(GroupModel group) async {
    try {
      await _groupCollection.doc(group.id).set(group.toMap());
      await loadGroups(); // Refresh list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final groupHomeNotifierProvider =
NotifierProvider<GroupHomeNotifier, GroupHomeState>(() => GroupHomeNotifier());
