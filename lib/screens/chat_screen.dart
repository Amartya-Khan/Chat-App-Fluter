import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser logggedInUser;

  //calling the function getCurrentUser from below  when the state is initialised
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //func below checks if there's a current user that's signed in
  void getCurrentUser() async {
    //var below would be null if no one is signed in. Else it will correspond to the current user
    //method below returns a future so async needs to be used
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        logggedInUser = user;
      }
    } catch (e) {
      print(e);
    }}
    //above web method can fail so put it in try and catch

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  //Implement logout functionality
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
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          //Do something with the user input.
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        //Implement send functionality.
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

