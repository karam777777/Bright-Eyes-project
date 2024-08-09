import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fire_base/controller/controller.dart';
import 'package:get/get.dart';

class password extends StatelessWidget {
  final String labeltext;
  final TextEditingController mycontroller;
  final TextInputType typee;
 
  final String text2;
  final int n;
  final String text4;
  const password(
      {super.key,
      required this.labeltext,
      required this.mycontroller,
      required this.typee,
      
      required this.text2,
      required this.n,
      required this.text4});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GetBuilder<homecontroller>(
      init: homecontroller(),
      builder: (controller) {return
        TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              return text2;
            }
            if (val.length < n) {
              return text4;
            }
            return null;
          },
          controller: mycontroller,
          keyboardType: typee,
          obscureText: controller.ispassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                controller.change();
              },
              icon: controller.ispassword
                  ? Icon(Icons.visibility_outlined)
                  : Icon(Icons.visibility_off_outlined),
            ),
            labelText: labeltext,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      },
    ));
  }
}