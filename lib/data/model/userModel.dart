class UserModel {
  final String username;
  final String email;
  final String avatarUrl;
  final String coverImage;

  UserModel({
    this.username = '',
    this.email = '',
    this.avatarUrl = '',
    this.coverImage = '',
  });

  // Factory to safely parse from JSON/Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatar'] ?? '',
      coverImage: map['coverImage'] ?? '',
    );
  }
}