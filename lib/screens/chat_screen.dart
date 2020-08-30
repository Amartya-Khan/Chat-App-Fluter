import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//var below instantiates a firestore instance
//its made a global var for everything in the file to access it easily
final _firestore = Firestore.instance;
//the var below is also made a global variable because we are accesing it in the messageStream
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //var belows helps in text disappearing after they are sent
  final messageTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  //var below saves the message typed by the user
  String messageText;

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
        loggedInUser = user;
        print(user.email);
      }
    } catch (e) {
      print(e);
    }
  }
  //above web method can fail so put it in try and catch
//FUNC BELOW IS NOT USED FINALLY
  void getMessages() async {
    final messages = await _firestore.collection('messages').getDocuments();

    for (var message in messages.documents) {
      print(message.data);
    }
  }
//FUNC BELOW IS NOT USED FINALLY
  void messagesStream() async {
    //snapshots() returns a stream of data instead of returning a single future var
    //for each snapshot in bunch of snapshots
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      //snapshot.documents = list of documents so we use for-in loop again
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: FaIcon(FontAwesomeIcons.signOutAlt),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('Chat'),
        backgroundColor: Colors.deepPurpleAccent.withRed(100).withAlpha(210),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      //controller expects a text editing controller
                      //we have initialised this earlier
                      //it controls the text screen
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //func below clears the text that's inside the text field
                      messageTextController.clear();

                      //Implement send functionality.
                      //messageText + loggedInUser.email
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        //The above fetches the query snapshots which is a stream
        //The query snapshot is a class from firebase which will utimately contain the chat messages that we're after.
        //stream builder now knows when new data comes  so that it can rebuild itself
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepPurple[400],
              ),
            );
          }
          //self explanatory name
          final messages = snapshot.data.documents.reversed;

          //above is how we access data in async snapshot
          //async snapshot = contains a query snapshot from firebase
          //we access this query snapshot through data property
          //now we are dealing with a query snapshot object so we can use the query snapshot's properties like the documents properties = list of document snapshots
          //.reverse reverses the order of the list
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data['text'];
            //name of key in hash of message where [ text(key)= actual chat message(value) & sender(key) = actual sender email (value) ]
            final messageSender = message.data['sender'];

            var currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              //property below will make sure the list sticks to the bottom.
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              children: messageBubbles,
            ),
          );
        },
        //docs say we need to provide a build strategy ~ which is the logic for what the stream builder will actually do.
        //the builder needs to rebuild all the children of the steam builder, namely the column and text widgets
        //we don't use the firebase's query snapshot tho, here we are using flutter's async snapshot. however the latter contains the former.
        //async snapshot represents the most recent interaction with the stream
        //our chat messages are buried in this async snapshot. and we can get access to it through the builder.

        //builder is something that takes an anonymous callback and has 2 inputs
        //so its going to trigger the callback passing in the context and also the snapshot then it returns an actual widget. our builder will return a text widget col.
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(35.0),
                    bottomLeft: Radius.circular(30.0),
                    topRight: Radius.circular(2.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(35.0),
                    bottomLeft: Radius.circular(30.0),
                    topLeft: Radius.circular(2.0)),
            //elevation: 3.0,
            color: isMe ? Colors.purpleAccent.withBlue(120) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(text,
                  style: TextStyle(
                    fontSize: 18,
                    color: isMe ? Colors.white : Colors.black54,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
