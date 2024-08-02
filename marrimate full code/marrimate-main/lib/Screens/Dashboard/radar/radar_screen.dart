
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marrimate/Screens/Dashboard/Dashboard/user_profile_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:im_animations/im_animations.dart';
import 'dart:math' as math;

import '../../../Widgets/constants.dart';
import '../../../models/filters_model.dart';
import '../../../models/notification_model.dart';
import '../../../models/radar_users_model.dart';
import '../../../models/match_model.dart';
import '../../../services/api.dart';
import '../../../services/notifications.dart';
import '../../Settings/subscription_screen.dart';
import '../Chat/chatting_screen.dart';
import '../Dashboard/couple_match_screen.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({Key key}) : super(key: key);

  @override
  _RadarScreenState createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen>
    with TickerProviderStateMixin{
  AnimationController controller;

  RadarUser selectedPartner;
  List<RadarUser> allUsers = [];

  bool allowLike = true;
  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  bool getMatched(int id){
    var partners = Provider.of<Partner>(context, listen: false);
    bool isMatched = false;
    for(var item in partners.partners){
      if(item.id == id){
        print(id.toString());
        isMatched = true;
        break;
      }
    }
    return isMatched;
  }

  getAge(String givenDob){
    String dob;
    int year = (DateTime.now().year - DateTime.parse(givenDob).year);
    if(year < 1){
      int month = (DateTime.now().month - DateTime.parse(givenDob).month);
      dob = month.toString();
    }else{
      dob = year.toString();
    }
    return dob;
  }
  getAgeMin(String ageRange){
    String minAge;
    minAge = ageRange.split("-").first.trim();
    return int.parse(minAge);
  }
  getAgeMax(String ageRange){
    String minAge;
    minAge = ageRange.split("-").last.trim();
    return int.parse(minAge);
  }

  getUsers()async{
    controller.repeat(min: 0.0, max: 1.0, period: const Duration(milliseconds: 500));
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var myFilters = Provider.of<Filters>(context, listen: false);
    var response = await API.getAllUsers(userDetails.accessToken);
    if(response != null){
      if(response['status']){
        setState(() {
          allUsers.clear();
        });
        for(var item in response['data']){
          //print(item['id'].toString());
          UserModel tempRadarUser = UserModel.fromRadar(item);
          if(tempRadarUser.userPrivacy.showLocation){

            int candidateAge = int.parse(getAge(tempRadarUser.dob));
            var distance = Geolocator.distanceBetween(
                double.parse(userDetails.lat), double.parse(userDetails.long),
                double.parse(tempRadarUser.lat), double.parse(tempRadarUser.long)
            );
            double partnerDistance = (distance / 1000);

            if(myFilters.gender == "All"){

            }else if(myFilters.gender != tempRadarUser.gender){
              continue;
            }
            if(myFilters.ageRange == "All"){

            }else if(candidateAge < getAgeMin(myFilters.ageRange)
                || candidateAge > getAgeMax(myFilters.ageRange)){
              continue;
            }
            if(partnerDistance > double.parse(myFilters.distanceRange)){
              continue;
            }
            allUsers.add(
                RadarUser.fromJson(
                    user: item,
                    matched: getMatched(item['id'])
                )
            );
          }
        }
        setState(() {});
      }else{

      }
    }else{

    }
    controller.reset();
    checkLikeLimit();
  }

  userAction({int partnerID, String type})async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.partnerAction(
        userDetails,
        partnerID: partnerID,
        type: type
    );
    if(response != null){
      if(response['status']){
        Provider.of<UserModel>(context, listen: false).incrementLikeCount();
        setState(() {
          selectedPartner.isLiked = true;
        });
        if(response['is_matched']){
          setLoading(false);
          partnerMatched(UserModel.fromPartnerJson(response['data']), userDetails);
        }
      }else{

      }
    }else{

    }
    setLoading(false);
  }

  partnerMatched(UserModel partnerDetails, UserModel userDetails){
    Provider.of<Partner>(context, listen: false).addPartner(partnerDetails);
    MyNotification newNotification = MyNotification(
        userID: partnerDetails.id,
        title: "New Match",
        content: "You got matched with ${userDetails.name}"
    );
    var response = API.addNotification(newNotification, userDetails);
    NotificationServices.postNotification(
        title: 'New Match',
        body: 'You got matched with ${userDetails.name}',
        partnerID: partnerDetails.id.toString(),
        purpose: 'match',
        receiverToken: partnerDetails.fcmToken
    );
    Navigator.push(
        context,
        SwipeLeftAnimationRoute(
          milliseconds: 200,
          widget: CoupleMatchScreen(partnerDetails: partnerDetails),
        ));
  }

  checkLikeLimit(){
    print("Checking limit");
    var userDetails = Provider.of<UserModel>(context, listen: false);
    if(userDetails.userPlanDetails.planID != 4){
      if(userDetails.likeLimit.totalLikes < Constants.getLikeLimit(userDetails.userPlanDetails.planID)){
        allowLike = true;
      }else{
        setState(() {
          allowLike = false;
        });
      }
      if(!allowLike){
        renderLikeLimit();
      }
    }else{
      setState(() {
        allowLike = true;
      });
    }
  }

  renderLikeLimit() {
    Future.delayed(const Duration(seconds: 1)).then((value){
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: "success",
        builder: (context) {
          var size = MediaQuery.of(context).size;

          return WillPopScope(
            onWillPop: ()=> Future.value(false),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: textColorW,
                    borderRadius: BorderRadius.circular(size.height * 0.02)),
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.35),
                padding: EdgeInsets.symmetric(
                    horizontal: size.height * 0.02, vertical: size.height * 0.01),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/limit_reached.png",
                            height: size.height * 0.08,
                          ),
                          SizedBox(height: size.height * 0.01),
                          VariableText(
                            text: "Limit Reached",
                            fontFamily: fontBold,
                            fontsize: size.height * 0.022,
                            fontcolor: primaryColor2,
                            textAlign: TextAlign.center,
                          ),
                          VariableText(
                            text: "Buy subscription plan to enjoy\nunlimited features",
                            fontFamily: fontMedium,
                            fontsize: size.height * 0.018,
                            fontcolor: textColorG,
                            textAlign: TextAlign.center,
                            max_lines: 3,
                          ),
                          SizedBox(height: size.height * 0.01),
                          MyButton(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(context,
                                  SwipeRightAnimationRoute(widget: SubscriptionScreen())).then((value){
                                checkLikeLimit();
                              });
                            },
                            btnTxt: "Buy Now",
                            borderColor: primaryColor1,
                            btnColor: primaryColor1,
                            txtColor: textColorW,
                            btnRadius: 5,
                            btnWidth: size.width * 0.60,
                            btnHeight: 40,
                            fontSize: size.height * 0.020,
                            weight: FontWeight.w700,
                            fontFamily: fontSemiBold,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.clear, color: textColorB, size: 18)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    //var partnersDetails = Provider.of<Partner>(context).getRadarPartner();
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: textColorW,
          body: Stack(
            children: [
              Positioned.fill(child: Image.asset("assets/images/radar_backgroud.png", fit: BoxFit.fill)),
              ColorSonar(
                //wavesDisabled: true,
                waveMotion: WaveMotion.synced,
                contentAreaRadius: size.height * 0.04,
                waveFall: size.width * 0.30,
                waveMotionEffect: Curves.linear,
                //waveMotion: WaveMotion.synced,
                //contentAreaColor: Colors.red,
                innerWaveColor: Colors.white.withOpacity(0.4),
                middleWaveColor: Colors.white.withOpacity(0.2),
                outerWaveColor: Colors.white.withOpacity(0.1),
                duration: Duration(seconds: 3),
                child: Container(
                  height: size.height * 0.08,
                  width: size.height * 0.08,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor1, width: 2),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: CachedNetworkImage(
                          imageUrl: userDetails.profilePicture,
                          fit: BoxFit.fill,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                                child: CircularProgressIndicator(
                                    value: downloadProgress.totalSize != null ?
                                    downloadProgress.downloaded / downloadProgress.totalSize
                                        : null,
                                    color: primaryColor2),
                              ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      Center(
                          child: InkWell(
                            onTap: (){
                              getUsers();
                            },
                              child: RotationTransition(
                                  turns: controller,
                                  child: Icon(Icons.refresh_outlined, size: size.height * 0.045, color: Colors.black54.withOpacity(0.4))
                              )
                          )
                      )
                    ],
                  ),
                ),
              ),
              if(selectedPartner != null && allowLike)
                Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.05),
                  child: Container(
                    height: size.height * 0.09,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: CachedNetworkImage(
                            imageUrl: selectedPartner.userDetails.profilePicture,
                            fit: BoxFit.fill,
                            height: size.height * 0.06,
                            width: size.height * 0.06,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.totalSize != null ?
                                      downloadProgress.downloaded / downloadProgress.totalSize
                                          : null,
                                      color: primaryColor2),
                                ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          flex: 20,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                VariableText(
                                  text: selectedPartner.userDetails.name,
                                  fontFamily: fontBold,
                                  fontsize: size.height * 0.020,
                                  fontcolor: textColorB,
                                  max_lines: 1,
                                ),
                                if(selectedPartner.isMatched)
                                  SizedBox(height: 5),
                                if(selectedPartner.isMatched)
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          SwipeLeftAnimationRoute(
                                            widget: UserProfileScreen(
                                              userID: selectedPartner.userDetails.id,
                                            ),
                                          ));
                                    },
                                    child: VariableText(
                                      text: "View Profile",
                                      underlined: true,
                                      fontFamily: fontRegular,
                                      fontsize: size.height * 0.015,
                                      fontcolor: primaryColor2,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if(!selectedPartner.isLiked)
                        InkWell(
                          onTap: () {
                            userAction(
                              partnerID: selectedPartner.userDetails.id,
                              type: "like"
                            );
                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.11,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff27AE60),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(size.height * 0.1),
                            ),
                            child: Image.asset(
                              "assets/icons/ic_like.png",
                              color: Color(0xff27AE60),
                              scale: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        if(selectedPartner.isMatched)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SwipeLeftAnimationRoute(
                                  widget: ChattingScreen(partner: selectedPartner.userDetails),
                                ));
                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.11,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor1,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(size.height * 0.1),
                            ),
                            child: Image.asset(
                              "assets/icons/ic_message_arrow.png",
                              color: primaryColor1,
                              scale: 1.8,
                            ),
                          ),
                        ),
                        /*Expanded(
                          flex: 14,
                          child: CommonButtonWithIcon(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    SwipeLeftAnimationRoute(
                                      widget: ChattingScreen(partner: selectedPartner.userDetails),
                                    ));
                              },
                              btnTxt: "Message",
                              btnColor: Color(0xFF064E80),
                              txtColor: textColorW,
                              btnRadius: 5,
                              //btnWidth: size.width * 0.30,
                              btnHeight: size.height * 0.04,
                              fontSize: size.height * 0.016,
                              weight: FontWeight.w600,
                              icon: "assets/icons/ic_message_arrow.png",
                              iconColor: textColorW,
                              iconHeight: size.height * 0.016
                          ),
                        )*/
                      ],
                    ),
                  ),
                ),
              ),
              ...renderPartnersNew()
            ],
          ),
        ),
        if(isLoading) ProcessLoadingLight()
      ],
    );
  }

  List<Widget> renderPartnersNew(){
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var size = MediaQuery.of(context).size;

    final children = <Widget>[];
    Random rand = Random();
    for(int i=0; i < allUsers.length; i++){
      var distance = Geolocator.distanceBetween(
          double.parse(userDetails.lat), double.parse(userDetails.long),
          double.parse(allUsers[i].userDetails.lat), double.parse(allUsers[i].userDetails.long)
      );
      //print(distance.toString());
      double partnerDistance = (distance / 1000);
      if(partnerDistance <= 25){
        double angle = (i + 1.1) * math.pi / 2.3;
        children.add(
          Center(
            child: Transform.rotate(
              angle: angle,
              child: Padding(
                padding: EdgeInsets.only(left: partnerDistance < 11 ? size.width * 0.42 : size.width * 0.75),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      selectedPartner = allUsers[i];
                    });
                    checkLikeLimit();
                  },
                  child: Transform.rotate(
                    angle: -angle,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: CachedNetworkImage(
                            imageUrl: allUsers[i].userDetails.profilePicture,
                            fit: BoxFit.fill,
                            height: size.height * 0.06,
                            width: size.height * 0.06,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.totalSize != null ?
                                      downloadProgress.downloaded / downloadProgress.totalSize
                                          : null,
                                      color: primaryColor2),
                                ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        VariableText(
                          text: "${partnerDistance.toStringAsFixed(0)} KM",
                          fontFamily: fontSemiBold,
                          fontsize: size.height * 0.016,
                          fontcolor: textColorW,
                          max_lines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return children;
  }

  double getRandomX(Random source, double start, double end) =>
      source.nextDouble() * (end - start) + start;

  List<Widget> renderPartners(){
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var size = MediaQuery.of(context).size;

    final children = <Widget>[];
    Random rand = Random();
    for(int i=0; i < allUsers.length; i++){
      var distance = Geolocator.distanceBetween(
          double.parse(userDetails.lat), double.parse(userDetails.long),
          double.parse(allUsers[i].userDetails.lat), double.parse(allUsers[i].userDetails.long)
      );
      //print(distance.toString());
      double partnerDistance = (distance / 1000);
      if(partnerDistance <= 25){
        children.add(
          Positioned(
            top: i.isEven ? size.height * 0.41 - size.height * getRandomX(rand, 0.05, 0.35) : size.height * 0.41 + size.height * getRandomX(rand, 0.05, 0.30),
            left: i.isEven ? size.width * 0.45 - size.width * getRandomX(rand, 0.06, 0.40) : size.width * 0.45 + size.width * getRandomX(rand, 0.06, 0.35),
            child: InkWell(
              onTap: (){
                setState(() {
                  selectedPartner = allUsers[i];
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: CachedNetworkImage(
                      imageUrl: allUsers[i].userDetails.profilePicture,
                      fit: BoxFit.fill,
                      height: size.height * 0.06,
                      width: size.height * 0.06,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                            child: CircularProgressIndicator(
                                value: downloadProgress.totalSize != null ?
                                downloadProgress.downloaded / downloadProgress.totalSize
                                    : null,
                                color: primaryColor2),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  VariableText(
                    text: "${partnerDistance.toStringAsFixed(0)} KM",
                    fontFamily: fontSemiBold,
                    fontsize: size.height * 0.016,
                    fontcolor: textColorW,
                    max_lines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return children;
  }

  /*List<Widget> renderPartners(List<UserModel> partners){
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var size = MediaQuery.of(context).size;

    final children = <Widget>[];
    Random rand = Random();
    for(int i=0; i < partners.length; i++){
      var distance = Geolocator.distanceBetween(
          double.parse(userDetails.lat), double.parse(userDetails.long),
          double.parse(partners[i].lat), double.parse(partners[i].long)
      );
      //print(distance.toString());
      double partnerDistance = (distance / 1000);
      if(partnerDistance <= 25){
        children.add(
          Positioned(
            top: i.isEven ? size.height * 0.41 - size.height * getRandomX(rand, 0.05, 0.35) : size.height * 0.41 + size.height * getRandomX(rand, 0.05, 0.30),
            //top: getRandomX(rand, 0.10, 0.40),
            //bottom: i.isOdd ? size.height * 0.41 - 100 :  0.0,
            left: i.isEven ? size.width * 0.45 - size.width * getRandomX(rand, 0.06, 0.40) : size.width * 0.45 + size.width * getRandomX(rand, 0.06, 0.35),
            //right: i.isOdd ? size.width * 0.35 : 0.0,
            child: InkWell(
              onTap: (){
                setState(() {
                  selectedPartner = partners[i];
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: CachedNetworkImage(
                      imageUrl: partners[i].profilePicture,
                      fit: BoxFit.fill,
                      height: size.height * 0.06,
                      width: size.height * 0.06,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                            child: CircularProgressIndicator(
                                value: downloadProgress.totalSize != null ?
                                downloadProgress.downloaded / downloadProgress.totalSize
                                    : null,
                                color: primaryColor2),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  VariableText(
                    text: "${partnerDistance.toStringAsFixed(0)} KM",
                    fontFamily: fontSemiBold,
                    fontsize: size.height * 0.016,
                    fontcolor: textColorW,
                    max_lines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return children;
  }*/
}
