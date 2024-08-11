import 'package:fire_base/view/Widget.dart/container.dart';
import 'package:fire_base/view/Widget.dart/doctor%20pages/pagebooking.dart';
import 'package:fire_base/view/Widget.dart/doctor%20pages/the_profiles_in_doctor_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'package:get/get.dart';

class doctorr extends StatelessWidget {
  const doctorr({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/uu.jpg"), fit: BoxFit.fill)),
        ),
        ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
              height: 200,
            ),
            container(
              iconn: Icons.account_box_rounded,
              texttt: "Registered patients",
              onPressedd: () {
                Get.to(MyCustomUI2());
              },
            ),
            Container(
              height: 80,
            ),
            container(
              iconn: Icons.event_outlined,
              texttt: "Reservations        ",
              onPressedd: () {
                Get.to(booking());
              },
            )
          ],
        )
      ],
    ));
  }
}