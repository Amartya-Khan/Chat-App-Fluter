import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_app/components/rounded_button.dart';
import 'package:chat_app/components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: SvgPicture.asset('assets/icons_logos/speech-bubble.svg'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            CustomTextField(hintText: 'Enter your email',),
            SizedBox(
              height: 8.0,
            ),
            CustomTextField(hintText: 'Enter your password',),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              color: Colors.deepPurpleAccent.withRed(100).withAlpha(210),
              title: 'Log In',
              onPressed: () {
                //Implement registration functionality.
              },
            ),
          ],
        ),
      ),
    );
  }
}

