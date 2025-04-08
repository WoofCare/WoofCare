import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/widgets/custom_button.dart';
import 'package:woofcare/ui/widgets/custom_dropdown.dart';
import 'package:woofcare/ui/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportingPage extends StatefulWidget {
  final ScrollController? scrollController;

  const ReportingPage({super.key, required this.scrollController});

  @override
  State<ReportingPage> createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  final _reportTitleController = TextEditingController();
  final _dogDescriptionController = TextEditingController();
  final _locationDescriptionController = TextEditingController();
  final _nearestAddressController = TextEditingController();
  final _locationFeaturesController = TextEditingController();
  final _extraNotesController = TextEditingController();
  String? dropdownValue;
  final List<String> urgencyList = [
    'High Urgency',
    'Medium Urgency',
    'Low Urgency',
  ];

  bool useCurrentLocation = false;
  bool dropPin = false;
  bool anonymousReport = false;

  void submitReport() async {
    CollectionReference reports =
        FirebaseFirestore.instance.collection('Reports');

    Map<String, dynamic> newReportData = {
      'userID': profile.id,
      'title': _reportTitleController.text,
      'description': _dogDescriptionController.text,
      'location_description': _locationDescriptionController.text,
    };

    try {
      await reports.add(newReportData);
      print("Report successfully submitted!");
    } catch (e) {
      print("Failed to submit report.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // The body contains the form for the user to fill out
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height, 
        maxWidth: MediaQuery.of(context).size.width,
      ),
      // Decoration for the box (shadow, border radius, color)
      decoration: const BoxDecoration(
        color: Color(0xFFF7FFF7),
      ),


      child: RawScrollbar(
        controller: widget.scrollController,
        thumbColor: const Color(0xFFA66E38),
        thickness: 3,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 27,
            right: 27,
            top: 20,
            bottom: 250,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        
            // Column to hold the input fields and buttons of the form
            // (i.e. Report Title, Dog Description, Location Description, Additional Notes)
            children: [
              // 'Description' text
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF3F2917),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF3F2917),
                  ),
                ),
              ),

              const SizedBox(height: 16),
          
              // Report Title text field
              CustomTextField(
                  controller: _reportTitleController,
                  hintText: 'Report Title'
              ),
          
              const SizedBox(height: 20),

              // Dropdown for urgency level
              Center(
                child: Container(
                  width: 307,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA66E38).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    underline: const SizedBox(), // Remove the underline
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    
                    menuWidth: 340,
                    dropdownColor: const Color(0xFFF7FFF7),
                    borderRadius: BorderRadius.circular(16.0),
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),

                    //focusColor: const Color.fromARGB(255, 0, 0, 0),
                    
                    hint: Text (
                      'Select Urgency Level',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: GoogleFonts.aBeeZee().fontFamily,
                        color: const Color(0xFF3F2917).withOpacity(0.5),
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    items: urgencyList.map((urgency) => DropdownMenuItem(
                      value: urgency,
                      child: Text(
                        urgency,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: GoogleFonts.aBeeZee().fontFamily,
                          color: const Color(0xFF3F2917),
                          fontWeight: FontWeight.w200,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )).toList(),
                    onChanged: (dropdownValue) => setState(() => this.dropdownValue = dropdownValue),
                  ),
                ),
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
        
              // Add Photos Button (new)
              SizedBox(
                width: 120,
                child: CustomButton(
                  text: 'Add Photos',
                  fontSize: 10,
                  edgeInstetAll: 10,
                  fontWeight: FontWeight.w200,
                  onTap: () => print('Add Photos Button Pressed'),
                ),
              ),
        
              const SizedBox(height: 20),
        
              // Photo Container (and camera placeholder)
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFA66E38).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt, 
                    size: 100, 
                    color: Colors.white,
                  )
                ),
              ),
        
              const SizedBox(height: 20),

              // 'Location' text
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Location:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF3F2917),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF3F2917),
                  ),
                ),
              ),

              Row(
                children: [
                  // Current Location Checkbox
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Checkbox(
                      value: useCurrentLocation,
                      side: const BorderSide(),
                      focusColor: Colors.green,
                      onChanged: (bool? value) {
                        setState(() {
                          useCurrentLocation = !useCurrentLocation;
                        });
                      },
                    ),
                  ),
                  const Text(
                    "Use Current Location",
                    style: TextStyle(
                      color: Color(0xFF3F2917),
                      fontSize: 12,
                    ),
                  ),
                  
                  const SizedBox(width: 30),
                  // Drop Pin Checkbox
                  Checkbox(
                    value: dropPin,
                    side: const BorderSide(),
                    focusColor: Colors.green,
                    onChanged: (bool? value) {
                      setState(() {
                        dropPin = !dropPin;
                      });
                    },
                  ),
                  const Text(
                    "Drop Pin",
                    style: TextStyle(
                      color: Color(0xFF3F2917),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              // Nearest address text field
              CustomTextField(
                  controller: _nearestAddressController,
                  hintText: 'Nearest Address',
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

              // 'Other' text
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Other:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF3F2917),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF3F2917),
                  ),
                ),
              ),  

              Row(
                children: [
                  // Current Location Checkbox
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Checkbox(
                      value: anonymousReport,
                      side: const BorderSide(),
                      focusColor: Colors.green,
                      onChanged: (bool? value) {
                        setState(() {
                          anonymousReport = !anonymousReport;
                        });
                      },
                    ),
                  ),
                  const Text(
                    "Make Anonymous Report",
                    style: TextStyle(
                      color: Color(0xFF3F2917),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              // Extra notes text field
              CustomTextField(
                  controller: _extraNotesController,
                  hintText: 'Additional Notes?',
              ),

              CustomButton(
                text: 'Submit', 
                fontSize: 20,
                fontWeight: FontWeight.w200,
                edgeSymmetricHorizontal: 50,
                edgeSymmetricVertical: 40,
                edgeInstetAll: 20,
                onTap: () => submitReport(),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
