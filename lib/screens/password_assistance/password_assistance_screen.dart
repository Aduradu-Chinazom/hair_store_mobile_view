import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hairstore/screens/password_reset/password_reset_screen.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class PasswordAssistanceScreen extends StatelessWidget {
  const PasswordAssistanceScreen({super.key});

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

                // Frosted card
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Password assistance',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'Enter the email address or mobile phone number associated with your account',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'Email or mobile phone number',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const CustomTextField(
                            hintText: '',
                          ),

                          const SizedBox(height: 14),

                          CustomButton(
                            text: 'Continue',
                            color: const Color(0xFF654039),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PasswordResetScreen(),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Footer links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _footerLink('Condition of Use'),
                    const SizedBox(width: 24),
                    _footerLink('Privacy Notice'),
                    const SizedBox(width: 24),
                    _footerLink('Help'),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  '@2026, HairHaven.com Inc',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF1A73E8),
        ),
      ),
    );
  }
}