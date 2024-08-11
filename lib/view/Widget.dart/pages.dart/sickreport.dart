import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class sickreport extends StatefulWidget {
  final bool isEditable;
  final String userId;
  sickreport({required this.isEditable, required this.userId});

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<sickreport> {
  late List<List<String>> _data;
  final Set<String> _fixedvalues = {
    'Distant',
    'Near',
    'Contact ',
    'LENSES ',
    'Hard',
    'Soft',
    'Toric'
  };

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
   SystemChrome.setPreferredOrientations(
       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    _data = [
      ['Distant', '', '', '', '', '', ''],
      ['Near', '', '', '', '', '', ''],
      ['Contact ', '', '', '', '', '', ''],
      ['LENSES ', 'Hard', 'Soft', 'Toric', 'Hard', 'Soft', 'Toric'],
    ];

    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('userTables')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        List<dynamic> data = doc.get('data');
        setState(() {
          _data = data.map((row) {
            Map<String, String> rowMap = Map<String, String>.from(row);
            return [
              rowMap['col0'] ?? '',
              rowMap['col1'] ?? '',
              rowMap['col2'] ?? '',
              rowMap['col3'] ?? '',
              rowMap['col4'] ?? '',
              rowMap['col5'] ?? '',
              rowMap['col6'] ?? '',
            ];
          }).toList();
        });
      }
    } catch (e) {
      _showErrorDialog('Error fetching data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showAddDialog(BuildContext context, int row, int col) async {
    TextEditingController controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Value'),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter value',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // No action, just close
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _data[row][col] = result; // Add the cell content
      });
    }
  }

  Future<void> _showEditDialog(BuildContext context, int row, int col) async {
    if (!widget.isEditable) return;
    String currentValue = _data[row][col];
    TextEditingController controller = TextEditingController(text: currentValue);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Cell'),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter value',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('delete');
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // No action, just close
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        if (result == 'delete') {
          _data[row][col] = ''; // Clear the cell content
        } else {
          _data[row][col] = result; // Update the cell content
        }
      });
    }
  }

  void _editCell(int row, int col) {
    if (widget.isEditable && !_fixedvalues.contains(_data[row][col])) {
      if (_data[row][col].isEmpty) {
        _showAddDialog(context, row, col);
      } else {
        _showEditDialog(context, row, col);
      }
    }
  }

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: 'Success',
      desc: message,
      btnOkOnPress: () {},
    )..show();
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
    )..show();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(label: Text('')),
                        DataColumn(label: Text('R.Sph')),
                        DataColumn(label: Text('R.Cyl')),
                        DataColumn(label: Text('R.Ax')),
                        DataColumn(label: Text('L.Sph')),
                        DataColumn(label: Text('L.Cyl')),
                        DataColumn(label: Text('L.Ax')),
                      ],
                      rows: List<DataRow>.generate(
                        _data.length,
                        (rowIndex) => DataRow(
                          cells: List<DataCell>.generate(
                            _data[rowIndex].length,
                            (colIndex) => DataCell(
                              Container(
                                child: InkWell(
                                  onTap: widget.isEditable
                                      ? () => _editCell(rowIndex, colIndex)
                                      : null,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      _data[rowIndex][colIndex],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      border: TableBorder.all(color: Colors.black38),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
           child :   CircularProgressIndicator(),
              ),
           
        ],
      ),
    );
  }
}
