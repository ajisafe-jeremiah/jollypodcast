import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jollypodcast/models/user.dart';
import 'package:jollypodcast/models/subscription.dart';
import 'package:jollypodcast/models/login.dart';
import 'package:jollypodcast/services/dio.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  AuthRepository({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  static const _userKey = "__user__";
  static const _subscriptionKey = "__subscription__";
  static const _tokenKey = "__token__";

  Future<LoginData?> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({
        'phone_number': phoneNumber,
        'password': password,
      });

      final response = await _dioClient.post(
        path: "/auth/login",
        data: formData,
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      final loginData = loginResponse.data;

      if (loginData == null) return null;

      // Save data
      if (loginData.user != null) {
        await saveUser(loginData.user!);
      }

      if (loginData.subscription != null) {
        await saveSubscription(loginData.subscription!);
      }

      if (loginData.token != null) {
        await saveToken(loginData.token!);
      }

      return loginData;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        // Try to extract error message from response
        String errorMessage = 'Login failed';

        if (responseData is Map<String, dynamic>) {
          errorMessage =
              responseData['message'] ??
              responseData['error'] ??
              responseData['msg'] ??
              errorMessage;
        }

        // Throw specific error based on status code
        switch (statusCode) {
          case 401:
            throw Exception('Invalid phone number or password');
          case 404:
            throw Exception('Account not found');
          case 422:
            throw Exception(errorMessage);
          case 500:
          case 502:
          case 503:
            throw Exception('Server error. Please try again later.');
          default:
            throw Exception(errorMessage);
        }
      } else {
        // Network errors
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          throw Exception('Connection timeout. Please try again.');
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception('No internet connection. Please check your network.');
        } else {
          throw Exception('Network error. Please try again.');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // ... rest of your code remains the same

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> saveSubscription(Subscription subscription) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_subscriptionKey, jsonEncode(subscription.toJson()));
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await _dioClient.authToken(token);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;
    return User.fromJson(jsonDecode(jsonString));
  }

  Future<Subscription?> getSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_subscriptionKey);
    if (jsonString == null) return null;
    return Subscription.fromJson(jsonDecode(jsonString));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_subscriptionKey);
    await prefs.remove(_tokenKey);
    await _dioClient.authToken('');
  }

  Future<void> init() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      await _dioClient.authToken(token);
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }
}
