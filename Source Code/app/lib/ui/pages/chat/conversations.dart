import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/ui/pages/profile/view_profile.dart';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: WoofCareColors.postBackground,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFF7FFF7),
          shape: CircleBorder(),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              backgroundColor: const Color(0xFFF7FFF7),
              builder: (context) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.4,
                  maxChildSize: 0.8,
                  expand: false,
                  builder: (context, scrollController) {
                    return SearchBottomSheet();
                  },
                );
              },
            );
          },
          child: const Icon(
            Icons.add,
            color: WoofCareColors.floatingActionIcons,
            size: 25,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream:
                    FIRESTORE
                        .collection("Conversations")
                        .where("Participants", arrayContains: profile.name)
                        .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.hasData) {
                    final List<QueryDocumentSnapshot> conversationSnapshots =
                        snapshot.data!.docs;

                    if (conversationSnapshots.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: conversationSnapshots.length,
                        itemBuilder: (context, index) {
                          return Container(
                            // padding: const EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: WoofCareColors.postBackground,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              // borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/chat',
                                    arguments: {
                                      'chatID': conversationSnapshots[index].id,
                                      'photoID': index,
                                      'participant':
                                          conversationSnapshots[index]['Participants'][0] ==
                                                  profile.name
                                              ? conversationSnapshots[index]['Participants'][1]
                                              : conversationSnapshots[index]['Participants'][0],
                                    },
                                  );
                                },
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left: 16,
                                    right: 16,
                                  ),
                                  leading: GestureDetector(
                                    onTap: () {
                                      final participant =
                                          conversationSnapshots[index]['Participants'][0] ==
                                                  profile.name
                                              ? conversationSnapshots[index]['Participants'][1]
                                              : conversationSnapshots[index]['Participants'][0];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewProfilePage(
                                            userName: participant,
                                            photoID: index,
                                          ),
                                        ),
                                      );
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundImage: AssetImage(
                                        // TODO: replace with profile pictures set by the user
                                        "assets/images/placeholders/$index.jpg",
                                      ),
                                    ),
                                  ),
                                  dense: true,
                                  title: Text(
                                    conversationSnapshots[index]['Participants'][0] ==
                                            profile.name
                                        ? conversationSnapshots[index]['Participants'][1]
                                        : conversationSnapshots[index]['Participants'][0],
                                    style: TextStyle(
                                      color: WoofCareColors.primaryTextAndIcons,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: FutureBuilder<String>(
                                    future: getLastConversationMessage(
                                      conversationSnapshots[index],
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(
                                          "Loading...",
                                          style: TextStyle(
                                            color:
                                                WoofCareColors
                                                    .primaryTextAndIcons,
                                            fontSize: 14,
                                          ),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Text(
                                          "Error",
                                          style: TextStyle(
                                            color:
                                                WoofCareColors
                                                    .primaryTextAndIcons,
                                            fontSize: 14,
                                          ),
                                        );
                                      }
                                      return Text(
                                        snapshot.data ?? "No messages yet",
                                        style: TextStyle(
                                          color:
                                              WoofCareColors
                                                  .primaryTextAndIcons,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    },
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    spacing: 15.0,
                                    children: [
                                      Text(
                                        "Yesterday",
                                        style: TextStyle(
                                          color:
                                              WoofCareColors
                                                  .primaryTextAndIcons,
                                          fontSize: 12,
                                        ),
                                      ),
                                      // TODO: implement unread messages count
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

                  return Column(
                    children: [
                      SizedBox(height: 40),
                      const Center(
                        child: Text(
                          "No Converstations\nStart a new one!",
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
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

  void startChat(String selectedUser) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Conversations')
            .where("Participants", arrayContains: profile.name)
            .get();

    var conversations = snapshot.docs.where((doc) {
      List participants = doc["Participants"];
      return participants.contains(selectedUser);
    });

    if (conversations.isEmpty) {
      DocumentReference newConvo = await FirebaseFirestore.instance
          .collection("Conversations")
          .add({
            "messages": [],
            "Participants": {profile.name, selectedUser},
          });

      if (!context.mounted) return;
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        '/chat',
        arguments: {'chatID': newConvo.id, 'participant': selectedUser},
      );
    } else {
      if (!context.mounted) return;
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

  void selectUser(String user) {
    setState(() {
      selectedUser = user; // Update selected user
    });
  }

  void addUser() {
    if (selectedUser != null) {
      startChat(selectedUser!); // Start chat with selected user
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
