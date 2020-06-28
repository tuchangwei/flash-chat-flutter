import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String kRoute = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseUser _loggedInUser;
  String _messageText;
  final Firestore _firestore = Firestore.instance;
  final TextEditingController _editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getMessages();
  }

  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        _loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').getDocuments();
    print(messages.documents);
    for (var message in messages.documents) {
      print(message.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection("messages").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data.documents;
                  List<MessagesWidget> list = List();
                  for (var message in messages) {
                    final text = message.data["message"];
                    final sender = message.data["sender"];

                    final messageWidget = MessagesWidget(
                      message: text,
                      sender: sender,
                    );
                    list.add(messageWidget);
                  }
                  return ListView(
                    children: list,
                  );
                },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                      controller: _editingController,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection("messages").add({
                        "message": _messageText,
                        "sender": _loggedInUser.email
                      });
                      _editingController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesWidget extends StatelessWidget {
  final String message;
  final String sender;
  MessagesWidget({this.message, this.sender});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(sender),
        Text(message),
      ],
    );
  }
}
