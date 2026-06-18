import 'package:shared_preferences/shared_preferences.dart';

class SolvedProblemsService {
  static const _key = 'lt_solved_problems';

  static Future<Set<String>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? {};
  }

  static Future<bool> isSolved(String problemName) async {
    final solved = await _loadAll();
    return solved.contains(problemName);
  }

  static Future<void> markSolved(String problemName) async {
    final solved = await _loadAll();
    solved.add(problemName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, solved.toList());
  }

  static Future<void> unmarkSolved(String problemName) async {
    final solved = await _loadAll();
    solved.remove(problemName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, solved.toList());
  }
}
