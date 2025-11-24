import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/tools/functions.dart';
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
      enableDrag:
          false, // Prevent dragging of the modal bottom sheet (instead cancel with "Cancel" button)
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WoofCareColors.primaryBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                "assets/images/patterns/BigPawPattern.png",
                repeat: ImageRepeat.repeat,
                scale: 0.5,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // This Expanded widget holds all the posts that will appear on the feed page
              Expanded(
                // We use a StreamBuilder to hear for any changes in the "User Posts" collection from firebase
                child: StreamBuilder(
                  stream:
                      FIRESTORE
                          .collection("posts")
                          .orderBy("timestamp", descending: true)
                          .snapshots(),

                  builder: (context, snapshot) {
                    // If there is any data in the snapshot of the collection return a ListView.builder will all the posts (docs)
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return Post(
                            message: post['message'],
                            user: post['email'],
                            time: formatDate(post['timestamp']),
                            postId: post.id,
                            usersWhoLiked: List<String>.from(
                              post['likes'] ?? [],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: TextStyle(
                            color: WoofCareColors.errorMessageColor,
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _postButtonPressed(),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: WoofCareColors.borderOutline.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadiusGeometry.circular(90),
        ),
        backgroundColor: WoofCareColors.secondaryBackground,
        child: FaIcon(
          FontAwesomeIcons.paperPlane,
          color: WoofCareColors.primaryTextAndIcons,
        ),
      ),
    );
  }
}
