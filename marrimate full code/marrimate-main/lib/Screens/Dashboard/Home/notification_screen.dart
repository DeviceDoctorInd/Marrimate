import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Dashboard/Dashboard/user_profile_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/notification_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  List<MyNotification> allNotifications = [];
  bool isLoading = false;
  bool isLoadingMain = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }
  setLoadingMain(bool loading){
    setState(() {
      isLoadingMain = loading;
    });
  }

  getAllNotifications()async{
    setLoadingMain(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getAllNotifications(userDetails);
    if(response != null){
      if(response['status']){
        for(var item in response['data']){
          allNotifications.add(MyNotification.fromJson(item));
        }
        setLoadingMain(false);
      }else{
        allNotifications.clear();
        setLoadingMain(false);
      }
    }else{
      allNotifications.clear();
      setLoadingMain(false);
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  readNotification(MyNotification notificationDetails)async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    if(!notificationDetails.isRead)
      var response = await API.readNotification(notificationDetails.id, userDetails);
    setLoading(false);
    Navigator.push(
        context,
        SwipeLeftAnimationRoute(
          widget: UserProfileScreen(
            userID: notificationDetails.userID,
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNotifications();
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
              text: tr("Notifications"),
              isBack: false,
              height: size.height * 0.085,
            ),
            body: isLoadingMain ? ProcessLoadingWhite() :
            allNotifications.isEmpty ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VariableText(
                      text: tr("No Notification Found"),
                      fontFamily: fontSemiBold,
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                    ),
                  ],
                ),
              ],
            ) :
            Container(
              width: size.width,
              height: size.height,
              child: ListView.builder(
                itemCount: allNotifications.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      readNotification(allNotifications[index]);
                      allNotifications[index].isRead = true;
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: borderLightColor.withOpacity(0.5), width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: padding / 2, vertical: padding / 4),
                      padding: EdgeInsets.all(6),
                      //height: size.height * 0.13,
                      //width: 80,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: allNotifications[index].isRead ? borderLightColor.withOpacity(0) : borderLightColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: allNotifications[index].profileImage,
                                fit: BoxFit.fill,
                                height: size.height * 0.07,
                                width: size.height * 0.07,
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
                              child: Padding(padding: EdgeInsets.all(8),
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                VariableText(
                                  text: allNotifications[index].title,
                                  fontFamily: fontBold,
                                  fontcolor: textColorB,
                                  fontsize: size.height * 0.017,
                                ),
                                SizedBox(height: size.height * 0.004),
                                VariableText(
                                  text: allNotifications[index].content,
                                  fontFamily: fontRegular,
                                  fontcolor: textColorB.withOpacity(0.8),
                                  fontsize: size.height * 0.015,
                                  max_lines: 3,
                                ),
                              ],
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
          ),
          if(isLoading) ProcessLoadingLight()
        ],
      ),
    );
  }
}
