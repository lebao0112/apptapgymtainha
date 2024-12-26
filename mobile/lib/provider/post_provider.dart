import 'package:flutter/material.dart';
import '../service/api_social_media.dart';

class PostProvider with ChangeNotifier {
  List<dynamic> _posts = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;
  List<dynamic> get posts => _posts;
  bool get isLoading => _isLoading;

  PostProvider() {
    loadPosts();
  }



  // Future<void> loadPosts() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     var data = await ApiSocialMedia.fetchPosts();
  //     _posts = data["posts"];
  //   } catch (error) {
  //     print("Error loading posts: $error");
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> loadPosts() async {
    _currentPage = 1; // Reset lại trang về 1
    _hasMore = true; // Reset trạng thái còn dữ liệu
    _posts = [];
    notifyListeners();
    await loadMorePosts(); // Gọi loadMore để tải trang đầu tiên
  }

  Future<void> loadMorePosts() async {
    if (!_hasMore) return; // Không tải thêm nếu đã hết dữ liệu

    try {
      final data = await ApiSocialMedia.fetchPosts(_currentPage);
      final newPosts = data["posts"];
      if (newPosts.isNotEmpty) {
        _posts.addAll(newPosts); // Thêm dữ liệu mới vào danh sách hiện tại
        _currentPage++; // Tăng trang hiện tại
      } else {
        _hasMore = false; // Đánh dấu đã tải hết dữ liệu
      }
      notifyListeners();
    } catch (error) {
      print("Error loading more posts: $error");
    }
  }

  Future<void> searchPosts(String keyword) async {
    _isLoading = true;
    _posts = [];
    notifyListeners();

    try {
      final data = await ApiSocialMedia.searchPosts(keyword, 1);
      _posts = data["posts"];
      _hasMore = data["hasMore"];
    } catch (error) {
      print("Error searching posts: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreSearchResults(String keyword) async {
    if (!_hasMore || _isLoading) return;

    try {
      final data = await ApiSocialMedia.searchPosts(keyword, _currentPage + 1);
      _posts.addAll(data["posts"]);
      _hasMore = data["hasMore"];
      _currentPage++;
      notifyListeners();
    } catch (error) {
      print("Error loading more search results: $error");
    }
  }

}
