import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:marrimate/Screens/Dashboard/Chat/chatting_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/chat_model.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isLoading = false;
  List<ChatModel> allMessages = [];
  DateFormat chatTimeFormatter = DateFormat("hh:mm");
  Timer _timer;

  final interval = const Duration(seconds: 5);

  setLoading(bool loading){
    setState(() {
      isLoading =loading;
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

  getChatList()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getChatList(userDetails.accessToken);
    if(response != null){
      allMessages.clear();
      if(response['status']){
        for(var item in response['data']){
          if(item['user'] != null){
            allMessages.add(ChatModel.fromJson(item));
          }
        }

      }
      setLoading(false);
      startTimer();
    }else{
      allMessages.clear();
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }
  updateChatList()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getChatList(userDetails.accessToken);
    if(response != null){
      allMessages.clear();
      if(response['status']){
        for(var item in response['data']){
          if(item['user'] != null){
            allMessages.add(ChatModel.fromJson(item));
          }
        }
      }
      setState(() {});
    }else{
      _timer.cancel();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatePartnerList();
    getChatList();
  }

  startTimer([int milliseconds]) {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      if(mounted){
        updateChatList();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var partnersDetails = Provider.of<Partner>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return Scaffold(
      backgroundColor: textColorW,
      appBar: CustomAppBar(
        text: tr("Messages"),
        isBack: false,
        height: size.height * 0.085,
        isActionBar: false,
      ),
      body: Column(
        children: [
          // Matches
          if(partnersDetails.partners.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: padding - 7, horizontal: padding - 6),
            child: Row(
              children: [
                VariableText(
                  text: tr("Now matches"),
                  fontFamily: fontSemiBold,
                  fontcolor: primaryColor1,
                  fontsize: size.height * 0.022,
                ),
              ],
            ),
          ),
          if(partnersDetails.partners.isNotEmpty)
          Container(
            height: size.height * 0.07,
            //color: Colors.yellowAccent,
            padding: EdgeInsets.only(left: padding),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              //shrinkWrap: true,
              itemCount: partnersDetails.partners.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: padding / 1.5),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          SwipeLeftAnimationRoute(
                            widget: ChattingScreen(
                              partner: partnersDetails.partners[index],
                            ),
                          ));
                    },
                    child: Container(
                      width: size.width * 0.15,
                      decoration: BoxDecoration(
                        //color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: CachedNetworkImage(
                            imageUrl: partnersDetails.partners[index].profilePicture,
                            fit: BoxFit.cover,
                          ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Messages
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: padding - 7, horizontal: padding - 6),
            child: Row(
              children: [
                VariableText(
                  text: tr("Messages"),
                  fontFamily: fontSemiBold,
                  fontcolor: primaryColor1,
                  fontsize: size.height * 0.022,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: (){
                print("Refresh");
                return updatePartnerList();
              },
              child: ListView(
                children: [
                  Stack(
                    children: [
                      allMessages.isEmpty ?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              VariableText(
                                text: "No chat found",
                                fontcolor: textColorB,
                                fontsize: size.height * 0.020,
                              ),
                            ],
                          ),
                        ],
                      ) : ListView.builder(
                        itemCount: allMessages.length,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              _timer.cancel();
                              Navigator.push(
                                  context,
                                  SwipeLeftAnimationRoute(
                                    widget: ChattingScreen(partner: allMessages[index].receiverDetails),
                                  )).then((value){
                                updateChatList();
                                startTimer();
                              });
                            },
                            child: Container(
                              height: size.height * 0.12,
                              padding: EdgeInsets.symmetric(
                                vertical: padding / 10,
                              ),
                              child: Card(
                                color: Color(0xffF5F5F5),
                                elevation: 0,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: padding - 15,
                                      vertical: padding / 1.5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(size.height * 0.1),
                                        child: CachedNetworkImage(
                                          imageUrl: allMessages[index].receiverDetails.profilePicture,
                                          fit: BoxFit.cover,
                                          //height: size.height * 0.065,
                                          width: size.height * 0.065,
                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                              Padding(
                                                padding: const EdgeInsets.all(45.0),
                                                child: CircularProgressIndicator(value: downloadProgress.progress, color: primaryColor2),
                                              ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        )
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
                                              Row(
                                                children: [
                                                  VariableText(
                                                    text: allMessages[index].receiverDetails.name,
                                                    fontFamily: fontMedium,
                                                    fontcolor: textColorB,
                                                    fontsize: size.height * 0.019,
                                                  ),
                                                  SizedBox(width: size.width * 0.02),
                                                  if(!allMessages[index].isSeen &&
                                                      allMessages[index].senderID != userDetails.id.toString())
                                                    Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.circular(90)
                                                      ),
                                                    )
                                                ],
                                              ),
                                              if(!allMessages[index].isSeen)
                                                SizedBox(height: size.height * 0.004),

                                              allMessages[index].isSeen ?
                                                allMessages[index].senderID == userDetails.id.toString() ?
                                                VariableText(
                                                  text: "You: "+ renderLastMessage(allMessages[index]),
                                                  fontFamily: fontRegular,
                                                  fontcolor: textColorG,
                                                  fontsize: size.height * 0.017,
                                                  max_lines: 2,
                                                ) :
                                                VariableText(
                                                  text: renderLastMessage(allMessages[index]),
                                                  fontFamily: fontRegular,
                                                  fontcolor: textColorG,
                                                  fontsize: size.height * 0.017,
                                                  max_lines: 2,
                                                ) :
                                                allMessages[index].senderID == userDetails.id.toString() ?
                                                VariableText(
                                                  text: "You: "+ renderLastMessage(allMessages[index]),
                                                  fontFamily: fontRegular,
                                                  fontcolor: textColorG,
                                                  fontsize: size.height * 0.017,
                                                  max_lines: 2,
                                                ) :
                                                VariableText(
                                                  text: renderLastMessage(allMessages[index]),
                                                  fontFamily: fontRegular,
                                                  fontcolor: primaryColor1,
                                                  fontsize: size.height * 0.017,
                                                  max_lines: 2,
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                      VariableText(
                                        text: chatTimeFormatter.format(DateTime.parse(allMessages[index].dateTime)),
                                        fontFamily: fontRegular,
                                        fontcolor: textColorG,
                                        fontsize: size.height * 0.017,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if(isLoading) ProcessLoadingWhite()
                    ],
                  ),
                ],
              ),
            ),
          ),
          /*Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding - 6),
              child: RefreshIndicator(
                onRefresh: (){
                  print("Refresh");
                  return updatePartnerList();
                },
                child: ListView.builder(
                  itemCount: 0,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            SwipeLeftAnimationRoute(
                              widget: ChattingScreen(),
                            ));
                      },
                      child: Container(
                        height: size.height * 0.13,
                        padding: EdgeInsets.symmetric(
                          vertical: padding / 10,
                        ),
                        child: Card(
                          color: Color(0xffF5F5F5),
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: padding - 15,
                                vertical: padding / 1.5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(size.height * 0.1),
                                  child: Image.asset(
                                    "assets/images/dummy_profile.png",
                                    fit: BoxFit.fill,
                                    height: size.height * 0.065,
                                    width: size.height * 0.065,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: padding - 6),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        VariableText(
                                          text: "Esther Howard",
                                          fontFamily: fontMedium,
                                          fontcolor: textColorB,
                                          fontsize: size.height * 0.019,
                                        ),
                                        SizedBox(height: size.height * 0.004),
                                        VariableText(
                                          text: "Hi there,hope you will be fine",
                                          fontFamily: fontRegular,
                                          fontcolor: textColorG,
                                          fontsize: size.height * 0.017,
                                          max_lines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                VariableText(
                                  text: "10:55",
                                  fontFamily: fontRegular,
                                  fontcolor: textColorG,
                                  fontsize: size.height * 0.017,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  String renderLastMessage(ChatModel chatDetails){
    switch(chatDetails.type){
      case "text":
        return chatDetails.content;
      case "image":
        return "File";
      case "voice":
        return "Voice Note";
      case "quiz":
        return "Quiz";
    }
  }

}
