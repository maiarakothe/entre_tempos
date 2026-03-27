class AppUser {
  final String name;
  final String email;

  AppUser({required this.name, required this.email});

  factory AppUser.fromMap(Map<String, dynamic> map, String email) {
    return AppUser(name: map['name'] ?? '', email: email);
  }
}
