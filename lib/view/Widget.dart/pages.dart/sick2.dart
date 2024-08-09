import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base/view/Widget.dart/container.dart';
import 'package:fire_base/view/Widget.dart/pages.dart/awareness.dart';
import 'package:fire_base/view/Widget.dart/pages.dart/sickreport.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class sick extends StatefulWidget {
  sick(this.uid, {super.key});
  String uid;

  @override
  State<sick> createState() => _sickState(uid);
}

class _sickState extends State<sick> {
  String IDD;
  _sickState(this.IDD);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? data;
  List<DateTime> _dates = [];
  var _Datecontroller = TextEditingController();
  String _datecontroller = '';
  var _timecontroller = TextEditingController();

  void _loadDates() async {
    var snapshot = await _firestore.collection('dates').orderBy('date').get();
    List<DateTime> _dates = snapshot.docs
        .map((doc) => (doc.data()['date'] as Timestamp).toDate())
        .toList();
  }

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        data = querySnapshot.docs.first.data() as Map<String, dynamic>;
      });
    }
  }

  bool _hasData = false;

 Future<void> _checkData() async {
  DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
      .collection('userTables')
      .doc(IDD)
      .get();

  setState(() {
    _hasData = docSnapshot.exists &&
        docSnapshot.data() != null &&
        (docSnapshot.data() as Map<String, dynamic>)['data'] != null;
  });
}


  void _onButtonPressed() {
    if (_hasData) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => sickreport( isEditable: false , userId : IDD),
        ),
      );
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'No Data',
        desc: ' ! لم يتم كتابة التقرير لك بعد ',
        btnOkOnPress: () {},
      )..show();
    }
  }

Future<void> deleteAppointment(String name) async {
  setState(() {
    // Optionally show a loading indicator here
  });

  // Query appointments to find documents matching the given name
  QuerySnapshot querySnapshot = await _firestore
      .collection('appointments')
      .where('name', isEqualTo: name)
      .get();

  // Delete each document that matches the query
  for (var doc in querySnapshot.docs) {
    await _firestore.collection('appointments').doc(doc.id).delete();
  }

  setState(() {
    // Optionally refresh the state or UI here
  });
}







Future<void> _checkAppointment() async {

  // جلب جميع المواعيد من قاعدة البيانات
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('appointments')
      .orderBy('date') // ترتيب النتائج حسب التاريخ
      .get();
 if (data!['fullname'] != null) {
   
 
  // البحث عن المواعيد التي تطابق الاسم المطلوب
  List<QueryDocumentSnapshot> matchingAppointments = querySnapshot.docs.where((doc) {
    var appointment = doc.data() as Map<String, dynamic>;
    return appointment['name'] == data!['fullname'];
  }).toList();

  if (matchingAppointments.isNotEmpty) {
    // إعداد نص لجميع المواعيد التي تطابق الاسم
    List<String> appointmentDetails = matchingAppointments.map((doc) {
      var appointment = doc.data() as Map<String, dynamic>;
      DateTime date = (appointment['date'] as Timestamp).toDate();
      String time = appointment['time'];
      DateTime dateTime = DateTime(date.year, date.month, date.day, 
                                   int.parse(time.split(':')[0]), 
                                   int.parse(time.split(':')[1]));
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    }).toList();

    // إعداد نص لعرض كل المواعيد
    String appointmentsText = appointmentDetails.join('\n');

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: 'تذكير بالموعد',
      desc: 'موعدك المقبل :\n$appointmentsText',
      btnOkOnPress: () {},
      btnCancelOnPress: () async {
        // تنفيذ عملية حذف هنا إذا كان مطلوباً
        for (var doc in matchingAppointments) {
          await FirebaseFirestore.instance
              .collection('appointments')
              .doc(doc.id)
              .delete();
        }

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: "تم الحذف",
          desc: 'تم الغاء موعدك بنجاح.',
          btnOkOnPress: () {},
        ).show();
      },
      btnCancelText: 'إلغاءالموعد؟',
    ).show();
    }
  } else {
    // التعامل مع الحالة عندما لا يكون هناك حجز
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: 'لا يوجد حجز',
      desc: 'لا يوجد مواعيد مسجلة باسم ${data?['fullname']}.',
      btnOkOnPress: () {},
    ).show();
  }
}



  

  @override
  void initState() {
    getData();
    _loadDates();
      _checkAppointment();
    _checkData();

    super.initState();
  }

  Future<void> _addAppointment(DateTime date, String name, String time) async {
    setState(() {});

    bool hasConflict = false;
    var snapshot = await _firestore
        .collection('appointments')
        .where('date', isEqualTo: date)
        .get();

    if (snapshot.docs.isEmpty) {
      List<QueryDocumentSnapshot> availableDatesSnapshot = await _firestore
          .collection('appointments')
          .get()
          .then((querySnapshot) => querySnapshot.docs);

      List<DateTime> availableDates = availableDatesSnapshot.map((doc) {
        Timestamp timestamp = doc['date'];
        return timestamp.toDate();
      }).toList();

      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'التاريخ ليس متوفراً',
        desc: 'لم يتم فتح هذا التاريخ بعد , يرجى اختيار تاريخ متاح ',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
         AwesomeDialog(
  context: Get.context!,
  dialogType: DialogType.info,
  animType: AnimType.rightSlide,
  title: 'Available Dates',
  body: Container(
    width: double.maxFinite,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: availableDates.toSet().toList().length, // إزالة التكرارات
      itemBuilder: (context, index) {
        List<DateTime> uniqueDates = availableDates.toSet().toList(); // قائمة بدون تكرارات
        return ListTile(
          title: Text(DateFormat('yyyy-MM-dd').format(uniqueDates[index])),
          onTap: () {
            Navigator.of(context).pop();
            AwesomeDialog(
              context: Get.context!,
              dialogType: DialogType.info,
              animType: AnimType.rightSlide,
              title: 'تأكيد التاريخ الجديد',
              desc: 'هل تود تغيير التاريخ ${DateFormat('yyyy-MM-dd').format(date as DateTime)} الى ${DateFormat('yyyy-MM-dd').format(uniqueDates[index])}?',
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                _Datecontroller.text = DateFormat('yyyy-MM-dd').format(uniqueDates[index]);
                print('Date changed to: ${DateFormat('yyyy-MM-dd').format(uniqueDates[index])}');
              },
              btnCancelText: 'Cancel',
              btnOkText: 'Confirm',
            ).show();
          },
        );
      },
    ),
  ),
  btnCancelOnPress: () {},
).show();

        },
        btnCancelText: 'OK',
        btnOkText: 'عرض التواريخ المتوفرة ',
      ).show();
    } else {
      var appointments = snapshot.docs;
      for (var doc in appointments) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime existingTime = DateFormat('HH:mm').parse(data['time']);
        DateTime newTime = DateFormat('HH:mm').parse(time);

        if ((newTime.difference(existingTime).inMinutes).abs() < 30) {
          hasConflict = true;
          break;
        }
      }

      if (hasConflict) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'تعارض في المواعيد',
          desc: ' يوجد موعد آخر قريب من هذا الموعد, يرجى اختيار موعد آخر ',
          btnOkOnPress: () {},
        ).show();
      } else {
        await _firestore.collection('appointments').add({
          'date': date,
          'name': name,
          'time': time,
          'conflict': hasConflict
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: 'نجحت العملية',
          desc: 'تم حجز الموعد بنجاح في ${DateFormat('yyyy-MM-dd HH:mm').format(date)}.',
          btnOkOnPress: () {
            Get.back();
          },
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> selectdate(BuildContext context) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != DateTime.now()) {
        setState(() {
          _datecontroller = DateFormat('yyyy-MM-dd').format(picked);
          _Datecontroller.text = _datecontroller;
        });
      }
    }

    Future<void> selectime(BuildContext context) async {
      TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (picked != null) {
        final now = DateTime.now();
        final formattedtime =
            DateFormat('HH:mm').format(DateTime(now.year, now.month, now.day, picked.hour, picked.minute));
        setState(() {
          _timecontroller.text = formattedtime;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("BRIGHT EYES"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/uu.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Container(height: 25),
              Text(
                "Welcome To",
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.start,
              ),
              AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              '                  Bright Eyes',
              textStyle: TextStyle(
                fontSize: 36.0,
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
              Container(height: 50),
              container(
                iconn: Icons.event_note_outlined,
                texttt: "Booking",
                onPressedd: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Appointment Booking",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        content: ListView(
                          children: [
                            Container(height: 30),
                            TextFormField(
                              controller: _Datecontroller,
                              decoration: InputDecoration(
                                icon: Icon(Icons.calendar_month),
                                labelText: "enter date",
                              ),
                              readOnly: true,
                              onTap: () => selectdate(context),
                            ),
                            Container(height: 50),
                            TextFormField(
                              controller: _timecontroller,
                              decoration: InputDecoration(
                                icon: Icon(Icons.calendar_month),
                                labelText: "enter time",
                              ),
                              readOnly: true,
                              onTap: () => selectime(context),
                            ),
                            Container(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 108, 187, 247),
                                    ),
                                  ),
                                ),
                                Container(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    String t = _timecontroller.text;
                                    String d = _Datecontroller.text;
                                    if(!d.isEmpty && !t.isEmpty){
                                      DateTime D = DateTime.parse(d);
                                    _addAppointment(D, data?['fullname'], t); }
                                    else {
                                     AwesomeDialog(
                                      context: Get.context!,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'استكمال بيانات',
                                      desc: 'لم تحدد الوقت او التاريخ المراد حجزهما  ',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {}                                                        
                                     ).show() ;
                                    }
                                  },
                                  child: Text(
                                    'Reservation',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 160, 204, 240),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
   //           Container(height: 40),
              Container(height: 50),
              container(
                iconn: Icons.person,
                texttt: "Profile",
                onPressedd: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color.fromARGB(255, 185, 228, 251),
                        content: ListView(
                          children: [
                            Container(
                              child: Icon(
                                Icons.account_circle,
                                size: 100,
                                color: Colors.black,
                              ),
                            ),
                            Container(height: 10),
                            Container(
                              padding: EdgeInsets.only(left: 1),
                              child: Text(
                                "Name:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabled: false,
                                  labelText: data?['fullname'] ?? '',
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Container(height: 20),
                            Container(
                              padding: EdgeInsets.only(left: 1),
                              child: Text(
                                "Birthday:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabled: false,
                                  labelText: data?['his_birthday'] ?? '',
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Container(height: 20),
                            Container(
                              padding: EdgeInsets.only(left: 1),
                              child: Text(
                                "Gender:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabled: false,
                                  labelText: data?['gender'] ?? '',
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _onButtonPressed,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return _hasData
                                        ? Color.fromARGB(255, 97, 208, 101)
                                        : Color.fromARGB(255, 255, 146, 138);
                                  },
                                ),
                              ),
                              child: Text(
                                "view the Report",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              Container(height: 50),
              container(
                iconn: Icons.water_drop_outlined,
                texttt: 'Awareness information',
                onPressedd: () {Get.to(Awareness());},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
