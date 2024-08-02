import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Coin/purchase_coin_screen.dart';
import 'package:marrimate/Screens/splash_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/daily_coins_model.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:marrimate/services/notifications.dart';
import 'package:provider/provider.dart';

import 'coin_history_screen.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({Key key}) : super(key: key);

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  TextEditingController coinsController = TextEditingController();
  bool claimButton = true;

  bool isLoadingMain = false;
  bool isLoading = false;
  bool isSendingCoin = false;
  DailyCoins dailyCoinsDetails;
  int activeIndex = 0;
  UserModel selectedPartner;

  setLoadingMain(bool loading){
    setState(() {
      isLoadingMain = loading;
    });
  }
  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //SplashScreen.sp.remove("hasAvailed");
    //SplashScreen.sp.remove("firstDay");
    //SplashScreen.sp.remove("coinsAvailed");
    checkDailyCoins();
  }

  resetDailyCheck(){
    SplashScreen.sp.setBool("hasAvailed", false);
    SplashScreen.sp.setString("firstDay", DateTime.now().toIso8601String());
    SplashScreen.sp.setStringList("coinsAvailed", ["0", "0", "0", "0", "0", "0", "0"]);
    dailyCoinsDetails = DailyCoins(
        days: ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5", "Day 6", "Day 7"],
        coins: ["+50", "+100", "+150", "+200", "+250", "+300", "+350"],
        availed: [false, false, false, false, false, false, false],
        firstDay: DateTime.now()
    );
    setState(() {

    });
  }

  checkDailyCoins(){
    setLoadingMain(true);
    bool hasAvailed = SplashScreen.sp.getBool('hasAvailed');
    var firstDay = SplashScreen.sp.getString('firstDay');
    //DateTime firstDay = DateTime.parse(SplashScreen.sp.getString('firstDay'));
    if(hasAvailed != null){
      if(hasAvailed){
        var coinsDetails = SplashScreen.sp.getStringList("coinsAvailed");
        //print(coinsDetails.toString());
        //print(firstDay);
        dailyCoinsDetails = DailyCoins.fromPreference(coinsDetails, DateTime.parse(firstDay));
        claimButton = true;
        int checkCompleted = 0;
        for(int i=0; i < dailyCoinsDetails.availed.length; i++){
          if(dailyCoinsDetails.availed[i] == false){ //DateTime.parse("2022-07-20T18:08:08.822824")
            if(dailyCoinsDetails.firstDay.isBefore(DateTime.now().subtract(Duration(days: i)))){
              if(dailyCoinsDetails.firstDay.add(Duration(days: i+1)).isBefore(DateTime.now())){
                //print("Reset");
                resetDailyCheck();
              }else{
                //print("is before: " + i.toString());
                claimButton = true;
                activeIndex = i;
              }
            }else{
              claimButton = false;
              //print("is after: " + i.toString());
            }
            break;
          }
          checkCompleted++;
          if(checkCompleted == dailyCoinsDetails.availed.length){
            resetDailyCheck();
          }
        }
        setState(() {

        });
      }else{
        print("Availed false");
        dailyCoinsDetails = DailyCoins(
            days: ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5", "Day 6", "Day 7"],
            coins: ["+50", "+100", "+150", "+200", "+250", "+300", "+350"],
            availed: [false, false, false, false, false, false, false],
            firstDay: DateTime.now()
        );
      }
    }else{
      print("not Availed!!");
      dailyCoinsDetails = DailyCoins(
        days: ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5", "Day 6", "Day 7"],
        coins: ["+50", "+100", "+150", "+200", "+250", "+300", "+350"],
        availed: [false, false, false, false, false, false, false],
        firstDay: DateTime.now()
      );
    }
    setLoadingMain(false);
  }

  renderSendCoins({context, Partner partners, UserModel userDetails, Size size, double padding}){
    showGeneralDialog(
      barrierLabel: "coins",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
            builder: (context, setState) {
              return Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.85,
                  height: size.height * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.height * 0.01),
                      topRight: Radius.circular(size.height * 0.01),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.13,
                            width: double.infinity,
                            padding: EdgeInsets.only(bottom: size.height * 0.01),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor1, primaryColor2],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(size.height * 0.01),
                                topRight: Radius.circular(size.height * 0.01),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                VariableText(
                                  text: "Send Coins",
                                  fontFamily: fontBold,
                                  fontsize: size.height * 0.021,
                                  fontcolor: textColorW,
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  height: size.height * 0.06,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset("assets/icons/ic_treasure.png"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.018),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: size.height * 0.06,
                                    child: StatefulBuilder(
                                      builder: (context, builder) {
                                        return Material(
                                          child: DropdownButtonFormField<UserModel>(
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                top: 0,
                                                bottom: 0,
                                                left: 12,
                                                right: 12,
                                              ),
                                              labelText: partners.partners.isNotEmpty ? "Select partner" : "No partner found",
                                              labelStyle: TextStyle(
                                                fontSize: size.height * 0.020,
                                                color: textColorB,
                                              ),

                                              enabledBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: primaryColor1, width: 1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: primaryColor1, width: 1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              // filled: true,
                                              // fillColor: Colors.blueAccent,
                                            ),
                                            value: selectedPartner,
                                            icon: const Icon(Icons.arrow_drop_down_outlined),
                                            elevation: 0,
                                            isDense: true,
                                            style: TextStyle(
                                                color: textColorG,
                                                fontFamily: fontRegular,
                                                fontSize: size.height * 0.020),
                                            onChanged: (UserModel newValue) {
                                              setState(() {
                                                selectedPartner = newValue;
                                              });
                                            },
                                            items: partners.partners.map<DropdownMenuItem<UserModel>>((UserModel value) {
                                              return DropdownMenuItem<UserModel>(
                                                value: value,
                                                child: VariableText(
                                                  text: value.name,
                                                  fontFamily: fontRegular,
                                                  fontcolor: textColorB,
                                                  fontsize: size.height * 0.020,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: size.height * 0.055,
                                    child: StatefulBuilder(
                                      builder: (context, builder) {
                                        return Material(
                                          child: TextFormField(
                                            controller: coinsController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: "Coins",
                                              hintText: "500",
                                              labelStyle: TextStyle(
                                                fontSize: size.height * 0.020,
                                                color: textColorB,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: primaryColor1, width: 1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: primaryColor1, width: 1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              focusColor: primaryColor1,
                                              border: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: primaryColor1, width: 1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            style: TextStyle(
                                                color: textColorB,
                                                fontFamily: fontRegular,
                                                fontSize: size.height * 0.020),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Material(
                            child: InkWell(
                              onTap: ()async{
                                double sendCoins = double.parse(coinsController.text);
                                if(selectedPartner != null){
                                  if(sendCoins <= double.parse(userDetails.coins.totalCoins)){
                                    FocusScope.of(context).unfocus();
                                    setState((){
                                      isSendingCoin = true;
                                    });
                                    var response = await API.sendCoins(sendCoins.toStringAsFixed(0), selectedPartner, userDetails);
                                    if(response != null){
                                      if(response['status']){
                                        Provider.of<UserModel>(context, listen: false).updateCoins(response['data']['total_coins'].toString());
                                        NotificationServices.postNotification(
                                            title: 'Coins Received',
                                            body: 'You received ${sendCoins.toStringAsFixed(0)} coins from ${userDetails.name}',
                                            partnerID: selectedPartner.id.toString(),
                                            purpose: 'coins',
                                            receiverToken: selectedPartner.fcmToken
                                        );
                                        setState((){
                                          isSendingCoin = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: "Coins sent successfully",
                                            toastLength: Toast.LENGTH_SHORT);
                                        Navigator.of(context).pop();
                                      }else{
                                        setState((){
                                          isSendingCoin = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: response['msg'],
                                            toastLength: Toast.LENGTH_SHORT);
                                      }
                                    }else{
                                      setState((){
                                        isSendingCoin = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Try again later",
                                          toastLength: Toast.LENGTH_SHORT);
                                    }
                                  }else{
                                    Fluttertoast.showToast(
                                        msg: "Not enough coins",
                                        toastLength: Toast.LENGTH_SHORT);

                                  }
                                }else{
                                  Fluttertoast.showToast(
                                      msg: "Select friend",
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              },
                              child: Container(
                                height: size.height * 0.045,
                                width: size.width * 0.40,
                                //margin: EdgeInsets.all(size.height * 0.02),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor1, primaryColor2],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: VariableText(
                                    text: "Send",
                                    fontsize: size.height * 0.020,
                                    fontcolor: textColorW,
                                    weight: FontWeight.w700,
                                    fontFamily: fontSemiBold,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // onTap: () {
                                //   Navigator.of(context).pop();
                                // }
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                        ],
                      ),
                      if(isSendingCoin) ProcessLoadingLight()
                    ],
                  ),
                ),
              );
            }
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          //position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    ).then((value){
      setState((){
        coinsController.clear();
        selectedPartner = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var partners = Provider.of<Partner>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    onClickShare() {
      var dropdownValue2 = "Jane Copper";
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.NO_HEADER,
        onDissmissCallback: (value){
          coinsController.clear();
        },
        isDense: true,
        padding: EdgeInsets.all(0),
        body: Container(
          width: size.width,
          height: size.height * 0.40,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.15,
                width: double.infinity,
                padding: EdgeInsets.only(bottom: size.height * 0.01),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor1, primaryColor2],
                  ),
                  // color: primaryColor1.withOpacity(0.1),
                  // border: Border.all(color: primaryColor2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.height * 0.01),
                    topRight: Radius.circular(size.height * 0.01),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    VariableText(
                      text: "Send Coins",
                      fontFamily: fontBold,
                      fontsize: size.height * 0.022,
                      fontcolor: textColorW,
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      height: size.height * 0.06,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("assets/icons/ic_treasure.png"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width * .8,
                      height: 70,
                      padding: EdgeInsets.only(
                        top: padding / 2,
                        left: padding,
                        right: padding,
                      ),
                      child: StatefulBuilder(
                        builder: (context, builder) {
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Friend",
                              labelStyle: TextStyle(
                                fontSize: size.height * 0.025,
                                color: textColorB,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor1, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor1, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // filled: true,
                              // fillColor: Colors.blueAccent,
                            ),
                            value: dropdownValue2,
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            elevation: 16,
                            style: TextStyle(
                                color: textColorG,
                                fontFamily: fontRegular,
                                fontSize: size.height * 0.02),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue2 = newValue;
                              });
                            },
                            items: <String>[
                              'Jane Copper',
                              'Two',
                              'Free',
                              'Four'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width * .8,
                      height: 100,
                      padding: EdgeInsets.symmetric(
                        vertical: padding / 5,
                        horizontal: padding,
                      ),
                      child: StatefulBuilder(
                        builder: (context, builder) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: "Coins",
                              hintText: "1000",
                              labelStyle: TextStyle(
                                fontSize: size.height * 0.025,
                                color: textColorB,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor1, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor1, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusColor: primaryColor1,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor1, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // filled: true,
                              // fillColor: Colors.blueAccent,
                            ),
                            style: TextStyle(
                                color: textColorG,
                                fontFamily: fontRegular,
                                fontSize: size.height * 0.02),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue2 = newValue;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: size.width * 0.40,
                margin: EdgeInsets.all(size.height * 0.02),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor1, primaryColor2],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: VariableText(
                    text: "Send",
                    fontsize: size.height * 0.020,
                    fontcolor: textColorW,
                    weight: FontWeight.w700,
                    fontFamily: fontSemiBold,
                    textAlign: TextAlign.center,
                  ),
                ),
                // onTap: () {
                //   Navigator.of(context).pop();
                // }
              ),
            ],
          ),
        ),
      ).show();
    }

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: textColorW,
            appBar: CustomAppBar(
              text: tr("Coins"),
              isBack: true,
              actionImage: "assets/icons/ic_more_option.png",
              actionOnTap: PopupMenuButton(
                icon: Icon(Icons.more_vert_sharp),
                color: textColorW,
                padding: EdgeInsets.all(0),
                elevation: 5,
                offset: Offset(-30, size.height * 0.085),
                /*shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2)),
                */
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            SwipeLeftAnimationRoute(widget: CoinHistoryScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 23,
                            child: Image.asset(
                              "assets/icons/ic_history.png",
                              scale: 2,
                              // fit: BoxFit.cover,
                              // width: size.width,
                            ),
                          ),
                          SizedBox(width: 8),
                          VariableText(
                            text: tr("Coin History"),
                            fontFamily: fontMedium,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.019,
                          ),
                        ],
                      ),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            SwipeLeftAnimationRoute(widget: PurchaseCoinScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 23,
                            child: Image.asset(
                              "assets/icons/ic_purchase_coin.png",
                              scale: 2,
                              // fit: BoxFit.cover,
                              // width: size.width,
                            ),
                          ),
                          SizedBox(width: 8),
                          VariableText(
                            text: tr("Purchase Coin"),
                            fontFamily: fontMedium,
                            fontcolor: textColorB,
                            fontsize: size.height * 0.019,
                          ),
                        ],
                      ),
                    ),
                    value: 2,
                  ),
                ],
              ),
              height: size.height * 0.085,
            ),
            body: isLoadingMain ? ProcessLoadingLight() :
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/coin_background.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: padding * 3),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/coins_chest.png",
                            scale: 2,
                            //width: size.width * 0.80,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: size.width * 0.28),
                            child: VariableText(
                              text: tr("Your Coins"),
                              fontFamily: fontMedium,
                              fontcolor: Color(0xFFFFCC00),
                              fontsize: size.height * 0.018,
                              max_lines: 1,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: size.height * 0.05, left: size.width * 0.29),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                VariableText(
                                  text: userDetails.coins.totalCoins,
                                  fontFamily: fontMedium,
                                  fontcolor: Colors.white,
                                  fontsize: size.height * 0.025,
                                  max_lines: 1,
                                ),
                                Image.asset("assets/icons/ic_coin.png", scale: 2)
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    // height: size.height * 0.3,
                    decoration: BoxDecoration(
                      color: borderLightColor.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: padding / 2),
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      children: [
                        VariableText(
                          text: tr("Daily Check-In"),
                          fontFamily: fontSemiBold,
                          fontcolor: primaryColor2,
                          fontsize: size.height * 0.028,
                          overflow: TextOverflow.ellipsis,
                          max_lines: 2,
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 100,
                          child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            itemCount: dailyCoinsDetails.days.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.01),
                                    child: Row(
                                      children: [
                                        VariableText(
                                          text: dailyCoinsDetails.days[index].toString(),
                                          fontsize: 10,
                                          textAlign: TextAlign.center,
                                          fontFamily: fontMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Container(
                                    height: 30,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.038),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        dailyCoinsDetails.availed[index]
                                            ? Container(
                                                height: 15,
                                                width: 15,
                                                // margin: EdgeInsets.only(right: 7),
                                                decoration: BoxDecoration(
                                                  color: coinBorderGreen.withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 10,
                                                  color: textColorW,
                                                ),
                                              )
                                            : Container(
                                                width: 15,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: coinBorderBlue.withOpacity(0.4),
                                                      width: 1.5),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                child: Container(
                                                  margin: EdgeInsets.all(1.5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    color: coinBorderBlue
                                                        .withOpacity(0.8),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 47,
                                    //color: Colors.redAccent,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Image.asset(
                                            "assets/images/coin_shape.png",
                                            scale: 2.7,
                                            color: dailyCoinsDetails.availed[index]
                                                ? coinBorderGreen.withOpacity(0.8)
                                                : coinBorderBlue
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: 43,
                                            //margin: EdgeInsets.only(right: 0),
                                            decoration: BoxDecoration(
                                                color: dailyCoinsDetails.availed[index]
                                                    ? coinBorderGreen.withOpacity(0.8)
                                                    : coinBorderBlue
                                                        .withOpacity(0.6),
                                                shape: BoxShape.circle),
                                            child: Container(
                                              margin: EdgeInsets.all(4),
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  color: textColorW,
                                                  shape: BoxShape.circle),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/coin_2.png",
                                                    scale: 1.3,
                                                  ),
                                                  VariableText(
                                                    text: dailyCoinsDetails.coins[index].toString(),
                                                    fontsize: 8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        MyButton(
                          onTap: ()async{
                            if(claimButton){
                              setLoading(true);
                              var response = await API.claimCoins(dailyCoinsDetails.coins[activeIndex], userDetails);
                              if(response != null){
                                if(response['status']){
                                  Provider.of<UserModel>(context, listen: false).updateCoins(response['data']['total_coins']);
                                  SplashScreen.sp.setBool("hasAvailed", true);
                                  SplashScreen.sp.setString("firstDay", dailyCoinsDetails.firstDay.toIso8601String());
                                  dailyCoinsDetails.availed[activeIndex] = true;
                                  List<String> tempList = [];
                                  for(int i=0; i < dailyCoinsDetails.availed.length; i++){
                                    if(dailyCoinsDetails.availed[i]){
                                      tempList.add("1");
                                    }else{
                                      tempList.add("0");
                                    }
                                  }
                                  SplashScreen.sp.setStringList("coinsAvailed", tempList);
                                  claimButton = false;
                                  print(dailyCoinsDetails.days[activeIndex]);
                                  setLoading(false);
                                  Fluttertoast.showToast(
                                      msg: "Coins Claimed Successfully",
                                      toastLength: Toast.LENGTH_SHORT);
                                }else{
                                  setLoading(false);
                                  Fluttertoast.showToast(
                                      msg: response['msg'],
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              }else{
                                setLoading(false);
                                Fluttertoast.showToast(
                                    msg: "Try again later",
                                    toastLength: Toast.LENGTH_SHORT);
                              }
                            }
                          },
                          btnTxt: tr("Claim"),
                          borderColor: Colors.transparent,
                          btnColor: claimButton ? primaryColor2 : borderColor,
                          txtColor: textColorW,
                          btnRadius: 5,
                          btnWidth: size.width * 0.3,
                          btnHeight: 35,
                          fontSize: size.height * 0.017,
                          weight: FontWeight.w700,
                          fontFamily: fontSemiBold,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(padding),
                    padding: EdgeInsets.all(padding),
                    // height: size.height * 0.3,
                    decoration: BoxDecoration(
                      color: borderLightColor.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VariableText(
                          text: tr("Earn More Coins"),
                          fontFamily: fontSemiBold,
                          fontcolor: primaryColor2,
                          fontsize: size.height * 0.028,
                          overflow: TextOverflow.ellipsis,
                          max_lines: 2,
                        ),
                        SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/icons/ic_person.png", scale: 2),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: padding / 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VariableText(
                                      text: "Refer any 1 friend",
                                      fontFamily: fontMedium,
                                      fontcolor: textColorB,
                                      fontsize: size.height * 0.024,
                                      overflow: TextOverflow.ellipsis,
                                      max_lines: 1,
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Image.asset("assets/images/coin.png",
                                            scale: 1.6),
                                        SizedBox(width: 7),
                                        VariableText(
                                          text: "+30",
                                          fontFamily: fontSemiBold,
                                          fontcolor: primaryColor2,
                                          fontsize: size.height * 0.024,
                                          overflow: TextOverflow.ellipsis,
                                          max_lines: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            MyButton(
                              onTap: () {
                                // onClickSubscription();
                              },
                              btnTxt: tr("Share"),
                              borderColor: primaryColor2,
                              btnColor: primaryColor2,
                              txtColor: textColorW,
                              btnRadius: 5,
                              btnWidth: size.width * 0.2,
                              btnHeight: 32,
                              fontSize: size.height * 0.018,
                              fontFamily: fontSemiBold,
                            ),
                          ],
                        ),
                        Divider(
                          color: textColorB,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/icons/ic_person.png", scale: 2),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: padding / 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VariableText(
                                      text: "Refer any 1 friend",
                                      fontFamily: fontMedium,
                                      fontcolor: textColorB,
                                      fontsize: size.height * 0.024,
                                      overflow: TextOverflow.ellipsis,
                                      max_lines: 1,
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Image.asset("assets/images/coin.png",
                                            scale: 1.6),
                                        SizedBox(width: 7),
                                        VariableText(
                                          text: "+30",
                                          fontFamily: fontSemiBold,
                                          fontcolor: primaryColor2,
                                          fontsize: size.height * 0.024,
                                          overflow: TextOverflow.ellipsis,
                                          max_lines: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            MyButton(
                              onTap: () {
                                // onClickSubscription();
                              },
                              btnTxt: tr("Share"),
                              borderColor: primaryColor2,
                              btnColor: primaryColor2,
                              txtColor: textColorW,
                              btnRadius: 5,
                              btnWidth: size.width * 0.2,
                              btnHeight: 32,
                              fontSize: size.height * 0.018,
                              fontFamily: fontSemiBold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: MyButton(
                      onTap: () {
                        renderSendCoins(
                            context: context,
                            partners: partners,
                            userDetails: userDetails,
                            size: size,
                            padding: padding);
                        //onClickShare();
                      },
                      btnTxt: tr("Send Coins"),
                      borderColor: primaryColor2,
                      btnColor: primaryColor2,
                      txtColor: textColorW,
                      btnRadius: 5,
                      btnWidth: size.width * 0.7,
                      btnHeight: 40,
                      fontSize: size.height * 0.020,
                      weight: FontWeight.w700,
                      fontFamily: fontSemiBold,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          if(isLoading) ProcessLoadingLight()
        ],
      ),
    );
  }
}
