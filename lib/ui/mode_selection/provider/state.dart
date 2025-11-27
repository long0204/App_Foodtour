import 'package:equatable/equatable.dart';
import '../../../config/constants/enum.dart';

class ModeState extends Equatable {
  final ModeType? selectedMode;

  const ModeState({this.selectedMode});

  ModeState copyWith({ModeType? selectedMode}) {
    return ModeState(selectedMode: selectedMode ?? this.selectedMode);
  }

  @override
  List<Object?> get props => [selectedMode];
}
