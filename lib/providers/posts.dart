import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/failure.dart';

import '../models/post.dart';

class Posts with ChangeNotifier {
  String token;
  List<Post> _posts;

  Posts(this.token, this._posts);

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

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
            data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
            '\n');
        throw Failure(buffer.toString(), response.statusCode);
      }

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

  Future<String> getImageUploadId() async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.9',
      port: 5000,
      path: 'api/posts/generate_upload_id',
    );

    try {
      final response =
          await http.get(url, headers: {'Authorization': 'JWT $token'});

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
            data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
            '\n');
        throw Failure(buffer.toString(), response.statusCode);
      }

      final dynamic data = json.decode(response.body);
      return data['id'] as String;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> uploadImage(XFile file, String id) async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.9',
      port: 5000,
      path: 'api/posts/upload_image',
    );

    try {
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'JWT $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['id'] = id;
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        await file.readAsBytes(),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
            data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
            '\n');
        throw Failure(buffer.toString(), response.statusCode);
      }

      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteImage(String id) async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.9',
      port: 5000,
      path: 'api/posts/delete_image/$id',
    );

    try {
      final response =
          await http.delete(url, headers: {'Authorization': 'JWT $token'});

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
            data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
            '\n');
        throw Failure(buffer.toString(), response.statusCode);
      }
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
