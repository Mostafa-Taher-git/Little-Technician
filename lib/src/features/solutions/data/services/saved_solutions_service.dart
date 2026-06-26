import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/solutions/data/models/saved_solution_model.dart';

class SavedSolutionsService {
  static const _key = 'lt_saved_solutions';
  static int _nextId = 1;

  static Future<int?> _userId() async {
    return AuthService.getCurrentUserId();
  }

  static String _userKey(int userId) => '${_key}_$userId';

  static Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  static Future<List<SavedSolution>> getAll() async {
    final uid = await _userId();
    if (uid == null) return [];
    final prefs = await _prefs;
    final raw = prefs.getString(_userKey(uid));
    if (raw == null) return [];
    List list;
    try {
      list = jsonDecode(raw) as List;
    } on FormatException {
      await prefs.remove(_userKey(uid));
      return [];
    }
    final items = list.map((e) => SavedSolution.fromJson(e as Map<String, dynamic>)).toList();
    if (items.isNotEmpty) {
      final ids = items.map((s) => s.id ?? 0).toList();
      final maxId = ids.reduce((a, b) => a > b ? a : b);
      if (maxId >= _nextId) _nextId = maxId + 1;
    }
    return items;
  }

  static Future<void> _persist(List<SavedSolution> items) async {
    final uid = await _userId();
    if (uid == null) return;
    final prefs = await _prefs;
    await prefs.setString(_userKey(uid), jsonEncode(items.map((s) => s.toJson()).toList()));
  }

  static Future<void> save(SavedSolution solution) async {
    final all = await getAll();
    // Avoid duplicates
    if (all.any((s) => s.problemTitle == solution.problemTitle)) return;
    final withId = SavedSolution(
      id: _nextId++,
      problemTitle: solution.problemTitle,
      category: solution.category,
      steps: solution.steps,
      savedAt: solution.savedAt,
    );
    all.add(withId);
    await _persist(all);
  }

  static Future<void> delete(int id) async {
    final all = await getAll();
    all.removeWhere((s) => s.id == id);
    await _persist(all);
  }

  static Future<bool> isSaved(String title) async {
    final all = await getAll();
    return all.any((s) => s.problemTitle == title);
  }
}
