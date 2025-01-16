import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

// Keys for SharedPreferences
const String _kDarkModeKey = 'darkMode';
const String _kAIDifficultyKey = 'aiDifficulty';

enum AIDifficulty { easy, medium, hard }

// Settings state class
class Settings {
  final bool isDarkMode;
  final AIDifficulty aiDifficulty;

  const Settings({
    required this.isDarkMode,
    required this.aiDifficulty,
  });

  Settings copyWith({
    bool? isDarkMode,
    AIDifficulty? aiDifficulty,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
    );
  }
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  // Initialize SharedPreferences instance
  late final SharedPreferences _prefs;

  @override
  Future<Settings> build() async {
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    
    // Load saved settings or use defaults
    final savedDarkMode = _prefs.getBool(_kDarkModeKey) ?? false;
    final savedDifficulty = _prefs.getString(_kAIDifficultyKey) ?? AIDifficulty.medium.name;
    
    return Settings(
      isDarkMode: savedDarkMode,
      aiDifficulty: AIDifficulty.values.firstWhere(
        (d) => d.name == savedDifficulty,
        orElse: () => AIDifficulty.medium,
      ),
    );
  }

  // Save theme setting
  Future<void> toggleTheme() async {
    final currentState = await future;
    state = AsyncValue.data(Settings(
      isDarkMode: !currentState.isDarkMode,
      aiDifficulty: currentState.aiDifficulty,
    ));
    await _prefs.setBool(_kDarkModeKey, !currentState.isDarkMode);
  }

  // Save AI difficulty setting
  Future<void> setAIDifficulty(AIDifficulty difficulty) async {
    final currentState = await future;
    state = AsyncValue.data(Settings(
      isDarkMode: currentState.isDarkMode,
      aiDifficulty: difficulty,
    ));
    await _prefs.setString(_kAIDifficultyKey, difficulty.name);
  }
}
