import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  Post findById(int id) {
    return _posts.firstWhere((element) => element.id == id);
  }

  Future<Map<String, String>> getAddressByCoords(
      Map<String, dynamic> body) async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.9',
      port: 5000,
      path: '/api/posts/getAddressByCoords',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'JWT $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

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

      final Map<String, String> addressComponents = {
        'city': '',
        'district': '',
        'subdistrict': '',
        'address': '',
      };

      if (data['success'] == true) {
        data['addr_components'].forEach((addressComponent) {
          if (addressComponent['type'] == 'country district') {
            addressComponents['city'] = addressComponent['name'] as String;
          }
          if (addressComponent['type'] == 'settlement district') {
            addressComponents['district'] = addressComponent['name'] as String;
          }
          if (addressComponent['type'] == 'settlement') {
            addressComponents['subdistrict'] =
                addressComponent['name'] as String;
          }
          if (addressComponent['type'] == 'street') {
            addressComponents['address'] = addressComponent['name'] as String;
          }
        });
      }

      // Check if district is empty
      if (addressComponents['district'] == '' &&
          addressComponents['subdistrict'] != '') {
        addressComponents['district'] = addressComponents['subdistrict'] ?? '';
        addressComponents['subdistrict'] = '';
      }

      return addressComponents;
    } catch (error) {
      rethrow;
    }
  }

  void clearPosts() {
    _posts = [];
  }
}
