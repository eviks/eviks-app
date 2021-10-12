import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/address.dart';
import '../models/failure.dart';

class Localities with ChangeNotifier {
  Future<Map<String, String>> getAddressByCoords(
      Map<String, dynamic> body) async {
    final url = Uri(
      scheme: 'http',
      host: '192.168.1.9',
      port: 5000,
      path: '/api/localities/getAddressByCoords',
    );

    try {
      final response = await http.post(
        url,
        headers: {
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

  Future<List<Address>> geocoder(String text) async {
    final url = Uri(
        scheme: 'http',
        host: '192.168.1.9',
        port: 5000,
        path: 'api/localities/geocoder',
        queryParameters: {
          'q': text,
          'lon': 49.8786270618439.toString(),
          'lat': 40.379108951404.toString()
        });

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

      final List<Address> addresses = [];

      final dynamic data = json.decode(response.body);
      data['rows'].forEach((element) {
        addresses.add(Address.fromJson(element));
      });

      return addresses;
    } catch (error) {
      rethrow;
    }
  }
}
