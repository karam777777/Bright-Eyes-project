import 'package:fire_base/compomnets/customtextfieldadd.dart';
import 'package:fire_base/compomnets/custonbutton.dart';
import 'package:flutter/material.dart';
class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
 
 TextEditingController name = TextEditingController() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("add catgeory") ,


      ),
      body:
      Form( key: formState ,
      child: Column( children : [
      Container(
        padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 25),
        child: customtextformAdd(hinttext: "enter name" , mycontroller:name , validator: (val){
        if(val == '') 
        return 'can`t be embty ';
        }),
      ) , 
      custombuttonauth ( onPressed: () {}, tit: Text ( "Add" ), hei: 20 ) 
      ]

      ) ,
    ) );
  }
}