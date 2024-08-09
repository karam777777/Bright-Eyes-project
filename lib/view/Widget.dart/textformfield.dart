import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class textfield extends StatelessWidget {
  final String labeltext;
  final TextEditingController mycontroller;
 // final TextInputType typee;
  final Icon iconn;
  final String text2;
   final String text3;
    final String text4;
  const textfield(
      {super.key,
      required this.labeltext,
      required this.mycontroller,
   //   required this.typee,
      required this.iconn, required this.text2, required this.text3, required this.text4});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: (val) {
          if (val!.isEmpty) {
            return text2;
          } else if (!val.contains(text3)) {
            return text4;
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: mycontroller,
       // keyboardType: typee,
        decoration: InputDecoration(
            suffixIcon: iconn,
            labelText: labeltext,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 60))),
      ),
    );
  }
}