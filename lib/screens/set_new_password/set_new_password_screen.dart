import 'package:flutter/material.dart';
import 'package:hairstore/screens/login/login_screen.dart';

import '../../widgets/auth_footer.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/frosted_card.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

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
                        'Set new password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        '*Must be at least 8 characters.',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const CustomTextField(
                        hintText: 'Create a new password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Confirm password',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const CustomTextField(
                        hintText: 'Create a new password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 24),

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

                      const SizedBox(height: 10),

                      Center(
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
                      ),
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