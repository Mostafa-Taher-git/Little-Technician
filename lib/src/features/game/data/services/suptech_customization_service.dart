import 'dart:convert';

import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/game/domain/models/suptech_customization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupTechCustomizationService {
  static const _baseKey = 'lt_suptech_customization';

  static String _key(int userId) => '${_baseKey}_$userId';

  static Future<SupTechCustomization> load() async {
    final uid = await AuthService.getCurrentUserId();
    if (uid == null) return const SupTechCustomization();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(uid));
    if (raw == null) return const SupTechCustomization();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return SupTechCustomization.fromJson(json);
    } catch (_) {
      return const SupTechCustomization();
    }
  }

  static Future<void> save(SupTechCustomization customization) async {
    final uid = await AuthService.getCurrentUserId();
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(uid), jsonEncode(customization.toJson()));
  }
}
