import 'package:dsage/db/model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserRepository {
  UserRepository._();

  static final UserRepository instance = UserRepository._();

  static const String boxName = 'users';

  Box get _box => Hive.box(boxName);

  Map<String, dynamic> _cast(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    return Map<String, dynamic>.from(raw as Map);
  }

  Future<int> insertUser(User user) => _box.add(user.toHiveMap());

  User? getUserById(int id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    return User.fromHiveMap(id, _cast(raw));
  }

  User? getUserByEmail(String email) {
    final target = email.trim().toLowerCase();
    for (final entry in _box.toMap().entries) {
      final map = _cast(entry.value);
      if ((map['email'] as String?)?.toLowerCase() == target) {
        return User.fromHiveMap(entry.key as int, map);
      }
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    if (user.id == null) return;
    await _box.put(user.id, user.toHiveMap());
  }

  Future<void> deleteUser(int id) => _box.delete(id);

  List<User> getAllUsers() {
    return _box
        .toMap()
        .entries
        .map((e) => User.fromHiveMap(e.key as int, _cast(e.value)))
        .toList();
  }
}
