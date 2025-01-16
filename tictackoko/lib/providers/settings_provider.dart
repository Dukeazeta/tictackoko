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
  late final SharedPreferences _prefs;

  @override
  Future<Settings> build() async {
    // Initialize SharedPreferences
    try {
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
    } catch (e) {
      // Return default settings if SharedPreferences fails
      return const Settings(
        isDarkMode: false,
        aiDifficulty: AIDifficulty.medium,
      );
    }
  }

  // Save theme setting
  Future<void> toggleTheme() async {
    try {
      final currentState = await future;
      final newSettings = Settings(
        isDarkMode: !currentState.isDarkMode,
        aiDifficulty: currentState.aiDifficulty,
      );
      
      state = AsyncValue.data(newSettings);
      await _prefs.setBool(_kDarkModeKey, newSettings.isDarkMode);
    } catch (e) {
      // Handle error silently and keep the UI working
      final currentState = await future;
      state = AsyncValue.data(Settings(
        isDarkMode: !currentState.isDarkMode,
        aiDifficulty: currentState.aiDifficulty,
      ));
    }
  }

  // Save AI difficulty setting
  Future<void> setAIDifficulty(AIDifficulty difficulty) async {
    try {
      final currentState = await future;
      final newSettings = Settings(
        isDarkMode: currentState.isDarkMode,
        aiDifficulty: difficulty,
      );
      
      state = AsyncValue.data(newSettings);
      await _prefs.setString(_kAIDifficultyKey, difficulty.name);
    } catch (e) {
      // Handle error silently and keep the UI working
      final currentState = await future;
      state = AsyncValue.data(Settings(
        isDarkMode: currentState.isDarkMode,
        aiDifficulty: difficulty,
      ));
    }
  }
}
