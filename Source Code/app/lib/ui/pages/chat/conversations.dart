import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/models/profile.dart';
import 'package:woofcare/ui/pages/profile/profile.dart';

import '/config/constants.dart';
import '/ui/widgets/custom_button.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  Future<String> getLastConversationMessage(
    QueryDocumentSnapshot conversation,
  ) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
          await conversation.reference
              .collection('messages')
              .orderBy('time', descending: true)
              .limit(1)
              .get();
      if (messagesSnapshot.docs.isNotEmpty) {
        final data = messagesSnapshot.docs.first.data();
        return data["text"] as String? ?? "No messages yet";
      }
    } catch (e) {
      e.printError();
    }
    return "No messages yet";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WoofCareColors.secondaryBackground,
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(
            color: WoofCareColors.primaryTextAndIcons,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: WoofCareColors.buttonColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: WoofCareColors.borderOutline.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadiusGeometry.circular(90),
            ),
            backgroundColor: WoofCareColors.secondaryBackground,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) {
                  return const SearchBottomSheet();
                },
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Stack(
        children: [
          // Background patterns
          Align(
            alignment: Alignment.topLeft,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                "assets/images/patterns/BigPawPattern.png",
                width: 200,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                "assets/images/patterns/SmallPawPattern.png",
                width: 150,
              ),
            ),
          ),

          // Content
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FIRESTORE
                          .collection("conversations")
                          .where("participants", arrayContains: profile.name)
                          .snapshots(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      final List<QueryDocumentSnapshot> conversationSnapshots =
                          snapshot.data!.docs;

                      if (conversationSnapshots.isNotEmpty) {
                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: conversationSnapshots.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            // Safely get participants list with null and bounds checking
                            final dynamic participantsData = 
                                conversationSnapshots[index]['participants'];
                            final List participants = participantsData is List
                                ? participantsData
                                : <String>[];
                            
                            // Find the other participant (not the current user)
                            String participantName = "Unknown";
                            if (participants.length > 1) {
                              // If first participant is current user, get second, otherwise get first
                              participantName = participants[0] == profile.name
                                  ? participants[1].toString()
                                  : participants[0].toString();
                            } else if (participants.length == 1) {
                              // Edge case: only one participant (shouldn't happen normally)
                              participantName = participants[0] == profile.name
                                  ? "Unknown"
                                  : participants[0].toString();
                            }

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/chat',
                                      arguments: {
                                        'chatID':
                                            conversationSnapshots[index].id,
                                        'photoID': index,
                                        'participant': participantName,
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final userProfile =
                                                await Profile.fromName(
                                                  participantName,
                                                );
                                            if (userProfile != null &&
                                                context.mounted) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => ProfilePage(
                                                        user: userProfile,
                                                      ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    WoofCareColors
                                                        .primaryBackground,
                                                width: 2,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 28,
                                              backgroundImage: AssetImage(
                                                "assets/images/placeholders/1.jpg",
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                participantName,
                                                style: const TextStyle(
                                                  color:
                                                      WoofCareColors
                                                          .primaryTextAndIcons,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              FutureBuilder<String>(
                                                future: getLastConversationMessage(
                                                  conversationSnapshots[index],
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text(
                                                      "Loading...",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13,
                                                      ),
                                                    );
                                                  }
                                                  return Text(
                                                    snapshot.data ??
                                                        "No messages yet",
                                                    style: TextStyle(
                                                      color: WoofCareColors
                                                          .primaryTextAndIcons
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                      fontSize: 13,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Now", // Placeholder for time
                                              style: TextStyle(
                                                color: WoofCareColors
                                                    .primaryTextAndIcons
                                                    .withValues(alpha: 0.5),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                              color:
                                                  WoofCareColors
                                                      .primaryBackground,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: WoofCareColors.primaryTextAndIcons
                                .withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No Conversations Yet",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: WoofCareColors.primaryTextAndIcons
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Start a new chat to connect!",
                            style: TextStyle(
                              fontSize: 14,
                              color: WoofCareColors.primaryTextAndIcons
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  TextEditingController searchController = TextEditingController();
  List<String> searchResults = [];
  String? selectedUser;

  void searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").get();

    List<String> matches =
        snapshot.docs
            .where(
              (user) => user["name"].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .map((user) => user["name"].toString())
            .toList();

    setState(() {
      searchResults = matches;
    });
  }

  void startChat(BuildContext context, String selectedUser) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('conversations')
            .where("participants", arrayContains: profile.name)
            .get();

    var conversations = snapshot.docs.where((doc) {
      List participants = doc["participants"];
      return participants.contains(selectedUser);
    });

    if (conversations.isEmpty) {
      DocumentReference newConvo = await FirebaseFirestore.instance
          .collection("conversations")
          .add({
            "messages": [],
            "participants": [profile.name, selectedUser],
          });

      if (context.mounted) {
        Navigator.pop(context);

        Navigator.pushNamed(
          context,
          '/chat',
          arguments: {'chatID': newConvo.id, 'participant': selectedUser},
        );
      }
    } else {
      if (context.mounted) {
        Navigator.pop(context);

        Navigator.pushNamed(
          context,
          '/chat',
          arguments: {
            'chatID': conversations.first.id,
            'participant': selectedUser,
          },
        );
      }
    }
  }

  void selectUser(String user) {
    setState(() {
      selectedUser = user; // Update selected user
    });
  }

  void addUser() {
    if (selectedUser != null) {
      startChat(context, selectedUser!); // Start chat with selected user
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a user first!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ), // Adjust for keyboard
      child: Container(
        padding: EdgeInsets.all(16),
        height: 400,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Color(0xFFA66E38),
                borderRadius: BorderRadius.circular(10),
              ),
            ), //
            SizedBox(height: 16),
            TextField(
              style: TextStyle(fontSize: 16, color: Color(0xFF3F2917)),
              cursorColor: Color(0xFF3F2917),
              maxLines: 1,
              maxLength: 100,
              controller: searchController,
              decoration: InputDecoration(
                constraints: BoxConstraints(maxHeight: 60),
                fillColor: Color(0xFFCAB096),
                hintText: "Find User...",
                hintStyle: TextStyle(fontSize: 16, color: Color(0xFF3F2917)),
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Color(0xFF3F2917),
                prefixIconConstraints: BoxConstraints(minWidth: 40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Color(0xFFCAB096)),
                ),
                suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              searchResults = [];
                            });
                          },
                        )
                        : null,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                suffixIconColor: Color(0xFF3F2917),
              ),
              onChanged: searchUsers,
            ),
            SizedBox(height: 12),
            Expanded(
              child:
                  searchResults.isEmpty
                      ? Center(
                        child: Text(
                          "No users found",
                          style: TextStyle(
                            color: Color(0xFFA66E38),
                            fontSize: 24,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          bool isSelected =
                              searchResults[index] == selectedUser;
                          return Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Color(0xFFFEE7CB)
                                      : Color(0xFFF7FFF7),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? const Color(0xFFFF926C)
                                        : Color(0xFFF7FFF7),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Color(0xFFA66E38),
                                child: Icon(
                                  Icons.person,
                                  color:
                                      isSelected
                                          ? Color(0xFFFEE7CB)
                                          : Color(0xFFF7FFF7),
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFFA66E38),
                              ),
                              title: Text(
                                searchResults[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFA66E38),
                                ),
                              ),
                              onTap: () => selectUser(searchResults[index]),
                            ),
                          );
                        },
                      ),
            ),
            SizedBox(height: 16),
            CustomButton(text: "Add User", onTap: addUser),
          ],
        ),
      ),
    );
  }
}
