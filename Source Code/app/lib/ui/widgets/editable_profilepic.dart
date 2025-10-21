import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/ui/widgets/custom_small_button.dart';

class EditableProfilePicture extends StatelessWidget {
  final bool isEditMode;
  final ImageProvider? image;

  const EditableProfilePicture({
    super.key,
    required this.isEditMode,
    this.image,
  });

  void _showChangePictureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: WoofCareColors.offWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Change Profile Picture",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: WoofCareColors.primaryTextAndIcons,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // profile picture review
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: WoofCareColors.primaryTextAndIcons,
                    width: 3.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: WoofCareColors.offWhite,
                  backgroundImage: image,
                  child:
                      image == null
                          ? const Icon(
                            Icons.person,
                            size: 100,
                            color: WoofCareColors.primaryTextAndIcons,
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 10),

              // ✅ Button instead of text
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog first
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Opening image picker..."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // TODO: Add actual image picker here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WoofCareColors.buttonColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.photo_camera_outlined, size: 18),
                label: const Text(
                  "Choose New Picture",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            // Cancel
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: WoofCareColors.buttonColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            CustomSmallButton(
              text: "Save",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isEditMode
              ? () {
                _showChangePictureDialog(context);
                // TODO: Add change photo function
              }
              : null,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: WoofCareColors.primaryTextAndIcons,
            width: 3.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 75,
              backgroundColor: WoofCareColors.offWhite,
              backgroundImage: image, // Display the image if provided
              child:
                  image == null
                      ? const Icon(
                        Icons.person,
                        size: 100,
                        color: WoofCareColors.primaryTextAndIcons,
                      )
                      : null,
            ),

            //dark overlay when in edit mode
            AnimatedOpacity(
              opacity: isEditMode ? 0.7 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            //text shown in edit mode
            if (isEditMode)
              const Text(
                "Change\nProfile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
