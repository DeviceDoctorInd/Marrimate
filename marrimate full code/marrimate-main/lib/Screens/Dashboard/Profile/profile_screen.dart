import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/Settings/EditProfile/video_player.dart';
import 'package:marrimate/Screens/Settings/setting_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  TabController tabController;
  List<VideoPlayerController> _controllers = [];

  bool loadingVideo = false;

  isVideoLoading(bool loading){
    setState(() {
      loadingVideo = loading;
    });
  }

  loadVideos()async{
    isVideoLoading(true);
    print("Loading Videos...");
    _controllers.clear();
    var userDetails = Provider.of<UserModel>(context, listen: false);
    for(var item in userDetails.userVideos){
      _controllers.add(VideoPlayerController.network(item.videoUrl));
    }
    for(var item in _controllers){
      item.setLooping(true);
      item.initialize().then((_) => setState(() {}));
    }
    isVideoLoading(false);
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
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(handleTabSelection);
    loadVideos();
  }

  handleTabSelection() {
    setState(() {});
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
    var userDetails = Provider.of<UserModel>(context, listen: true);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.32,
                    margin: EdgeInsets.only(bottom: size.height * 0.03),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/profile_header.png",
                          width: double.infinity,
                          height: size.height * 0.22,
                          fit: BoxFit.fitWidth,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppBar(
                              actions: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SwipeRightAnimationRoute(
                                            widget: SettingScreen())).then((value){
                                              if(value != null){
                                                if(value){
                                                  loadVideos();
                                                }
                                              }
                                              print(value.toString());
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/icons/ic_setting.png",
                                    scale: 2,
                                  ),
                                )
                              ],
                              title: VariableText(
                                text: tr("Your Profile"),
                                fontFamily: fontSemiBold,
                                fontsize: size.height * 0.026,
                                fontcolor: textColorW,
                              ),
                              centerTitle: true,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              automaticallyImplyLeading: false,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                                vertical: size.height * 0.01),
                            height: size.height * 0.18,
                            decoration: BoxDecoration(
                              color: textColorW,
                              borderRadius:
                                  BorderRadius.circular(size.height * 0.02),
                              boxShadow: [
                                BoxShadow(
                                    color: borderColor,
                                    blurRadius: 5.0,
                                    offset: Offset(0.0, 0.15))
                              ],
                            ),
                            padding:
                                EdgeInsets.symmetric(horizontal: padding / 2),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    openImage(userDetails.profilePicture);
                                  },
                                  child: SizedBox(
                                    width: size.height * 0.14,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(size.height * 0.02),
                                      child: Image.network(
                                        userDetails.profilePicture,
                                        fit: BoxFit.fill,
                                        height: size.width * 0.28,
                                        width: size.height * 0.14,
                                          loadingBuilder: (BuildContext context, Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes
                                                    : null,
                                              ),
                                            );
                                          },
                                        errorBuilder: (BuildContext context, obj, trace) {
                                          return const Center(
                                              child: Icon(Icons.error_outline,
                                                  size: 30, color: Colors.red));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.04),
                                        child: Row(
                                          children: [
                                            VariableText(
                                              text: userDetails.name,
                                              fontFamily: fontBold,
                                              fontsize: size.height * 0.026,
                                              fontcolor: primaryColor2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: size.width * 0.04),
                                            child: Column(
                                              children: [
                                                VariableText(
                                                  text: "0",
                                                  fontFamily: fontBold,
                                                  fontsize: size.height * 0.022,
                                                  fontcolor: primaryColor2,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: size.height * 0.002),
                                                  child: VariableText(
                                                    text: tr("Likes"),
                                                    fontFamily: fontSemiBold,
                                                    fontsize:
                                                        size.height * 0.015,
                                                    fontcolor: textColorG,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              VariableText(
                                                text: "0",
                                                fontFamily: fontBold,
                                                fontsize: size.height * 0.022,
                                                fontcolor: primaryColor2,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: size.height * 0.002),
                                                child: VariableText(
                                                  text: tr("Followers"),
                                                  fontFamily: fontSemiBold,
                                                  fontsize: size.height * 0.015,
                                                  fontcolor: textColorG,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              VariableText(
                                                text: "0",
                                                fontFamily: fontBold,
                                                fontsize: size.height * 0.022,
                                                fontcolor: primaryColor2,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: size.height * 0.002),
                                                child: VariableText(
                                                  text: tr("Followings"),
                                                  fontFamily: fontSemiBold,
                                                  fontsize: size.height * 0.015,
                                                  fontcolor: textColorG,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: size.height * 0.07,
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF22562).withOpacity(0.3),
                        borderRadius:
                            BorderRadius.circular(size.height * 0.010),
                      ),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(size.height * 0.01),
                        color: primaryColor1,
                        strokeWidth: 1,
                        dashPattern: [8, 4],
                        child: Container(
                          height: size.height,
                          // decoration: BoxDecoration(
                          //   color: Color(0xffF22562).withOpacity(0.3),
                          //   borderRadius: BorderRadius.circular(9),
                          // ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/ic_wallet.png",
                                scale: 2.2,
                              ),
                              SizedBox(
                                width: size.width * 0.04,
                              ),
                              VariableText(
                                text: "${userDetails.coins.totalCoins} ${tr("Coins")}",
                                fontFamily: fontBold,
                                fontsize: size.height * 0.024,
                                fontcolor: primaryColor1,
                              ),
                            ],
                          ),
                        ),
                      ),
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
                          text: tr("Short Bio") +":",
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
                      bottom: padding,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: VariableText(
                            text: userDetails.shortBio?? tr("Enter your bio now!"),
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
                      bottom: padding,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            runSpacing: 12,
                            spacing: size.width * 0.05,
                            children: List.generate(userDetails.hobbies.length, (index){
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    userDetails.hobbies[index].icon,
                                    height: size.height * 0.023,
                                    color: textColorG,
                                  ),
                                  SizedBox(
                                    width: size.height * 0.01,
                                  ),
                                  VariableText(
                                    text: userDetails.hobbies[index].name,
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
                toolbarHeight: size.height * 0.015,
                backgroundColor: textColorW,
                pinned: true,
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
              itemCount: userDetails.userImages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                // mainAxisExtent: 100,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Image _img = Image.network(userDetails.userImages[index].imageUrl);
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
                  },
                  child: CachedNetworkImage(
                      imageUrl: userDetails.userImages[index].imageUrl,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Padding(
                            padding: const EdgeInsets.all(45.0),
                            child: CircularProgressIndicator(value: downloadProgress.progress, color: primaryColor2),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  /*Image.network(
                    userDetails.userImages[index].imageUrl,
                    fit: BoxFit.cover,
                  ),*/
                );
              },
            ),
            loadingVideo ? ProcessLoadingWhite() :
            GridView.builder(
              itemCount: userDetails.userVideos.length,
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
                                videoURL: userDetails.userVideos[index].videoUrl,
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
                            text: userDetails.shortBio??"",
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
    );
  }
}
