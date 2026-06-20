import 'package:shared_preferences/shared_preferences.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';

class SolvedProblemsService {
  static const _key = 'lt_solved_problems';

  static Future<int?> _userId() async {
    return AuthService.getCurrentUserId();
  }

  static String _userKey(int userId) => '${_key}_$userId';

  static Future<Set<String>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = await _userId();
    if (uid == null) return {};
    return prefs.getStringList(_userKey(uid))?.toSet() ?? {};
  }

  static Future<bool> isSolved(String problemName) async {
    final solved = await _loadAll();
    return solved.contains(problemName);
  }

  static Future<void> markSolved(String problemName) async {
    final uid = await _userId();
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    final key = _userKey(uid);
    final solved = prefs.getStringList(key)?.toSet() ?? {};
    solved.add(problemName);
    await prefs.setStringList(key, solved.toList());
  }

  static Future<void> unmarkSolved(String problemName) async {
    final uid = await _userId();
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    final key = _userKey(uid);
    final solved = prefs.getStringList(key)?.toSet() ?? {};
    solved.remove(problemName);
    await prefs.setStringList(key, solved.toList());
  }
}
