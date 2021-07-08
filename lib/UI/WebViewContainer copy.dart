/*import 'dart:io' as io;
import 'package:alameenworkflow/Models/shared_pref.dart';
import 'package:alameenworkflow/Models/user.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as CoM;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final siteCookie;

  WebViewContainer(this.url, this.siteCookie);

  @override
  createState() => _WebViewContainerState(this.url, this.siteCookie);
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    // initialise the plugin of flutterlocalnotifications.
    var isnotify = await getNotification();
    if (isnotify) {
      FlutterLocalNotificationsPlugin flip =
          new FlutterLocalNotificationsPlugin();
      var android = new AndroidInitializationSettings('@mipmap/launcher_icon');
      var iOS = new IOSInitializationSettings();
      var settings = new InitializationSettings(android: android, iOS: iOS);
      flip.initialize(settings);
      _showNotificationWithDefaultSound(flip);
    }
    return Future.value(true);
  });
}

Future<bool> getNotification() async {
  try {
    Dio dio = new Dio();

    SharedPref sharedPref = SharedPref();

    User user = User.fromJson(await sharedPref.read("user"));

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (io.X509Certificate cert, String host, int port) => true;
      return client;
    };

    List<io.Cookie> coo = [
      new io.Cookie(".AspNetCore.Identity.Application",
          user.setcookie['.AspNetCore.Identity.Application'])
    ];
    var cj = new CookieJar();
    //Save cookies
    cj.saveFromResponse(Uri.parse(user.url), coo);
    dio.interceptors.add(CoM.CookieManager(cj));
    Response response =
        await dio.get(user.url + "/Notification/GetNotificationForMobile");
    var v = response.data;
    return v == true ? true : false;
  } catch (Exception) {
    return false;
  }
}

Future _showNotificationWithDefaultSound(flip) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flip.show(0, 'alameen workflow', 'You have new notification ',
      platformChannelSpecifics,
      payload: 'Default_Sound');
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  var siteCookie;
  final _key = UniqueKey();
  final CookieManager cookieManager = CookieManager.instance();
  _WebViewContainerState(this._url, this.siteCookie);
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    Workmanager.initialize(callbackDispatcher, isInDebugMode: false);
    // Periodic task registration
    Workmanager.registerPeriodicTask(
      "2",
      "simplePeriodicTask",
      frequency: Duration(minutes: 15),
    );

    cookieManager.setCookie(
        url: _url,
        name: ".AspNetCore.Identity.Application",
        value: siteCookie['.AspNetCore.Identity.Application']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Expanded(
            child: InAppWebView(
          key: _key,
          onReceivedServerTrustAuthRequest: (InAppWebViewController controller,
              ServerTrustChallenge challenge) async {
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
          initialUrl: _url,
        ))
      ],
    )));
  }
}*/
