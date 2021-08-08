class User {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? active;
  final String? activationToken;
  final DateTime? activationTokenExpires;
  final String? resetPasswordToken;
  final DateTime? resetPasswordExpires;
  final Map<String, bool>? favorites;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.active,
    this.activationToken,
    this.activationTokenExpires,
    this.resetPasswordToken,
    this.resetPasswordExpires,
    this.favorites,
  });

  factory User.fromJson(dynamic json) {
    return User(
      id: json['_id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      active: json['active'] as bool?,
      activationToken: json['activationToken'] as String?,
      activationTokenExpires: json['activationTokenExpires'] == null
          ? null
          : DateTime.parse(json['activationTokenExpires'] as String),
      resetPasswordToken: json['resetPasswordToken'] as String?,
      resetPasswordExpires: json['resetPasswordExpires'] == null
          ? null
          : DateTime.parse(json['resetPasswordExpires'] as String),
      favorites: json['favorites'] == null
          ? null
          : (json['favorites'] as Map<String, dynamic>).cast<String, bool>(),
    );
  }
}
