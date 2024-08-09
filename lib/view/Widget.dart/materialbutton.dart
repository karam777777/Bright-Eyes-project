import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fire_base/controller/controller.dart';
import 'package:get/get.dart';

class buttom  extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  const buttom ({super.key, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<homecontroller>(
      init: homecontroller(),
      builder: (controller) {
        return MaterialButton(
          
            shape:RoundedRectangleBorder(
           borderRadius:BorderRadius.circular(30) ,),
          onPressed: onPressed,
          child: child,
        );
      },
    );
  }
}