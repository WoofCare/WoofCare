import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants.dart';
import 'package:woofcare/config/constants.dart';
import '/services/auth.dart';
import '/tools/extensions.dart';
import 'package:woofcare/ui/widgets/input_field.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final RxList<Map<String, Object>> fields;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fields = [
      {
        "value": "message",
        "name": "Message",
        "controller": _messageController,
        "icon": Icons.message,
        "input": TextInputType.name,
        "submit": (_) => submit(context),
        "error": "",
      },
    ].obs;
  }

  @override
  void dispose() {
    fields.forEach((field) {
      if (field["controller"] != null) {
        (field["controller"]! as TextEditingController).dispose();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEB784),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Messages(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Obx(
                    () => Expanded(
                      child: Column(
                        children: List.generate(
                          fields.length,
                          (index) {
                            final Map<String, dynamic> field = fields[index];
                            return InputField(
                              decoration: InputDecoration(
                                label: Text(field["name"]),
                                prefixIcon: Icon(
                                  field["icon"],
                                  color: context.theme.colorScheme.tertiary,
                                ),
                              ),
                              controller: field["controller"],
                              onSubmitted: field["submit"],
                              textInputType: field["input"],
                              error: field["error"],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => submit(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    FIRESTORE.collection("messages").add(
      {
        "text": _messageController.text.trim(),
        "sender": profile.name,
        "time": Timestamp.now(),
      },
    );

    _messageController.clear();
  }
}

class _Messages extends StatelessWidget {
  const _Messages();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FIRESTORE
          .collection("messages")
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Loading ...",
                    textAlign: TextAlign.center,
                    style: context.textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          );
        }
        final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
        final List<_Message> messages = [];
        for (final QueryDocumentSnapshot doc in docs) {
          messages.add(
            _Message(
              text: doc.get("text"),
              sender: doc.get("sender"),
              time: doc.get("time"),
              isSelf: profile.name == doc.get("sender"),
            ),
          );
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messages,
          ),
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  final String text;
  final String sender;
  final Timestamp time;
  final bool isSelf;

  const _Message({
    required this.text,
    required this.sender,
    required this.time,
    required this.isSelf,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: context.textTheme.titleSmall,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: isSelf
                ? BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: const Color.fromARGB(255, 139, 158, 54),
                  )
                : BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: const Color.fromARGB(255, 139, 158, 54),
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: context.textTheme.displaySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
