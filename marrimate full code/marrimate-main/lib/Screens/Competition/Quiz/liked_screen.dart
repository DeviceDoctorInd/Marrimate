import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/Dashboard/Chat/chatting_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/quiz_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:provider/provider.dart';

class LikedScreen extends StatefulWidget {
  Quiz quizDetails;
  LikedScreen({Key key, this.quizDetails}) : super(key: key);

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {

  TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  List<UserModel> searchedPartners = [];


  searchPartners(String searchText) {
    var partner = Provider.of<Partner>(context, listen: false).partners;
    if(searchText.isNotEmpty){
      setState(() {
        isSearching = true;
      });
    }else{
      setState(() {
        isSearching = false;
      });
    }
    searchedPartners.clear();
    for (int i = 0; i < partner.length; i++) {
      String data = partner[i].name;
      if (data.toLowerCase().contains(searchText.toLowerCase())) {
        searchedPartners.addAll([partner[i]]);
      }
    }
    setState(() {});
    print("result is: " + searchedPartners.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    var partner = Provider.of<Partner>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Scaffold(
        backgroundColor: textColorW,
        appBar: CustomSimpleAppBar(
          text: tr("Matched"),
          isBack: false,
          height: size.height * 0.085,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: padding,
                  bottom: padding - 7,
                  left: padding - 6,
                  right: padding - 6),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) => searchPartners(value),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: tr("Search..."),
                  hintStyle: TextStyle(color: borderLightColor),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderLightColor),
                      borderRadius: BorderRadius.circular(7)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderLightColor),
                      borderRadius: BorderRadius.circular(7)),
                ),
              ),
            ),
            partner.partners.isNotEmpty ?
                isSearching ?
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding - 6),
                    child: ListView.builder(
                      itemCount: searchedPartners.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChattingScreen(
                                      partner: searchedPartners[index],
                                      shareQuiz: true,
                                      quizID: widget.quizDetails.id,
                                    )));
                          },
                          child: Container(
                            height: size.height * 0.12,
                            child: Card(
                              color: Color(0xffF5F5F5),
                              elevation: 0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: padding / 1.2,
                                    vertical: padding / 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(size.height * 0.1),
                                        child: CachedNetworkImage(
                                          imageUrl: searchedPartners[index].profilePicture,
                                          height: size.height * 0.065,
                                          width: size.height * 0.065,
                                          fit: BoxFit.cover,
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            VariableText(
                                              text: searchedPartners[index].name,
                                              fontFamily: fontMedium,
                                              fontcolor: textColorB,
                                              fontsize: size.height * 0.019,
                                            ),
                                          ],
                                        ),
                                      ),
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
                ) :
                Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding - 6),
                child: ListView.builder(
                  itemCount: partner.partners.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChattingScreen(
                                  partner: partner.partners[index],
                                  shareQuiz: true,
                                  quizID: widget.quizDetails.id,
                                )));
                      },
                      child: Container(
                        height: size.height * 0.12,
                        child: Card(
                          color: Color(0xffF5F5F5),
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: padding / 1.2,
                                vertical: padding / 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(size.height * 0.1),
                                  child: CachedNetworkImage(
                                    imageUrl: partner.partners[index].profilePicture,
                                    height: size.height * 0.065,
                                    width: size.height * 0.065,
                                    fit: BoxFit.cover,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        VariableText(
                                          text: partner.partners[index].name,
                                          fontFamily: fontMedium,
                                          fontcolor: textColorB,
                                          fontsize: size.height * 0.019,
                                        ),
                                      ],
                                    ),
                                  ),
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
            )
                :
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VariableText(
                    text: tr("No match yet!"),
                    fontcolor: textColorB,
                    fontsize: size.height * 0.020,
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
