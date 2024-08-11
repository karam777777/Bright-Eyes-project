
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base/view/Widget.dart/report_in_doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/route_manager.dart';
class MyCustomUI2 extends StatefulWidget {
  @override
  State<MyCustomUI2> createState() => _MyCustomUI2State();
}

class _MyCustomUI2State extends State<MyCustomUI2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 107, 170, 251),
        elevation: 10,
        title: 
        AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Bright Eyes',
              textStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              colors: [
               
                Color.fromARGB(255, 15, 15, 15),
                Color.fromARGB(255, 249, 249, 247),
                Color.fromARGB(255, 170, 165, 165),
                
              ],
            ),
          ],
          isRepeatingAnimation: true,
          repeatForever: true,

        ),
        
        
       // Text('Bright Eyes'),
      
        centerTitle: true,
      ),
      body: AnimatedCards(),
    );
  }
}

class AnimatedCards extends StatefulWidget {
  @override
  _AnimatedCardsState createState() => _AnimatedCardsState();
}

class _AnimatedCardsState extends State<AnimatedCards> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;

  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getData() async {
    try {
      FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true); // Enable offline data
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      // Use a set to avoid duplicates
      Set<String> userIds = {};
      data = querySnapshot.docs.where((doc) {
        final documentData = doc.data() as Map<String, dynamic>;
        final uid = documentData['id'] as String;
        if (userIds.contains(uid)) {
          return false;
        } else {
          userIds.add(uid);
          return true;
        }
      }).toList();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {});

    _animation2 = Tween<double>(begin: 0, end: -30)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    getData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _deleteUser(String userId) async {
    try {
      // لم أقم بتطبيق الحذف لان ذلك يطلب مصادقة من المستخدم 
    isLoading  =true ;
      await   FirebaseFirestore.instance.collection('userTables').doc(userId).delete() ;
      setState(() async {
    FirebaseFirestore.instance.collection('userTables').doc(userId).delete() ;
     
      });
      isLoading = false ;
    } catch (e) {
     isLoading = false ;
      print("Error deleting user: $e");
    }
  }

  void _editUser(String userId, String fullname, String gender, String age) async {
    TextEditingController fullnameController = TextEditingController(text: fullname);
    TextEditingController genderController = TextEditingController(text: gender);
    TextEditingController ageController = TextEditingController(text: age);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fullnameController,
                decoration: InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: genderController,
                decoration: InputDecoration(labelText: "Gender"),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: "Age"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  isLoading = true;
               QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.update({
        'fullname': fullnameController.text,
        'gender': genderController.text,
        'age': ageController.text,
      });
    }
                  setState(() {
                    getData();
                  });

                  Get.back();
                  isLoading = false;
                } catch (e) {
                  isLoading = false;
                  print("Error updating user: $e");
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              SizedBox(height: _w / 13),
              ListView.builder(
                itemCount: data.length,
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (BuildContext context, int index) {
                  final document = data[index];
                  final documentData = document.data() as Map<String, dynamic>;
                  final String userId = documentData['id'] as String; // Use the 'id' field as userId
                  final String fullname = documentData.containsKey('fullname') ? documentData['fullname'] : 'Unknown';
                  final String gender = documentData.containsKey('gender') ? documentData['gender'] : 'Unknown';
                  final String age = documentData.containsKey('his_birthday') ? documentData['his_birthday'] : 'Unknown';

                  return cards(userId, fullname, gender, age);
                },
              ),
              CustomPaint(
                painter: MyPainter(),
                child: Container(height: 0),
              ),
            ],
          );
  }

  Widget cards(String userId, String name, String gender, String age) {
    double _w = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(0, _animation2.value),
        child: InkWell(
          onLongPress: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.question,
              headerAnimationLoop: false,
              animType: AnimType.topSlide,
              title: 'Options',
              desc: 'Choose an option',
              btnOkOnPress: () {
                _editUser(userId, name, gender, age);
              },
              btnOkText: 'Edit',
              btnCancelText: 'Delete',
              btnCancelOnPress: () {
                // Show confirmation dialog for deletion
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: false,
                  animType: AnimType.topSlide,
                  title: 'Delete the report',
                  desc: 'Are you sure you want to delete the report of this user?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    _deleteUser(userId);
                  },
                ).show();
              },
            ).show();
          },
          onTap: () {
            // Single tap handling
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => reportdocotr(userId, name, gender, age, isedit: true),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(_w / 20, _w / 20, _w / 20, 0),
            padding: EdgeInsets.all(_w / 20),
            height: _w / 3.5,
            width: _w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffEDECEA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xffEDECEA),
                  radius: _w / 15,
                  child: Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Color.fromARGB(255, 49, 104, 198),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: _w / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(.7),
                        ),
                      ),
                      Text(
                        gender,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(.8),
                        ),
                      ),
                      Text(
                        age,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.navigate_next_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = Paint()
      ..color = Color.fromARGB(255, 91, 135, 237)
      ..style = PaintingStyle.fill;

    Path path_1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * .1, 0)
      ..cubicTo(size.width * .05, 0, 0, 20, 0, size.width * .08);

    Path path_2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * .9, 0)
      ..cubicTo(size.width * .95, 0, size.width, 20, size.width, size.width * .08);

    Paint paint_2 = Paint()
      ..color = Color.fromARGB(255, 110, 178, 230)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path path_3 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path_1, paint_1);
    canvas.drawPath(path_2, paint_1);
    canvas.drawPath(path_3, paint_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RouteWhereYouGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 50,
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(.5),
        title: Text('EXAMPLE PAGE',
            style: TextStyle(
                color: Colors.black.withOpacity(.7),
                fontWeight: FontWeight.w600,
                letterSpacing: 1)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black.withOpacity(.8)),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}
