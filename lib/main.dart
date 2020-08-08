import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black54) ),
      ),
      initialRoute: WelcomeScreen.id,
      //can't use home property with initial routes property
      //here we called the id var without creating an object of class and wasting recources
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        //'login_screen': (context) => LoginScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'chat_screen': (context) => ChatScreen(),
      } , //All routes defined as key-val pairs
    );
  }
}

