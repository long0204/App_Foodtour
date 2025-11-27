import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../config/constants/enum.dart';
import 'state.dart';

class ModeNotifier extends Notifier<ModeState> {
  static const _selectedModeKey = 'selectedMode';
  final _box = Hive.box('userBox');

  @override
  ModeState build() {
    final storedModeIndex = _box.get(_selectedModeKey);
    if (storedModeIndex != null && storedModeIndex is int) {
      final savedMode = ModeType.values[storedModeIndex];
      return ModeState(selectedMode: savedMode);
    }
    return const ModeState();
  }

  void selectMode(ModeType mode) {
    _box.put(_selectedModeKey, mode.index);
    state = state.copyWith(selectedMode: mode);
  }

  void clearMode() {
    _box.delete(_selectedModeKey);
    state = const ModeState();
  }
}

final modeNotifierProvider = NotifierProvider<ModeNotifier, ModeState>(
      () => ModeNotifier(),
);
