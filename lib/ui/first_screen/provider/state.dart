// onboarding_state.dart
import 'dart:io';
import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final DateTime? selectedDate;
  final File? avatarLeft;
  final File? avatarRight;
  final bool isPicking;

  const OnboardingState({
    this.selectedDate,
    this.avatarLeft,
    this.avatarRight,
    this.isPicking = false,
  });

  OnboardingState copyWith({
    DateTime? selectedDate,
    File? avatarLeft,
    File? avatarRight,
    bool? isPicking,
  }) {
    return OnboardingState(
      selectedDate: selectedDate ?? this.selectedDate,
      avatarLeft: avatarLeft ?? this.avatarLeft,
      avatarRight: avatarRight ?? this.avatarRight,
      isPicking: isPicking ?? this.isPicking,
    );
  }

  @override
  List<Object?> get props => [selectedDate, avatarLeft, avatarRight, isPicking];
}
