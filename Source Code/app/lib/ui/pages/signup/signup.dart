import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/services/auth.dart';
import '/ui/widgets/custom_button.dart';
import '/ui/widgets/custom_dropdown.dart';
import '/ui/widgets/custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _dateOfBirthTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _passwordConfirmTextController =
      TextEditingController();
  final TextEditingController _errorTextController = TextEditingController();

  final List<String> roles = [
    "Animal Lover",
    "NGO Representative",
    "Looking to Adopt",
    "Dog Feeder",
    "Veterinarian",
  ];

  String role = "";
  String? errorMessage = "";

  @override
  void initState() {
    super.initState();
    _passwordTextController.addListener(passwordChecker);
    _passwordConfirmTextController.addListener(passwordChecker);
    _passwordConfirmTextController.addListener(() {
      setState(() {});
    });
  }

  void signup() {
    var progress = 0.0;

    final controllers = [
      _nameTextController,
      _emailTextController,
      _passwordTextController,
      _passwordConfirmTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    if (progress == 1 && passwordChecker()) {
      Auth.signup(
        context: context,
        email: _emailTextController.text,
        password: _passwordTextController.text,
        data: {
          "bio": "",
          "email": _emailTextController.text,
          "name": _nameTextController.text,
          "role": role,
        },
        error: (e) {
          setState(() {
            errorMessage = e.message;
            _errorTextController.text = errorMessage ?? '';
          });
        },
      );
    } else {
      _errorTextController.text = "Error";
    }
  }

  bool passwordChecker() {
    if (_passwordTextController.text == _passwordConfirmTextController.text) {
      _errorTextController.text = "";
      return true;
    } else {
      _errorTextController.text = "Passwords do not match!";
      return false;
    }
  }

  void pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(1980),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.aBeeZeeTextTheme(),
            colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: Colors.white,
              secondary: Colors.white,
              onSurface: Colors.black,
              onPrimary: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFA66E38),
                textStyle: GoogleFonts.aBeeZee(),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: GoogleFonts.aBeeZee(),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;
    _dateOfBirthTextController.text = DateFormat(
      "yyyy-MM-dd",
    ).format(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            child: Card(
              child: Container(
                decoration: const BoxDecoration(color: Color(0xFFEEB784)),
                child: Stack(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 125.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black, width: 2.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF000000,
                              ).withValues(alpha: 0.45),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(6, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          // ClipRRect to allow for rounded corners
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Create Your Account",
                                        style: TextStyle(
                                          color: Color(0xFF3F2917),
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    // Name text entry.
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: CustomTextField(
                                        controller: _nameTextController,
                                        hintText: "Name",
                                        prefix: Icons.person,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: CustomTextField(
                                        controller: _dateOfBirthTextController,
                                        hintText: "Date of Birth",
                                        prefix: Icons.calendar_today,
                                        suffix: Icons.arrow_drop_down,
                                        onTap: () => pickDate(context),
                                      ),
                                    ),

                                    // Selection of role.
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 25,
                                      ),
                                      child: CustomDropdown<String>(
                                        heading: "Role",
                                        title: "Select a Role",
                                        label: "Search",
                                        itemAsString: (val) => val,
                                        icon: Icons.work,
                                        items:
                                            roles.map((String roles) {
                                              return roles;
                                            }).toList(),
                                        onChanged: (String? val) {
                                          setState(() {
                                            role = val!;
                                          });
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Email Text Entry
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: CustomTextField(
                                        controller: _emailTextController,
                                        hintText: "Email",
                                        prefix: Icons.email,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: CustomTextField(
                                        controller: _passwordTextController,
                                        hintText: "Password",
                                        obscureText: true,
                                        prefix: Icons.password,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: CustomTextField(
                                        controller:
                                            _passwordConfirmTextController,
                                        hintText: "Confirm Password",
                                        obscureText: true,
                                        prefix: Icons.password,
                                        maxLines: 1,
                                      ),
                                    ),

                                    // Passwords match text.
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

                                    CustomButton(
                                      text: "Sign up",
                                      onTap: signup,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
