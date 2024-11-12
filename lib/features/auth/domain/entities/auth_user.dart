class AuthUser {
  final String id;
  final String email;
  final String name;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}
