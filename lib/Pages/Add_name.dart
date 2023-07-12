import 'package:flutter/material.dart';
import 'package:money_manager/Pages/Homepage.dart';
import 'package:money_manager/db_helper.dart';

class AddNamescreen extends StatefulWidget {
  const AddNamescreen({Key? key}) : super(key: key);

  @override
  State<AddNamescreen> createState() => _AddNamescreenState();
}

class _AddNamescreenState extends State<AddNamescreen> {
  DBhelper dBhelper = DBhelper();
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Image.asset(
                "assets/moneybag.png",
                width: 64.0,
                height: 64.0,
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'What should we call you !',
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 18.0),
                child: TextField(
                  decoration: InputDecoration(
                      // hintText: "Name",
                      label: Text("Name")),
                  onChanged: (value) {
                    name = value;
                  },
                ),
              )),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: 50.0,
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    if (name.isNotEmpty) {
                      //add to datbase
                      dBhelper.addName(name);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Homepagescreen()));
                    } else {
                      //show some error
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        action: SnackBarAction(
                          label: "ok",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                        backgroundColor: Colors.white,
                        content: Text(
                          'Please Enter the name',
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ));
                    }
                  },
                  child: Text("Next")),
            ),
          ),
        ],
      ),
    );
  }
}
