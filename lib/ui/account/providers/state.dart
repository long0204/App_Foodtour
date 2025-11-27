import 'package:equatable/equatable.dart';

class AvatarState extends Equatable {
  final String? avatarUrl;
  final bool isLoading;

  const AvatarState({this.avatarUrl, this.isLoading = false});

  AvatarState copyWith({String? avatarUrl, bool? isLoading}) {
    return AvatarState(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [avatarUrl, isLoading];
}
