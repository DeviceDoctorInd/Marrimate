import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/Dashboard/Dashboard/premium_alert_screen.dart';
import 'package:marrimate/Screens/Dashboard/Dashboard/user_profile_screen.dart';
import 'package:marrimate/Screens/Dashboard/Home/filter_screen.dart';
import 'package:marrimate/Screens/Dashboard/Home/notification_screen.dart';
import 'package:marrimate/Screens/Dashboard/Home/story/view_story_screen.dart';
import 'package:marrimate/Screens/Settings/Gift/gift_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

import '../../../models/my_story_model.dart';
import '../../../models/story_model.dart';
import '../Home/story/create_story_screen.dart';
import 'view_story_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin{
  TabController tabController;
  int selectedIndex = 0;
  int selectedStoryIndex;
  List<Map<String, dynamic>> tabs = [
    {"name": "Matched"},
    {"name": "Liked You"},
    {"name": "You Liked"},
  ];

  TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  
  List<UserModel> myLiked = [];
  List<UserModel> likedBy = [];
  bool isLoading = true;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }
  setSearching(bool loading){
    setState(() {
      isSearching = loading;
    });
  }


  Future updatePartnerList()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var responsePartners = await API.getMatchedPartners(userDetails.accessToken);
    if(responsePartners != null){
      if(mounted)
        Provider.of<Partner>(context, listen: false).loadPartners(responsePartners);
    }
    return;
  }

  updateMyStories()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var responseStories = await API.getMyStories(userDetails.accessToken);
    if(responseStories != null){
      if(mounted)
        Provider.of<MyStories>(context, listen: false).loadMyStories(responseStories);
    }
  }
  updateStories()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var responseStories = await API.getMatchedStories(userDetails.accessToken);
    if(responseStories != null){
      if(mounted)
        Provider.of<MatchedStories>(context, listen: false).loadMatchedStories(responseStories);
    }
  }

  getMyLiked()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getMyLiked(userDetails.accessToken);
    if(response != null){
      myLiked.clear();
      for(var item in response['data']){
        myLiked.add(UserModel.fromLikes(item));
      }
      print(myLiked.length.toString());
    }
    setLoading(false);
  }
  getLikedBy()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getLikedBy(userDetails.accessToken);
    if(response != null){
      likedBy.clear();
      for(var item in response['data']){
        likedBy.add(UserModel.fromLikes(item));
      }
    }
    setLoading(false);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(handleTabSelection);
    updatePartnerList();
    updateMyStories();
    updateStories();
    getMyLiked();
    getLikedBy();
  }

  handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var partnersDetails = Provider.of<Partner>(context);
    var myStories = Provider.of<MyStories>(context);
    var stories = Provider.of<MatchedStories>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    onSelectedIndex(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    onSelectedStoryIndex(int index) {
      setState(() {
        selectedStoryIndex = index;
      });
    }

    return SafeArea(
      child: Scaffold(
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
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: tr("Search..."),
                          hintStyle: TextStyle(color: borderLightColor),
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: borderLightColor),
                              borderRadius: BorderRadius.circular(7)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: borderLightColor),
                              borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.28,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                            scale: 1.8,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SwipeLeftAnimationRoute(
                                    widget: NotificationScreen()));
                          },
                          child: Image.asset(
                            "assets/icons/ic_bell.png",
                            scale: 1.8,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SwipeLeftAnimationRoute(
                                    widget: FilterScreen()));
                          },
                          child: Image.asset(
                            "assets/icons/ic_filter.png",
                            scale: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Stories
            Container(
              height: size.height * 0.065,
              padding: EdgeInsets.only(left: padding),
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SwipeLeftAnimationRoute(
                                  widget: GalleryStoryScreen(),
                                )).then((value){
                                  updateMyStories();
                                  updateStories();
                            });
                          },
                          child: Container(
                            height: size.height * 0.07,
                            width: size.height * 0.067,
                            margin: EdgeInsets.only(right: padding / 1.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor1,
                                width: 2,
                              ),
                              borderRadius:
                              BorderRadius.circular(size.height * 0.1),
                            ),
                            child: Icon(
                              Icons.add,
                              color: primaryColor1,
                              size: size.height * 0.03,
                            ),
                          ),
                        ),
                        if(myStories.myStories.isNotEmpty)
                          InkWell(
                          onTap: () {
                            Navigator.push(context,
                                SwipeUpAnimationRoute(widget: ViewMyStoryScreen(
                                  myStories: myStories,
                                  size: size,
                                )));
                          },
                          child: Container(
                            height: size.height * 0.07,
                            width: size.height * 0.067,
                            margin: EdgeInsets.only(right: padding / 1.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor1,
                                width: 2,
                              ),
                              borderRadius:
                              BorderRadius.circular(size.height * 0.1),
                            ),
                            child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(size.height * 0.1),
                                child: CachedNetworkImage(
                                  imageUrl: userDetails.profilePicture,
                                  fit: BoxFit.cover,
                                  height: size.height * 0.065,
                                  width: size.height * 0.065,
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
                                )
                            ),
                          ),
                        ),
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: stories.userStories.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    SwipeUpAnimationRoute(
                                      milliseconds: 200,
                                        widget: ViewStoryScreen(
                                      storyDetails: stories.userStories[index],
                                          size: size,
                                    )));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: size.height * 0.07,
                                    width: size.height * 0.067,
                                    margin: EdgeInsets.only(right: padding / 1.5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: stories.userStories[index].isSeen
                                            ? borderColor
                                            : primaryColor1,
                                        width: 2,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(size.height * 0.1),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(size.height * 0.1),
                                      child: CachedNetworkImage(
                                        imageUrl: stories.userStories[index].userDetails.profilePicture,
                                        fit: BoxFit.fill,
                                        height: size.height * 0.065,
                                        width: size.height * 0.065,
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
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              height: size.height * 0.053,
              width: double.infinity,
              padding: EdgeInsets.only(left: padding, bottom: 0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 2),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: tabs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: padding / 1,
                      top: padding / 1.8,
                      // bottom: padding / 2,
                    ),
                    child: InkWell(
                      onTap: () {
                        onSelectedIndex(index);
                        tabController.animateTo(index);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: padding / 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: selectedIndex == index
                                    ? primaryColor1
                                    : borderUltraLightColor,
                                width: selectedIndex == index ? 2 : 0),
                          ),
                        ),
                        child: VariableText(
                          text: tr(tabs[index]['name']),
                          fontFamily: fontSemiBold,
                          fontsize: size.height * 0.017,
                          fontcolor: selectedIndex == index
                              ? primaryColor1
                              : primaryColor2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              //height: 250,
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  partnersDetails.partners.isNotEmpty ?
                  RefreshIndicator(
                    onRefresh: (){
                      print("Refresh");
                      updateStories();
                      updateMyStories();
                      getMyLiked();
                      getLikedBy();
                      return updatePartnerList();
                    },
                    child: GridView.builder(
                        padding: EdgeInsets.all(padding / 2.2),
                        itemCount: partnersDetails.partners.length,
                        //shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: size.width * 0.03,
                          mainAxisSpacing: size.height * 0.02,
                          // childAspectRatio: 3,
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SwipeLeftAnimationRoute(
                                    widget: UserProfileScreen(
                                      userID: partnersDetails.partners[index].id,
                                    ),
                                  )).then((value){
                                updateStories();
                                updateMyStories();
                                getMyLiked();
                                getLikedBy();
                                updatePartnerList();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(0),
                              height: size.height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(size.height * 0.02),
                                /*image: DecorationImage(
                              image: AssetImage(personList[0]['image']),
                              fit: BoxFit.cover,
                            ),*/
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(size.height * 0.02),
                                    child: CachedNetworkImage(
                                      imageUrl: partnersDetails.partners[index]
                                          .profilePicture,
                                      fit: BoxFit.fill,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(padding / 2.2),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(size.height * 0.02),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3),
                                          child: VariableText(
                                            text: partnersDetails.partners[index].name + ", "+ getAge(partnersDetails.partners[index].dob),
                                            fontFamily: fontBold,
                                            fontsize: size.height * 0.019,
                                            fontcolor: textColorW,
                                            max_lines: 2,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            VariableText(
                                              text: partnersDetails.partners[index].username,
                                              fontFamily: fontRegular,
                                              fontsize: size.height * 0.015,
                                              fontcolor: textColorW,
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/ic_camera.png",
                                                    color: textColorW,
                                                    scale: 2.8,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: padding / 5),
                                                    child: VariableText(
                                                      text: partnersDetails.partners[index]
                                                          .userImages
                                                          .length.toString(),
                                                      fontFamily: fontRegular,
                                                      fontsize: size.height * 0.017,
                                                      fontcolor: textColorW,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ) :
                  RefreshIndicator(
                    onRefresh: (){
                      print("Refresh");
                      return updatePartnerList();
                    },
                    child: Stack(
                      children: [
                        ListView(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                VariableText(
                                  text: tr("No match yet!"),
                                  fontsize: size.height * 0.020,
                                  fontcolor: textColorB,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  likedBy.isNotEmpty ?
                  RefreshIndicator(
                    onRefresh: (){
                      print("Refresh");
                      return getLikedBy();
                    },
                    child: GridView.builder(
                        padding: EdgeInsets.all(padding / 2.2),
                        itemCount: likedBy.length,
                        //shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: size.width * 0.03,
                          mainAxisSpacing: size.height * 0.02,
                          // childAspectRatio: 3,
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, int index) {
                          return InkWell(
                            onTap: () {
                              /*Navigator.push(
                                  context,
                                  SwipeLeftAnimationRoute(
                                    widget: UserProfileScreen(
                                      userID: likedBy[index].id,
                                    ),
                                  ));*/
                            },
                            child: Container(
                              padding: EdgeInsets.all(0),
                              height: size.height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(size.height * 0.02),
                                /*image: DecorationImage(
                              image: AssetImage(personList[0]['image']),
                              fit: BoxFit.cover,
                            ),*/
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(size.height * 0.02),
                                    child: CachedNetworkImage(
                                      imageUrl: likedBy[index]
                                          .profilePicture,
                                      fit: BoxFit.fill,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(padding / 2.2),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(size.height * 0.02),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3),
                                          child: VariableText(
                                            text: likedBy[index].name + ", "+ getAge(likedBy[index].dob),
                                            fontFamily: fontBold,
                                            fontsize: size.height * 0.019,
                                            fontcolor: textColorW,
                                            max_lines: 2,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            VariableText(
                                              text: likedBy[index].username,
                                              fontFamily: fontRegular,
                                              fontsize: size.height * 0.015,
                                              fontcolor: textColorW,
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/ic_camera.png",
                                                    color: textColorW,
                                                    scale: 2.8,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: padding / 5),
                                                    child: VariableText(
                                                      text: likedBy[index]
                                                          .userImages
                                                          .length.toString(),
                                                      fontFamily: fontRegular,
                                                      fontsize: size.height * 0.017,
                                                      fontcolor: textColorW,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ) :
                  RefreshIndicator(
                    onRefresh: (){
                      print("Refresh");
                      return getLikedBy();
                    },
                    child: Stack(
                      children: [
                        ListView(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                VariableText(
                                  text: tr("No Likes yet!"),
                                  fontsize: size.height * 0.020,
                                  fontcolor: textColorB,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  myLiked.isNotEmpty ?
                  RefreshIndicator(
                    onRefresh: (){
                      print("Refresh");
                      return getMyLiked();
                    },
                    child: GridView.builder(
                        padding: EdgeInsets.all(padding / 2.2),
                        itemCount: myLiked.length,
                        //shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: size.width * 0.03,
                          mainAxisSpacing: size.height * 0.02,
                          // childAspectRatio: 3,
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, int index) {
                          return InkWell(
                            onTap: () {
                              /*Navigator.push(
                                  context,
                                  SwipeLeftAnimationRoute(
                                    widget: UserProfileScreen(
                                      userID: myLiked[index].id,
                                    ),
                                  ));*/
                            },
                            child: Container(
                              padding: EdgeInsets.all(0),
                              height: size.height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(size.height * 0.02),
                                /*image: DecorationImage(
                              image: AssetImage(personList[0]['image']),
                              fit: BoxFit.cover,
                            ),*/
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(size.height * 0.02),
                                    child: CachedNetworkImage(
                                      imageUrl: myLiked[index]
                                          .profilePicture,
                                      fit: BoxFit.fill,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(padding / 2.2),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(size.height * 0.02),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3),
                                          child: VariableText(
                                            text: myLiked[index].name + ", "+ getAge(myLiked[index].dob),
                                            fontFamily: fontBold,
                                            fontsize: size.height * 0.019,
                                            fontcolor: textColorW,
                                            max_lines: 2,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            VariableText(
                                              text: myLiked[index].username,
                                              fontFamily: fontRegular,
                                              fontsize: size.height * 0.015,
                                              fontcolor: textColorW,
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/ic_camera.png",
                                                    color: textColorW,
                                                    scale: 2.8,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: padding / 5),
                                                    child: VariableText(
                                                      text: myLiked[index]
                                                          .userImages
                                                          .length.toString(),
                                                      fontFamily: fontRegular,
                                                      fontsize: size.height * 0.017,
                                                      fontcolor: textColorW,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ) :
                  RefreshIndicator(
                    onRefresh: (){
                      print("Refresh");
                      return getMyLiked();
                    },
                    child: Stack(
                      children: [
                        ListView(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                VariableText(
                                  text: tr("No Likes yet!"),
                                  fontsize: size.height * 0.020,
                                  fontcolor: textColorB,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // DashBoard
          ],
        ),
      ),
    );
  }
}
