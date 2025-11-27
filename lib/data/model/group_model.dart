class GroupModel {
  final String id;
  final String groupName;
  final DateTime startDate;
  final DateTime endDate;
  final int memberCount;
  final List<String> invitedFriends;
  final String note;
  final DateTime createdAt;

  GroupModel({
    required this.id,
    required this.groupName,
    required this.startDate,
    required this.endDate,
    required this.memberCount,
    required this.invitedFriends,
    required this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupName': groupName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'memberCount': memberCount,
      'invitedFriends': invitedFriends,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static GroupModel fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'],
      groupName: map['groupName'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      memberCount: map['memberCount'],
      invitedFriends: List<String>.from(map['invitedFriends']),
      note: map['note'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
