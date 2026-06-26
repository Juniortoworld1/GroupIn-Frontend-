class UserModel {
  final String username;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String? coverImage;

  UserModel({
    required this.username,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.coverImage,
  });
}