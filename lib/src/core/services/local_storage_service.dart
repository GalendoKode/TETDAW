import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('LocalStorageService must be initialized');
});

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static const String _sessionKey = 'user_session';
  static const String _timestampKey = 'session_timestamp';

  Future<void> saveSession(Map<String, dynamic> sessionData) async {
    await _prefs.setString(_sessionKey, jsonEncode(sessionData));
    await _prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Map<String, dynamic>? getSession() {
    final sessionString = _prefs.getString(_sessionKey);
    if (sessionString == null) return null;
    return jsonDecode(sessionString) as Map<String, dynamic>;
  }

  int? getSessionTimestamp() {
    return _prefs.getInt(_timestampKey);
  }

  Future<void> deleteSession() async {
    await _prefs.remove(_sessionKey);
    await _prefs.remove(_timestampKey);
  }
  
  bool isSessionValid() {
    final timestamp = getSessionTimestamp();
    if (timestamp == null) return false;
    
    final sessionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(sessionTime);
    
    return difference.inHours < 6;
  }
}
