class PostModel {
  final String id;
  final Author author;
  final String text;
  final List<String> mediaUrl;
  final List<String> mediaType;
  final String privacy;
  final List<dynamic> likes;
  final List<dynamic> comments;
  final List<dynamic> shares;
  final String createdAt;

  PostModel({
    required this.id,
    required this.author,
    required this.text,
    required this.mediaUrl,
    required this.mediaType,
    required this.privacy,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['_id'] ?? '',
      author: Author.fromMap(map['author'] ?? {}),
      text: map['text'] ?? '',
      mediaUrl: List<String>.from(map['mediaUrl'] ?? []),
      mediaType: List<String>.from(map['mediaType'] ?? []),
      privacy: map['privacy'] ?? 'public',
      likes: List<dynamic>.from(map['likes'] ?? []),
      // Notice 'Comment' capitalized to match your JSON key
      comments: List<dynamic>.from(map['Comment'] ?? []),
      shares: List<dynamic>.from(map['shares'] ?? []),
      createdAt: map['createdAt'] ?? '',
    );
  }
}

class Author {
  final String id;
  final String fullName;
  final String username;
  final String avatar;

  Author({
    required this.id,
    required this.fullName,
    required this.username,
    required this.avatar,
  });

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['_id'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      avatar: map['avatar'] ?? '',
    );
  }
}