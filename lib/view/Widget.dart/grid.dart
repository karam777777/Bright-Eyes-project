import 'package:fire_base/view/Widget.dart/textt.dart';
import 'package:flutter/material.dart';

class grid extends StatelessWidget {
  final Icon iconsf;
  final Color color;
  final String texttt;
  void Function()? onPressed;
  final Color colorr;
  grid(
      {super.key,
      required this.iconsf,
      required this.color,
      required this.texttt,
      this.onPressed, required this.colorr});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Container(width: 400,height: 120,
        decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color:colorr ),
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 30),
            child: Container(
              height: 70,
              width: 70,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: color),
                  child: iconsf),
            ),
          ),
          Container(padding: EdgeInsets.only(right: 10),
            child: textt(
                text0: texttt,
                c: Colors.black45,
                m: 20,
                w: FontWeight.w500,
                m2: 0,
                k: FontStyle.normal),
          )
        ],
      )
      ),
    );
  }
}