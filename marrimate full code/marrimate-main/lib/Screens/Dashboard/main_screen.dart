import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Dashboard/Chat/chat_screen.dart';
import 'package:marrimate/Screens/Dashboard/Home/home_screen.dart';
import 'package:marrimate/Screens/Dashboard/Profile/profile_screen.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:provider/provider.dart';
import '../../models/call_model.dart';
import '../../models/user_model.dart';
import '../../services/api.dart';
import '../call_alert.dart';
import '../splash_screen.dart';
import 'Dashboard/dashboard_screen.dart';
import 'radar/radar_screen.dart';

class MainScreen extends StatefulWidget {
  int index;
  MainScreen({Key key, this.index=0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController tabController;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Timer _timer;
  final interval = const Duration(seconds: 5);

  CallModel activeCall;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    tabController = TabController(length: 5, initialIndex: widget.index, vsync: this);
    tabController.addListener(handleTabSelection);
    startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  startTimer([int milliseconds]) {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      if(activeCall == null){
        callCheck();
      }else{
        checkCallStatus();
      }
    });
  }

  checkCallStatus()async{
    if(mounted){
      var userDetails = Provider.of<UserModel>(context, listen: false);
      var response = await API.getSingleCallChannel(activeCall.id, userDetails.accessToken);
      if(response != null){
        if(response['status']){
          activeCall = CallModel.fromJson(response['data']);
        }
      }
      if(activeCall.status == "deactive"){
        activeCall = null;
        CallAlert.hideAlert();
        if(CallAlert.isShowing){
          Navigator.of(context).pop();
        }
        CallAlert.isShowing = false;
        flutterLocalNotificationsPlugin.cancel(1122);
        Fluttertoast.showToast(
            msg: "Call Cancelled",
            toastLength: Toast.LENGTH_LONG);
      }

    }
  }

  callCheck()async{
    if(mounted){
      var userDetails = Provider.of<UserModel>(context, listen: false);
      var response = await API.getCallChannels(userDetails.accessToken);
      if(response != null){
        if(response['status']){
          for(var item in response['data']){
            if(item['status'] == "active"){
              activeCall = CallModel.fromJson(item);
              break;
            }
          }
          if(activeCall != null){
            print("Has active call");
            if(CallAlert.appActive){
              if(!CallAlert.isShowing){
                print("Show alert");
                CallAlert.cContext = context;
                CallAlert.showAlert(context, activeCall);
              }
            }else{
              showCallNotification();
            }
          }
        }
      }
    }
  }

  showCallNotification()async{
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

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.max,
        ongoing: true,
        fullScreenIntent: true,
        enableVibration: true,
        colorized: true,
        playSound: false,
        enableLights: true,
        visibility: NotificationVisibility.public,
        showWhen: true);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(1122, "Incoming ${activeCall.type} call",
        "${activeCall.senderName} is calling you", platformChannelSpecifics,
        payload: "");
    FlutterRingtonePlayer.playRingtone();
  }

  void selectNotification(String payload) async {
    callCheck();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print("onDidReceiveLocalNotification");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        CallAlert.appActive = true;
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        CallAlert.appActive = false;
        break;
      case AppLifecycleState.paused:
        CallAlert.appActive = false;
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        CallAlert.appActive = false;
        print("app in detached");
        break;
    }
  }

  handleTabSelection() {
    setState(() {});
  }

  Future<bool> onWillPop() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.red)),
              onPressed: () {
                exit(0);
              },
            )
          ],
        );
      },
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              DashboardScreen(),
              RadarScreen(),
              ChatScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color(0xffE5E5E5), width: 3))),
            child: TabBar(
                controller: tabController,
                indicator: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: primaryColor1, width: 2))),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                labelPadding: EdgeInsets.only(top: 8),
                tabs: [
                  Tab(
                    icon: Image.asset(
                      "assets/icons/ic_home.png",
                      height: size.height * 0.033,
                      color: tabController.index == 0 ? null : primaryColor2,
                    ),
                    // text: "Home",
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/icons/ic_category.png",
                      height: size.height * 0.033,
                      color: tabController.index == 1 ? null : primaryColor2,
                    ),
                    // text: "Category",
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/icons/ic_radar3.png",
                      height: size.height * 0.033,
                      color: tabController.index == 2 ? primaryColor1 : primaryColor2,
                    ),
                    // text: "Category",
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/icons/ic_chat.png",
                      height: size.height * 0.033,
                      color: tabController.index == 3 ? null : primaryColor2,
                    ),
                    // text: "Chat",
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/icons/ic_profile.png",
                      height: size.height * 0.033,
                      color: tabController.index == 4 ? null : primaryColor2,
                    ),
                    // text: "Profile",
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
