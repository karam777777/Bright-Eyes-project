import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:fire_base/controller/controller.dart';
import 'package:fire_base/view/Widget.dart/images.dart';
import 'package:fire_base/view/Widget.dart/materialbutton.dart';
//import 'package:fire_base/view/Widget.dart/pages.dart/first-stepto-create-newaccount.dart';
import 'package:fire_base/auth/login222.dart';
import 'package:fire_base/view/Widget.dart/pages.dart/sick2.dart';
import 'package:fire_base/view/Widget.dart/textformfield.dart';
import 'package:fire_base/view/Widget.dart/textt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class createAcc extends StatelessWidget {
  createAcc({super.key})
  {
  }

  TextEditingController fullname = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController date = TextEditingController();
CollectionReference users = FirebaseFirestore.instance.collection('users');
static bool x = false ;
  get context => null;

    
addUser() async {
try {
   DocumentReference response = await users.add({
             'id' : FirebaseAuth.instance.currentUser!.uid ,
            'fullname': fullname.text,  
            'gender': gender.text ,
            'his_birthday':date.text ,
          }) ;
          x= true ;
} catch (e) {
  
         AwesomeDialog(
            context:context,
            animType: AnimType.rightSlide,
            dialogType: DialogType.error,
            body:  Center(child: Text("$e" ,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),),
            title: 'Erorr',
            desc:   '$e',
            btnOkOnPress: () {},
            ).show(); 
}
      // Call the user's CollectionReference to add a new user

        
      
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: [
    image(),
      ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          
          Container(
            height: 70,
          ),
        textfield(labeltext:"Full name" , mycontroller:fullname,/* typee:TextInputType.text ,*/ iconn: Icon(Icons.colorize_outlined), text2:"The field is empty", text3: "", text4:""),
         Container(
            height: 25,
          ),
        
           textfield(labeltext:"Gender" , mycontroller:gender,/* typee:TextInputType.text,*/ iconn: Icon(Icons.g_mobiledata_rounded), text2:"The field is empty", text3: "", text4:""),
          Container(
            height: 25,
          ),
           textfield(labeltext:"Data of birth" , mycontroller:date,/* typee:TextInputType.text,*/ iconn: Icon(Icons.date_range_outlined), text2:"The field is empty", text3: "", text4:""),
     Container(
            height: 25,
          ),
          buttom(
            onPressed: () {
              
 AwesomeDialog(
                context: context,
                  animType: AnimType.rightSlide,
                   dialogType: DialogType.question,
                      body:  const Center(child: Text("did you verified your email ?" ,
                      style: TextStyle(fontStyle: FontStyle.italic),
                  ),),
            title: 'did you verified your email ?',
            desc:   'did you verified your email ?',
            btnCancelOnPress: (){  /*FirebaseAuth.instance.currentUser!.sendEmailVerification() ;*/ },
            btnOkOnPress: () async { 
            //addUser() ;
            // print('yes**********************************************************************');
             if (/*FirebaseAuth.instance.currentUser!.emailVerified*/ true )  {
           await addUser() ;
           if(x){
    Get.to(sick(FirebaseAuth.instance.currentUser!.uid)) ;
    x=false ;
    }
  }
  else {
  AwesomeDialog(
                context: context,
                  animType: AnimType.rightSlide,
                   dialogType: DialogType.error,
                      body:  const Center(child: Text(" You must verify your email first" ,
                      style: TextStyle(fontStyle: FontStyle.italic),
                  ),),
            title: 'check up',
            desc:   'You must verify your email first',
            btnOkOnPress: () { 
           
            },
            ).show();

  }
              } ).show();

        //    Get.find<homecontroller>().adduser(firstname.text,lastname.text)  

          //  addUser();
              
            },
            child: Container(
              width: 110,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black54),
              child:textt(text0: "Create", c:Colors.white , m: 20, w: FontWeight.w300, m2: 2, k: FontStyle.italic)
             
            ),
          ) ],
      ),
    ]));
  }
}