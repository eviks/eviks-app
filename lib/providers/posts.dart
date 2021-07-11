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

  Future<void> fetchAndSetPosts() async {
    final url = Uri.parse('http://192.168.1.13:5000/api/posts?limit=15');

    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedData = json.decode(response.body);
      final List<Post> loadedPosts = [];
      extractedData['result'].forEach((element) {
        loadedPosts.add(Post.fromJson(element));
      });
      _posts = loadedPosts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
