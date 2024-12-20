import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/failure.dart';
import '../models/user.dart';

enum AuthMode { login, register }

class Auth with ChangeNotifier {
  String _token = '';
  User? _user;
  final _googleSignIn = GoogleSignIn();

  User? get user {
    return _user;
  }

  bool get isAuth {
    return token != '';
  }

  String get userId {
    return _user?.id ?? '';
  }

  UserRole get userRole {
    return _user?.role ?? UserRole.user;
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
      final url = Uri.parse('$baseUrl/api/auth');
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }
      final data = (json.decode(response.body) as Map<String, dynamic>)
          .cast<String, String>();
      _token = data['token'] ?? '';
      await loadUser();
      await saveTokenOnDevice();
      await saveUserDevice();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final url = Uri.parse('$baseUrl/api/auth/login_with_google');
        final response = await http.post(
          url,
          body: json.encode({
            'displayName': googleUser.displayName,
            'email': googleUser.email,
            'googleId': googleUser.id,
            'picture': googleUser.photoUrl,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode >= 500) {
          throw Failure('Server error', response.statusCode);
        } else if (response.statusCode != 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;

          final buffer = StringBuffer();
          buffer.writeAll(
            data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
            '\n',
          );
          throw Failure(buffer.toString(), response.statusCode);
        }

        final data = (json.decode(response.body) as Map<String, dynamic>)
            .cast<String, String>();
        _token = data['token'] ?? '';
        await loadUser();
        await saveTokenOnDevice();
        await saveUserDevice();
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> register(
    String displayName,
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/users');
      final response = await http.post(
        url,
        body: json.encode({
          'displayName': displayName,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> verifyUser(String email, String activationToken) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/verification');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'JWT $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'activationToken': activationToken,
        }),
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }
      final data = (json.decode(response.body) as Map<String, dynamic>)
          .cast<String, String>();
      _token = data['token'] == null ? '' : data['token']!;
      await loadUser();
      await saveTokenOnDevice();
      await saveUserDevice();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createResetPasswordToken(String email) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/create_reset_password_token');
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> verifyResetPasswordToken(
    String email,
    String resetPasswordToken,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/check_reset_password_token');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'resetPasswordToken': resetPasswordToken,
        }),
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> resetPassword(
    String email,
    String resetPasswordToken,
    String password,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/reset_password');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'resetPasswordToken': resetPasswordToken,
          'password': password,
        }),
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      final data = (json.decode(response.body) as Map<String, dynamic>)
          .cast<String, String>();
      _token = data['token'] == null ? '' : data['token']!;
      await loadUser();
      await saveTokenOnDevice();
      await saveUserDevice();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loadUser() async {
    try {
      final url = Uri.parse('$baseUrl/api/auth');
      final response =
          await http.get(url, headers: {'Authorization': 'JWT $token'});
      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      final dynamic data = json.decode(response.body);
      _user = User.fromJson(data);
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

  Future<void> updateProfile(
    String displayName,
    String password,
    String newPassword,
  ) async {
    final url = Uri.parse('$baseUrl/api/users');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'JWT $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'displayName': displayName,
        'password': password,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode >= 500) {
      throw Failure('Server error', response.statusCode);
    } else if (response.statusCode != 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      final buffer = StringBuffer();
      buffer.writeAll(
        data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
        '\n',
      );
      throw Failure(buffer.toString(), response.statusCode);
    }
    final dynamic data = json.decode(response.body);
    _user!.favorites =
        (data['favorites'] as Map<String, dynamic>).cast<String, bool>();
    await loadUser();
    notifyListeners();
  }

  Future<void> addPostToFavorites(int postId) async {
    if (user == null) {
      return;
    }
    final url = Uri.parse('$baseUrl/api/users/add_to_favorites/$postId');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'JWT $token',
      },
    );

    if (response.statusCode >= 500) {
      throw Failure('Server error', response.statusCode);
    } else if (response.statusCode != 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      final buffer = StringBuffer();
      buffer.writeAll(
        data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
        '\n',
      );
      throw Failure(buffer.toString(), response.statusCode);
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
    final url = Uri.parse('$baseUrl/api/users/remove_from_favorites/$postId');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'JWT $token',
      },
    );

    if (response.statusCode >= 500) {
      throw Failure('Server error', response.statusCode);
    } else if (response.statusCode != 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      final buffer = StringBuffer();
      buffer.writeAll(
        data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
        '\n',
      );
      throw Failure(buffer.toString(), response.statusCode);
    }
    final dynamic data = json.decode(response.body);
    _user!.favorites =
        (data['favorites'] as Map<String, dynamic>).cast<String, bool>();
    notifyListeners();
  }

  Future<void> deleteProfile() async {
    try {
      final url = Uri.parse('$baseUrl/api/users');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'JWT $token',
        },
      );

      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }

      _user = null;
      _token = '';

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('token')) {
        return false;
      }
      _token = prefs.getString('token') ?? '';

      if (_token == '') {
        return false;
      }

      await loadUser();
      notifyListeners();
      return true;
    } catch (error) {
      _token = '';
      return false;
    }
  }

  Future<void> saveTokenOnDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('userId', userId);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> clearTokenFromDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('userId');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveUserDevice() async {
    try {
      final deviceToken = await FirebaseMessaging.instance.getToken() ?? '';

      final url = Uri.parse('$baseUrl/api/users/save_device');
      final response = await http.post(
        url,
        body: json.encode({
          'deviceToken': deviceToken,
        }),
        headers: {
          'Authorization': 'JWT $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode >= 500) {
        throw Failure('Server error', response.statusCode);
      } else if (response.statusCode != 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final buffer = StringBuffer();
        buffer.writeAll(
          data['errors'].map((error) => error['msg']) as Iterable<dynamic>,
          '\n',
        );
        throw Failure(buffer.toString(), response.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }
}
