import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fire_base/view/Widget.dart/images.dart';
import 'package:fire_base/view/Widget.dart/materialbutton.dart';
import 'package:fire_base/auth/second-stepto-create-newAccount.dart';
import 'package:fire_base/view/Widget.dart/textformfield.dart';
import 'package:fire_base/view/Widget.dart/textformfieldpass.dart';
import 'package:fire_base/view/Widget.dart/textt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class create2 extends StatelessWidget {
  create2({super.key});
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _passwordcontroller1 = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formstate,
        child: Stack(
          alignment: Alignment.center,
          children: [
            image(),
            ListView(
              children: [
                Container(
                  height: 100,
                ),
                textfield(
                  labeltext: "Email",
                  mycontroller: _emailcontroller,
                  iconn: Icon(Icons.email_outlined),
                  text2: "Please enter email address",
                  text3: "@gmail.com",
                  text4: "Please enter a valid email address",
                ),
                Container(
                  height: 25,
                ),
                password(
                  labeltext: "Password",
                  mycontroller: _passwordcontroller,
                  typee: TextInputType.visiblePassword,
                  text2: "The field is empty",
                  n: 5,
                  text4: "The password cannot be less than five characters long",
                ),
                Container(
                  height: 25,
                ),
                password(
                  labeltext: "Confirm Password",
                  mycontroller: _passwordcontroller1,
                  typee: TextInputType.visiblePassword,
                  text2: "The field is empty",
                  n: 5,
                  text4: "The password cannot be less than five characters long",
                ),
                Container(
                  height: 25,
                ),
                buttom(
                  onPressed: () async {
                    String password = _passwordcontroller.text;
                    String password1 = _passwordcontroller1.text;
                    if (password == password1) {
                      if (formstate.currentState!.validate()) {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.rightSlide,
                          dialogType: DialogType.info,
                          body: const Center(
                            child: Text(
                              "Check your email box to verify your email",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          title: 'Check Up',
                          desc: 'Check your email box to verify your email',
                          btnOkOnPress: () async {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: _emailcontroller.text,
                                password: _passwordcontroller.text,
                              );
                              Get.to(createAcc());
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'email-already-in-use') {
                                print('The account already exists for that email.');
                              }
                            }
                          },
                        ).show();
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: textt(
                              text0: "Error",
                              c: Colors.black54,
                              m: 20,
                              w: FontWeight.w500,
                              m2: 0,
                              k: FontStyle.normal,
                            ),
                            content: textt(
                              text0: "The two passwords do not match",
                              c: Colors.black,
                              m: 20,
                              w: FontWeight.normal,
                              m2: 0,
                              k: FontStyle.italic,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: textt(
                                  text0: "Ok",
                                  c: Colors.black54,
                                  m: 20,
                                  w: FontWeight.w500,
                                  m2: 0,
                                  k: FontStyle.normal,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black45,
                    ),
                    child: textt(
                      text0: "Next",
                      c: Colors.white,
                      m: 20,
                      w: FontWeight.w300,
                      m2: 2,
                      k: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
