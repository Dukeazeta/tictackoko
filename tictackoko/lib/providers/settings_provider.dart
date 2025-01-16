import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/storage_service.dart';

part 'settings_provider.g.dart';

// Keys for storage
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

// Create a provider for the storage service
@Riverpod(keepAlive: true)
StorageService storageService(StorageServiceRef ref) {
  final service = StorageServiceFactory.create();
  if (service is SharedPrefsStorageService) {
    service.init();
  }
  return service;
}

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  late final StorageService _storage;

  @override
  Future<Settings> build() async {
    _storage = ref.read(storageServiceProvider);
    
    // Load saved settings or use defaults
    final savedDarkMode = await _storage.getBool(_kDarkModeKey) ?? false;
    final savedDifficulty = await _storage.getString(_kAIDifficultyKey) ?? AIDifficulty.medium.name;
    
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
    final newSettings = Settings(
      isDarkMode: !currentState.isDarkMode,
      aiDifficulty: currentState.aiDifficulty,
    );
    
    await _storage.setBool(_kDarkModeKey, newSettings.isDarkMode);
    state = AsyncValue.data(newSettings);
  }

  // Save AI difficulty setting
  Future<void> setAIDifficulty(AIDifficulty difficulty) async {
    final currentState = await future;
    final newSettings = Settings(
      isDarkMode: currentState.isDarkMode,
      aiDifficulty: difficulty,
    );
    
    await _storage.setString(_kAIDifficultyKey, difficulty.name);
    state = AsyncValue.data(newSettings);
  }
}
