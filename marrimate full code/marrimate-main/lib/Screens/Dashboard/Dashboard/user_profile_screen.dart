import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marrimate/Screens/Competition/start_quiz_screen.dart';
import 'package:marrimate/Screens/Settings/EditProfile/video_player.dart';
import 'package:marrimate/Screens/Settings/Gift/gift_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../Chat/chatting_screen.dart';

class UserProfileScreen extends StatefulWidget {
  int userID;
  UserProfileScreen({Key key, this.userID}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  List<VideoPlayerController> _controllers = [];
  bool isLoading = true;
  bool isMainLoading = false;
  UserModel partnerDetails;
  String partnerDistance = "0";

  TabController tabController;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }
  setMainLoading(bool loading){
    setState(() {
      isMainLoading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(handleTabSelection);
    getPartnerDetails();
  }

  handleTabSelection() {
    setState(() {});
  }

  loadVideos()async{
    print("Loading Videos...");
    _controllers.clear();
    //var userDetails = Provider.of<UserModel>(context, listen: false);
    for(var item in partnerDetails.userVideos){
      _controllers.add(VideoPlayerController.network(item.videoUrl));
    }
    for(var item in _controllers){
      item.setLooping(true);
      item.initialize().then((_) => setState(() {}));
    }
  }

  getPartnerDetails()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getSinglePartner(widget.userID, userDetails.accessToken);
    if(response != null){
      partnerDetails = UserModel.fromJson(response['data']);
      var distance = Geolocator.distanceBetween(
          double.parse(userDetails.lat), double.parse(userDetails.long),
        double.parse(partnerDetails.lat), double.parse(partnerDetails.long)
      );
      partnerDistance = (distance / 1000).toStringAsFixed(1);
      setLoading(false);
      loadVideos();
    }else{
      Navigator.of(context).pop();
    }
  }

  blockUser(UserModel userDetails)async{
    setMainLoading(true);
    var response = await API.blockUser(partnerDetails.id, userDetails);
    if(response != null){
      setMainLoading(false);
      if(response['status']){
        Provider.of<Partner>(context, listen: false).removePartner(partnerDetails.id);
        Fluttertoast.showToast(
            msg: "Blocked Successfully",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.of(context).pop();
      }
    }else{
      setMainLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  getUserQuiz()async{
    setMainLoading(true);
    var response = await API.getAllQuiz(partnerDetails);
    if(response != null){
      if(response['status']){
        setMainLoading(false);
        Navigator.push(
            context,
            SwipeLeftAnimationRoute(
                widget: StartQuizScreen(
                  quizID: response['data'][0]['id'],
                )));
      }else{
        setMainLoading(false);
        Fluttertoast.showToast(
            msg: "No Quiz Available",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      setMainLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);

    }
  }

  openImage(String imageUrl){
    Image _img = Image.network(imageUrl);
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: true ? Colors.black : Colors.white,
        pageBuilder: (BuildContext context, _, __) {
          return FullScreenImage(
            child: _img,
            dark: true,
            hasDelete: false,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for(var item in _controllers){
      item.dispose();
    }
    print("videos disposed");
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: !isLoading ? CustomAppBar(
              text: "@${partnerDetails.username}",
              isBack: true,
              actionImage: "assets/icons/ic_more_option.png",
              actionOnTap: PopupMenuButton(
                icon: Icon(Icons.more_vert_sharp),
                color: textColorW,
                padding: EdgeInsets.all(0),
                elevation: 5,
                offset: Offset(-30, size.height * 0.082),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    onTap: (){
                      blockUser(userDetails);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 23,
                          child: Image.asset(
                            "assets/icons/ic_block_user.png",
                            scale: 2.2,
                          ),
                        ),
                        SizedBox(width: 8),
                        VariableText(
                          text: tr("Block User"),
                          fontFamily: fontMedium,
                          fontcolor: textColorB,
                          fontsize: size.height * 0.019,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              height: size.height * 0.08,
            ) : null,
            body: isLoading ?
            SafeArea(
              child: Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    period: Duration(milliseconds: 1000),
                    child: Container(
                      height: size.height * 0.08,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(0)
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    period: Duration(milliseconds: 1000),
                    child: Container(
                      height: size.height * 0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(0)
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    period: Duration(milliseconds: 1000),
                    child: Container(
                      height: size.height * 0.07,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    period: Duration(milliseconds: 1000),
                    child: Row(
                      children: [
                        Container(
                          height: size.height * 0.05,
                          width: size.width * 0.40,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    period: Duration(milliseconds: 1000),
                    child: Row(
                      children: [
                        Container(
                          height: size.height * 0.01,
                          width: size.width * 0.80,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    period: Duration(milliseconds: 1000),
                    child: Row(
                      children: [
                        Container(
                          height: size.height * 0.01,
                          width: size.width * 0.70,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    period: Duration(milliseconds: 1000),
                    child: Row(
                      children: [
                        Container(
                          height: size.height * 0.01,
                          width: size.width * 0.40,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    period: Duration(milliseconds: 1000),
                    child: Row(
                      children: [
                        Container(
                          height: size.height * 0.01,
                          width: size.width * 0.85,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    period: Duration(milliseconds: 1000),
                    child: Container(
                      height: size.height * 0.06,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: padding / 4),
                      itemCount: 4,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                      ),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          period: Duration(milliseconds: 1000),
                          child: Container(
                            //padding: EdgeInsets.only(top: 12),
                            height: size.width * 0.40,
                            //width: size.width,
                            //color: Colors.black,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: size.width * 0.38,
                                  width: size.width * 0.47,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ) :
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            openImage(partnerDetails.profilePicture);
                          },
                          child: SizedBox(
                            height: size.height * 0.22,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl: partnerDetails.profilePicture,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.01,
                          color: primaryColor2,
                        ),
                        Container(
                          height: size.height * 0.09,
                          padding: EdgeInsets.symmetric(
                              horizontal: padding, vertical: padding / 2.2),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VariableText(
                                      text: partnerDetails.name,
                                      fontFamily: fontBold,
                                      fontsize: size.height * 0.026,
                                      fontcolor: primaryColor2,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        if(partnerDetails.userPrivacy.showLocation)
                                        Image.asset(
                                          "assets/icons/ic_marker.png",
                                          scale: 2.2,
                                        ),
                                        if(partnerDetails.userPrivacy.showLocation)
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 8.0),
                                          child: VariableText(
                                            text: "$partnerDistance km away",
                                            fontFamily: fontRegular,
                                            fontsize: size.height * 0.017,
                                            fontcolor: textColorG,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Image.asset(
                                          "assets/icons/ic_heart.png",
                                          scale: 2.2,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 8.0),
                                          child: VariableText(
                                            text: "0K",
                                            fontFamily: fontRegular,
                                            fontsize: size.height * 0.017,
                                            fontcolor: textColorG,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.36,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        /*Navigator.push(
                                            context,
                                            SwipeLeftAnimationRoute(
                                              widget: CoupleMatchScreen(),
                                            ));*/
                                      },
                                      child: Container(
                                        height: size.width * 0.1,
                                        width: size.width * 0.1,
                                        // margin: EdgeInsets.only(right: padding / 1.5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xff27AE60),
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              size.height * 0.1),
                                        ),
                                        child: Image.asset(
                                          "assets/icons/ic_like.png",
                                          color: Color(0xff27AE60),
                                          scale: 2,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            SwipeLeftAnimationRoute(
                                              widget: GiftScreen(),
                                            ));
                                      },
                                      child: Container(
                                        width: size.width * 0.1,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: padding / 3),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.orange,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              size.height * 0.1),
                                        ),
                                        child: Image.asset(
                                          "assets/icons/ic_gifts.png",
                                          // color: Color(0xff27AE60),
                                          scale: 2.2,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            SwipeLeftAnimationRoute(
                                              widget: ChattingScreen(partner: partnerDetails),
                                            ));
                                      },
                                      child: Container(
                                        //height: size.height * 0.05,
                                        height: size.width * 0.1,
                                        width: size.width * 0.1,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: primaryColor1,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                        child: Image.asset(
                                          "assets/icons/ic_message_arrow.png",
                                          color: primaryColor1,
                                          scale: 2.5,
                                        ),
                                      ),
                                    ),
                                    /*Container(
                                      width: size.width * 0.1,
                                      // margin: EdgeInsets.only(right: padding / 1.5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.lightGreenAccent,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            size.height * 0.1),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          getUserQuiz();
                                          *//*Navigator.push(
                                              context,
                                              SwipeLeftAnimationRoute(
                                                  widget: QuizScreen()));*//*
                                        },
                                        child: Image.asset(
                                          "assets/icons/ic_quiz.png",
                                          // color: Color(0xff27AE60),
                                          scale: 2.4,
                                        ),
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Short Bio
                        Padding(
                          padding: EdgeInsets.only(
                            left: padding,
                            right: padding,
                            top: padding,
                            bottom: padding - 17,
                          ),
                          child: Row(
                            children: [
                              VariableText(
                                text: "Hello Friends!",
                                fontFamily: fontBold,
                                fontsize: size.height * 0.021,
                                fontcolor: primaryColor2,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        if(partnerDetails.userPrivacy.showBio)
                        Padding(
                          padding: EdgeInsets.only(
                            left: padding,
                            right: padding,
                            // top: padding - 10,
                            bottom: padding,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: VariableText(
                                  text: partnerDetails.shortBio??"",
                                  fontFamily: fontSemiBold,
                                  fontsize: size.height * 0.0162,
                                  fontcolor: textColorG,
                                  max_lines: 3,
                                  line_spacing: size.height * 0.0017,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Interest
                        Padding(
                          padding: EdgeInsets.only(
                            left: padding,
                            right: padding,
                            // top: padding - 15,
                            bottom: padding - 13,
                          ),
                          child: Row(
                            children: [
                              VariableText(
                                text: tr("Interests") + ":",
                                fontFamily: fontBold,
                                fontsize: size.height * 0.021,
                                fontcolor: primaryColor2,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: padding,
                            right: padding,
                            // top: padding - 10,
                            bottom: padding - 7,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    runSpacing: 12,
                                    spacing: size.width * 0.05,
                                    children: List.generate(partnerDetails.hobbies.length, (index){
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            partnerDetails.hobbies[index].icon,
                                            height: size.height * 0.023,
                                            color: textColorG,
                                          ),
                                          SizedBox(
                                            width: size.height * 0.01,
                                          ),
                                          VariableText(
                                            text: partnerDetails.hobbies[index].name,
                                            fontFamily: fontSemiBold,
                                            fontsize: size.height * 0.019,
                                            fontcolor: textColorG,
                                            max_lines: 3,
                                            // line_spacing: size.height * 0.0017,
                                          ),
                                        ],
                                      );
                                    })
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverAppBar(
                      expandedHeight: size.height * 0.01,
                      toolbarHeight: size.height * 0.01,
                      backgroundColor: textColorW,
                      pinned: false,
                      // floating: true,
                      // forceElevated: value,
                      bottom: PreferredSize(
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffE5E5E5), width: 3))),
                            // padding: EdgeInsets.only(right: size.width * 0.5),
                            child: TabBar(
                              controller: tabController,
                              // physics: NeverScrollableScrollPhysics(),
                              indicator: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: primaryColor1, width: 2))),
                              labelColor: primaryColor1,
                              indicatorSize: TabBarIndicatorSize.label,
                              unselectedLabelColor: primaryColor2,
                              padding: EdgeInsets.all(0),
                              labelPadding: EdgeInsets.all(0),
                              labelStyle: TextStyle(fontFamily: fontRegular),
                              tabs: [
                                Tab(
                                  text: tr("Photo"),
                                ),
                                Tab(
                                  text: tr("Video"),
                                ),
                                Tab(
                                  text: tr("Bio"),
                                ),
                              ],
                            ),
                          ),
                          preferredSize: Size(0, size.height * 0.05))),
                ];
              },
              body: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    itemCount: partnerDetails.userImages.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      // mainAxisExtent: 100,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          openImage(partnerDetails.userImages[index].imageUrl);
                        },
                        child: CachedNetworkImage(
                          imageUrl: partnerDetails.userImages[index].imageUrl,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Padding(
                                padding: const EdgeInsets.all(45.0),
                                child: CircularProgressIndicator(value: downloadProgress.progress, color: primaryColor2),
                              ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )
                      );
                    },
                  ),
                  GridView.builder(
                    itemCount: partnerDetails.userVideos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                FadeAnimationRoute(
                                    milliseconds: 200,
                                    widget: UserVideoPlayer(
                                      videoURL: partnerDetails.userVideos[index].videoUrl,
                                    )));
                          },
                          child: VideoPlayer(_controllers[index]));
                    },
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: padding,
                            right: padding,
                            top: padding,
                            bottom: padding - 17,
                          ),
                          child: Row(
                            children: [
                              VariableText(
                                text: "Short Bio:",
                                fontFamily: fontBold,
                                fontsize: size.height * 0.021,
                                fontcolor: primaryColor2,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        if(partnerDetails.userPrivacy.showBio)
                        Padding(
                          padding: EdgeInsets.only(
                            left: padding,
                            right: padding,
                            // top: padding - 10,
                            bottom: padding,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: VariableText(
                                  text: partnerDetails.shortBio??"",
                                  fontFamily: fontSemiBold,
                                  fontsize: size.height * 0.0162,
                                  fontcolor: textColorG,
                                  max_lines: 3,
                                  line_spacing: size.height * 0.0017,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(isMainLoading) ProcessLoadingLight()
        ],
      ),
    );
  }
}
