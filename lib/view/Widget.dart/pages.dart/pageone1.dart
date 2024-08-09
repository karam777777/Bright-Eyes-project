import 'package:fire_base/view/Widget.dart/pages.dart/choose.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutterprojectnew/view/Login.dart';
import 'package:get/get.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 700,
              child: PageView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                        ),
                        Image.asset(
                          "images/aa.webp",
                          fit: BoxFit.fill,
                        ),
                        Container(height: 7,),
                        Text(
                          "Eyes Safety First",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w200,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 47,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.lightBlueAccent,
                            ),
                            Container(
                              width: 7,
                            ),
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.black45,
                            ),
                            Container(
                              width: 7,
                            ),
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.black45,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: 250,
                        ),
                        Image.asset(
                          "images/cc.jpg",
                          fit: BoxFit.fill,
                        ),
                        Container(
                          height: 28,
                        ),
                        Text(
                          "Take Care of Your Eyes",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w200,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.black45,
                            ),
                            Container(
                              width: 7,
                            ),
                            Icon(
                              Icons.circle,
                              color: Colors.lightBlueAccent,
                            ),
                            Container(
                              width: 7,
                            ),
                            Icon(Icons.circle_outlined,
                              color: Colors.black45,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                       /* Container(
                            height: 30,
                            width: 70,
                            margin: EdgeInsets.only(top: 60),
                            alignment: Alignment.bottomRight,
                            child: MaterialButton(
                              onPressed: () {
                                Get.to(pagetwo());
                              },
                              child: Text(
                                "Next",
                              ),
                            )),*/
                        Container(
                          height: 183,
                        ),
                        Image.asset(
                          "images/dd.jpg",
                          fit: BoxFit.fill,
                        ),
                        Container(
                          height: 47,
                        ),
                        Text(
                          "Check Your Eyesight",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w200,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 49,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.black45,
                            ),
                            Container(
                              width: 7,
                            ),
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.black45,
                            ),
                            Container(
                              width: 7,
                            ),
                            Icon(
                              Icons.circle,
                              color: Colors.lightBlueAccent,
                            ),
                          ],
                        ),
                         Container(
                          
                            margin: EdgeInsets.only(top: 60),
                            alignment: Alignment.bottomRight,
                            child: MaterialButton(
                              onPressed: () {
                                Get.to(pagetwo());
                              },
                              child:Icon (Icons.arrow_forward,size: 27,color: Colors.black45,
                                
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}