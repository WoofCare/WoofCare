import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/services/auth.dart';
import 'package:woofcare/ui/widgets/custom_button.dart';
import 'package:woofcare/ui/widgets/custom_textfield.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  String? errorMessage = "";
  bool remeberMe = false;

  // TODO: Forgot Password (Method for Backend)
  void forgotPassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEB784),
      body: Stack(
        // Stack to allow for multiple background images
        children: [
          Container(
            // Container for the first background image
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/patterns/BigPawPattern.png",
                ),
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
                left: 25.0, right: 25.0, top: 175.0, bottom: 100.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // COMMENTED OUT BORDER
                // border: Border.all(
                //   //color: Colors.black,
                //   width: 2.0,
                // ),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.45),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(6, 3)),
                ],
              ),
              child: ClipRRect(
                // ClipRRect to allow for rounded corners
                borderRadius:
                    BorderRadius.circular(8.0), // Radius of the corners
                child: Scaffold(
                  backgroundColor: const Color.fromARGB(
                      255, 255, 255, 255), // Background color of the container
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Center(
                        // Center the contents
                        child: Column(
                          children: [
                            //Welcome Back Message
                            const Text(
                              "Welcome Back to \n      WoofCare!", // There is probably a better way to do this XD
                              style: TextStyle(
                                  color: Color(0xFF3F2917),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            const Divider(
                              color: Color(0xFF3F2917),
                              thickness: 3,
                              indent: 50,
                              endIndent: 50,
                            ),

                            const SizedBox(
                              height: 25,
                            ),

                            //Username Field
                            CustomTextField(
                              controller: _emailTextController,
                              hintText: "Email",
                              prefix: Icons.email,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //Password Field
                            CustomTextField(
                              controller: _passwordTextController,
                              hintText: "Password",
                              obscureText: true,
                              prefix: Icons.password,
                            ),

                            const SizedBox(
                              height: 1,
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
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
                                        value: remeberMe,
                                        side: const BorderSide(),
                                        focusColor: Colors.green,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            remeberMe = !remeberMe;
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
                                              color: const Color(0xFFA66E38)),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = forgotPassword,
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
                              text: "Log In",
                              onTap: () => Auth.login(
                                context: context,
                                email: _emailTextController.text,
                                password: _passwordTextController.text,
                                error: (e) {
                                  setState(() {
                                    errorMessage = e.toString();
                                  });
                                },
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //First Time User? Sign Up Button
                            RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                  color: Color(0xFF3F2917),
                                  fontSize: 12,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Sign Up",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                        color: const Color(0xFFA66E38)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context, "/signup"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
