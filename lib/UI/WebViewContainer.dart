import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final siteCookie;

  WebViewContainer(this.url, this.siteCookie);

  @override
  createState() => _WebViewContainerState(this.url, this.siteCookie);
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  var siteCookie;
  final _key = UniqueKey();
  final CookieManager cookieManager = CookieManager.instance();
  _WebViewContainerState(this._url, this.siteCookie);
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    cookieManager.setCookie(
        url: _url,
        name: ".AspNetCore.Identity.Application",
        value: siteCookie['.AspNetCore.Identity.Application']);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        /* Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));*/
      }
    });
    if (!kIsWeb) {
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

      var android = new AndroidInitializationSettings('@mipmap/launcher_icon');
      var iOS = new IOSInitializationSettings();
      var settings = new InitializationSettings(android: android, iOS: iOS);
      flutterLocalNotificationsPlugin.initialize(settings);
    }
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title, notification.body, platformChannelSpecifics);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      /*Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));*/
    });
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
}
