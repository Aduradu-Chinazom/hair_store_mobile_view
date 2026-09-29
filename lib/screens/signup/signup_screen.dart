import 'package:flutter/material.dart';
import 'package:hairstore/screens/login/login_screen.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_button.dart';
import '../password_assistance/password_assistance_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              children: [
                const SizedBox(height: 100),

                // Logo
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.eco_outlined,
                          size: 24,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 2),
                        const Text(
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

                // Create an account
                const Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 25),

                // Email field
                const CustomTextField(
                  hintText: 'Enter your email',
                ),

                const SizedBox(height: 13),

                // Continue button
                CustomButton(
                  text: 'Continue',
                  color: const Color(0xFF654039),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 23),

                // OR divider
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.white54,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.55),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.white54,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 23),

                // Google
                SocialButton(
                  prefixIcon: Image.asset(
                    'assets/images/google.png',
                    width: 18,
                    height: 18,
                  ),
                  text: 'Sign up with Google',
                ),

                const SizedBox(height: 10),

                // Facebook
                SocialButton(
                  prefixIcon: Image.asset(
                    'assets/images/facebook.png',
                    width: 18,
                    height: 18,
                  ),
                  text: 'Sign up with Facebook',
                ),

                const SizedBox(height: 10),

                // Apple
                const SocialButton(
                  prefixIcon: Icon(
                    Icons.apple,
                    color: Colors.black,
                    size: 20,
                  ),
                  text: 'Sign up with Apple',
                ),

                const SizedBox(height: 27),

                // Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
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
                            builder: (context) => LoginScreen(),
                          ),
                        );                      },
                      child: const Text(
                        'Log in',
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