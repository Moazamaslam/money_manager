import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:money_manager/Pages/Add_Transaction.dart';
import 'package:money_manager/Transaction_model.dart';
import 'package:money_manager/Widgets/Confirm_Dilogbox.dart';
import 'package:money_manager/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepagescreen extends StatefulWidget {
  const Homepagescreen({Key? key}) : super(key: key);

  @override
  State<Homepagescreen> createState() => _HomepagescreenState();
}

class _HomepagescreenState extends State<Homepagescreen> {
  DBhelper dBhelper = DBhelper();
  late SharedPreferences preferences;
  late Box box;
  int totalbalance = 0;
  int totalIncome = 0;
  int totalExpence = 0;
  DateTime today = DateTime.now();
  List<FlSpot> dataset = [];
  List<FlSpot> getPlotPionts(List<TransactionModel> entireData) {
    dataset = [];
    List tempdataset = [];
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month && data.type == "debit") {
        tempdataset.add(data);
      }
    }
    tempdataset.sort((a, b) => a.date.day.compareTo(b.date.day));
    for (var i = 0; i < tempdataset.length; i++) {
      dataset.add(FlSpot(tempdataset[i].date.day.toDouble(),
          tempdataset[i].amount.toDouble()));
    }
    return dataset;
  }

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
  getTotalbalance(List<TransactionModel> entireData) {
    totalbalance = 0;
    totalIncome = 0;
    totalExpence = 0;
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == "credit") {
          totalbalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalbalance -= data.amount;
          totalExpence += data.amount;
        }
      }
    }
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> items = [];
      box.toMap().values.forEach(
        (element) {
          // print(element);
          items.add(TransactionModel(
              element["amount"] as int,
              element["date"] as DateTime,
              element["note"] as String,
              element["type"] as String));
        },
      );
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box("money");
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          )
              .whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: Colors.purple,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: FaIcon(
          FontAwesomeIcons.plus,
          size: 24.0,
        ),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Unexpected error!'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text('No data found !'),
              );
            }
            getTotalbalance(snapshot.data!);
            getPlotPionts(snapshot.data!);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white70),
                            padding: EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              maxRadius: 30.0,
                              child: FaIcon(
                                FontAwesomeIcons.user,
                                size: 26.0,
                              ),
                            ),
                          ),
                          Text(
                            '${preferences.getString("name")}',
                            style: TextStyle(fontSize: 22.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white70),
                        padding: EdgeInsets.all(12.0),
                        child: FaIcon(
                          FontAwesomeIcons.cog,
                          size: 32.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.blueAccent],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(24.0),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        Text(
                          'Total Balance',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          'Rs $totalbalance',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28.0, color: Colors.white),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardIncome(totalIncome.toString()),
                              cardExpense(totalExpence.toString()),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Debit Chart',
                    style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                dataset.length < 2
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5.0,
                                blurRadius: 6.0,
                                offset: Offset(0, 4),
                              ),
                            ]),
                        padding: EdgeInsets.all(12.0),
                        child: Text("No data to render Chart"),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5.0,
                                blurRadius: 6.0,
                                offset: Offset(0, 4),
                              ),
                            ]),
                        padding: EdgeInsets.all(12.0),
                        height: 300.0,
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: false,
                                barWidth: 2.5,
                                color: Colors.blueAccent,
                                spots: getPlotPionts(snapshot.data!),
                              ),
                            ],
                          ),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Transactions',
                    style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    TransactionModel dataatIndex;
                    try {
                      dataatIndex = snapshot.data![index];
                    } catch (e) {
                      return ShowConfirmDilogbox(context, "Warning",
                          "Something bad happens !\n Close the app");
                    }
                    if (dataatIndex.type == "credit") {
                      return IncomeTile(dataatIndex.amount, dataatIndex.note,
                          dataatIndex.date, index);
                    } else {
                      return ExpenceTile(dataatIndex.amount, dataatIndex.note,
                          dataatIndex.date, index);
                    }
                  },
                ),
                SizedBox(
                  height: 60.0,
                ),
              ],
            );
          } else {
            return Center(
              child: Text('Unexpected error !'),
            );
          }
        },
      ),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(24.0),
          ),
          padding: EdgeInsets.all(6.0),
          child: FaIcon(
            FontAwesomeIcons.arrowDown,
            size: 28.0,
            color: Colors.green,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Column(
          children: [
            Text(
              'Credit',
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
            Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0),
            ),
          ],
        )
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(24.0),
          ),
          padding: EdgeInsets.all(6.0),
          child: FaIcon(
            FontAwesomeIcons.arrowUp,
            size: 28.0,
            color: Colors.red,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Column(
          children: [
            Text(
              'Debit',
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
            Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0),
            ),
          ],
        )
      ],
    );
  }

  Widget IncomeTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answere = await ShowConfirmDilogbox(
            context, "Warning", "Do you want to delete this record");
        if (answere != null && answere) {
          dBhelper.deletedata(index);
          setState(() {});
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(
            0xffced4eb,
          ),
          borderRadius: BorderRadius.circular(
            18.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.arrowCircleDown,
                      size: 28.0,
                      color: Colors.green[700],
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      'Credit',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "(${date.day} ${months[date.month - 1]} ${date.year})",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+ $value',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  '$note',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ExpenceTile(int value, String note, DateTime date, int index) {
    return InkWell(
        onLongPress: () async {
          bool? answere = await ShowConfirmDilogbox(
              context, "Warning", "Do you want to delete this record");
          if (answere != null && answere) {
            dBhelper.deletedata(index);
            setState(() {});
          }
        },
        child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color(
              0xffced4eb,
            ),
            borderRadius: BorderRadius.circular(
              18.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.arrowCircleUp,
                        size: 28.0,
                        color: Colors.red[700],
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        'Debit',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "(${date.day} ${months[date.month - 1]} ${date.year})",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '- $value',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '$note',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
