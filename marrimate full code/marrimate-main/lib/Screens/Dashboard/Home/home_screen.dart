import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/Dashboard/Dashboard/couple_match_screen.dart';
import 'package:marrimate/Screens/Dashboard/Dashboard/user_profile_screen.dart';
import 'package:marrimate/Screens/Dashboard/Home/story/create_story_screen.dart';
import 'package:marrimate/Screens/Dashboard/Home/notification_screen.dart';
import 'package:marrimate/Screens/Settings/Gift/gift_screen.dart';
import 'package:marrimate/Screens/Settings/subscription_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/constants.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/match_model.dart';
import 'package:marrimate/models/notification_model.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:marrimate/services/notifications.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../models/filters_model.dart';
import 'filter_screen.dart';

class Content {
  final String text;
  final Color color;

  Content({this.text, this.color});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine _matchEngine;
  bool partnersFinished = false;
  bool isLoading = false;
  bool allowLike = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    renderCards();
    checkLikeLimit();
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

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  userAction({int partnerID, String type})async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.partnerAction(
        userDetails,
        partnerID: partnerID,
        type: type
    );
    if(response != null){
      if(response['status']){
        if(type != "dislike"){
          Provider.of<UserModel>(context, listen: false).incrementLikeCount();
        }
        Provider.of<Match>(context, listen: false).markCandidate(partnerID);
        if(response['is_matched']){
          //print(response.toString);
          partnerMatched(UserModel.fromPartnerJson(response['data']), userDetails);
        }
        checkLikeLimit();
      }else{

      }
    }else{

    }
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

  renderCards(){
    var allCandidates = Provider.of<Match>(context, listen: false);
    _swipeItems.clear();
    for (int i = 0; i < allCandidates.candidates.length; i++) {
      if(allCandidates.marked[i] == false){
        _swipeItems.add(
          SwipeItem(
            content: UserModel.fromModel(allCandidates.candidates[i]),
            likeAction: () {
              userAction(partnerID: allCandidates.candidates[i].id, type: "like");
              print("likeAction");
            },
            nopeAction: () {
              userAction(partnerID: allCandidates.candidates[i].id, type: "dislike");
              print("nopeAction");
            },
            superlikeAction: () {
              userAction(partnerID: allCandidates.candidates[i].id, type: "superlike");
              print("superlikeAction");
            },
            onSlideUpdate: (SlideRegion region) async {
              //print("Region $region");
            },
          ),
        );
      }
    }
    if(_swipeItems.isNotEmpty){
      _matchEngine = MatchEngine(swipeItems: _swipeItems);
      setState(() {
        partnersFinished = false;
      });
    }else{
      setState(() {
        partnersFinished = true;
      });
    }
    setLoading(false);
  }

  refresh()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var myFilters = Provider.of<Filters>(context, listen: false);
    var responseCandidate = await API.getCandidates(userDetails.accessToken);
    if(responseCandidate != null){
      Provider.of<Match>(context, listen: false).loadCandidates(responseCandidate, userDetails, myFilters);
      renderCards();
    }else{
      setLoading(false);
    }
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
                            text: tr("Limit Reached"),
                            fontFamily: fontBold,
                            fontsize: size.height * 0.022,
                            fontcolor: primaryColor2,
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                            child: VariableText(
                              text: tr("Buy subscription plan to enjoy unlimited features"),
                              fontFamily: fontMedium,
                              fontsize: size.height * 0.018,
                              fontcolor: textColorG,
                              textAlign: TextAlign.center,
                              max_lines: 3,
                            ),
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
                            btnTxt: tr("Buy Now"),
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

  renderUpgradeSub() {
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
                          text: tr("Upgrade Plan"),
                          fontFamily: fontBold,
                          fontsize: size.height * 0.022,
                          fontcolor: primaryColor2,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                          child: VariableText(
                            text: tr("Buy subscription plan to enjoy unlimited features"),
                            fontFamily: fontMedium,
                            fontsize: size.height * 0.018,
                            fontcolor: textColorG,
                            textAlign: TextAlign.center,
                            max_lines: 3,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        MyButton(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(context,
                                SwipeRightAnimationRoute(widget: SubscriptionScreen()));
                          },
                          btnTxt: tr("Buy Now"),
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
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    refresh();
    print("@@@");
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context, listen: true);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: textColorW,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: padding / 2, horizontal: padding / 2),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: size.height * 0.055,
                      padding: const EdgeInsets.all(3.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              SwipeLeftAnimationRoute(
                                widget: /*ArTest*/GalleryStoryScreen(),
                              ));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: size.width * 0.1),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12),
                            color: primaryColor1,
                            strokeWidth: 1,
                            dashPattern: [8, 4],
                            child: Container(
                              height: size.height,
                              width: size.width * 0.4,
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: size.height * 0.025,
                                      width: size.height * 0.025,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: padding / 2.5),
                                      decoration: BoxDecoration(
                                        color: primaryColor1,
                                        borderRadius: BorderRadius.circular(
                                            size.height * 0.1),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: textColorW,
                                        size: size.height * 0.019,
                                      ),
                                    ),
                                    FittedBox(
                                      child: VariableText(
                                        text: tr('Add Story'), //DemoLocalization.translate("Add Story"),
                                        fontFamily: fontBold,
                                        fontsize: size.height * 0.020,
                                        fontcolor: primaryColor1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.09),
                  SizedBox(
                    width: size.width * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /*Icon(
                          Icons.search,
                        ),*/
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SwipeUpAnimationRoute(
                                  widget: GiftScreen(),
                                ));
                          },
                          child: Image.asset(
                            "assets/icons/ic_shop.png",
                            color: textColorG,
                            scale: 1.6,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SwipeUpAnimationRoute(
                                  widget: NotificationScreen(),
                                ));
                          },
                          child: Image.asset(
                            "assets/icons/ic_bell.png",
                            scale: 1.6,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SwipeUpAnimationRoute(
                                  widget: FilterScreen(),
                                )).then((value){
                                refresh();
                            });
                          },
                          child: Image.asset(
                            "assets/icons/ic_filter.png",
                            scale: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.07,
            ),

            partnersFinished ?
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: size.width * 0.8,
              //color: Colors.redAccent,
              child: isLoading ?
              Stack(
                children: [
                  ProcessLoadingWhite()
                ],
              ) :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/ic_notfound_marker.png", scale: 2),
                  SizedBox(height: 15),
                  VariableText(
                    text: tr("Oops! Not Found"),
                    fontFamily: fontBold,
                    fontsize: size.height * 0.026,
                    fontcolor: primaryColor2,
                  ),
                  SizedBox(height: 5),
                  VariableText(
                    text: tr("No one near by your location"),
                    fontFamily: fontRegular,
                    fontsize: size.height * 0.018,
                    fontcolor: textColor1,
                  ),
                  SizedBox(height: 15),
                  MyButton(
                    btnTxt: tr("Refresh"),
                    btnColor: primaryColor2,
                    txtColor: textColorW,
                    btnHeight: size.height * 0.042,
                    btnWidth: size.width * 0.33,
                    btnRadius: 5,
                    borderColor: primaryColor2,
                    onTap: (){
                      refresh();
                    },
                  )
                ],
              ),
            ) :
            Expanded(
              child: Container(
                //height: MediaQuery.of(context).size.height - kToolbarHeight,
                width: size.width * 0.7,
                //color: Colors.redAccent,
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: -1 / 8,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 0,
                            right: size.width * 0.055,
                            bottom: size.height * 0.1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xffE77094),
                              Color(0xff148FE2).withOpacity(0.105),
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Transform.rotate(
                      angle: 1 / 15,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: size.width * 0.08,
                            right: 0,
                            bottom: size.height * 0.1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              primaryColor1,
                              primaryColor2,
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    allowLike ?
                    SwipeCards(
                      matchEngine: _matchEngine,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            if(userDetails.userPlanDetails.planID != 4){
                              renderUpgradeSub();
                            }else{
                              Navigator.push(
                                  context,
                                  SwipeLeftAnimationRoute(
                                    widget: UserProfileScreen(
                                      userID: _swipeItems[index]
                                          .content.id,
                                    ),
                                  ));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 30),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: _swipeItems[index]
                                              .content.profilePicture,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.black12, Colors.black87.withOpacity(0.7)]),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: allowLike ? 0.0 : 20.0, sigmaY: allowLike ? 0.0 : 20.0),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          //color: Colors.lightGreen,
                                          height: size.height * 0.16,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: padding * 1.1,
                                              vertical: padding / 2),
                                          child: Column(

                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: VariableText(
                                                                text: _swipeItems[index]
                                                                    .content.name + ", "+ getAge(_swipeItems[index]
                                                                    .content.dob),
                                                                fontsize: size.height * 0.021,
                                                                fontcolor: textColorW,
                                                                weight: FontWeight.w600,
                                                                max_lines: 2,
                                                              ),
                                                            ),
                                                            /*Expanded(
                                                                child: VariableText(
                                                                  text: ", "+ getAge(_swipeItems[index]
                                                                      .content.dob),
                                                                  fontsize: size.height * 0.03,
                                                                  fontcolor: textColorW,
                                                                  max_lines: 1,
                                                                ),
                                                              ),*/
                                                          ],
                                                        ),
                                                        /*SizedBox(
                                                            height: 3,
                                                          ),
                                                          VariableText(
                                                            text: "NewYork",
                                                            fontsize: size.height * 0.018,
                                                            fontcolor: textColorW,
                                                          ),*/
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Wrap(
                                                                  alignment: WrapAlignment.start,
                                                                  runAlignment: WrapAlignment.start,
                                                                  runSpacing: 10,
                                                                  spacing: size.width * 0.03,
                                                                  children: List.generate(
                                                                      _swipeItems[index].content.hobbies.length <= 3 ?
                                                                      _swipeItems[index].content.hobbies.length : 3
                                                                      /*_swipeItems[index].content.hobbies.length*/,
                                                                          (index2){
                                                                        return Container(
                                                                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: textColorW),
                                                                              borderRadius: BorderRadius.circular(10)
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              VariableText(
                                                                                text: _swipeItems[index].content.hobbies[index2].name,
                                                                                fontFamily: fontMedium,
                                                                                fontsize: size.height * 0.015,
                                                                                fontcolor: textColorW,
                                                                                max_lines: 3,
                                                                                // line_spacing: size.height * 0.0017,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      })
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            mainAxisAlignment: MainAxisAlignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      onStackFinished: () {
                        print("Finished");
                        setState(() {
                          partnersFinished = true;
                        });
                      },
                      itemChanged: (SwipeItem item, int index) {
                        //print("item: ${item.content.name}, index: $index");
                      },
                      upSwipeAllowed: false,
                      fillSpace: true,
                    ) :
                    IgnorePointer(
                      ignoring: true,
                      child: SwipeCards(
                        matchEngine: _matchEngine,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(top: 30),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: _swipeItems[index]
                                              .content.profilePicture,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.black12, Colors.black87.withOpacity(0.7)]),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: allowLike ? 0.0 : 20.0, sigmaY: allowLike ? 0.0 : 20.0),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          //color: Colors.lightGreen,
                                          height: size.height * 0.16,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: padding * 1.1,
                                              vertical: padding / 2),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: VariableText(
                                                                text: _swipeItems[index]
                                                                    .content.name + ", "+ getAge(_swipeItems[index]
                                                                    .content.dob),
                                                                fontsize: size.height * 0.021,
                                                                fontcolor: textColorW,
                                                                weight: FontWeight.w600,
                                                                max_lines: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Wrap(
                                                                  alignment: WrapAlignment.start,
                                                                  runAlignment: WrapAlignment.start,
                                                                  runSpacing: 10,
                                                                  spacing: size.width * 0.03,
                                                                  children: List.generate(
                                                                      _swipeItems[index].content.hobbies.length <= 3 ?
                                                                      _swipeItems[index].content.hobbies.length : 3
                                                                      /*_swipeItems[index].content.hobbies.length*/,
                                                                          (index2){
                                                                        return Container(
                                                                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: textColorW),
                                                                              borderRadius: BorderRadius.circular(10)
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              VariableText(
                                                                                text: _swipeItems[index].content.hobbies[index2].name,
                                                                                fontFamily: fontMedium,
                                                                                fontsize: size.height * 0.015,
                                                                                fontcolor: textColorW,
                                                                                max_lines: 3,
                                                                                // line_spacing: size.height * 0.0017,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      })
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        onStackFinished: () {
                          print("Finished");
                          setState(() {
                            partnersFinished = true;
                          });
                        },
                        itemChanged: (SwipeItem item, int index) {
                          //print("item: ${item.content.name}, index: $index");
                        },
                        upSwipeAllowed: false,
                        fillSpace: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if(!partnersFinished && allowLike)
            Container(
              height: size.height * 0.2,
              padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _matchEngine.currentItem.like();
                    },
                    child: Container(
                      width: size.width * 0.15,
                      // margin: EdgeInsets.only(right: padding / 1.5),
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
                        scale: 1.2,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _matchEngine.currentItem.superLike();
                    },
                    child: Container(
                      width: size.width * 0.15,
                      margin: EdgeInsets.symmetric(horizontal: padding / 3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor1,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(size.height * 0.1),
                      ),
                      child: Image.asset(
                        "assets/icons/ic_heart_fill.png",
                        // color: Color(0xff27AE60),
                        scale: 2,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _matchEngine.currentItem.nope();
                    },
                    child: Container(
                      width: size.width * 0.15,
                      // margin: EdgeInsets.only(right: padding / 1.5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(size.height * 0.1),
                      ),
                      child: Image.asset(
                        "assets/icons/ic_unlike.png",
                        // color: Color(0xff27AE60),
                        scale: 1.6,
                      ),
                    ),
                  ),
                  /*Container(
                    width: size.width * 0.15,
                    // margin: EdgeInsets.only(right: padding / 1.5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: primaryColor2,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(size.height * 0.1),
                    ),
                    child: Image.asset(
                      "assets/icons/ic_radar1.png",
                      // color: Color(0xff27AE60),
                      scale: 1.6,
                    ),
                  ),*/
                ],
              ),
            ),

            if(!allowLike && !partnersFinished)
              Container(
                height: size.height * 0.2,
              )
          ],
        ),
      ),
    );
  }
}
