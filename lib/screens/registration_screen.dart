import 'package:chat_app/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  //final because we don't wanna change this var once it is created
  //
  String email;
  String password;
  //vars for acc details of users

  //boolean for spinner. false because it shouldn't be spinning right at the beginning
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        //starts out as false.
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child:
                      SvgPicture.asset('assets/icons_logos/speech-bubble.svg'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType
                    .emailAddress, //this line changes keyboard layout to have email keyboard (having @ sign show up)
                onChanged: (value) {
                  email = value;
                //user input stored in var email.
                },
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.65),
                      fontWeight: FontWeight.w500),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.purpleAccent.withBlue(120), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Colors.deepPurpleAccent.withRed(100).withAlpha(210),
                        width: 2.2),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true, //makes input text type= "password"
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                  //user input stored as password
                },
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.65),
                      fontWeight: FontWeight.w500),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.purpleAccent.withBlue(120), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Colors.deepPurpleAccent.withRed(100).withAlpha(210),
                        width: 2.2),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.deepPurpleAccent.withRed(100).withAlpha(210),
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                    //this would make the spinner keep spinning when the registration button is pressed.
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    //this func returns a future because we don't want the user interface to be hanging while these values are authenticated
                    //The future is captured and placed inside a new final variable names newUser

                    //now we will check that that new user != null
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  } //async and await ensures that a new user has been created and authenticated
                  //try and catch methods are used to make sure that the user email and password and other details are correct
                },
              ),
              Center(
                child: Text(
                  'Passwords need to be at least 6 characters long',
                  style: TextStyle(letterSpacing: 0.01, wordSpacing: 0.001),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
