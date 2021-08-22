import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './post.dart';

class Posts with ChangeNotifier {
  List<Post> _posts;

  Posts(this._posts);

  List<Post> get posts {
    return [..._posts];
  }

  Future<void> fetchAndSetPosts(Map<String, dynamic> queryParameters) async {
    queryParameters['limit'] = '15';

    final url = Uri(
        scheme: 'http',
        host: '192.168.1.9',
        port: 5000,
        path: 'api/posts',
        queryParameters: queryParameters);

    try {
      final response = await http.get(url);
      final dynamic data = json.decode(response.body);
      final List<Post> loadedPosts = [];
      data['result'].forEach((element) {
        loadedPosts.add(Post.fromJson(element));
      });
      _posts = loadedPosts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Post findById(int id) {
    return _posts.firstWhere((element) => element.id == id);
  }

  void clearPosts() {
    _posts = [];
  }
}
