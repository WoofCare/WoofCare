import 'package:flutter/material.dart';

// Install the intl dependency in the pubspec.yamml file prior to importing this.
import 'package:intl/intl.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignUpScreen(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _dateOfBirthTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passwordConfirmTextController = TextEditingController();
  final _passwordsMatchTextController = TextEditingController();

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
      _usernameTextController,
      _emailTextController,
      _dateOfBirthTextController,
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

  // Returns true if the password fields match, otherise returns false.
  bool passwordChecker() {
    if (_passwordTextController.text == _passwordConfirmTextController.text) {
      print("Passwords Match!");
      _passwordsMatchTextController.text = "";
      return true;
    } else {
      print("Password Do Not Match!");
      _passwordsMatchTextController.text = "Passwords do not match!";
      return false;
    }
  }

  onTapFunction({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2015),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    _dateOfBirthTextController.text =
        DateFormat('yyyy-MM-dd').format(pickedDate);
  }

  double _formProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Sign up for WoofCare',
              style: Theme.of(context).textTheme.headlineMedium),

          // First name text entry.
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),

          // Last name text entry.
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),

          // Date of birth text entry.
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _dateOfBirthTextController,
              decoration: const InputDecoration(
                  hintText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today)),
              onTap: () => onTapFunction(context: context),
            ),
          ),

          // Email of birth text entry.
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _emailTextController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
          ),

          // Username of birth text entry.
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),

          // Passord text entry.
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _passwordTextController,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
          ),

          // Passord confirm text entry.
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _passwordConfirmTextController,
              decoration: const InputDecoration(hintText: 'Confirm Password'),
            ),
          ),

          // Passwords match text.
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_passwordsMatchTextController.text,
                style: const TextStyle(
                  fontSize: 20,
                )),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: (_formProgress == 7) && passwordChecker()
                ? null
                : null, // add welcome page
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}
