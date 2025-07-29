import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/pages/export.dart';
import 'package:woofcare/ui/pages/posts/posting.dart';
import 'package:woofcare/ui/widgets/post_widget.dart';

class SocialMediaFeed extends StatefulWidget {
  const SocialMediaFeed({super.key});

  @override
  State<SocialMediaFeed> createState() => _SocialMediaFeedState();
}

class _SocialMediaFeedState extends State<SocialMediaFeed> {

  void _postButtonPressed() {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      enableDrag: false, // Prevent dragging of the modal bottom sheet (instead cancel with "Cancel" button)
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          minChildSize: 0.95,
          maxChildSize: 0.95,
          builder: (sheetContext, scrollController) {
            return Container(
              // Container to store the drag handle and the ReportingPage
              decoration: const BoxDecoration(
                color: WoofCareColors.secondaryBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(
                    color: WoofCareColors.borderOutline,
                    width: 2.0,
                  ),
                ),
              ),

              // Children of the container => drag handle and the ReportingPage
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // The ReportingPage (uses Expanded to take up the rest of the space)
                  Expanded(
                    child: SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 10,
                          bottom: 30,
                        ),
                        child: PostingPage(scrollController: scrollController),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: 
              Column(
                children: [
                  Post(), 
                  Post(), 
                  Post(),
                ] 
              ),
            ),
          ),

          // Expanded(
          //   child: StreamBuilder(
          //     stream: FIRESTORE
          //       .collection("User Posts")
          //       .orderBy("Timestamp", descending: false)
          //       .snapshots(),

          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return ListView.builder(
          //           itemBuilder: (context, index) {
          //             final post = snapshot.data!.docs[index];
                      
          //           }
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _postButtonPressed(),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: WoofCareColors.borderOutline.withValues(alpha: 0.5)),
          borderRadius: BorderRadiusGeometry.circular(90)
        ),
        backgroundColor: WoofCareColors.secondaryBackground,
        child: FaIcon(FontAwesomeIcons.paperPlane),
      ),
      
    );
  }
}

