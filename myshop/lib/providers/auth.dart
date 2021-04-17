import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  String get token {
    return (_expiryDate != null &&
            _expiryDate.isAfter(DateTime.now()) &&
            _token != null)
        ? _token
        : null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD_EWrsWc2tVQpq1nQSC5AizIqg86l0NdU');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null)
        throw HttpException(responseData['error']['message']);

      _token = responseData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _userId = responseData['localId'];

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async =>
      _authenticate(email, password, 'signUp');

  Future<void> login(String email, String password) async =>
      _authenticate(email, password, 'signInWithPassword');
}
