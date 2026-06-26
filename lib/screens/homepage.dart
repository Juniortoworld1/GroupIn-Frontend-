import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:groupin/provider/userlogin.provider.dart';
import 'package:provider/provider.dart';

import '../data/model/post_model.dart';
import '../data/network/feeddioClient.dart';
import '../routes/routes.dart';

// 🔧 ADJUST THESE TWO PATHS to match where these actually live in your project


class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postMessage = TextEditingController();

  List<PostModel> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _postMessage.dispose();
    super.dispose();
  }

  Future<void> _loadFeed() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await feed(); // returns response.data['data'], i.e. a List<dynamic>

      if (data == null) {
        setState(() {
          _error = "Couldn't load your feed. Pull down to try again.";
          _isLoading = false;
        });
        return;
      }

      final posts = (data as List)
          .map((item) => PostModel.fromMap(item as Map<String, dynamic>))
          .toList();

      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Something went wrong loading the feed.";
        _isLoading = false;
      });
    }
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year;
      final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$day/$month/$year $hour12 $ampm';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<UserLoginProvider>();
    final watch2 = context.watch<GlobalValueProvider>();
    final _isDark = watch2.getisDarkMode();
    final data = watch.user;
    final Color adaptiveTextColor = _isDark ? Colors.white : Colors.black;
    final Color adaptiveSubtextColor = _isDark ? Colors.white70 : Colors.black54;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: _isDark ? Colors.black : Colors.white,
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          height: double.infinity,
          width: screenWidth > 800 ? screenWidth * 0.6 : screenWidth,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showLogoutConfirmation(context),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: (data?.avatarUrl != null && data!.avatarUrl!.isNotEmpty)
                              ? NetworkImage(data.avatarUrl!)
                              : const NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          style: TextStyle(color: adaptiveTextColor),
                          decoration: InputDecoration(
                            hintText: 'Search or type here...',
                            hintStyle: TextStyle(color: adaptiveSubtextColor),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(Icons.notifications_none_outlined, color: adaptiveTextColor),
                        onPressed: () => print("Search text: ${_searchController.text}"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                    width: double.infinity,
                    child: Divider(thickness: 2, color: _isDark ? Colors.white24 : Colors.grey[300]),
                  ),

                  // --- Feed Content ---
                  Expanded(
                    child: _buildFeedBody(_isDark, adaptiveTextColor, adaptiveSubtextColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedBody(bool isDark, Color textColor, Color subtextColor) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: TextStyle(color: subtextColor), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadFeed, child: const Text("Retry")),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return Center(
        child: Text("No posts yet", style: TextStyle(color: subtextColor, fontSize: 16)),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFeed,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8),
        itemCount: _posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return _buildPostCard(_posts[index], isDark, textColor, subtextColor);
        },
      ),
    );
  }

  Widget _buildPostCard(PostModel post, bool isDark, Color textColor, Color subtextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: post.author.avatar.isNotEmpty
                  ? NetworkImage(post.author.avatar)
                  : null,
              child: post.author.avatar.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.author.fullName.isNotEmpty ? post.author.fullName : post.author.username,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  Text(
                    _formatDate(post.createdAt),
                    style: TextStyle(fontSize: 13, color: subtextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark ? Colors.white10 : Colors.grey[100],
              border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.text.isNotEmpty)
                    Text(post.text, style: TextStyle(fontSize: 16, color: textColor)),
                  if (post.mediaUrl.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _PostMediaGallery(urls: post.mediaUrl),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.favorite_border, color: textColor, size: 24),
                      const SizedBox(width: 4),
                      Text('${post.likes.length}', style: TextStyle(color: subtextColor)),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => _showCommentsBottomSheet(context, isDark, post.comments),
                        child: Icon(Icons.chat_bubble_outline, color: textColor, size: 24),
                      ),
                      const SizedBox(width: 4),
                      Text('${post.comments.length}', style: TextStyle(color: subtextColor)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(alertContext), child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.pop(alertContext);
                Provider.of<UserLoginProvider>(context, listen: false).logout();
                Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, bool isDark, List<dynamic> comments) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        "Comments",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: comments.isEmpty
                        ? Center(
                      child: Text(
                        "No comments yet",
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      ),
                    )
                        : ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        // ⚠️ Adjust field names below once your Comment shape is known
                        final c = comments[index];
                        final commentText = c is Map ? (c['text'] ?? c.toString()) : c.toString();
                        return ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text("User", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                          subtitle: Text(commentText.toString(), style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// A horizontal, swipeable image slider for posts with multiple images.
/// Snaps one image per page and shows dot indicators below for position,
/// like a typical Instagram-style carousel.
class _PostMediaGallery extends StatefulWidget {
  final List<String> urls;
  const _PostMediaGallery({required this.urls});

  @override
  State<_PostMediaGallery> createState() => _PostMediaGalleryState();
}

class _PostMediaGalleryState extends State<_PostMediaGallery> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stack) => const Center(child: Icon(Icons.broken_image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.urls;

    // Single image: no slider needed, just show it.
    if (urls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(height: 220, width: double.infinity, child: _buildImage(urls.first)),
      );
    }

    // Multiple images: full-width slider that snaps one at a time, with dots below.
    return Column(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: urls.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImage(urls[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(urls.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 8 : 6,
              height: isActive ? 8 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey.withOpacity(0.5),
              ),
            );
          }),
        ),
      ],
    );
  }
}