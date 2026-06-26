class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String avatar;
  final String coverImage;
  final List<dynamic> friends;
  final List<dynamic> post;
  final List<dynamic> likes;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.avatar,
    required this.coverImage,
    required this.friends,
    required this.post,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      avatar: map['avatar'] ?? '',
      coverImage: map['coverImage'] ?? '',
      friends: List<dynamic>.from(map['friends'] ?? []),
      post: List<dynamic>.from(map['post'] ?? []),
      likes: List<dynamic>.from(map['likes'] ?? []),
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }
}