import 'package:fire_base/view/Widget.dart/textt.dart';
import 'package:flutter/material.dart';

class container extends StatelessWidget {
  final void Function()? onPressedd;
  final IconData iconn;
  final String texttt;
  const container({super.key, this.onPressedd, required this.iconn, required this.texttt});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(.7),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(50, 30),
                topRight: Radius.elliptical(50, 50)),
            shape: BoxShape.rectangle),
        child: MaterialButton(
            onPressed: onPressedd,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(7),
                  width: 80,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    iconn,
                    size: 35,
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    textt(
                        text0: texttt,
                        c: Colors.black,
                        m: 23,
                        w: FontWeight.w300,
                        m2: 0,
                        k: FontStyle
                            .normal), //textt(text0: 'kkkkkk', c:Colors.black87.withOpacity(.5) , m: 15, w: FontWeight.w400, m2: 0, k: FontStyle.normal),
                    textt(
                        text0: 'Tap to know more',
                        c: Colors.black87.withOpacity(.5),
                        m: 15,
                        w: FontWeight.w400,
                        m2: 0,
                        k: FontStyle.normal),
                  ],
                ),
              ],
            )));
  }
}