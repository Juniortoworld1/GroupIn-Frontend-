import 'package:flutter/material.dart';
import 'package:groupin/data/model/post_model.dart';
import '../data/network/feeddioClient.dart';

class Postrefresh extends StatefulWidget {
  // Pass a function that takes the list of posts and returns a Widget
  final Widget Function(BuildContext context, List<PostModel> posts, Future<void> Function() onRefresh) builder;

  const Postrefresh({super.key, required this.builder,});

  @override
  State<Postrefresh> createState() => _PostrefreshState();
}

class _PostrefreshState extends State<Postrefresh> {
  List<PostModel> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  // Your existing _loadFeed logic (Fixed a small closing bracket syntax issue here)
  Future<void> _loadFeed() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await feed();
      if (data == null) {
        setState(() {
          _error = "Couldn't load your feed. Pull down to refresh.";
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(_error!),
        ),
      );
    }

    // Wrap with RefreshIndicator so users can pull down to call _loadFeed again
    return RefreshIndicator(
      onRefresh: _loadFeed,
      child: widget.builder(context, _posts, _loadFeed),
    );
  }
}