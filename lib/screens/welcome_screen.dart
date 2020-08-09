import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  //static makes it a variable of the class instead of makinng it a property of objs of class
  //This lets us access vars and methods of classes without having to create objects and wasting resources
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

//we need to specify the state obj as something we specify as a ticker
//its like giving the state a new ability
//if there were multiple animations we'd be using TickerProviderStateMixin
//Mixins enable class with new abilities
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  //right when the state is initialised we want to initialise the animatedController and create that

  //initialising curve var
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 600),
      //duration object created and duration in seconds assigned to it

      //upperBound: 100.0,

      vsync:
          this, //here is where we provide the ticker provider for animation controller
      //an object from this class will be acting as a ticker hence we use 'this'
    );

    controller.forward();
    //this will proceed animation forward

    //now basically the animation will go from 0 to 1 with every tick of the counter (unless uppper and lower bounds defined)
    //to see what the controller is doing, we need to add a listener to it
    //method below lets us see the actual animation

    controller.addStatusListener((status) {});

    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });

    //using the animation var to a new curved animation
    //animation = CurvedAnimation(parent: controller, curve: Curves.easeInQuad);
    //parent is what we apply this curve to
    //WHEN YOU APPLY CURVED ANIMATION TO PARENT THAT PARENT CAN'T HAVE UPPER BOUND>1
    //now this lets us use "animation.value" instead of 'controller.value' because the former is applied as cover to the latter

    animation = ColorTween(begin:Colors.purpleAccent.withBlue(120).withAlpha(100), end: Colors.white).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      //ALTERNATE: Colors.white.withOpacity(controller.value),
      //here the animation controller changes its value accorning to the value of the ticker
      //now the opacity characteristic changes from 0 to 1 and so does the ticker
      //so when we start the app, in the course of 1 second the background will fade in to the color white
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: SvgPicture.asset(
                          'assets/icons_logos/speech-bubble.svg'),
                      height: 80,
                      width: 80,
                    ),
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 400),
                  //isRepeatingAnimation: true,
                  repeatForever: true,
                  text: ['Chat App'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.purpleAccent.withBlue(120),
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    //Go to login screen.
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.deepPurpleAccent.withRed(100).withAlpha(210),
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    //Go to registration screen.
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
