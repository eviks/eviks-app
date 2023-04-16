import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/failure.dart';
import '../models/subscription.dart';

class Subscriptions with ChangeNotifier {
  String token;
  List<Subscription> _subscriptions;

  Subscriptions(
    this.token,
    this._subscriptions,
  );

  List<Subscription> get subscriptions {
    return [..._subscriptions];
  }

  void clearSubscriptions() {
    _subscriptions = [];
  }

  Future<void> getSubscriptions() async {
    final url = Uri(
      scheme: baseScheme,
      host: baseHost,
      port: basePort,
      path: 'api/subscriptions',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'JWT $token'},
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
      data.forEach((element) {
        _subscriptions.add(Subscription.fromJson(json: element));
      });

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> subscribe(Subscription subscription) async {
    final data = subscription.toJson();
    try {
      final url = Uri.parse('$baseUrl/api/subscriptions');
      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token'
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
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
