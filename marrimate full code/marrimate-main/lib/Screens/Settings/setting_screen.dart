import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marrimate/Screens/Coin/coin_screen.dart';
import 'package:marrimate/Screens/Competition/Quiz/all_quiz_screen.dart';
import 'package:marrimate/Screens/Competition/Quiz/add_quiz_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/login_screen.dart';
import 'package:marrimate/Screens/Settings/EditProfile/edit_profile.dart';
import 'package:marrimate/Screens/Settings/Gift/gift_screen.dart';
import 'package:marrimate/Screens/Settings/language_setting_screen.dart';
import 'package:marrimate/Screens/Settings/privacy_option_screen.dart';
import 'package:marrimate/Screens/Settings/privacy_screen.dart';
import 'package:marrimate/Screens/Settings/push_notification_screen.dart';
import 'package:marrimate/Screens/Settings/subscription_screen.dart';
import 'package:marrimate/Screens/Settings/terms_condition_screen.dart';
import 'package:marrimate/Screens/splash_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/new_quiz_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

import '../../services/ad_helper.dart';
import 'block_screen.dart';
import 'boost_screen.dart';
import 'help_screen.dart';
import 'likes_liked_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool holidayMode = false;
  bool pushNotification = true;
  bool updateVideos = false;
  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  onClickHoliday() {
    showDialog(
      context: context,
      builder: (context) {
        var size = MediaQuery.of(context).size;
        return Container(
          decoration: BoxDecoration(
              color: textColorW,
              borderRadius: BorderRadius.circular(size.height * 0.02)),
          margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.1, vertical: size.height * 0.28),
          height: 200,
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                holidayMode
                    ? "assets/images/holiday.png"
                    : "assets/images/office.png",
                height: size.height * 0.15,
                width: size.width * 0.6,
              ),
              VariableText(
                text: holidayMode ? "Holiday Mode On" : "Office Mode On",
                fontFamily: fontMatchMaker,
                fontsize: size.height * 0.035,
                fontcolor: primaryColor1,
                textAlign: TextAlign.left,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        holidayMode = false;
                      });
                    },
                    btnTxt: "Disable",
                    borderColor: primaryColor1,
                    btnColor: textColorW,
                    txtColor: primaryColor1,
                    btnRadius: 25,
                    btnWidth: size.width * 0.30,
                    btnHeight: 40,
                    fontSize: size.height * 0.020,
                    weight: FontWeight.w700,
                    fontFamily: fontSemiBold,
                  ),
                  MyButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        holidayMode = true;
                      });
                    },
                    btnTxt: "Active",
                    btnColor: primaryColor1,
                    txtColor: textColorW,
                    btnRadius: 25,
                    btnWidth: size.width * 0.30,
                    btnHeight: 40,
                    fontSize: size.height * 0.020,
                    weight: FontWeight.w700,
                    fontFamily: fontSemiBold,
                  ),
                ],
              ),
/*
          setState(() {
            holidayMode = !holidayMode;
          });*/
            ],
          ),
        );
      },
    );
  }

  onClickDeactivate() {
    showDialog(
      context: context,
      builder: (context) {
        var size = MediaQuery.of(context).size;
        return Container(
          decoration: BoxDecoration(
              color: textColorW,
              borderRadius: BorderRadius.circular(size.height * 0.02)),
          margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.1, vertical: size.height * 0.28),
          height: 200,
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/delete_account.png",
                height: size.height * 0.15,
                width: size.width * 0.6,
              ),
              VariableText(
                text: "Deactivate Account",
                fontFamily: fontSemiBold,
                fontsize: size.height * 0.024,
                fontcolor: primaryColor2,
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: VariableText(
                  text: "Are you sure you want to Deactivate your account?",
                  fontFamily: fontSemiBold,
                  fontsize: size.height * 0.018,
                  fontcolor: primaryColor2,
                  textAlign: TextAlign.center,
                  max_lines: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    btnTxt: "Cancel",
                    borderColor: primaryColor1,
                    btnColor: textColorW,
                    txtColor: primaryColor1,
                    btnRadius: 25,
                    btnWidth: size.width * 0.30,
                    btnHeight: 40,
                    fontSize: size.height * 0.018,
                    weight: FontWeight.w700,
                    fontFamily: fontSemiBold,
                  ),
                  MyButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      deactivateAccount();
                    },
                    btnTxt: "Deactivate",
                    btnColor: primaryColor1,
                    txtColor: textColorW,
                    btnRadius: 25,
                    btnWidth: size.width * 0.30,
                    btnHeight: 40,
                    fontSize: size.height * 0.018,
                    weight: FontWeight.w700,
                    fontFamily: fontSemiBold,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  deactivateAccount()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.deactivateAccount(userDetails);
    if(response != null){
      if(response['status']){
        SplashScreen.sp.remove('userAuth');
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Account deactivated successfully",
            toastLength: Toast.LENGTH_LONG);
        Navigator.pushAndRemoveUntil(context,
            SwipeRightAnimationRoute(widget: const LoginScreen(), milliseconds: 300),
                (route) => route.isCurrent);
      }else{
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later: 500",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  toggleHolidayMode(UserModel userDetails)async{
    setLoading(true);
    var response = await API.toggleHolidayMode(userDetails);
    if(response != null){
      if(response['status']){
        setState(() {
          holidayMode = !holidayMode;
          userDetails.onHoliday = holidayMode;
        });
        setLoading(false);
      }else{
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later: 500",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  toggleNotification(bool newState)async{
    bool showNotification = SplashScreen.sp.getBool("showNotification")??true;
    await SplashScreen.sp.setBool("showNotification", !showNotification);
    setState(() {
      pushNotification = !pushNotification;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userDetails = Provider.of<UserModel>(context, listen: false);
    holidayMode = userDetails.onHoliday;
    pushNotification = SplashScreen.sp.getBool("showNotification")??true;
    _createBannerAd();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    _ad.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  BannerAd _ad;
  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 1;
  int maxFailedLoadAttempts = 3;
  bool _isAdLoaded = false;
  AdRequest request = const AdRequest(
    keywords: <String>['flutter', 'ad'],
    contentUrl:
    'https://ionicframework.com/docs/v3/intro/tutorial/project-structure/',
    nonPersonalizedAds: true,
  );

  _createBannerAd() {
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }


  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context, listen: true);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: WillPopScope(
        onWillPop: (){
          Navigator.of(context).pop(updateVideos);
        },
        child: Stack(
          children: [
            Scaffold(
              appBar: CustomSimpleAppBar(
                text: tr("Settings"),
                isBack: true,
                height: size.height * 0.085,
                onBack: (){
                  Navigator.of(context).pop(updateVideos);
                },
              ),
              body: ListView(
                children: [
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 2),
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(size.height * 0.05),
                        child: Image.network(
                          userDetails.profilePicture,
                          width: size.height * 0.05,
                          height: size.height * 0.05,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                                  : null,
                            );
                          },
                          errorBuilder: (BuildContext context, obj, trace) {
                            return const Icon(Icons.error_outline,
                                size: 20, color: Colors.red);
                          },
                        )
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            SwipeLeftAnimationRoute(widget: EditProfileScreen())).then((value){
                              if(value != null)
                                updateVideos = value;
                        });
                      },
                      icon: Image.asset(
                        "assets/icons/ic_edit.png",
                        scale: 1.7,
                      ),
                    ),
                    title: VariableText(
                      text: userDetails.name,
                      fontFamily: fontSemiBold,
                      fontsize: size.height * 0.020,
                      fontcolor: primaryColor2,
                      textAlign: TextAlign.left,
                    ),
                    subtitle: userDetails.email != null ? VariableText(
                      text: userDetails.email,
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.017,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ) : null
                  ),
                  InkWell(
                    onTap: (){
                      Provider.of<NewQuiz>(context, listen: false).initializeQuiz();
                      Navigator.push(context,
                          SwipeLeftAnimationRoute(widget: AddQuizScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.1, vertical: size.height * 0.01),
                      child: Image.asset(
                        "assets/images/setting_logo.png",
                        height: size.height * 0.1,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  /*ListTile(
                    onTap: () {
                      Navigator.push(context,
                          SwipeLeftAnimationRoute(widget: LikesLikedScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Image.asset(
                      "assets/icons/ic_heart_fill.png",
                      color: textColorG,
                      scale: 2.7,
                    ),
                    title: VariableText(
                      text: "Likes & Liked",
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),*/
                  if(_isAdLoaded)
                  Container(
                    child: AdWidget(ad: _ad),
                    width: _ad.size.width.toDouble(),
                    height: _ad.size.height.toDouble(),
                    alignment: Alignment.center,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(
                        Icons.ad_units,
                        color: Colors.white,
                      ),
                    ),
                    title: Text('Ads Example'),
                    subtitle: Text('Tap to launch ad'),
                    onTap: _showInterstitialAd,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          SwipeLeftAnimationRoute(widget: AllQuizScreen()));
                    },
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_shop.png",
                        color: textColorG,
                        scale: 1.7,
                      ),
                    ),
                    title: VariableText(
                      text: tr("My Quiz"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context, SwipeLeftAnimationRoute(widget: GiftScreen()));
                    },
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_shop.png",
                        color: textColorG,
                        scale: 1.7,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Buy Gift"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //Navigator.push(context, SwipeLeftAnimationRoute(widget: PushNotificationScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Image.asset(
                      "assets/icons/ic_bell.png",
                      color: textColorG,
                      scale: 1.7,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        VariableText(
                          text: tr("Push Notification"),
                          fontFamily: fontRegular,
                          fontsize: size.height * 0.020,
                          fontcolor: textColorG,
                          textAlign: TextAlign.left,
                        ),
                        FlutterSwitch(
                          width: size.width * 0.11,
                          height: size.height * 0.028,
                          valueFontSize: size.height * 0.015,
                          toggleSize: size.height * 0.025,
                          value: pushNotification,
                          borderRadius: 30.0,
                          // padding: 8.0,
                          showOnOff: false,
                          activeColor: primaryColor1,
                          inactiveText: "Off",
                          inactiveColor: primaryColor2,
                          inactiveTextColor: textColorW,
                          activeTextColor: textColorW,
                          onToggle: (val) {
                            toggleNotification(val);
                            /*setState(() {
                              pushNotification = val;
                            });*/
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          SwipeLeftAnimationRoute(widget: SubscriptionScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_subscription.png",
                        color: textColorG,
                        scale: 1.7,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Manage Subscription"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context, SwipeLeftAnimationRoute(widget: BoostScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.09),
                    leading: Container(
                      padding: EdgeInsets.only(right: size.height * 0.016),
                      child: Image.asset(
                        "assets/icons/ic_boost.png",
                        color: textColorG,
                        fit: BoxFit.cover,
                        scale: 1.2,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Profile Boost"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          SwipeLeftAnimationRoute(widget: PrivacyOptionScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_password.png",
                        color: textColorG,
                        scale: 1.8,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Privacy Option"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context, SwipeLeftAnimationRoute(widget: BlockScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Icon(Icons.block),
                    title: VariableText(
                      text: tr("Blocking"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      onClickDeactivate();
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Icon(Icons.delete),
                    title: VariableText(
                      text: tr("Deactivate Account"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      //onClickHoliday();
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_holiday.png",
                        color: textColorG,
                        scale: 1.4,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        VariableText(
                          text: tr("Holiday/Office Mode"),
                          fontFamily: fontRegular,
                          fontsize: size.height * 0.020,
                          fontcolor: textColorG,
                          textAlign: TextAlign.left,
                        ),
                        FlutterSwitch(
                          width: size.width * 0.11,
                          height: size.height * 0.028,
                          valueFontSize: size.height * 0.015,
                          toggleSize: size.height * 0.025,
                          value: holidayMode,
                          borderRadius: 30.0,
                          // padding: 8.0,
                          showOnOff: false,
                          activeColor: primaryColor1,
                          inactiveText: "Off",
                          inactiveColor: primaryColor2,
                          inactiveTextColor: textColorW,
                          activeTextColor: textColorW,
                          onToggle: (val) {
                            toggleHolidayMode(userDetails);
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context, SwipeLeftAnimationRoute(widget: CoinScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_coins.png",
                        color: textColorG,
                        scale: 1.7,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Coins"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context, SwipeLeftAnimationRoute(widget: HelpScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_help.png",
                        color: textColorG,
                        scale: 2,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Help Center"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          SwipeLeftAnimationRoute(widget: TermsConditionScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_terms.png",
                        color: textColorG,
                        scale: 1.9,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Terms & Condition"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context, SwipeLeftAnimationRoute(widget: PrivacyScreen()));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_policy.png",
                        color: textColorG,
                        scale: 1.7,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Privacy Policy"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      String locale = context.locale.toString();
                      Navigator.push(context,
                          SwipeLeftAnimationRoute(widget: LanguageSettingScreen(
                            activeLocale: locale,
                          )));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_language.png",
                        color: textColorG,
                        scale: 1.7,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Language"),
                      fontFamily: fontRegular,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      SplashScreen.sp.remove('userAuth');
                      Navigator.pushAndRemoveUntil(context,
                          SwipeRightAnimationRoute(widget: const LoginScreen(), milliseconds: 300),
                              (route) => route.isCurrent);
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0, top: size.height * 0.005),
                      child: Image.asset(
                        "assets/icons/ic_logout.png",
                        color: primaryColor1,
                        scale: 1.5,
                      ),
                    ),
                    title: VariableText(
                      text: tr("Logout"),
                      fontFamily: fontMedium,
                      fontsize: size.height * 0.020,
                      fontcolor: primaryColor1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            if(isLoading) ProcessLoadingLight()
          ],
        ),
      ),
    );
  }
}
