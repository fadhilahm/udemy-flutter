import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  String get token {
    return (_expiryDate != null &&
            _expiryDate.isAfter(DateTime.now()) &&
            _token != null)
        ? _token
        : null;
  }

  String get userId {
    return _userId;
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

      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async =>
      _authenticate(email, password, 'signUp');

  Future<void> login(String email, String password) async =>
      _authenticate(email, password, 'signInWithPassword');

  void logout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    final expiryDate = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryDate), logout);
  }
}
