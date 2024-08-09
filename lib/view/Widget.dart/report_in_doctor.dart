import 'package:fire_base/view/Widget.dart/pages.dart/report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class reportdocotr extends StatelessWidget {
  final bool isedit ;
  final String name,gender ,age;
  var id ;
  reportdocotr( this.id ,this.name,  this.gender, this.age,{ super.key, required this.isedit});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Container(
            child: Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.black,
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.only(left: 1),
              child: Text(
                "Name:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54),
              )),
          MaterialButton(
            onPressed: () {},
            child: TextFormField(
              decoration: InputDecoration(
                  enabled: false,
                  labelText: name,
                  hintStyle: TextStyle(color: Colors.black)),
            ),
          ),
          Container(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(left: 1),
              child: Text(
                "Birthday:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54),
              )),
          MaterialButton(
            onPressed: () {},
            child: TextFormField(
              decoration: InputDecoration(
                  enabled: false,
                  labelText: age,
                  hintStyle: TextStyle(color: Colors.black)),
            ),
          ),
          Container(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(left: 1),
              child: Text(
                "Gender:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54),
              )),
          MaterialButton(
            onPressed: () {},
            child: TextFormField(
              decoration: InputDecoration(
                enabled: false,
                labelText: gender,
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(doctorReport(isEditable: true , userId: id,));
              },
              child: Text("Viewing Report",style: TextStyle(color: Colors.black54),)),
        ],
      ),
    );
  }
}