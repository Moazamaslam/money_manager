import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBhelper {
  late Box box;
  late SharedPreferences preferences;
  DBhelper() {
    Openbox();
  }
  Openbox() {
    box = Hive.box("money");
  }

  Future addData(int amount, DateTime date, String note, String type) async {
    var value = {'amount': amount, 'date': date, 'note': note, 'type': type};
    box.add(value);
  }

  Future deletedata(int index) async {
    await box.deleteAt(index);
  }
  addName(String name) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString('name', name);
  }

  getName() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getString('name');
  }
}
