import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/ui/pages/chat/chat.dart';

import '/config/theme.dart';
import 'package:flutter/material.dart';

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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Text(
              "\nConversations",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
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
                              height: 70,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 65, 112, 21),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(2, 2),
                                        blurRadius: 10)
                                  ]),
                              child: Stack(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snap[index]['name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ))
                                ],
                              ));
                        });
                  } else {
                    return const SizedBox();
                  }
                })
          ]),
        ));
  }
}
