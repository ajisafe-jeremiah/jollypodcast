import 'package:equatable/equatable.dart';
import 'user.dart';
import 'subscription.dart';

// Main Login Response Model
class LoginResponse extends Equatable {
  final String? message;
  final LoginData? data;

  const LoginResponse({this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (message != null) 'message': message,
      if (data != null) 'data': data?.toJson(),
    };
  }

  @override
  List<Object?> get props => [message, data];
}

// Login Data Model
class LoginData extends Equatable {
  final User? user;
  final Subscription? subscription;
  final String? token;

  const LoginData({this.user, this.subscription, this.token});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (user != null) 'user': user?.toJson(),
      if (subscription != null) 'subscription': subscription?.toJson(),
      if (token != null) 'token': token,
    };
  }

  @override
  List<Object?> get props => [user, subscription, token];
}
