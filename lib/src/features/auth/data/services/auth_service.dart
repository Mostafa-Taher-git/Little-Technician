import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:littletech/src/features/auth/data/models/user_model.dart';

class AuthService {
  static const _usersKey = 'lt_users';
  static const _sessionKey = 'lt_session';
  static SharedPreferences? _cachedPrefs;

  static Future<SharedPreferences> get _prefs async {
    _cachedPrefs ??= await SharedPreferences.getInstance();
    return _cachedPrefs!;
  }

  static void init(SharedPreferences prefs) {
    _cachedPrefs = prefs;
  }

  static int? getCachedUserId() {
    return _cachedPrefs?.getInt('${_sessionKey}_id');
  }

  /// Read user ID directly from disk, bypassing in-memory cache.
  /// Use after login/logout to get the freshest value.
  static Future<int?> getFreshUserId() async {
    final prefs = await _prefs;
    return prefs.getInt('${_sessionKey}_id');
  }

  // ── Password hashing ─────────────────────────────────────────────────────

  static String _generateSalt() {
    final rng = Random.secure();
    return List.generate(16, (_) => rng.nextInt(36).toRadixString(36)).join();
  }

  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt$password');
    return sha256.convert(bytes).toString();
  }

  static String _saltAndHash(String password) {
    final salt = _generateSalt();
    final hash = _hashPassword(password, salt);
    return '$salt:$hash';
  }

  /// Returns true if [stored] is in "salt:hash" format.
  static bool _isHashed(String stored) => stored.contains(':');

  /// Verify a plaintext password against a stored value (hashed or legacy).
  static bool _verifyPassword(String password, String stored) {
    if (_isHashed(stored)) {
      final parts = stored.split(':');
      if (parts.length != 2) return false;
      return _hashPassword(password, parts[0]) == parts[1];
    }
    return password == stored;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static Future<List<UserModel>> _loadUsers() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    final users = list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
    bool migrated = false;
    for (var i = 0; i < users.length; i++) {
      if (users[i].id == 0) {
        users[i].id = i + 1;
        migrated = true;
      }
    }
    if (migrated) await _saveUsers(users);
    return users;
  }

  static Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await _prefs;
    final raw = jsonEncode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_usersKey, raw);
  }

  // ── Migration ──────────────────────────────────────────────────────────────

  static Future<void> migrateUserData(int userId) async {
    final prefs = await _prefs;

    final olds = prefs.getStringList('lt_solved_problems');
    if (olds != null) {
      final newKey = 'lt_solved_problems_$userId';
      if (prefs.getStringList(newKey) == null) {
        await prefs.setStringList(newKey, olds);
      }
      await prefs.remove('lt_solved_problems');
    }

    final oldSaved = prefs.getString('lt_saved_solutions');
    if (oldSaved != null) {
      final newKey = 'lt_saved_solutions_$userId';
      if (prefs.getString(newKey) == null) {
        await prefs.setString(newKey, oldSaved);
      }
      await prefs.remove('lt_saved_solutions');
    }

    final oldCount = prefs.getInt('lt_problem_counter');
    if (oldCount != null) {
      final newKey = 'lt_problem_counter_$userId';
      if (prefs.getInt(newKey) == null) {
        await prefs.setInt(newKey, oldCount);
      }
      await prefs.remove('lt_problem_counter');
    }
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  static Future<bool> register({
    required String username,
    required String password,
    String avatarIcon = '🔧',
  }) async {
    final users = await _loadUsers();
    if (users.any((u) => u.username.toLowerCase() == username.toLowerCase())) {
      return false;
    }
    final newId = users.isEmpty ? 1 : users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;
    users.add(UserModel(id: newId, username: username, password: _saltAndHash(password), avatarIcon: avatarIcon));
    await _saveUsers(users);
    final prefs = await _prefs;
    await prefs.setString(_sessionKey, username);
    await prefs.setInt('${_sessionKey}_id', newId);
    await migrateUserData(newId);
    return true;
  }

  static Future<bool> login({required String username, required String password}) async {
    final users = await _loadUsers();
    UserModel? match;
    for (final u in users) {
      if (u.username.toLowerCase() == username.toLowerCase() && _verifyPassword(password, u.password)) {
        match = u;
        break;
      }
    }
    if (match == null) return false;
    // Transparently re-hash if stored as legacy plaintext
    if (!_isHashed(match.password)) {
      match.password = _saltAndHash(password);
      await _saveUsers(users);
    }
    final prefs = await _prefs;
    await prefs.setString(_sessionKey, match.username);
    await prefs.setInt('${_sessionKey}_id', match.id);
    await migrateUserData(match.id);
    return true;
  }

  static Future<int?> getCurrentUserId() async {
    final prefs = await _prefs;
    return prefs.getInt('${_sessionKey}_id');
  }

  static Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionKey);
    await prefs.remove('${_sessionKey}_id');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getString(_sessionKey) != null;
  }

  static Future<UserModel?> getCurrentUser() async {
    final prefs = await _prefs;
    final username = prefs.getString(_sessionKey);
    if (username == null) return null;
    final users = await _loadUsers();
    for (final u in users) {
      if (u.username == username) return u;
    }
    return null;
  }

  static Future<List<UserModel>> getAllUsers() => _loadUsers();

  static Future<bool> userExists(String username) async {
    final users = await _loadUsers();
    return users.any((u) => u.username.toLowerCase() == username.toLowerCase());
  }

  static Future<bool> updatePassword({required String username, required String newPassword}) async {
    final users = await _loadUsers();
    final idx = users.indexWhere((u) => u.username.toLowerCase() == username.toLowerCase());
    if (idx < 0) return false;
    users[idx].password = _saltAndHash(newPassword);
    await _saveUsers(users);
    return true;
  }

  /// Delete a user completely — removes from users list, clears per-user prefs, clears session
  static Future<void> deleteUser(int userId) async {
    final users = await _loadUsers();
    users.removeWhere((u) => u.id == userId);
    await _saveUsers(users);
    final prefs = await _prefs;
    await prefs.remove('lt_solved_problems_$userId');
    await prefs.remove('lt_saved_solutions_$userId');
    await prefs.remove('lt_problem_counter_$userId');
    await prefs.remove(_sessionKey);
    await prefs.remove('${_sessionKey}_id');
  }

  /// Reset all users for testing - call this to start fresh
  static Future<void> resetAllUsers() async {
    final prefs = await _prefs;
    await prefs.remove(_usersKey);
    await prefs.remove(_sessionKey);
    await prefs.remove('${_sessionKey}_id');
    _cachedPrefs = null;
  }

  static Future<void> addPoints(String username, int delta) async {
    final users = await _loadUsers();
    final idx = users.indexWhere((u) => u.username == username);
    if (idx >= 0) {
      users[idx].points += delta;
      await _saveUsers(users);
    }
  }
}
