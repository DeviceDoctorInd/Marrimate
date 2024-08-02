// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:marrimate/Screens/Dashboard/main_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/enable_location_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/language_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/login_screen.dart';
import 'package:marrimate/Screens/story_test.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/constants.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/models/match_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:marrimate/services/navigation.dart';
import 'package:marrimate/services/socket_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/filters_model.dart';
import 'Dashboard/Chat/chat_screen.dart';
import 'LoginRegistration/user_activate_screen.dart';
import 'LoginRegistration/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  static SharedPreferences sp;
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
    notificationInit();
    //go();
    /*Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          SwipeUpAnimationRoute(widget: LanguageScreen(), milliseconds: 400));
    });*/
  }

  go(){
    Future.delayed(Duration(seconds: 3)).then((value){
      var size = MediaQuery.of(context).size;
      Navigator.of(context).push(
          SwipeUpAnimationRoute(widget: StoryTest(size: size), milliseconds: 300));
    });
  }

  initialize()async{
    SplashScreen.sp = await SharedPreferences.getInstance();
    //SplashScreen.sp.clear();
    //SplashScreen.sp.setBool('firstTime', false);
    bool firstTime = SplashScreen.sp.getBool('firstTime') ?? true;
    var userToken = SplashScreen.sp.getString('userAuth');
    print('User: ' + userToken.toString());
    Provider.of<Filters>(context, listen: false).initialize();
    var myFilters = Provider.of<Filters>(context, listen: false);
    Future.delayed(Duration(seconds: 1)).then((value) async {
      if (userToken != null) {
        var response = await API.getSingleUser(userToken);
        if(response != null){
          Provider.of<UserModel>(context, listen: false).userSignIn(response['data']);
          var userDetails = Provider.of<UserModel>(context, listen: false);
          if(userDetails.userPlanDetails.planID != 4){
            if(DateTime.parse(userDetails.likeLimit.startDate).add(Duration(days: Constants.getDaysLimit(userDetails.userPlanDetails.planID))).isBefore(DateTime.now())){
              print("### Reset Count");
              var responseReset = await API.resetLikeCount(userToken);
              Provider.of<UserModel>(context, listen: false).resetLikeCount();
            }
          }
          var responseCandidate = await API.getCandidates(userToken);
          if(responseCandidate != null){
            Provider.of<Match>(context, listen: false).loadCandidates(responseCandidate, userDetails, myFilters);
            var responsePartners = await API.getMatchedPartners(userToken);
            if(responsePartners != null){
              Provider.of<Partner>(context, listen: false).loadPartners(responsePartners);
            }else{
              Provider.of<Partner>(context, listen: false).initialize();
            }
            if(userDetails.isActive){
              Navigator.push(
                  context,
                  SwipeLeftAnimationRoute(
                    widget: MainScreen(),
                  ));
            }else{
              Navigator.push(
                  context,
                  SwipeLeftAnimationRoute(
                    widget: ActivateScreen(),
                  ));
            }
          }else{
            Navigator.of(context).pushReplacement(
                SwipeUpAnimationRoute(widget: LoginScreen(), milliseconds: 400));
          }
        }else{
          Navigator.of(context).pushReplacement(
              SwipeUpAnimationRoute(widget: LoginScreen(), milliseconds: 400));
        }
      }else{
        if (firstTime) {
          String locale = context.locale.toString();
          Navigator.of(context).pushReplacement(
              SwipeUpAnimationRoute(widget: LanguageScreen(activeLocale: locale), milliseconds: 400));
        } else {
          Navigator.of(context).pushReplacement(
              SwipeUpAnimationRoute(widget: LoginScreen(), milliseconds: 400));
        }
      }
    });
  }

  Future<void> notificationInit() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('Notification permission denied');
    }
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    final RemoteMessage initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      print("initialMessage");
      //selectNotification(initialMessage.data.toString());
    }
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.max,
        showWhen: true);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    /*FirebaseMessaging.onBackgroundMessage((message){
      print("####################");
    });*/

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Notification Listening!!!!");
      final RemoteNotification notification = message.notification;
      final AndroidNotification android = message.notification?.android;


      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        if (Platform.isAndroid) {
          var hasUser = SplashScreen.sp.getString('userAuth');
          bool showNotification = SplashScreen.sp.getBool("showNotification")??true;
          if(showNotification && hasUser != null){
            print("onMessage");
            await flutterLocalNotificationsPlugin.show(0, notification.title,
                notification.body, platformChannelSpecifics,
                payload: message.data.toString());
          }
        }
      }

      /*FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
        final RemoteNotification notification = message.notification;
        final AndroidNotification android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          if (Platform.isAndroid) {
            bool showNotification = SplashScreen.sp.getBool("showNotification")??true;
            if(showNotification){
              print("onBackgroundMessage");
              await flutterLocalNotificationsPlugin.show(0, notification.title,
                  notification.body, platformChannelSpecifics,
                  payload: message.data.toString());
            }
          }
        }
      });*/
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp");
      selectNotification(message.data.toString());
    });

  }

  void selectNotification(String payload) async {
    if (payload != null && payload.isNotEmpty) {
      print("selectNotification");
      String temp = payload.substring(1, payload.length-1);
      print(temp);
      var dataSp = temp.split(',');
      Map<String,String> mapData = Map();
      dataSp.forEach((element) => mapData.addAll({element.split(':')[0].trim(): element.split(':')[1].trim()})); //mapData[element.split(':')[0]] = element.split(':')[1]);
      print(mapData['purpose']);
      print(mapData['partnerID'].toString());
      if(mapData['purpose'] == 'match'){
        _navigationService.navigateTo(
            MaterialPageRoute(builder: (_)=>MainScreen(index: 1)));
      }else if(mapData['purpose'] == 'chat'){
        _navigationService.navigateTo(
            MaterialPageRoute(builder: (_)=>MainScreen(index: 3)));
      }
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print("onDidReceiveLocalNotification");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/splash_background.png",
                fit: BoxFit.fill,
                // width: size.width,
              ),
            ),
            Column(
              children: [
                SizedBox(height: size.height * 0.29),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/splash_logo.png",
                      height: size.height * 0.33,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: VariableText(
                        text: "Powered By \nDeviceDoctor.IN",
                        fontFamily: fontBold,
                        fontcolor: textColorW,
                        fontsize: size.height * 0.015,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
