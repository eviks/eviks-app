import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

enum AuthMode { login, register }

class Auth with ChangeNotifier {
  String _token = '';

  bool get isAuth {
    return token != '';
  }

  String get token {
    return _token;
  }

  Future<void> login(String username, String password) async {
    try {
      final url = Uri.parse('http://192.168.1.8:5000/api/auth');
      final result = await http.post(url,
          body: json.encode({
            'username': username,
            'password': password,
          }),
          headers: {'Content-Type': 'application/json'});
      if (result.statusCode != 200) {
        return;
      }
      final response = (json.decode(result.body) as Map<String, dynamic>)
          .cast<String, String>();
      _token = response['token'] == null ? '' : response['token']!;
      print(result.body);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
