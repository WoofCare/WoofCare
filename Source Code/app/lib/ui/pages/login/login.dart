import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/config/constants.dart';
import '/services/auth.dart';
import '/ui/widgets/custom_button.dart';
import '/ui/widgets/custom_textfield.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final TextEditingController _errorTextController = TextEditingController();

  String? errorMessage = "";
  bool rememberMe = false;

  // TODO: Forgot Password (Method for Backend)
  void forgotPassword() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Prevents the keyboard from pushing the container up
        body: Stack(
          // Stack to allow for multiple background images
          children: [
            Container(
              // Container for the first background image
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/patterns/BigPawPattern.png"),
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
            Container(
              // Container for the second background image
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/patterns/SmallPawPattern.png",
                  ),
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
            Padding(
              // Padding for the container that holds the login form
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                top: 90.0,
                bottom: 90.0,
              ),
              child: Container(
                // height: 30.0.sh,
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.normal,
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(5, 5),
                      spreadRadius: 1,
                    )
                  ],
                ), // Background color of the container
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      //Welcome Back Message
                      const Text(
                        textAlign: TextAlign.center,
                        "Welcome Back to WoofCare!", // There is probably a better way to do this XD
                        style: TextStyle(
                          color: Color(0xFF3F2917),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),  
                        
                      const SizedBox(height: 5),
                          
                      const Divider(
                        color: Color(0xFF3F2917),
                        thickness: 3,
                        indent: 50,
                        endIndent: 50,
                      ),
                          
                      const SizedBox(height: 35),
                          
                      //Username Field
                      CustomTextField(
                        controller: _emailTextController,
                        hintText: "Email",
                        prefix: Icons.email,
                      ),
                          
                      const SizedBox(height: 35),
                          
                      //Password Field
                      CustomTextField(
                        controller: _passwordTextController,
                        hintText: "Password",
                        obscureText: true,
                        prefix: Icons.password,
                        maxLines: 1,
                      ),
                          
                      const SizedBox(height: 7),
                          
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            //Remember Me Text & Checkbox
                            Row(
                              children: [
                                const Text(
                                  "Remember Me",
                                  style: TextStyle(
                                    color: Color(0xFF3F2917),
                                    fontSize: 12,
                                  ),
                                ),
                                Checkbox(
                                  value: rememberMe,
                                  side: const BorderSide(),
                                  focusColor: Colors.green,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberMe = !rememberMe;
                                    });
                                  },
                                ),
                              ],
                            ),
                          
                            // Forgot Password Button
                            RichText(
                              text: TextSpan(
                                text: "Forgot Password?",
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(
                                      color: const Color(0xFFA66E38),
                                    ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = forgotPassword,
                              ),
                            ),
                          ],
                        ),
                      ),
                                    
                      // Error Message    
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          _errorTextController.text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                          
                      const SizedBox(height: 35),
                          
                      //Log In Button
                      CustomButton(
                        text: "Log In",
                        margin: 30,
                        onTap:
                            () => Auth.login(
                              context: context,
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                              error: (e) {
                                setState(() {
                                  errorMessage = e.toString();
                                  _errorTextController.text =
                                      errorMessage ?? '';
                                });
                              },
                            ),
                      ),
                          
                      const SizedBox(height: 15),
                          
                      //First Time User? Sign Up Button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(
                              fontFamily: "ABeeZee",
                              color: Color(0xFF3F2917),
                              fontSize: 12,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Sign Up",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: const Color(0xFFA66E38),
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap =
                                          () => Navigator.pushNamed(
                                            context,
                                            "/signup",
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
