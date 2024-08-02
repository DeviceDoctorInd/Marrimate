import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Settings/Gift/gift_detail_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/gift_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class GiftScreen extends StatefulWidget {
  const GiftScreen({Key key}) : super(key: key);

  @override
  _GiftScreenState createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {

  List<Gift> allGifts = [];
  bool isLoading = true;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  getAllGifts()async{
    setLoading(true);
    var response = await API.getAllGifts();
    if(response != null){
      if(response['status']){
        for(var item in response['data']){
          allGifts.add(Gift.fromJson(item));
        }
        setLoading(false);
      }else{
        allGifts.clear();
        setLoading(false);
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllGifts();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Scaffold(
        appBar: CustomSimpleAppBar(
          text: tr("Gifts"),
          isBack: false,
          height: size.height * 0.085,
        ),
        body: SingleChildScrollView(
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
              isLoading ?
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: padding / 4),
                itemCount: 6,
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
              ) :
              allGifts.isNotEmpty ?
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: padding / 4),
                itemCount: allGifts.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          SwipeLeftAnimationRoute(widget: GiftDetailScreen(
                            giftDetails: allGifts[index],
                          )));
                    },
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CachedNetworkImage(
                            imageUrl: allGifts[index].mainImage,
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
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: padding / 2.2, top: 8),
                                    child: VariableText(
                                      text: allGifts[index].name,
                                      fontFamily: fontBold,
                                      fontsize: size.height * 0.017,
                                      fontcolor: textColorB,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: padding / 2.2),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/coin.png",
                                      scale: 1.5,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    VariableText(
                                      text: "x"+allGifts[index].price,
                                      fontFamily: fontRegular,
                                      fontsize: size.height * 0.017,
                                      fontcolor: textColorG,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ) :
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.10),
                child: VariableText(
                  text: tr("No gifts found"),
                  fontcolor: textColorB,
                  fontsize: size.height * 0.021,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
