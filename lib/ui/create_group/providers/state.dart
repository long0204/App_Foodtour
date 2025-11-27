part of 'notifier.dart';

class GroupState extends Equatable {
  final String groupName;
  final DateTime? startDate;
  final DateTime? endDate;
  final int memberCount;
  final List<String> invitedFriends;
  final String note;
  final bool isLoading;

  const GroupState({
    this.groupName = '',
    this.startDate,
    this.endDate,
    this.memberCount = 1,
    this.invitedFriends = const [],
    this.note = '',
    this.isLoading = false,
  });

  GroupState copyWith({
    String? groupName,
    DateTime? startDate,
    DateTime? endDate,
    int? memberCount,
    List<String>? invitedFriends,
    String? note,
    bool? isLoading,
  }) {
    return GroupState(
      groupName: groupName ?? this.groupName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      memberCount: memberCount ?? this.memberCount,
      invitedFriends: invitedFriends ?? this.invitedFriends,
      note: note ?? this.note,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [groupName, startDate, endDate, memberCount, invitedFriends, note, isLoading];
}
