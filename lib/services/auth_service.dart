import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  AuthService._();

  static const String boxName = 'session';

  static const String _keyUserId = 'active_user_id';

  static Box get _box => Hive.box(boxName);

  static Future<void> saveUserId(int id) => _box.put(_keyUserId, id);

  static int? getUserId() => _box.get(_keyUserId) as int?;

  static Future<void> clearSession() => _box.delete(_keyUserId);
}
