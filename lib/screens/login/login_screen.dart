import 'package:flutter/material.dart';
import 'package:hairstore/screens/home/home_screen.dart';
import 'package:hairstore/screens/password_assistance/password_assistance_screen.dart';
import 'package:hairstore/screens/signup/signup_screen.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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
                    const Text(
                      'Haven',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 27),

                // Title
                const Text(
                  'Log in to your account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  'Welcome back! Please enter your details.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                // Email label
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                const CustomTextField(
                  hintText: 'Enter your email',
                ),

                const SizedBox(height: 13),

                // Password label
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                const CustomTextField(
                  hintText: '••••••••',
                  obscureText: true,
                ),

                const SizedBox(height: 13),

                // Remember me + Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() => rememberMe = value ?? false);
                            },
                            fillColor: WidgetStateProperty.all(Colors.white),
                            checkColor: const Color(0xFF654039),
                            side: BorderSide.none,
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember for 30 days',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordAssistanceScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot password',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 23),

                // Sign in button
                CustomButton(
                  text: 'Continue',
                  color: const Color(0xFF654039),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // Google
                SocialButton(
                  prefixIcon: Image.asset(
                    'assets/images/google.png',
                    width: 18,
                    height: 18,
                  ),
                  text: 'Sign in with Google',
                ),

                const SizedBox(height: 27),

                // Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}