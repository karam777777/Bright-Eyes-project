import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class textt extends StatelessWidget {
  final String text0;
  final Color c;
  final double m;
  final FontWeight w;
  final double m2;
  final FontStyle k;
  const textt(
      {super.key,
      required this.text0,
      required this.c,
      required this.m,
      required this.w,
      required this.m2,
      required this.k});

  @override
  Widget build(BuildContext context) {
    return Text(
      text0,
      style: TextStyle(
        letterSpacing: m2,
        fontSize: m,
        fontWeight: w,
        fontStyle: k,
        color: c,
      ),
      textAlign: TextAlign.center,
    );
  }
}