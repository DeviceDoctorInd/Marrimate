// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Dashboard/main_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class EnableLocationScreen extends StatefulWidget {
  const EnableLocationScreen({Key key}) : super(key: key);

  @override
  State<EnableLocationScreen> createState() => _EnableLocationScreenState();
}

class _EnableLocationScreenState extends State<EnableLocationScreen> {

  Location location = Location();

  getLocation() async {
    try{
      PermissionStatus locationPermission = await location.hasPermission();
      print("locationPermission: " + locationPermission.toString());
      if(locationPermission.toString() == 'PermissionStatus.granted'){
        bool locationService = await location.serviceEnabled();
        if(locationService){
          Navigator.of(context).pop(true);
          /*Navigator.push(
              context,
              SwipeLeftAnimationRoute(
                widget: MainScreen(),
              ));*/
        }else{
          locationService = await location.requestService();
          if(locationService){
            Navigator.of(context).pop(true);
            /*Navigator.push(
                context,
                SwipeLeftAnimationRoute(
                  widget: MainScreen(),
                ));*/
          }else{
            throw Exception();
          }
        }
      }else if(locationPermission.toString() == "PermissionStatus.denied"){
        locationPermission = await location.requestPermission();
        print("locationPermission: " + locationPermission.toString());
        if(locationPermission.toString() == 'PermissionStatus.deniedForever'){
          throw Exception("fromApp");
        }else{
          getLocation();
        }
      }
      else{
        locationPermission = await location.requestPermission();
        print("locationPermission: " + locationPermission.toString());
        if(locationPermission.toString() == 'PermissionStatus.granted'){
          getLocation();
        }else{
          throw Exception("fromApp");
        }
      }
    }catch(e){
      if(e.toString().contains("fromApp")){
       /* Fluttertoast.showToast(
            msg: "Please allow location access from app settings",
            toastLength: Toast.LENGTH_LONG);*/
        locationPopup();
      }else{
        print(e.toString());
        Fluttertoast.showToast(
            msg: "Location access denied",
            toastLength: Toast.LENGTH_SHORT);
      }
    }
  }

  locationPopup() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Location Permission'),
          content: Text('Please allow location permission from app settings'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () async{
                try{
                  await ph.openAppSettings();
                  Navigator.of(context).pop();
                }catch(e){
                  print(e.toString());
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.10;

    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop(false);
        return;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: textColorW,
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Image.asset(
                  "assets/images/social_login_header.png",
                  width: size.height * 0.30,
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.12),
                    Image.asset(
                      "assets/images/merrimate_logo.png",
                      width: size.height * 0.27,
                    ),
                    SizedBox(height: size.height * 0.1),
                    VariableText(
                      text: tr("Enable Location"),
                      fontFamily: fontMatchMaker,
                      fontcolor: primaryColor2,
                      fontsize: size.height * 0.042,
                      textAlign: TextAlign.center,
                      max_lines: 2,
                      line_spacing: size.height * 0.0017,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: VariableText(
                        text: tr("Please enable your location in order to use Merrimate"),
                        fontFamily: fontMedium,
                        fontcolor: textColorG,
                        fontsize: size.height * 0.020,
                        textAlign: TextAlign.center,
                        max_lines: 2,
                        // line_spacing: size.height * 0.0017,
                      ),
                    ),
                    SizedBox(height: size.height * 0.07),
                    Image.asset(
                      "assets/images/location.png",
                      width: size.height * 0.1,
                    ),
                    SizedBox(height: size.height * 0.07),
                    MyButton(
                      onTap: () {
                        getLocation();
                        /*Navigator.push(
                            context,
                            SwipeLeftAnimationRoute(
                              widget: MainScreen(),
                            ));*/
                      },
                      btnTxt: tr("Allow Location"),
                      borderColor: primaryColor1,
                      btnColor: primaryColor1,
                      txtColor: textColorW,
                      btnRadius: 25,
                      btnWidth: size.width * 0.55,
                      btnHeight: 50,
                      fontSize: size.height * 0.020,
                      weight: FontWeight.w700,
                      fontFamily: fontSemiBold,
                    ),
                    SizedBox(height: size.height * 0.05),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
