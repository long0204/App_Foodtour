import 'package:equatable/equatable.dart';
import '../../../data/model/group_model.dart';

class GroupHomeState extends Equatable {
  final List<GroupModel> groups;
  final bool isLoading;
  final String? error;

  const GroupHomeState({
    required this.groups,
    this.isLoading = false,
    this.error,
  });

  factory GroupHomeState.initial() => const GroupHomeState(groups: []);

  GroupHomeState copyWith({
    List<GroupModel>? groups,
    bool? isLoading,
    String? error,
  }) {
    return GroupHomeState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [groups, isLoading, error];
}
