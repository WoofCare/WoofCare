import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/pages/chat/chat.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEEB784),
        appBar: AppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
          child: const Icon(Icons.add, color: Colors.white, size: 25),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Text(
              "\nConversations",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Conversations")
                    .where("Participants", arrayContains: profile.name)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 139, 158, 54),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              dense: true,
                              title: Text(
                                  snap[index]['Participants'][0] == profile.name
                                      ? snap[index]['Participants'][1]
                                      : snap[index]['Participants'][0]),
                              onTap: () {
                                Navigator.pushNamed(context, '/chat',
                                    arguments: {'chatID': snap[index].id});
                              },
                            ),
                          );
                        });
                  } else {
                    return const SizedBox();
                  }
                })
          ]),
        ));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  TextStyle get searchFieldStyle {
    return const TextStyle(
      color: Colors.black,
      fontSize: 18,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> users = snapshot.data!.docs;
            List<String> matchQuery = [];

            for (var user in users) {
              if (user['name']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  query != '') {
                matchQuery.add(user['name']);
              }
            }
            if (matchQuery.isEmpty) {
              return const Center(child: Text("No users found"));
            }
            return ListView.builder(
                itemCount: matchQuery.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 139, 158, 54),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                        title: Text(
                          matchQuery[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          QuerySnapshot snapshot = await FirebaseFirestore
                              .instance
                              .collection('Conversations')
                              .where("Participants",
                                  arrayContains: profile.name)
                              .get();

                          var conversations = snapshot.docs.where((doc) {
                            List participants = doc["Participants"];
                            return participants.contains(matchQuery[index]);
                          });

                          if (conversations.isEmpty) {
                            DocumentReference newConvo = await FirebaseFirestore
                                .instance
                                .collection("Conversations")
                                .add({
                              "messages": [],
                              "Participants": {profile.name, matchQuery[index]}
                            });
                            if (!context.mounted) return;
                            Navigator.pushNamed(context, '/chat',
                                arguments: {'chatID': newConvo.id});
                          } else {
                            if (!context.mounted) return;
                            Navigator.pushNamed(context, '/chat',
                                arguments: {'chatID': conversations.first.id});
                          }
                        }),
                  );
                });
          }
          return const Scaffold(body: CircularProgressIndicator());
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> users = snapshot.data!.docs;
            List<String> matchQuery = [];

            for (var user in users) {
              if (user['name']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  query != '') {
                matchQuery.add(user['name']);
              }
            }
            if (matchQuery.isEmpty) {
              return const Center(child: Text("No users found"));
            }
            return ListView.builder(
                itemCount: matchQuery.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 139, 158, 54),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                        title: Text(
                          matchQuery[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          QuerySnapshot snapshot = await FirebaseFirestore
                              .instance
                              .collection('Conversations')
                              .where("Participants",
                                  arrayContains: profile.name)
                              .get();

                          var conversations = snapshot.docs.where((doc) {
                            List participants = doc["Participants"];
                            return participants.contains(matchQuery[index]);
                          });

                          if (conversations.isEmpty) {
                            DocumentReference newConvo = await FirebaseFirestore
                                .instance
                                .collection("Conversations")
                                .add({
                              "messages": [],
                              "Participants": {profile.name, matchQuery[index]}
                            });
                            if (!context.mounted) return;
                            Navigator.pushNamed(context, '/chat',
                                arguments: {'chatID': newConvo.id});
                          } else {
                            if (!context.mounted) return;
                            Navigator.pushNamed(context, '/chat',
                                arguments: {'chatID': conversations.first.id});
                          }
                        }),
                  );
                });
          }
          return const Scaffold(body: CircularProgressIndicator());
        });
  }
}
