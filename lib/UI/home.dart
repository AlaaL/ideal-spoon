import 'package:alameenworkflow/Models/shared_pref.dart';
import 'package:alameenworkflow/Models/user.dart';
import 'package:alameenworkflow/UI/WebViewContainer.dart';
import 'package:alameenworkflow/UI/login_page.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPref sharedPref = SharedPref();

  User model = new User();

  loadSharedPrefs() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));

      setState(() {
        model = user;
      });
    } catch (Excepetion) {}
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadSharedPrefs();

    if (model.email == null)
      return MaterialApp(
        home: LoginPage(),
      );
    else
      return MaterialApp(home: WebViewContainer(model.url, model.setcookie));
  }
}
