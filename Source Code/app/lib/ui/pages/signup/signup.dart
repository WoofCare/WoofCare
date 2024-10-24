import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _dateOfBirthTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _passwordConfirmTextController =
      TextEditingController();
  final TextEditingController _passwordsMatchTextController =
      TextEditingController();
  var roles = [
    "Role",
    "Animal Lover",
    "NGO Representative",
    "Looking to Adopt",
    "Dog Feeder",
    "Veterinarian",
  ];
  String dropdownvalue = "Role";
  String? errorMessage = "";

  @override

  // Set the state of the two password fields.
  void initState() {
    super.initState();
    _passwordTextController.addListener(passwordChecker);
    _passwordConfirmTextController.addListener(passwordChecker);
    _passwordConfirmTextController.addListener(() {
      setState(() {});
    });
  }

  // Checks if all fields have been properly filled.
  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _emailTextController,
      _passwordTextController,
      _passwordConfirmTextController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  void navigateToProfile(BuildContext context, String uid) {
    Navigator.pushNamed(
      context,
      '/profile',
      arguments: uid,
    );
  }

  // Create User Function
  Future<void> createUserWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text);

      String uid = userCredential.user!.uid;
      FirebaseFirestore.instance.collection("userData").doc(uid).set({
        "firstName": _firstNameTextController.text,
        "lastName": _lastNameTextController.text,
        "role": dropdownvalue,
      });

      //Navigate to the user profile.
      navigateToProfile(context, uid);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  // Returns true if the password fields match, otherise returns false.
  bool passwordChecker() {
    if (_passwordTextController.text == _passwordConfirmTextController.text) {
      _passwordsMatchTextController.text = "";
      return true;
    } else {
      _passwordsMatchTextController.text = "Passwords do not match!";
      return false;
    }
  }

  void onTapFunction({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2015),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    _dateOfBirthTextController.text =
        DateFormat("yyyy-MM-dd").format(pickedDate);
  }

  double _formProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEB784),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Form(
              onChanged: _updateFormProgress,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEEB784),
                ),
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
                          horizontal: 25.0, vertical: 125.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.45),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(6, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          // ClipRRect to allow for rounded corners
                          borderRadius: BorderRadius.circular(8.0),
                          child: Scaffold(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            body: SafeArea(
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),

                                      // First name text entry.
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          controller: _firstNameTextController,
                                          decoration: const InputDecoration(
                                            hintText: "First Name",
                                          ),
                                        ),
                                      ),

                                      // Last name text entry.
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          controller: _lastNameTextController,
                                          decoration: const InputDecoration(
                                            hintText: "Last Name",
                                          ),
                                        ),
                                      ),

                                      // Date of birth text entry.
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          controller:
                                              _dateOfBirthTextController,
                                          decoration: const InputDecoration(
                                            hintText: "Date of Birth",
                                            suffixIcon:
                                                Icon(Icons.calendar_today),
                                          ),
                                          onTap: () =>
                                              onTapFunction(context: context),
                                        ),
                                      ),

                                      // Email text entry.
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          controller: _emailTextController,
                                          decoration: const InputDecoration(
                                            hintText: "Email",
                                          ),
                                        ),
                                      ),

                                      // Selection of role.
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            DropdownButton(
                                              value: dropdownvalue,
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              items: roles.map((String roles) {
                                                return DropdownMenuItem(
                                                  value: roles,
                                                  child: Text(roles),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalue = newValue!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Passord text entry.
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          controller: _passwordTextController,
                                          decoration: const InputDecoration(
                                            hintText: "Password",
                                          ),
                                        ),
                                      ),

                                      // Passord confirm text entry.
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          controller:
                                              _passwordConfirmTextController,
                                          decoration: const InputDecoration(
                                            hintText: "Confirm Password",
                                          ),
                                        ),
                                      ),

                                      // Passwords match text.
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          _passwordsMatchTextController.text,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),

                                      TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStateProperty.resolveWith(
                                                  (states) {
                                            return states.contains(
                                                    WidgetState.disabled)
                                                ? null
                                                : Colors.white;
                                          }),
                                          backgroundColor:
                                              WidgetStateProperty.resolveWith(
                                            (states) {
                                              return states.contains(
                                                      WidgetState.disabled)
                                                  ? null
                                                  : Colors.blue;
                                            },
                                          ),
                                        ),
                                        onPressed: (_formProgress == 1) &&
                                                passwordChecker()
                                            ? createUserWithEmailAndPassword
                                            : null,
                                        child: const Text("Sign up"),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
