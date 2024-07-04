// AuthService.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class AuthService {
  String? _idToken;
  String? _refreshToken;
  DateTime? _expiryDate;

  Future<void> registerUser(String email, String password) async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$firebaseApiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _idToken = responseData['idToken'];
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print('Registration successful: $responseData');
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<void> loginUser(String email, String password) async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$firebaseApiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _idToken = responseData['idToken'];
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print('Login successful: $responseData');
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> updateUserProfile(String displayName) async {
    if (_idToken == null) {
      throw Exception('User is not logged in');
    }
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:update?key=$firebaseApiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idToken': _idToken,
        'displayName': displayName,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _idToken = responseData['idToken'];
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print('Profile updated: $responseData');
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<void> refreshToken() async {
    if (_refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final url = Uri.parse('https://securetoken.googleapis.com/v1/token?key=$firebaseApiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'grant_type': 'refresh_token',
        'refresh_token': _refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _idToken = responseData['id_token'];
      _refreshToken = responseData['refresh_token'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expires_in'])));
      print('Token refreshed: $responseData');
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

 Future<String?> getToken() async {
    if (_idToken == null || _expiryDate == null || DateTime.now().isAfter(_expiryDate!)) {
      print('Token is expired or not available.');
            try {
        await refreshToken();
      } catch (e) {
        print('Failed to refresh token: $e');
        return null;
    }
    print('Returning token: $_idToken');
    return _idToken;
  }
}

  Future<void> logout() async {
    _idToken = null;
    _refreshToken = null;
    _expiryDate = null;
    print('User logged out');
  }
}
