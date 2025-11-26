import 'package:equatable/equatable.dart';
import 'package:jollypodcast/models/login.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String phoneNumber;
  final String password;
  final LoginData? loginData;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.phoneNumber = '',
    this.password = '',
    this.loginData,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? phoneNumber,
    String? password,
    LoginData? loginData,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      loginData: loginData ?? this.loginData,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    phoneNumber,
    password,
    loginData,
    errorMessage,
  ];

  @override
  String toString() {
    return 'LoginState('
        'status: $status, '
        'phoneNumber: $phoneNumber, '
        'hasPassword: ${password.isNotEmpty}, '
        'loginData: $loginData, '
        'errorMessage: $errorMessage)';
  }
}
