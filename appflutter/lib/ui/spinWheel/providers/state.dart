part of 'notifier.dart';

class SpinWheelState extends Equatable {
  final bool isSpinning;
  final bool showResult;
  final int selectedIndex;

  const SpinWheelState({
    required this.isSpinning,
    required this.showResult,
    required this.selectedIndex,
  });

  SpinWheelState copyWith({
    bool? isSpinning,
    bool? showResult,
    int? selectedIndex,
  }) {
    return SpinWheelState(
      isSpinning: isSpinning ?? this.isSpinning,
      showResult: showResult ?? this.showResult,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object> get props => [isSpinning, showResult, selectedIndex];
}
