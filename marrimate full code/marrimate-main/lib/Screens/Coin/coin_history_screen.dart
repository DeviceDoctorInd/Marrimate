import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Dashboard/Chat/chatting_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/coin_history_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class CoinHistoryScreen extends StatefulWidget {
  const CoinHistoryScreen({Key key}) : super(key: key);

  @override
  State<CoinHistoryScreen> createState() => _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen> {
  List<CoinHistory> history = [];

  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  getHistory()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getCoinsHistory(userDetails);
    if(response != null){
      if(response['status']){
        for(var item in response['history']){
          history.add(CoinHistory.fromJson(item));
        }
        setLoading(false);
      }else{
        history.clear();
        setLoading(false);
      }
    }else{
      history.clear();
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
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Scaffold(
        backgroundColor: textColorW,
        appBar: CustomSimpleAppBar(
          text: tr("Coin History"),
          isBack: false,
          height: size.height * 0.085,
        ),
        body: isLoading ? ProcessLoadingWhite() :
        history.isNotEmpty ?
        Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            itemCount: history.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: borderLightColor.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: padding / 3, vertical: padding / 4),
                padding: EdgeInsets.all(10),
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
                        child: CachedNetworkImage(
                          height: size.height * 0.06,
                          width: size.height * 0.07,
                          imageUrl: userDetails.id.toString() == history[index].sendTo ?
                          userDetails.profilePicture : history[index].profilePicture,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress){
                            return Padding(
                              padding: const EdgeInsets.all(45.0),
                              child: CircularProgressIndicator(value: downloadProgress.progress, color: primaryColor2),
                            );
                          },
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //SizedBox(height: size.height * 0.004),
                              userDetails.id.toString() == history[index].sendTo ?
                              VariableText(
                                text: "${history[index].name} send you coins.",
                                fontFamily: fontSemiBold,
                                fontcolor: textColorB.withOpacity(0.8),
                                fontsize: size.height * 0.015,
                                overflow: TextOverflow.ellipsis,
                                max_lines: 2,
                              ) :
                              VariableText(
                                text: "You send coins to ${history[index].name}",
                                fontFamily: fontSemiBold,
                                fontcolor: textColorB.withOpacity(0.8),
                                fontsize: size.height * 0.015,
                                overflow: TextOverflow.ellipsis,
                                max_lines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      VariableText(
                        text: history[index].coinsSent,
                        fontFamily: fontSemiBold,
                        fontcolor: textColorG,
                        fontsize: size.height * 0.028,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 3),
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
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: size.height * 0.40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VariableText(
                  text: tr("No Record Found"),
                  fontFamily: fontSemiBold,
                  fontsize: size.height * 0.020,
                  fontcolor: textColorG,
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
