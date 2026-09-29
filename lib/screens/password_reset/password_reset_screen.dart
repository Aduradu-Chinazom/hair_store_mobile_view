import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hairstore/screens/set_new_password/set_new_password_screen.dart';

import '../../widgets/auth_footer.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/frosted_card.dart';
import '../login/login_screen.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 100),

                // Logo
                Column(
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.eco_outlined,
                          size: 24,
                          color: Colors.black,
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Hair',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Haven',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 78),

                FrostedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Password reset',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "We've sent a code to cutiepatootie@gmail.com",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // OTP boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                              (i) => _OtpBox(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            onChanged: (v) => _onChanged(v, i),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      CustomButton(
                        text: 'Continue',
                        color: const Color(0xFF654039),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetNewPasswordScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 22),

                      // Resend
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Didn't receive the email? ",
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.black,
                            ),
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Click here to send again',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF1A73E8),
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFF1A73E8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      const _BackToLogin(),
                    ],
                  ),
                ),

                const Spacer(),

                const AuthFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _BackToLogin extends StatelessWidget {
  const _BackToLogin();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back,
              size: 11,
              color: Colors.black.withOpacity(0.5),
            ),
            const SizedBox(width: 3),
            Text(
              'Back to login',
              style: TextStyle(
                fontSize: 9,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}