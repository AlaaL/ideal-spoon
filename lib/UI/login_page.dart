import 'dart:io';
import 'package:alameenworkflow/Models/shared_pref.dart';
import 'package:dio/adapter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:alameenworkflow/Models/user.dart';
import 'WebViewContainer.dart';
import 'form_button.dart';
import 'form_text.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPref sharedPref = SharedPref();
  User model = new User();
  // Dio _dio;
  String aToken = '';
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          title: Text("alameen workflow"),
        ),
        body: new SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: new Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        child: Image.asset('asset/images/HR.png')),
                  ),
                ),
                MyFormTextField(
                  isObscure: false,
                  // EmailAddress decoration
                  decoration: InputDecoration(
                      labelText: "EmailAddress",
                      hintText: "me@abc.com",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.email)),

                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an email address';
                    } else if (!_emailRegExp.hasMatch(value)) {
                      return 'Invalid email address!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    model.email = value;
                  },
                ),
                Padding(
                  child: MyFormTextField(
                    // masks the input text
                    // typical password box style
                    isObscure: true,

                    // Password box decoration
                    decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "my password",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.lock_outline)),

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },

                    onSaved: (value) {
                      model.password = value;
                    },
                  ),
                  padding: EdgeInsets.only(top: 15),
                ),
                Padding(
                  child: MyFormTextField(
                    // masks the input text
                    // typical password box style
                    isObscure: false,

                    // Password box decoration
                    decoration: InputDecoration(
                        labelText: "Url",
                        hintText: "Url",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.link)),

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a url';
                      } else if (!Uri.parse(value).isAbsolute) {
                        return "Invalid url";
                      }
                      return null;
                    },

                    onSaved: (value) {
                      model.url = value;
                    },
                  ),
                  padding: EdgeInsets.only(top: 15),
                ),
                FormSubmitButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      Scaffold.of(_formKey.currentContext).showSnackBar(
                          SnackBar(
                              content: Text('Processing Data'),
                              duration: const Duration(milliseconds: 500)));

                      bool isOk = await signIn(model);

                      Scaffold.of(_formKey.currentContext).showSnackBar(
                          SnackBar(
                              content: new Text(
                                  isOk ? "Saved!" : "Invalid user data"),
                              duration: const Duration(milliseconds: 10000)));
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  Future<bool> signIn(User userdata) async {
    Dio dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    String token = "";

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      print('FlutterFire Messaging Example: Getting APNs token...');
      token = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      await FirebaseMessaging.instance.getToken().then((value) async {
        token = value;

        return;
      });
    }
    var d = {
      'Email': userdata.email,
      'Password': userdata.password,
      'RememberMe': true,
      'MobileToken': token
    };

    Response response = await dio.post(
      userdata.url + "/Account/LoginForMobile",
      data: FormData.fromMap(d),
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );

    if (response.data == false) {
      return false;
    }

    Map<String, String> _cookies = Map();
    response.headers.forEach((String name, List<String> values) {
      if (name == 'set-cookie') {
        // Get cookies for next request
        values.forEach((String rawCookie) {
          try {
            Cookie cookie = Cookie.fromSetCookieValue(rawCookie);
            _cookies[cookie.name] = cookie.value;
            print(cookie.name);
          } catch (e) {
            final List<String> cookie = rawCookie.split(';')[0].split('=');
            _cookies[cookie[0]] = cookie[1];
          }
        });
      }
    });

    userdata.setcookie = _cookies;
    userdata.token = token;

    sharedPref.save("user", userdata);
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WebViewContainer(userdata.url, userdata.setcookie)));
    return true;
  }
}
