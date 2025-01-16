import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Abstract storage interface
abstract class StorageService {
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
}

/// Memory-based storage implementation for web
class MemoryStorageService implements StorageService {
  static final Map<String, dynamic> _store = {};

  @override
  Future<void> setBool(String key, bool value) async {
    _store[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async {
    return _store[key] as bool?;
  }

  @override
  Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<String?> getString(String key) async {
    return _store[key] as String?;
  }
}

/// SharedPreferences-based storage implementation for mobile/desktop
class SharedPrefsStorageService implements StorageService {
  late final SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    } catch (e) {
      print('Failed to initialize SharedPreferences: $e');
    }
  }

  @override
  Future<void> setBool(String key, bool value) async {
    if (!_initialized) return;
    await _prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    if (!_initialized) return null;
    return _prefs.getBool(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    if (!_initialized) return;
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    if (!_initialized) return null;
    return _prefs.getString(key);
  }
}

/// Factory to create the appropriate storage service
class StorageServiceFactory {
  static StorageService create() {
    if (kIsWeb) {
      return MemoryStorageService();
    } else {
      return SharedPrefsStorageService();
    }
  }
}
