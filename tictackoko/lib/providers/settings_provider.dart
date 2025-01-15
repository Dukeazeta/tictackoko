import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

enum AIDifficulty { easy, medium, hard }

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  ({bool isDarkMode, AIDifficulty aiDifficulty}) build() {
    return (isDarkMode: false, aiDifficulty: AIDifficulty.medium);
  }

  void toggleTheme() {
    state = (isDarkMode: !state.isDarkMode, aiDifficulty: state.aiDifficulty);
  }

  void setAIDifficulty(AIDifficulty difficulty) {
    state = (isDarkMode: state.isDarkMode, aiDifficulty: difficulty);
  }
}
