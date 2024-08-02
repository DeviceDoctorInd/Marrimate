import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/leaderboard_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>{

  List<Leaderboard> leaderboardList = [];
  bool isLoading = false;
  //TabController _controller;

  Leaderboard goldCandidate;
  Leaderboard silverCandidate;
  Leaderboard bronzeCandidate;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  getLeaderboard()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getLeaderboard(userDetails);
    if(response != null){
      if(response['status']){
        for(var item in response['data']){
          leaderboardList.add(Leaderboard.fromJson(item));
        }
        getWinners();
      }else{
        leaderboardList.clear();
        setLoading(false);
      }
    }else{
      leaderboardList.clear();
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);

    }
  }

  getWinners(){
    int gold = 0;
    for(var item in leaderboardList){
      if(int.parse(item.score) > gold){
        gold = int.parse(item.score);
        goldCandidate = item;
      }
    }
    print(goldCandidate.score);
    int goldScore = int.parse(goldCandidate.score);
    int silver = 0;
    for(var item in leaderboardList){
      if(int.parse(item.score) < goldScore && int.parse(item.score) > silver){
        silver = int.parse(item.score);
        silverCandidate = item;
      }
    }
    if(silverCandidate != null){
      print(silverCandidate.score);
      int silverScore = int.parse(silverCandidate.score);
      int bronze = 0;
      for(var item in leaderboardList){
        if(int.parse(item.score) < silverScore && int.parse(item.score) > bronze){
          bronze = int.parse(item.score);
          bronzeCandidate = item;
        }
      }
      //print(bronzeCandidate.score);
    }
    setLoading(false);
    //print(goldCandidate.score);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeaderboard();
    //_controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Scaffold(
        backgroundColor: textColorW,
        appBar: CustomAppBar(
          text: tr("Leaderboard"),
          isBack: true,
          actionImage: "assets/icons/ic_more_option.png",
          height: size.height * 0.085,
          isActionBar: false,
        ),
        body: isLoading ? ProcessLoadingWhite() :
        Container(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Image.asset(
                "assets/images/leaderboard.png",
                fit: BoxFit.fill,
                height: size.height * 0.45,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.32,
                      //color: Colors.redAccent,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: size.height * 0.15,
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        "assets/images/leaderboard_silver.png",
                                      ),
                                      if(silverCandidate != null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.022,
                                          top: size.height * 0.009
                                        ),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(200),
                                            child: CachedNetworkImage(
                                              imageUrl: silverCandidate.profileImage,
                                              fit: BoxFit.cover,
                                              height: size.height * 0.095,
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
                                ),
                                SizedBox(
                                  height: size.height * 0.21,
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        "assets/images/leaderboard_gold.png",
                                      ),
                                      if(goldCandidate != null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.026,
                                            top: size.height * 0.008
                                        ),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(200),
                                            child: CachedNetworkImage(
                                              imageUrl: goldCandidate.profileImage,
                                              fit: BoxFit.cover,
                                              height: size.height * 0.14,
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
                                ),
                                SizedBox(
                                  height: size.height * 0.15,
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        "assets/images/leaderboard_bronze.png",
                                      ),
                                      if(bronzeCandidate != null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.024,
                                            top: size.height * 0.008
                                        ),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(200),
                                            child: CachedNetworkImage(
                                              imageUrl: bronzeCandidate.profileImage,
                                              fit: BoxFit.cover,
                                              height: size.height * 0.095,
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: 10),
                    leaderboardList.isEmpty ?
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              VariableText(
                                text: tr("No Record Found"),
                                fontFamily: fontSemiBold,
                                fontcolor: textColorG,
                                fontsize: size.height * 0.020,
                                overflow: TextOverflow.ellipsis,
                                max_lines: 2,
                              ),
                            ],
                          ),
                        ) :
                    Expanded(
                      child: ListView.builder(
                        itemCount: leaderboardList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [primaryColor2, primaryColor1]),
                              border: Border.all(
                                  color: borderLightColor.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: padding / 3,
                                vertical: padding / 4),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: size.height * 0.085,
                            width: 80,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: leaderboardList[index].profileImage,
                                    fit: BoxFit.cover,
                                    height: size.height * 0.06,
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
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: size.height * 0.006),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0),
                                          child: VariableText(
                                            text: leaderboardList[index].name,
                                            fontFamily: fontSemiBold,
                                            fontcolor: textColorW,
                                            fontsize: size.height * 0.020,
                                            overflow: TextOverflow.ellipsis,
                                            max_lines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                VariableText(
                                  text: "${leaderboardList[index].score}%",
                                  fontFamily: fontSemiBold,
                                  fontcolor: textColorW,
                                  fontsize: size.height * 0.028,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    /*TabBar(
                      indicatorColor: primaryColor2,
                      controller: _controller,
                      tabs: [
                        Tab(
                          child: VariableText(
                            text: "National",
                            fontFamily: fontBold,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.024,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Tab(
                          child: VariableText(
                            text: "International",
                            fontFamily: fontBold,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.024,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 2,
                      child: TabBarView(
                        controller: _controller,
                        children: [
                          ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [primaryColor2, primaryColor1]),
                                  border: Border.all(
                                      color: borderLightColor.withOpacity(0.5),
                                      width: 1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: padding / 3,
                                    vertical: padding / 4),
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                height: size.height * 0.1,
                                width: 80,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                        "assets/images/dummy_profile.png",
                                        fit: BoxFit.fill,
                                        height: size.height * 0.08,
                                        width: size.height * 0.08,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: size.height * 0.006),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: VariableText(
                                                text: "Myley Carbyn",
                                                fontFamily: fontSemiBold,
                                                fontcolor: textColorW,
                                                fontsize: size.height * 0.017,
                                                overflow: TextOverflow.ellipsis,
                                                max_lines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    VariableText(
                                      text: "1100",
                                      fontFamily: fontSemiBold,
                                      fontcolor: textColorW,
                                      fontsize: size.height * 0.028,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, left: 3),
                                      child: Image.asset(
                                        "assets/images/coin.png",
                                        fit: BoxFit.fill,
                                        height: size.height * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [primaryColor2, primaryColor1]),
                                  border: Border.all(
                                      color: borderLightColor.withOpacity(0.5),
                                      width: 1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: padding / 3,
                                    vertical: padding / 4),
                                padding: EdgeInsets.all(5),
                                height: size.height * 0.11,
                                width: 80,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: borderLightColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.asset(
                                          "assets/images/dummy_profile.png",
                                          fit: BoxFit.fill,
                                          height: size.height * 0.06,
                                          width: size.height * 0.07,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: size.height * 0.006),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: VariableText(
                                                  text: "Myley Carbyn",
                                                  fontFamily: fontSemiBold,
                                                  fontcolor: textColorW,
                                                  fontsize: size.height * 0.017,
                                                  overflow: TextOverflow.ellipsis,
                                                  max_lines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      VariableText(
                                        text: "1100",
                                        fontFamily: fontSemiBold,
                                        fontcolor: textColorW,
                                        fontsize: size.height * 0.028,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 3.0, left: 3),
                                        child: Image.asset(
                                          "assets/images/coin.png",
                                          fit: BoxFit.fill,
                                          height: size.height * 0.02,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),*/
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
