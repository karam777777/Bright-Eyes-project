import 'package:fire_base/controller/controller.dart';
import 'package:fire_base/view/Widget.dart/images.dart';
import 'package:fire_base/view/Widget.dart/materialbutton.dart';
import 'package:fire_base/auth/first-stepto-create-newaccount.dart';
import 'package:fire_base/view/Widget.dart/pages.dart/sick2.dart';
import 'package:fire_base/view/Widget.dart/textformfield.dart';
import 'package:fire_base/view/Widget.dart/textformfieldpass.dart';
import 'package:fire_base/view/Widget.dart/textt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart'; 

class page4 extends StatelessWidget {
  page4({super.key});

  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<homecontroller>(
        init: homecontroller(),
        builder: (controller) => Form(
          key: formstate,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const image(),
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(height: 200),
                  textfield(
                    labeltext: "Email",
                    mycontroller: _emailcontroller,
                    iconn: const Icon(Icons.email_outlined),
                    text2: "Please enter email address",
                    text3: "@gmail.com",
                    text4: "Please enter a valid email address",
                  ),
                  Container(height: 25),
                  password(
                    labeltext: "Password",
                    mycontroller: _passwordcontroller,
                    typee: TextInputType.visiblePassword,
                    text2: "The field is empty",
                    n: 5,
                    text4: "The password cannot be less than five characters long",
                  ),
                  Container(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buttom(
                        onPressed: () async {
                          if (_emailcontroller.text.isEmpty) {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.error,
                              body: const Center(
                                child: Text(
                                  "You must input your email first",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              title: 'Error',
                              desc: 'You must input your email first',
                              btnOkOnPress: () {},
                            ).show();
                            return;
                          }

                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailcontroller.text);
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.info,
                              body: const Center(
                                child: Text(
                                  "Check your email box",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              title: 'Check Up',
                              desc: 'This is also Ignored',
                              btnOkOnPress: () {},
                            ).show();
                          } catch (e) {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.error,
                              body: const Center(
                                child: Text(
                                  "Your email is wrong",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              title: 'Error',
                              desc: 'Your email is wrong',
                              btnOkOnPress: () {},
                            ).show();
                          }
                        },
                        child: const Text("Forget password?"),
                      ),
                      buttom(
                        onPressed: () {
                          Get.to(create2());
                        },
                        child: const Text("Create a new account?"),
                      ),
                    ],
                  ),
                  buttom(
                    onPressed: () async {
                      if (formstate.currentState!.validate()) {
                        try {
                          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailcontroller.text,
                            password: _passwordcontroller.text,
                          );
                          if (credential.user != null ) {
                            Get.to(sick(FirebaseAuth.instance.currentUser!.uid ,));
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                           AwesomeDialog(
                                      context: Get.context!,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: ' حدث خطأ ',
                                      desc: ' لم تقم بتسجيل الدخول في هذا الحساب مسبقاً',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {}                                                        
                                     ).show() ;
                          } else if (e.code == 'wrong-password') {
                            AwesomeDialog(
                                      context: Get.context!,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'حدث خطأ',
                                      desc: 'كلمة المرور ليست صحيحة',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {}                                                        
                                     ).show() ;
                          }
                        }
                      } else {
                        print("Form not valid");
                      }
                    },
                    child: Container(
                      width: 110,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black45,
                      ),
                      child: const textt(
                        text0: "L O G I N",
                        c: Colors.white,
                        m: 20,
                        w: FontWeight.w300,
                        m2: 2,
                        k: FontStyle.italic,
                      ),
                    ),
                  ),
                  Container(height: 20),
                  buttom(
                    onPressed: () async {
                      await signInWithGoogle(context);
                    },
                    child: const Text("Sign in with Google"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // المستخدم ألغى تسجيل الدخول
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.to(sick(FirebaseAuth.instance.currentUser!.uid));
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            "Failed to sign in with Google",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'Error',
        desc: 'Failed to sign in with Google',
        btnOkOnPress: () {},
      ).show();
    }
  }
}
