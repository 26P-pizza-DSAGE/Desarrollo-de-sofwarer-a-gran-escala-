enum Role { admin, user }

class User {
  final int? id;
  final String username;
  final Role role;
  final String email;
  final String password;

  User({
    this.id,
    required this.username,
    required this.role,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toHiveMap() {
    return {
      'username': username,
      'role': role.name, // 'admin' | 'user'
      'email': email,
      'password': password,
    };
  }

  factory User.fromHiveMap(int id, Map<String, dynamic> map) {
    return User(
      id: id,
      username: map['username'] as String,
      role: Role.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => Role.user,
      ),
      email: map['email'] as String,
      password: map['password'] as String? ?? '',
    );
  }
}
