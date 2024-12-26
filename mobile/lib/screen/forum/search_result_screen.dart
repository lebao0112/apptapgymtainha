import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../service/api_social_media.dart';
import '../forum/post_widget.dart';

import 'package:flutter/material.dart';
import '../forum/post_widget.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && _hasMore && !_isLoadingMore) {
        _loadMoreResults();
      }
    });
  }

  Future<void> _fetchSearchResults() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ApiSocialMedia.searchPosts(widget.query, 1);
      setState(() {
        _posts = data['posts'];
        _hasMore = data['hasMore'];
      });
    } catch (error) {
      print('Error fetching search results: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreResults() async {
    if (!_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final data = await ApiSocialMedia.searchPosts(widget.query, _currentPage + 1);
      setState(() {
        _posts.addAll(data['posts']);
        _hasMore = data['hasMore'];
        _currentPage++;
      });
    } catch (error) {
      print('Error loading more results: $error');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshResults() async {
    _currentPage = 1;
    _hasMore = true;
    _posts.clear();
    await _fetchSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả cho "${widget.query}"'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshResults,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _posts.length + 1,
          itemBuilder: (context, index) {
            if (index < _posts.length) {
              return PostWidget(post: _posts[index]);
            } else if (_isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
