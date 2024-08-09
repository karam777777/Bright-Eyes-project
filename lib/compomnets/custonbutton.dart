import 'package:flutter/material.dart';

class custombuttonauth extends StatelessWidget {
  const custombuttonauth({super.key, required this.onPressed, required this.tit, required this.hei});
final void Function()? onPressed ;
final Widget tit ;
final double hei ;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: hei ,
       shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)) ,
       onPressed: onPressed ,
       color: const Color.fromARGB(255, 6, 18, 180),
       textColor: Colors.white,
       child: tit  ,
         ) ;
  }
}