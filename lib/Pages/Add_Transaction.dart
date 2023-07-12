import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_manager/db_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  //these are the variables used in this screen
  int? amount;
  String note = "some expense";
  String type = "credit";
  DateTime selectdate = DateTime.now();
  List<String> months = [
    "January",
    "Fabuary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  Future<void> _selecteddate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectdate,
      firstDate: DateTime(2020, 12),
      lastDate: DateTime(2100, 01),
    );
    if (picked != null && picked != selectdate) {
      setState(() {
        selectdate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
        ),
        body: ListView(
          padding: EdgeInsets.all(12.0),
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Add Transaction',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: FaIcon(
                    FontAwesomeIcons.dollarSign,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 18.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      try {
                        amount = int.parse(val);
                      } catch (e) {
                        //you can create any toast and any action
                      }
                    },
                    style: TextStyle(fontSize: 24.0),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: FaIcon(
                    FontAwesomeIcons.stickyNote,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 18.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Note on Transaction',
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      note = val;
                    },
                    style: TextStyle(fontSize: 24.0),
                    maxLength: 10,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: FaIcon(
                    FontAwesomeIcons.balanceScale,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 18.0),
                ChoiceChip(
                  label: Text(
                    'Credit',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: type == "credit" ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: type == "credit" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "credit";
                      });
                    }
                  },
                ),
                SizedBox(width: 18.0),
                ChoiceChip(
                  label: Text(
                    'Debit',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: type == "debit" ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: type == "debit" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "debit";
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () {
                _selecteddate(context);
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: FaIcon(
                      FontAwesomeIcons.calendar,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 18.0,
                  ),
                  Text(
                    '${selectdate.day} ${months[selectdate.month - 1]} ${selectdate.year}',
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (amount != null && note.isNotEmpty) {
                    DBhelper dbhelper = DBhelper();
                    await dbhelper.addData(amount!, selectdate, note, type);
                    Navigator.of(context).pop();
                  } else {
                    print('Not all values provided !');
                  }
                },
                child: Text('ADD'))
          ],
        ));
  }
}
