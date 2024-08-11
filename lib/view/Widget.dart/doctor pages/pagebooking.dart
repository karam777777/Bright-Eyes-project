
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class booking extends StatefulWidget {
  @override
  _bookingState createState() => _bookingState();
}

class _bookingState extends State<booking> {
  final DateTime _startDate = DateTime(2024, 9, 1);
  List<DateTime> _dates = [];
  Map<DateTime, bool> _showAppointments = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDates();
  }

  void _loadDates() async {
    setState(() {
      _isLoading = true;
    });

    var snapshot = await _firestore.collection('dates').orderBy('date').get();
    List<DateTime> loadedDates = snapshot.docs
        .map((doc) => (doc.data()['date'] as Timestamp).toDate())
        .toList();
    
    setState(() {
      _dates = loadedDates;
      for (var date in _dates) {
        _showAppointments[date] = false;
      }
      _isLoading = false;
    });
  }

  void _toggleShowAppointments(DateTime date) {
    setState(() {
      _showAppointments[date] = !_showAppointments[date]!;
    });
  }

  Future<void> _addDate() async {
    setState(() {
    });

    DateTime newDate;
    if (_dates.isEmpty) {
      newDate = _startDate;
    } else {
      newDate = _dates.last.add(Duration(days: 1));
    }
    await _firestore.collection('dates').add({'date': newDate});
    setState(() {
      _dates.add(newDate);
      _showAppointments[newDate] = false;
   
    });
  }

  Future<void> _deleteDate(DateTime date) async {
    setState(() {
     
    });

    var snapshot = await _firestore.collection('dates').where('date', isEqualTo: date).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    setState(() {
      _dates.remove(date);
      _showAppointments.remove(date);
     
    });
  }

  Future<void> _addAppointment(DateTime date, String name, String time) async {
    setState(() {
     
    });

    bool hasConflict = false;
    var snapshot = await _firestore
        .collection('appointments')
        .where('date', isEqualTo: date)
        .get();
    var appointments = snapshot.docs;
    for (var doc in appointments) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime existingTime =
          DateFormat('HH:mm').parse(data['time']);
      DateTime newTime = DateFormat('HH:mm').parse(time);
      if ((newTime.difference(existingTime).inMinutes).abs() < 30) {
        hasConflict = true;
        break;
      }
    }

    await _firestore.collection('appointments').add({
      'date': date,
      'name': name,
      'time': time,
      'conflict': hasConflict
    });

    setState(() {
     
    });

    if (hasConflict) {
       AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'تعارض في المواعيد',
        desc: 'يوجد موعد آخر قريب من هذا الموعد. سيتم إضافته مع ذلك.',
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> _deleteAppointment(String id) async {
    setState(() {
    });

    await _firestore.collection('appointments').doc(id).delete();

    setState(() {
     
    });
  }

  Future<void> _showAddDateDialog() async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      title: 'إضافة تاريخ جديد',
      desc: 'هل تريد إضافة تاريخ جديد؟',
      btnOkOnPress: _addDate,
      btnCancelOnPress: () {},
    ).show();
  }

  Future<void> _showDeleteDateDialog(DateTime date) async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: 'تأكيد الحذف',
      desc: 'هل تريد حذف هذا التاريخ؟',
      btnOkOnPress: () => _deleteDate(date),
      btnCancelOnPress: () {},
    ).show();
  }

Future<void> _showAddAppointmentDialog(DateTime date) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    return AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      title: 'إضافة موعد جديد',
      body: Column(
        children: [
         TypeAheadField<dynamic>(
           controller: nameController,
suggestionsCallback: (pattern) async {
var snapshot = await _firestore
 .collection('users')
.where('fullname', isGreaterThanOrEqualTo: pattern)
 .where('fullname', isLessThanOrEqualTo: pattern + '\uf8ff')
 .get();

 // استخدام Set لتخزين الأسماء الفريدة
 Set<String> uniqueNames = {};

for (var doc in snapshot.docs) {
 uniqueNames.add(doc['fullname']);
 }

 // تحويل Set إلى List وإرجاعها
 return uniqueNames.toList();
},
itemBuilder: (context, suggestion) {
return ListTile(
title: Text(suggestion),
 );
},
onSelected: (suggestion) {
 nameController.text = suggestion;
},
builder: (context, controller, focusNode) {
 return TextField(
 controller: controller,
 focusNode: focusNode,
 decoration: InputDecoration(labelText: 'الاسم'),
 );
},
),
          TextField(
            controller: timeController,
            decoration: InputDecoration(labelText: 'الوقت'),
            onTap: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                final now = DateTime.now();
                timeController.text = DateFormat('HH:mm').format(DateTime(
                    now.year, now.month, now.day, picked.hour, picked.minute));
              }
            },
          ),
        ],
      ),
      btnOkOnPress: () async {
        if (nameController.text.isNotEmpty &&
            timeController.text.isNotEmpty) {
          await _addAppointment(date, nameController.text, timeController.text);
        }
      },
      btnCancelOnPress: () {},
    ).show();
  }


  Future<void> _showDeleteAppointmentDialog(String id) async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: 'تأكيد الحذف',
      desc: 'هل تريد حذف هذا الموعد؟',
      btnOkOnPress: () => _deleteAppointment(id),
      btnCancelOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('التواريخ والمواعيد'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadDates,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.all(_w / 30),
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  DateTime date = _dates[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      verticalOffset: -250,
                      child: ScaleAnimation(
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  DateFormat('yyyy-MM-dd').format(date),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                leading: Icon(Icons.calendar_today,
                                    color: Colors.blue),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () =>
                                          _showAddAppointmentDialog(date),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () =>
                                          _showDeleteDateDialog(date),
                                    ),
                                  ],
                                ),
                                onTap: () => _toggleShowAppointments(date),
                              ),
                              if (_showAppointments[date]!)
                                StreamBuilder<QuerySnapshot>(
                                  stream: _firestore
                                      .collection('appointments')
                                      .where('date', isEqualTo: date)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    var appointments = snapshot.data!.docs;
                                    return Column(
                                      children: appointments.map((doc) {
                                        var data = doc.data()
                                            as Map<String, dynamic>;
                                        return ListTile(
                                          title: Text(data['name']),
                                          subtitle: Text(data['time']),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () =>
                                                _showDeleteAppointmentDialog(
                                                    doc.id),
                                          ),
                                          tileColor: data['conflict']
                                              ? Colors.red.shade100
                                              : null,
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDateDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}