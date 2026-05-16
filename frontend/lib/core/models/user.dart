class AppUser {
  final int id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String role; // 'user' | 'admin'
  final String? token;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.role,
    this.token,
  });

  bool get isAdmin => role == 'admin';

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'user',
      token: json['token'] as String?,
    );
  }

  AppUser copyWith({String? username, String? avatarUrl, String? token}) {
    return AppUser(
      id: id,
      username: username ?? this.username,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role,
      token: token ?? this.token,
    );
  }
}
