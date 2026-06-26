import 'package:flutter/material.dart';
class PostMediaGallery extends StatefulWidget {
  final List<String> urls;
  const PostMediaGallery({required this.urls});

  @override
  State<PostMediaGallery> createState() => _PostMediaGalleryState();
}

class _PostMediaGalleryState extends State<PostMediaGallery> {
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