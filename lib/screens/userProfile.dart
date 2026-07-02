import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:groupin/utils/PostRefresh.dart'; // Ensure exact capitalization matches your file
import 'package:provider/provider.dart';

import '../data/model/post_model.dart';
import '../provider/userlogin.provider.dart';
import '../utils/multiImageViewer.dart'; // Import your multi-image viewer class

class userProfile extends StatefulWidget {
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<userProfile> {

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year;
      final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$day/$month/$year $hour12:$month $ampm';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<UserLoginProvider>();
    final isDark = context.watch<GlobalValueProvider>().getisDarkMode();
    final user = loginProvider.user;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white60 : Colors.black54;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushReplacementNamed('/user/${user?.username}');
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: screenWidth > 800 ? screenWidth * 0.6 : screenWidth,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            user?.username ?? 'Profile',
                            style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.menu_rounded, color: textColor),
                        onPressed: () {},
                      ),
                    ],
                  ) ,


                  Expanded(
                    child: Postrefresh(
                      builder: (context, allPosts, onRefresh) {
                        // Filters feed items strictly down to the active profile author context
                        final userPosts = allPosts.where((post) => post.author.username == user?.username).toList();

                        return CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            CupertinoSliverRefreshControl(onRefresh: () async => onRefresh()),

                            // --- Structural Profile Card Block ---
                            SliverToBoxAdapter(
                              child: _buildProfileCardHeader(user, isDark, textColor, subtitleColor, userPosts.length),
                            ),

                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  "My Posts",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                                ),
                              ),
                            ),

                            // --- Home Feed Renderer Implementation ---
                            _buildFeedList(userPosts, isDark, textColor, subtitleColor),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Refactored cleanly into dynamic modern home-style list representation
  Widget _buildFeedList(List<PostModel> posts, bool isDark, Color textColor, Color subtextColor) {
    if (posts.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Center(
            child: Text(
              "No posts published yet.",
              style: TextStyle(color: subtextColor, fontSize: 15),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final post = posts[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey[200]!, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta: Author Profile Avatar & Details Layout Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: post.author.avatar.isNotEmpty ? NetworkImage(post.author.avatar) : null,
                      child: post.author.avatar.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author.fullName.isNotEmpty ? post.author.fullName : post.author.username,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(post.createdAt),
                            style: TextStyle(fontSize: 12, color: subtextColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Text Content Render Frame
                if (post.text.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    post.text,
                    style: TextStyle(fontSize: 15, color: textColor, height: 1.45),
                  ),
                ],

                // Dynamic Post Attachment Media Gallery Pipeline Injection
                if (post.mediaUrl.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  PostMediaGallery(urls: post.mediaUrl),
                ],

                const SizedBox(height: 14),

                // Industry Native Minimalist Engagement Interaction Bar
                Row(
                  children: [
                    _buildInteractionButton(
                      icon: Icons.favorite_border_rounded,
                      label: '${post.likes.length}',
                      color: subtextColor,
                      onTap: () {},
                    ),
                    const SizedBox(width: 28),
                    _buildInteractionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: '${post.comments.length}',
                      color: subtextColor,
                      onTap: () {},
                    ),
                    const SizedBox(width: 28),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.share_outlined, size: 20, color: subtextColor),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        childCount: posts.length,
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // Structural user data display implementation representation shell
  Widget _buildProfileCardHeader(dynamic user, bool isDark, Color textColor, Color subtextColor, int postCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 160,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark ? Colors.white10 : Colors.black12,
              ),
              child: (user?.coverImage != null && user!.coverImage.isNotEmpty)
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(user.coverImage, fit: BoxFit.cover),
              )
                  : Icon(Icons.landscape, size: 40, color: isDark ? Colors.white24 : Colors.black26),
            ),
            Positioned(
              bottom: -15,
              left: 28,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? Colors.black : Colors.white, width: 4),
                ),
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor: isDark ? Colors.grey[900] : Colors.grey[200],
                  backgroundImage: (user?.avatar != null && user!.avatar!.isNotEmpty)
                      ? NetworkImage(user.avatar!)
                      : const NetworkImage('https://via.placeholder.com/150'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.username ?? '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 4),
              Text(
                "Bio - Everything is all right inshallah",
                style: TextStyle(fontSize: 14, color: subtextColor),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text("$postCount ", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  Text("posts", style: TextStyle(color: subtextColor)),
                  SizedBox(width: 8,) ,
                  Text("${user.friends.length} ", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  Text("Friends", style: TextStyle(color: subtextColor)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: isDark ? Colors.white10 : Colors.grey[200]),
      ],
    );
  }
}