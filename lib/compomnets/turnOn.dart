import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:fire_base/view/Widget.dart/pages.dart/pageone1.dart';
import 'package:flutter/services.dart';
//import 'package:slider_button/slider_button.dart';

class MyCustomWidget extends StatefulWidget {
  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return SecondScreen();
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool _a = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 700), () {
      setState(() {
        _a = !_a;
      });
    });
    Timer(Duration(milliseconds: 2000), () {
    /**************************************************************************************************************************************/
      Navigator.of(context)
          .pushReplacement(SlideTransitionAnimation(MyWidget()));
         //  FirebaseAuth.instance.currentUser == null ? MyWidget(): sick2() ;
    /*****************************************************************************************************************************************/
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            curve: Curves.fastLinearToSlowEaseIn,
            width: _a ? _width : 0,
            height: _height,
            color: Color.fromARGB(255, 71, 131, 200),
          ),
          Center(
            child:
             Text(
              'Bright Eyes',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Colors.white,)
                
                ) /* SliderButton(
              action: (){ return Future(() => null); } ,
              icon: Text('x'),
              label : Text(
              'APP\'s NAME',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Colors.white,
              ),
            ))*/,
          ),
        ],
      ),
    );
  }
}

class SlideTransitionAnimation extends PageRouteBuilder {
  final Widget page;

  SlideTransitionAnimation(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: Duration(milliseconds: 2000),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
              );
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation),
                textDirection: TextDirection.rtl,
                child: page,
              );
            });
}