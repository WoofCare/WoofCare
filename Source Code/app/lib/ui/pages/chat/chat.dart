import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woofcare/config/colors.dart';

import '/config/constants.dart';
import '/ui/widgets/input_field.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final RxList<Map<String, Object>> fields;
  final TextEditingController _messageController = TextEditingController();
  late String chatID;
  bool _isSendButtonDisabled = true;


  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _isSendButtonDisabled = _messageController.text.trim().isEmpty;
      });
    });

    fields =
        [
          {
            "value": "message",
            "name": "message",
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
    for (var field in fields) {
      if (field["controller"] != null) {
        (field["controller"]! as TextEditingController).dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
            as Map;
    chatID = arguments['chatID'];
    final String participant = arguments['participant'];
    final int? photoID = arguments['photoID'];

    return Scaffold(
    
      // It is in the app bar where the user can see the name of the person they are chatting with
      appBar: AppBar(
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: Color(0xFF3F2917), size: 30),
        actionsIconTheme: IconThemeData(color: Color(0xFF3F2917), size: 30),
        actions: [
          IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
        ],
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 25,
              backgroundImage: AssetImage(
                "assets/images/placeholders/$photoID.jpg",
              ),
            ),
            Text(
              participant,
              style: TextStyle(
                color: Color(0xFF3F2917),
                fontFamily: "ABeeZee",
                fontSize: 16,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: WoofCareColors.postBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Messages(chatId: chatID),
            Row(
              children: [
                Obx(
                  () => Expanded(
                    child: Column(
                      children: List.generate(fields.length, (index) {
                        final Map<String, dynamic> field = fields[index];
                        return Container(
                          padding: const EdgeInsets.fromLTRB(12, 8, 5, 8),
                          child: InputField(                                 
                            decoration: InputDecoration(
                              fillColor: Color(0xFFF7FFF7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Type your ${field["name"]} here...",
                              hintStyle: TextStyle(
                                color: Color(0xFFCAB096),
                                fontFamily: "ABeeZee",
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                field["icon"],
                                color: Color(0xFFA66E38),
                              ),
                            ),
                            controller: field["controller"],
                            onSubmitted: field["submit"],
                            textInputType: TextInputType.multiline,
                            maxLines: 5,
                            error: field["error"],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                  ),
                  disabledColor: WoofCareColors.gray,
                  color: WoofCareColors.primaryTextAndIcons,
                  onPressed: _isSendButtonDisabled ? null : () => submit(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    FIRESTORE
        .collection("Conversations")
        .doc(chatID)
        .collection("messages")
        .add({
          "text": _messageController.text.trim(),
          "sender": profile.name,
          "time": Timestamp.now(),
        });

    _messageController.clear();
  }
}

class _Messages extends StatelessWidget {
  final String chatId;

  const _Messages({required this.chatId});

  @override
  Widget build(BuildContext context) {
    print("chadID: $chatId");
    return StreamBuilder<QuerySnapshot>(
      stream:
          FIRESTORE
              .collection("Conversations")
              .doc(chatId)
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          Text(sender, style: TextStyle(color: WoofCareColors.primaryTextAndIcons, fontWeight: FontWeight.bold, height: 1.5)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration:
                isSelf
                    ? const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: WoofCareColors.white60,
                    )
                    : const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: WoofCareColors.white60,
                    ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(text, style: TextStyle(color: WoofCareColors.primaryTextAndIcons, fontSize: 17))],
            ),
          ),
        ],
      ),
    );
  }
}
