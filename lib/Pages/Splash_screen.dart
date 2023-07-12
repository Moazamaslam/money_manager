import 'package:flutter/material.dart';
import 'package:money_manager/Pages/Add_name.dart';
import 'package:money_manager/Pages/Homepage.dart';
import 'package:money_manager/db_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //
  DBhelper dBhelper = DBhelper();
  //
  Future getSetting() async {
    String? name = await dBhelper.getName();
    if (name != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Homepagescreen()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AddNamescreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    getSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(toolbarHeight: 0.0),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
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
    );
  }
}
