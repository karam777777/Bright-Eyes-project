
//import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class homecontroller extends GetxController {
  bool ispassword = true;
  RxList<String> userslist = <String>[].obs;
  var isLoading = true.obs ;
  int selectedindex = 0;

void change() {
    ispassword = !ispassword;
    update();
 }

  /*void change1(int Value) {
    selectedindex = Value;
    HapticFeedback.lightImpact();
    update();
  }*/

  /*void adduser(String firstname, String lastname) {
    userslist.add('$firstname $lastname');
  }*/

  /*void clearusers() {
    userslist.clear();
  }*/
}
     