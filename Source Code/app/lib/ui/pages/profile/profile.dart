import 'package:flutter/material.dart';
import 'package:woofcare/ui/pages/export.dart';
import 'package:woofcare/ui/pages/settings/settings.dart';
import 'package:woofcare/ui/widgets/custom_button.dart';
import 'package:woofcare/ui/widgets/custom_small_button.dart';
import 'package:woofcare/ui/widgets/custom_stat.dart';
import 'package:woofcare/ui/widgets/editable_profilepic.dart';

import '/config/colors.dart';
import '/config/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// Model class for a fact option
class FactOption {
  final IconData icon;
  final String label;

  FactOption(this.icon, this.label);
}

class _ProfilePageState extends State<ProfilePage> {
  final _bioTextController = TextEditingController(text: profile.bio);
  
  // Track whether we are in edit mode or view mode
  // When true, fields are editable
  bool _editMode = false;

//TODO: connect to database for profile picture
  ImageProvider? profileImage; 

//TODO: connect to database for more facts
  final List<FactOption> _factOptions = [
    FactOption(Icons.pets, "Has a dog"),
    FactOption(Icons.volunteer_activism, "Volunteers"),
    FactOption(Icons.favorite, "Looking to adopt"),
    FactOption(Icons.school, "Dog trainer"),
    FactOption(
      Icons.health_and_safety,
      "Passionate about pet health and wellness.",
    ),
    FactOption(Icons.nature_people, "Loves outdoor activities with pets."),
    FactOption(Icons.home, "Works at an animal shelter."),
  ];

  //TODO: connect to database to save selected facts between sessions to display
  List<FactOption> _selOptions = [];

  // @override
  // void dispose() {
  //   _bioTextController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: WoofCareColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: WoofCareColors.primaryBackground,
          foregroundColor: WoofCareColors.primaryTextAndIcons,
          actions: [
            //edit mode button
            IconButton(
              icon: Icon(
                _editMode ? Icons.create_rounded : Icons.create_outlined,
                color:
                    _editMode
                        ? WoofCareColors.buttonColor
                        : WoofCareColors.primaryTextAndIcons,
              ),
              tooltip: "Toggle Edit Mode",
              onPressed: () {
                setState(() {
                  _editMode = !_editMode;
                });
              },
            ),

            //settings button
            IconButton(
              icon: Icon(
                Icons.settings,
                color: WoofCareColors.primaryTextAndIcons,
              ),
              tooltip: "Settings",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
        //Header
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 20), // Spacer on the left
                  // Profile Picture
                  EditableProfilePicture(
                    isEditMode: _editMode,
                    image: profileImage
                  ),

                  //spacer between picture and text
                  const SizedBox(width: 5),

                  //profile information
                  Expanded(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisSize:
                                MainAxisSize
                                    .min, // This will minimize the space needed
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Username
                              SizedBox(
                                height: 30,
                                width: 300,
                                child: Text.rich(
                                  TextSpan(
                                    text: profile.name,
                                    style: const TextStyle(
                                      fontFamily: "Abeezee",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: WoofCareColors.primaryTextAndIcons,
                                    ),
                                    /*children: const [
                                      //TextSpan(
                                        TODO: connect username to database
                                    children: const [
                                      TextSpan(
                                        //TODO: connect username to database
                                        text: " @username",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFA66E38),
                                        ),
                                      ),
                                    ],*/
                                  ),
                                ),
                              ),

                              // Role
                              SizedBox(
                                width: 300,
                                child: Text(
                                  profile.role,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontFamily: "Abeezee",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: WoofCareColors.primaryTextAndIcons,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),

                              //location
                              const SizedBox(
                                width: 300,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 24,
                                      color: Color(0xFF805832),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      //TODO: connect location to database + allow privacy
                                      "Location",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Abeezee",
                                        fontSize: 14,
                                        color: Color(0xFF805832),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 5),

                              //phone number
                              const SizedBox(
                                width: 300,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 24,
                                      color: Color(0xFF805832),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      //TODO: connect phone number to database + allow privacy
                                      "(123)456-7890",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Abeezee",
                                        fontSize: 14,
                                        color: Color(0xFF805832),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 3),

                              //email
                              SizedBox(
                                width: 300,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.mail_outline,
                                      size: 24,
                                      color: Color(0xFF805832),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      profile.email,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontFamily: "Abeezee",
                                        fontSize: 14,
                                        color: Color(0xFF805832),
                                      ),
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
                  const SizedBox(width: 20), // Spacer on the right
                ],
              ),

              // Spacer
              const SizedBox(height: 20),

              // Button Row
              //TODO: add functionality to buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: CustomButton(
                      height: 60,
                      width: 200,
                      color: WoofCareColors.backgroundElementColor,
                      fontColor: WoofCareColors.primaryTextAndIcons,
                      fontSize: 14,
                      borderRadius: 16,
                      text: "Message",
                      onTap: () {
                        Navigator.pop(context,0);
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 0),
                      child: CustomButton(
                        height: 60,
                        color: WoofCareColors.buttonColor,
                        borderRadius: 16,
                        text: "Follow",
                        fontSize: 14,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // Spacer
              const SizedBox(height: 20),

              // AboutInformation
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: WoofCareColors.offWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Row of two buttons
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 25),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,

                                  vertical: 12,

                                ),
                                backgroundColor: WoofCareColors.buttonColor,
                              ),
                              child: Text(
                                'About',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: WoofCareColors.offWhite,
                                ),
                              ),
                            ),
                            SizedBox(width: 25),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 25),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,

                                  vertical: 12,

                                ),
                                backgroundColor:
                                    WoofCareColors.backgroundElementColor,
                              ),
                              child: Text(
                                'Posts',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: WoofCareColors.primaryTextAndIcons,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Stats
                      //TODO: connect stats to database
                      if (!_editMode) //Hide stats in edit mod
                        Container(
                          height:
                              60, // controls vertical height of stats and dividers
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              custom_stat('1.2K', 'Posts'),
                              VerticalDivider(
                                color: WoofCareColors.dividerColor,
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                              custom_stat('345', 'Followers'),
                              VerticalDivider(
                                color: WoofCareColors.dividerColor,
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                              custom_stat('87', 'Following'),
                              VerticalDivider(
                                color: WoofCareColors.dividerColor,
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                              custom_stat('5', 'Reports'),
                            ],
                          ),
                        ),

                      // Spacer
                      if (!_editMode) const SizedBox(height: 10),


                      // Biography Section
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'About:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: WoofCareColors.primaryTextAndIcons,
                          ),
                        ),
                      ),
                      // Biography box
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: WoofCareColors.offWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            _editMode

                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextField(
                                      controller: _bioTextController,
                                      maxLines: 5,
                                      maxLength: 500,
                                      buildCounter: (
                                        BuildContext context, {
                                        required int currentLength,
                                        required bool isFocused,
                                        required int? maxLength,
                                      }) {
                                        return Text(
                                          '$currentLength / $maxLength',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                WoofCareColors
                                                    .primaryTextAndIcons,
                                          ),
                                        );
                                      },

                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            WoofCareColors.primaryTextAndIcons,
                                      ),

                                      decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                WoofCareColors
                                                    .backgroundElementColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                WoofCareColors
                                                    .backgroundElementColor,
                                          ),
                                        ),
                                        hintText: 'Enter your biography...',
                                        hintStyle: TextStyle(
                                          color:
                                              WoofCareColors
                                                  .primaryTextAndIcons,
                                        ),
                                        fillColor: WoofCareColors.textBoxColor,
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    CustomSmallButton(
                                      text: "Save",
                                      onTap: () {},
                                    ), //TODO: add save functionality
                                  ],
                                )
                                : Text(
                                  _bioTextController.text.isEmpty
                                      ? 'This is the biography box. Here you can write a short description about the user.'
                                      : _bioTextController.text,
                                  maxLines: 5,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: WoofCareColors.primaryTextAndIcons,
                                  ),
                                ),
                      ),


                      Divider(
                        color: WoofCareColors.dividerColor,
                        thickness: 2,
                        indent: 16,
                        endIndent: 16,
                      ),

                      // List of fact item
                      Expanded(
                        child: ListView.builder(
                          itemCount: _editMode
                              ? _selOptions.length + 1
                              : _selOptions.length,
                          itemBuilder: (context, index) {
                            // "add a fact" button at top of list if in edit mode
                            if (_editMode && index ==  0) {
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 0,
                                ),
                                leading: Icon(
                                  Icons.add,
                                  color: WoofCareColors.buttonColor,
                                ),
                                title: Text(
                                  "Add a new fact",
                                  style: TextStyle(
                                    color: WoofCareColors.buttonColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () async {
                                  FactOption?
                                  newFact = await showDialog<FactOption>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      FactOption? selectedFact =
                                          _factOptions.first;
                                      return AlertDialog(
                                        backgroundColor:
                                            WoofCareColors.offWhite,
                                        title: Text(
                                          "Choose a fact",
                                          style: TextStyle(
                                            color:
                                                WoofCareColors
                                                    .primaryTextAndIcons,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: StatefulBuilder(
                                          builder: (context, setModalState) {
                                            return DropdownButton<FactOption>(
                                              isExpanded: true,
                                              value: selectedFact,
                                              dropdownColor:
                                                  WoofCareColors.offWhite,
                                              items:
                                                  _factOptions.map((fact) {
                                                    return DropdownMenuItem<
                                                      FactOption
                                                    >(
                                                      value: fact,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            fact.icon,
                                                            color:
                                                                WoofCareColors
                                                                    .primaryTextAndIcons,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Flexible(
                                                            child: Text(
                                                              fact.label,
                                                              softWrap: true,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              style: TextStyle(
                                                                color:
                                                                    WoofCareColors
                                                                        .primaryTextAndIcons,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                              onChanged: (value) {
                                                setModalState(() {
                                                  selectedFact = value!;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  null,
                                                ),
                                            child: Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (selectedFact == null) return;

                                              // Check if the fact already exists in the list
                                              final alreadyExists = _selOptions
                                                  .any(
                                                    (f) =>
                                                        f.label ==
                                                        selectedFact!.label,
                                                  );

                                              if (alreadyExists) {
                                                // Show alert/snackbar
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "This fact is already in your list.",
                                                    ),
                                                    duration: Duration(
                                                      seconds: 2,
                                                    ),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                              } else {
                                                setState(() {
                                                  _selOptions.add(
                                                    selectedFact!,
                                                  );
                                                });
                                                Navigator.pop(
                                                  context,
                                                ); // close dialog after adding
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  WoofCareColors.buttonColor,
                                            ),
                                            child: Text(
                                              "Add",
                                              style: TextStyle(
                                                color: WoofCareColors.offWhite,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // Add the chosen fact
                                  if (newFact != null) {
                                    setState(() {
                                      _selOptions.add(newFact);
                                    });
                                  }
                                },
                              );
                            }

                            final fact =
                                _selOptions[index -
                                    (_editMode
                                        ? 1
                                        : 0)]; // Adjust index if in edit mode
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 0,
                              ),
                              leading: Icon(
                                fact.icon,
                                color: WoofCareColors.primaryTextAndIcons,
                              ),
                              title: Text(
                                fact.label,
                                style: TextStyle(
                                  color: WoofCareColors.primaryTextAndIcons,
                                  fontSize: 12,
                                ),
                              ),

                              //show delete only in edit mode
                              trailing:
                                  _editMode
                                      ? IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: WoofCareColors.buttonColor,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selOptions.removeAt(index-1);
                                          });
                                        },
                                      )
                                      : null,
                            );
                          },
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
    );
  }
}
