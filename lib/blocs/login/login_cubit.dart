import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jollypodcast/repo/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(const LoginState());

  void phoneChanged(String value) {
    emit(state.copyWith(phoneNumber: value, errorMessage: null));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, errorMessage: null));
  }

  Future<void> login() async {
    // Validate inputs
    if (state.phoneNumber.isEmpty) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: "Please enter your phone number",
        ),
      );
      return;
    }

    if (state.password.isEmpty) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: "Please enter your password",
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      final loginData = await authRepository.login(
        phoneNumber: state.phoneNumber,
        password: state.password,
      );

      if (loginData == null) {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: "Invalid server response",
          ),
        );
        return;
      }

      emit(state.copyWith(status: LoginStatus.success, loginData: loginData));
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: _parseErrorMessage(e.toString()),
        ),
      );
    }
  }

  String _parseErrorMessage(String error) {
    // Parse common error messages
    if (error.contains('SocketException') ||
        error.contains('NetworkException')) {
      return 'No internet connection. Please check your network.';
    }
    if (error.contains('TimeoutException')) {
      return 'Connection timeout. Please try again.';
    }
    if (error.contains('401') || error.contains('Unauthorized')) {
      return 'Invalid phone number or password';
    }
    if (error.contains('404')) {
      return 'Account not found';
    }
    if (error.contains('500') ||
        error.contains('502') ||
        error.contains('503')) {
      return 'Server error. Please try again later.';
    }

    // Return the original error if no match
    return error.replaceAll('Exception:', '').trim();
  }

  void reset() {
    emit(const LoginState());
  }
}
