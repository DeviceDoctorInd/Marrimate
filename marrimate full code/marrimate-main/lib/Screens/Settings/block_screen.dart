import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class BlockScreen extends StatefulWidget {
  const BlockScreen({Key key}) : super(key: key);

  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  bool isLoading = false;
  bool isMainLoading = false;

  List<UserModel> blockedUser = [];

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

  getBlockedUser()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    setMainLoading(true);
    var response = await API.getBlockedUser(userDetails.accessToken);
    if(response != null){
      blockedUser.clear();
      print(response.toString());
      for(var item in response['data']){
        blockedUser.add(UserModel.fromMatchedJson(item));
      }
      setMainLoading(false);
    }else{
      blockedUser.clear();
      setMainLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  unblockUser(int userID)async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.unBlockUser(userID, userDetails.accessToken);
    if(response != null){
      if(response['status']){
        blockedUser.removeWhere((element) => element.id == userID);
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Unblocked Successfully",
            toastLength: Toast.LENGTH_SHORT);
      }else{
        setLoading(false);
        Fluttertoast.showToast(
            msg: response['status'].toString(),
            toastLength: Toast.LENGTH_SHORT);
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
    getBlockedUser();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: textColorW,
            appBar: CustomSimpleAppBar(
              text: tr("Blocking"),
              isBack: false,
              height: size.height * 0.085,
            ),
            body: isMainLoading ? Stack(
              children: [
                ProcessLoadingWhite()
              ],
            ) :
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: padding - 7, left: padding - 6),
                  child: Row(
                    children: [
                      VariableText(
                        text: "Block People",
                        fontFamily: fontSemiBold,
                        fontcolor: primaryColor2,
                        fontsize: size.height * 0.022,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: padding / 3, bottom: padding / 2, left: padding - 6),
                  child: VariableText(
                    text:
                        "Once you block someone, that person can no longer se things you post on your timeline or any other activity",
                    fontFamily: fontSemiBold,
                    fontcolor: textColorG,
                    fontsize: size.height * 0.018,
                    max_lines: 3,
                  ),
                ),
                blockedUser.isNotEmpty ?
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding - 6),
                    child: ListView.builder(
                      itemCount: blockedUser.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          height: size.height * 0.10,
                          child: Card(
                            color: Color(0xffF5F5F5),
                            elevation: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding - 15, vertical: padding / 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(size.height * 0.2),
                                    child: CachedNetworkImage(
                                      imageUrl: blockedUser[index].profilePicture,
                                      fit: BoxFit.fill,
                                      height: size.width * 0.13,
                                      width: size.width * 0.13,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: padding - 6),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          VariableText(
                                            text: blockedUser[index].name,
                                            fontFamily: fontMedium,
                                            fontcolor: textColorB,
                                            fontsize: size.height * 0.019,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      unblockUser(blockedUser[index].id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: VariableText(
                                        text: "Unblock",
                                        fontFamily: fontBold,
                                        fontcolor: textColorG,
                                        fontsize: size.height * 0.017,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ) :
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VariableText(
                        text: "No User Found",
                        fontFamily: fontMedium,
                        fontcolor: primaryColor2,
                        fontsize: size.height * 0.020,
                      ),
                    ],
                  ),
                ),
                /*Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: padding * 4, vertical: padding / 2),
                  child: MyButton(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     SwipeLeftAnimationRoute(
                      //       widget: SexualOrientationScreen(),
                      //     ));
                    },
                    btnTxt: "Save",
                    borderColor: primaryColor2,
                    btnColor: primaryColor2,
                    txtColor: textColorW,
                    btnRadius: 25,
                    btnWidth: size.width * 0.75,
                    btnHeight: 50,
                    fontSize: size.height * 0.020,
                    weight: FontWeight.w700,
                    fontFamily: fontSemiBold,
                  ),
                )*/
              ],
            ),
          ),
          if(isLoading) ProcessLoadingLight()
        ],
      ),
    );
  }
}
