import 'package:flutter/material.dart';
//import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/widgets/custom_button.dart';
import 'package:woofcare/ui/widgets/custom_textfield.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key});

  @override
  State<ReportingPage> createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  final _reportTitleController = TextEditingController();
  final _dogDescriptionController = TextEditingController();
  final _locationDescriptionController = TextEditingController();
  final _extraNotesController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // The body contains the form for the user to fill out
    return SafeArea(
      child: Center(
        child: Container(
          height: 830,
          width: 393,
          // Decoration for the box (shadow, border radius, color)
          decoration: BoxDecoration(
            color: const Color(0xFFF7FFF7),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color:Color(0x1A000000),
                offset: Offset(4, 4),
                blurRadius: 7.0,
                spreadRadius: 2.0
              ),
              BoxShadow(
                color:Color.fromARGB(255, 235, 165, 99),
                offset: Offset(-1, -1),
                blurRadius: 5.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
      
          // Stack to allow for better precision in positioning widgets
          child: Stack(
            children: [
              Column(   // Column to hold the text fields
                children: [
                  const SizedBox(height: 35),
              
                  // Report Title text field
                  CustomTextField(
                    controller: _reportTitleController, 
                    hintText: 'Report Title'
                  ),
              
                  const SizedBox(height: 20),
              
                  // Dog Description text field
                  CustomTextField(
                    controller: _dogDescriptionController, 
                    hintText: 'Identifying features of dog? (i.e Patterns, injuries, gender, etc.)',
                    top: 25,
                    bottom: 25,
                  ),
              
                  const SizedBox(height: 20),
              
                  // Location Description text field
                  CustomTextField(
                    controller: _locationDescriptionController, 
                    hintText: 'Identifying features of location? (i.e Landmarks, dangers, time etc.)',
                    top: 25,
                    bottom: 25,
                  ),
              
                  const SizedBox(height: 20),
              
                  // Additional Notes text field
                  CustomTextField(
                    controller: _extraNotesController, 
                    hintText: 'Additional Notes?',
                  ),              
                ],
              ),
      
              // Add Photos button
              Positioned(
                right: 262,
                bottom: 350,
                child: CustomButton(
                  text: 'Add Photos',
                  fontSize: 10,
                  edgeInstetAll: 10,
                  onTap: () => print('Add Photos button pressed'), //TODO: Implement photo upload
                ),
              ),
      
              // Photo container (and camera placeholder)
              Positioned(
                left: 28, 
                bottom: 140,
                child: Container(
                  width: 330,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA66E38).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Image(
                    image: AssetImage('assets/images/placeholders/camera.png'),
                    fit: BoxFit.scaleDown,
                  )
                )
              ),
              
              // Submit button
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: 'Submit', 
                    fontSize: 20,
                    onTap: () => print('Submit button pressed'), //TODO: Implement submit button
                    edgeSymmetricHorizontal: 80,
                    edgeSymmetricVertical: 40,
                    edgeInstetAll: 20,
                  ),
                ],
              )
            ]
          ),          
        ),
      ),
    );
  }
}