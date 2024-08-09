import 'package:flutter/material.dart';

class customtextform extends StatelessWidget {
  const customtextform({super.key, required this.hinttext, required this.mycontroller, required this.validator});
final String hinttext ;
final TextEditingController mycontroller ;
final String? Function(String?)? validator ;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:validator ,
      controller: mycontroller ,
 decoration:
    InputDecoration(
      hintText: hinttext ,hintStyle: const TextStyle(
      fontSize: 14 , color: Colors.grey),
     contentPadding: const EdgeInsets.symmetric(vertical: 2 , horizontal: 20) ,
     filled: true  ,
      fillColor :Colors.grey[200],
       border: OutlineInputBorder( borderSide: const BorderSide(color: Color.fromARGB(255, 139, 136, 136)) ,borderRadius: BorderRadius.circular(50)),
       enabledBorder: OutlineInputBorder( borderSide: const BorderSide(color: Color.fromARGB(255, 90, 89, 89)) ,borderRadius: BorderRadius.circular(50)),

       ),
        
        ) ;
  }
}