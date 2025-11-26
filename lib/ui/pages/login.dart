import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jollypodcast/blocs/login/login_cubit.dart';
import 'package:jollypodcast/blocs/login/login_state.dart';
import 'package:jollypodcast/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final listenerNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    // UserProfile currentUser = HiveService.getData('__user__', defaultValue: UserProfile.empty);
    // if(!isTokenExpired(currentUser.token ?? '')) {
    //   context.go(kHomePath);
    // }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    listenerNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (prevState, currentState) =>
          currentState.status != prevState.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.go(kHomePath);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Dark Overlay
            Container(color: Colors.black.withOpacity(0.3)),
            // Content
            KeyboardListener(
              autofocus: true,
              onKeyEvent: (keyEvent) {
                if (keyEvent is KeyUpEvent &&
                    keyEvent.logicalKey.keyLabel.toLowerCase() == "enter") {
                  context.read<LoginCubit>().login();
                }
              },
              focusNode: listenerNode,
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Jolly Logo
                        Image.asset('assets/images/jolly.png', height: 80),
                        const SizedBox(height: 16),
                        // Subtitle
                        const Text(
                          'PODCASTS FOR\nAFRICA, BY AFRICANS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Phone Number Input
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            buildCounter:
                                (
                                  context, {
                                  required currentLength,
                                  required isFocused,
                                  maxLength,
                                }) => null,
                            onTapOutside: (pointerEvent) =>
                                listenerNode.requestFocus(),
                            onFieldSubmitted: (value) =>
                                listenerNode.requestFocus(),
                            onChanged: (value) =>
                                context.read<LoginCubit>().phoneChanged(value),
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 12,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/icons/nigerian_flag.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 1,
                                      height: 24,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password Input
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            onTapOutside: (pointerEvent) =>
                                listenerNode.requestFocus(),
                            onFieldSubmitted: (value) =>
                                listenerNode.requestFocus(),
                            onChanged: (value) => context
                                .read<LoginCubit>()
                                .passwordChanged(value),
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 12,
                                ),
                                child: Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey[600],
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Error Message
                        BlocBuilder<LoginCubit, LoginState>(
                          buildWhen: (prevState, currentState) =>
                              currentState.status != prevState.status,
                          builder: (context, state) {
                            if (state.status == LoginStatus.failure) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        state.errorMessage ??
                                            "Unable to login. Try again later",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            final isLoading =
                                state.status == LoginStatus.loading;

                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context.read<LoginCubit>().login();
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1A4D4D),
                                  disabledBackgroundColor: const Color(
                                    0xFF1A4D4D,
                                  ).withOpacity(0.7),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 4,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Continue',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Terms and Conditions
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'By proceeding, you agree and accept our ',
                              ),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to T&C
                                  },
                                  child: const Text(
                                    'T&C',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Become a Podcast Creator
                        TextButton(
                          onPressed: () {
                            // Navigate to creator signup
                          },
                          child: const Text(
                            'BECOME A PODCAST CREATOR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Loading Overlay
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state.status == LoginStatus.loading) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF88D66C),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
