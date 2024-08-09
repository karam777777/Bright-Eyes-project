import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fire_base/view/Widget.dart/materialbutton.dart';
import 'package:fire_base/view/Widget.dart/pages.dart/doctor_main_page.dart';
import 'package:fire_base/auth/login222.dart';
import 'package:fire_base/view/Widget.dart/textformfieldpass.dart';
import 'package:fire_base/view/Widget.dart/textt.dart';
import 'package:flutter/material.dart';
import 'package:fire_base/controller/controller.dart';
import 'package:get/get.dart';

class pagetwo extends StatelessWidget {
  pagetwo({super.key});
  TextEditingController _passwordcontroller1 = TextEditingController();
  @override
  final String X = '00000000' ;
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
    //  color: Colors.lightBlueAccent,
      child: Stack(children: [ Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/uu.jpg"), fit: BoxFit.fill))), ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            height: 100,
          ),
          textt(
              text0: " Are you a doctor or a patient ?",
              c: Colors.black,
              m: 33,
              w: FontWeight.w300,
              m2: 0,
              k: FontStyle.normal),
          Container(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                      child: GetBuilder<homecontroller>(
                    init: homecontroller(),
                    builder: (controller) {
                      return buttom(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: textt(
                                      text0:
                                          "Please enter your password",
                                      c: Colors.black87,
                                      m: 20,
                                      w: FontWeight.bold,
                                      m2: 0,
                                      k: FontStyle.normal),
                                  content: password(
                                      labeltext: "Password",
                                      mycontroller: _passwordcontroller1,
                                      typee: TextInputType.visiblePassword,
                                      text2: "The field is empty",
                                      n: 5,
                                      text4:
                                          "The password cannot be less then five long"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                           if( X ==  _passwordcontroller1.text){
                                   AwesomeDialog(
            context: context,
            animType: AnimType.rightSlide,
            dialogType: DialogType.success,
            body:  const Center(child: Text("Welcome yo your App" ,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),),
            title: 'Erorr',
            desc:   'Welcome to your App :)',
            btnOkOnPress: () { Get.to(doctorr());},
            ).show(); 

                                           }
                                            else 
                                            {
                                            AwesomeDialog(
            context: context,
            animType: AnimType.rightSlide,
            dialogType: DialogType.error,
            body:  const Center(child: Text("your password is wrong" ,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),),
            title: 'Erorr',
            desc:   ' your password is wrong',
            btnOkOnPress: () {},
            ).show(); }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 66),
                                          alignment: Alignment.bottomCenter,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: textt(
                                              text0: "Log in",
                                              c: Colors.white,
                                              m: 20,
                                              w: FontWeight.w300,
                                              m2: 0,
                                              k: FontStyle.italic),
                                        ))],
                                );
                              });
                        },
                        child: Container(
                          height: 130,
                          width: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.asset("images/oo.jpg"),
                          ),
                        ),
                      );
                    },
                  )),
                  Container(
                    height: 10,
                  ),
                  textt(
                      text0: "Doctor",
                      c: Colors.black,
                      m: 20,
                      w: FontWeight.w300,
                      m2: 0,
                      k: FontStyle.normal)
                ],
              ),
              Column(
                children: [
                  Container(
                    child: buttom(
                      onPressed: () {
                        Get.to(page4());
                      },
                      child: Container(
                        height: 130,
                        width: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.asset("images/ff.jpg"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 13.7,
                  ),
                  textt(
                      text0: "Patient",
                      c: Colors.black,
                      m: 20,
                      w: FontWeight.w300,
                      m2: 0,
                      k: FontStyle.normal)
                ],
              )
            ],
          )
        ],
      ),],)
      
    ));
  }
}