import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterService {
  static const _baseKey = 'lt_problem_counter';

  static String _key(int userId) => '${_baseKey}_$userId';

  static Future<int> load() async {
    final uid = await AuthService.getCurrentUserId();
    if (uid == null) return 0;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key(uid)) ?? 0;
  }

  static Future<void> save(int value) async {
    final uid = await AuthService.getCurrentUserId();
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key(uid), value);
  }
}
