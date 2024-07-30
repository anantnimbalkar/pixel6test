import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://lab.pixel6.co/api';

  verifyPan(String pan) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-pan.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'panNumber': pan}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to verify PAN');
    }
  }

  getPostCodeDetails(int postCode) async {
    try {
      final response = await http.post(
          Uri.parse('$_baseUrl/get-postcode-details.php'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"postcode": postCode}));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        if (kDebugMode) {
          print('not valid response --------------->');
        }
      }
    } catch (e, trace) {
      if (kDebugMode) {
        print(e);
        print(trace);
      }
    }
  }
}
