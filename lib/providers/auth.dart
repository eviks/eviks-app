import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

enum AuthMode { login, register }

class Auth with ChangeNotifier {
  String _token = '';
  User? _user;

  User? get user {
    return _user;
  }

  bool get isAuth {
    return token != '';
  }

  String get token {
    return _token;
  }

  Map<String, bool> get favorites {
    return user?.favorites ?? {};
  }

  bool postIsFavorite(int postId) {
    return user?.favorites?.containsKey(postId.toString()) ?? false;
  }

  Future<void> login(String email, String password) async {
    try {
      final url = Uri.parse('http://192.168.1.9:5000/api/auth');
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
          }),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        return;
      }
      final data = (json.decode(response.body) as Map<String, dynamic>)
          .cast<String, String>();
      _token = data['token'] == null ? '' : data['token']!;
      await loadUser();
      await saveTokenOnDevice();
      print(_token);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> register(String username, String displayName, String email,
      String password) async {
    try {
      final url = Uri.parse('http://192.168.1.9:5000/api/users');
      final response = await http.post(url,
          body: json.encode({
            'username': username,
            'displayName': displayName,
            'email': email,
            'password': password,
            'pinMode': true,
          }),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        return;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> verifyUser(String activationToken) async {
    try {
      final url = Uri.parse(
          'http://192.168.1.9:5000/api/auth/verification/$activationToken');
      final response =
          await http.post(url, headers: {'Authorization': 'JWT $token'});
      if (response.statusCode != 200) {
        return;
      }
      final data = (json.decode(response.body) as Map<String, dynamic>)
          .cast<String, String>();
      _token = data['token'] == null ? '' : data['token']!;
      await loadUser();
      await saveTokenOnDevice();
      print(_token);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loadUser() async {
    try {
      final url = Uri.parse('http://192.168.1.9:5000/api/auth');
      final response =
          await http.get(url, headers: {'Authorization': 'JWT $token'});
      if (response.statusCode != 200) {
        return;
      }
      final dynamic data = json.decode(response.body);
      _user = User.fromJson(data);
      print(_user);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = '';
    notifyListeners();
    await clearTokenFromDevice();
  }

  Future<void> addPostToFavorites(int postId) async {
    if (user == null) {
      return;
    }
    final url =
        Uri.parse('http://192.168.1.9:5000/api/users/add_to_favorites/$postId');
    final response = await http.put(url, headers: {
      'Authorization': 'JWT $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode != 200) {
      return;
    }
    final dynamic data = json.decode(response.body);
    _user!.favorites =
        (data['favorites'] as Map<String, dynamic>).cast<String, bool>();
    notifyListeners();
  }

  Future<void> removePostFromFavorites(int postId) async {
    if (user == null) {
      return;
    }
    final url = Uri.parse(
        'http://192.168.1.9:5000/api/users/remove_from_favorites/$postId');
    final response = await http.put(url, headers: {
      'Authorization': 'JWT $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode != 200) {
      return;
    }
    final dynamic data = json.decode(response.body);
    _user!.favorites =
        (data['favorites'] as Map<String, dynamic>).cast<String, bool>();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return false;
    }
    _token = prefs.getString('token') ?? '';

    if (_token == '') {
      return false;
    }

    try {
      await loadUser();
      notifyListeners();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> saveTokenOnDevice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> clearTokenFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
