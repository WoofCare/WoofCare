import 'package:flutter/material.dart';
import 'package:woofcare/components/button.dart';
import 'package:woofcare/components/textfield.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});

  // Text Editing Controllers (private)
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  // Sign User In (Method)
  void signUser() {
    // Sign User In
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEEB784),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 260,
                ),

                //Welcome Back Message
                const Text(
                  'Welcome Back to WoofCare!',
                  style: TextStyle(
                      color: Color(0xFF3F2917),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(
                  height: 25,
                ),

                //Username Field
                CustomTextField(
                  controller: _usernameTextController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(
                  height: 15,
                ),

                //Password Field
                CustomTextField(
                  controller: _passwordTextController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(
                  height: 5,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Remember Me Text & Checkbox
                      Row(
                        children: [
                          const Text(
                            'Remember Me',
                            style: TextStyle(color: Color(0xFF3F2917)),
                          ),
                          Checkbox(
                            value: false,
                            onChanged: (bool? value) {},
                          ),
                        ],
                      ),

                      // Forgot Password Button
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Color(0xFF3F2917)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 35,
                ),

                //Log In Button
                CustomButton(
                  onTap: signUser,
                ),

                //First Time User? Sign Up Button
              ],
            ),
          ),
        ));
  }
}
