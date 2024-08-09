import 'package:fire_base/view/Widget.dart/pages.dart/turnOn.dart';
import 'package:fire_base/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized() ;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
const MyApp({super.key}) ;
 @override
State<MyApp> createState() => _MyAppState();
  }

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('===========User is currently signed out!');
    } else {
      print('========User is signed in!');
    }
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false ,
    
      home :
   MyCustomWidget() ,
      routes : {
          },
    );
  }
}

