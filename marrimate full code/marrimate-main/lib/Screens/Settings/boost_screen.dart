import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/LoginRegistration/sexual_orientation_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/boosters_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:marrimate/services/paypal_api.dart';
import 'package:provider/provider.dart';

import 'booster_success_screen.dart';

class BoostScreen extends StatefulWidget {
  const BoostScreen({Key key}) : super(key: key);

  @override
  State<BoostScreen> createState() => _BoostScreenState();
}

class _BoostScreenState extends State<BoostScreen> {
  int selectedBooster;
  int selectedIndex;

  bool isLoadingMain = false;
  bool isLoadingPayment = false;
  List<Booster> allBoosters = [];
  Map transactionData;
  String transactionID;

  List<Map<String, dynamic>> subscriptionsList = [
    {
      "subtitle": "Unlimited likes & more"
    },
    {
      "subtitle": "See who likes & more"
    },
    {
      "subtitle": "Priority likes, see who likes you"
    },
    {
      "subtitle": "Invisibility, Priority likes & more"
    },
  ];

  setLoadingMain(bool loading){
    setState(() {
      isLoadingMain = loading;
    });
  }
  setLoadingPayment(bool loading){
    setState(() {
      isLoadingPayment = loading;
    });
  }

  getAllBoosters()async{
    setLoadingMain(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getAllBoosters(userDetails);
    if(response != null){
      if(response['status']){
        for(var item in response['data']){
          allBoosters.add(Booster.fromJson(item));
        }
        setLoadingMain(false);
      }else{
        allBoosters.clear();
        setLoadingMain(false);
      }
    }else{
      setLoadingMain(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  updateBooster(Booster boosterDetails)async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.updateBooster(
        boosterID: boosterDetails.id,
        transactionID: transactionID,
        userDetails: userDetails
    );
    if(response != null){
      if(response['status']){
        Provider.of<UserModel>(context, listen: false).updateUserBooster(boosterDetails, response['data']['updated_at']);
        setLoadingPayment(false);
        Navigator.push(
          context,
          SwipeLeftAnimationRoute(
            milliseconds: 200,
            widget: BoosterSuccessScreen(
              boosterDetails: boosterDetails,
            ),
          ),
        );
      }else{
        setLoadingPayment(false);
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_LONG);
      }
    }else{
      setLoadingPayment(false);
      Fluttertoast.showToast(
          msg: "Something went wrong, Please contact Admin",
          toastLength: Toast.LENGTH_LONG);
    }
  }

  processPaypal(Booster boosterDetails){
    setLoadingPayment(true);
    transactionData = null;
    transactionID = null;
    Navigator.push(
      context,
      SwipeLeftAnimationRoute(
        milliseconds: 200,
        widget: UsePaypal(
            sandboxMode: true,
            clientId: PaypalApi.clientId,
            secretKey: PaypalApi.secret,
            returnURL: PaypalApi.returnUrl,
            cancelURL: PaypalApi.cancelUrl,
            transactions: [
              {
                "amount": {
                  "total": boosterDetails.price,
                  "currency": "USD",

                  "details": {
                    "subtotal": boosterDetails.price,
                  }
                },
                "description": "The payment for buying merrimate Profile Booster",
                "item_list": {
                  "items": [
                    {
                      "name": boosterDetails.boosterName,
                      "quantity": 1,
                      "price": boosterDetails.price,
                      "currency": "USD"
                    },
                  ]
                }
              }
            ],
            note: "Contact us for any questions on your subscription.",
            onSuccess: (Map params)async{
              transactionData = params;
              transactionID = transactionData['data']['transactions'][0]['related_resources'][0]['sale']['id'].toString();
              //Navigator.of(context).pop();
              //setLoadingMain(true);
              //printWrapped(params.toString());
              //print("onSuccess: ${params['data']}");
              print("onSuccess: $transactionID");
              Future.delayed(Duration(seconds: 2)).then((value){
                updateBooster(boosterDetails);
              });
            },
            onError: (error) {
              //ngMain(false);
              setLoadingPayment(false);
              print("onError: $error");
              Fluttertoast.showToast(
                  msg: "Transaction Failed",
                  toastLength: Toast.LENGTH_SHORT);
            },
            onCancel: (params) {
              setLoadingPayment(false);
              print('cancelled: $params');
            }
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBoosters();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context, listen: true);
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.06;

    onSelectedIndex(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: textColorW,
            appBar: CustomSimpleAppBar(
              text: tr("Boost"),
              isBack: true,
              height: size.height * 0.085,
            ),
            body: isLoadingMain ? ProcessLoadingWhite() :
            Container(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                    child: Row(
                      children: [
                        VariableText(
                          text: "Profile Boosters",
                          fontFamily: fontSemiBold,
                          fontcolor: primaryColor1,
                          fontsize: size.height * 0.036,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  if(userDetails.userBooster.boosterID != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                      child: Row(
                        children: [
                          VariableText(
                            text: "Active Booster: ",
                            fontFamily: fontSemiBold,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.022,
                            textAlign: TextAlign.left,
                          ),
                          VariableText(
                            text: allBoosters.firstWhere((element) => element.id == userDetails.userBooster.boosterID).boosterName.toString() + " Booster",
                            fontFamily: fontSemiBold,
                            fontcolor: primaryColor1,
                            fontsize: size.height * 0.022,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                    child: Row(
                      children: [
                        VariableText(
                          text: "Select Your Booster",
                          fontFamily: fontSemiBold,
                          fontcolor: primaryColor2,
                          fontsize: size.height * 0.026,
                          textAlign: TextAlign.center,
                          max_lines: 2,
                          line_spacing: size.height * 0.0017,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Expanded(
                    // height: size.height * 0.55,
                    child: ListView.builder(
                        itemCount: allBoosters.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: ()async{
                              onSelectedIndex(index);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: textColorW,
                                        borderRadius: BorderRadius.circular(size.height * 0.01)),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.1, vertical: size.height * 0.30),
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: size.height * 0.03, vertical: size.height * 0.01),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: size.height * 0.15,
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [primaryColor1, primaryColor2],
                                            ),
                                            // color: primaryColor1.withOpacity(0.1),
                                            // border: Border.all(color: primaryColor2),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(size.height * 0.01),
                                                topRight: Radius.circular(size.height * 0.01)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              VariableText(
                                                text: "${allBoosters[index].boosterName} Booster",
                                                fontFamily: fontBold,
                                                fontsize: size.height * 0.022,
                                                fontcolor: textColorW,
                                                textAlign: TextAlign.left,
                                              ),
                                              Container(
                                                height: size.height * 0.045,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  "assets/icons/ic_heart_fill.png",
                                                  scale: 2.5,
                                                ),
                                              ),
                                              VariableText(
                                                text: "1 Free Boost Every Month",
                                                fontFamily: fontSemiBold,
                                                fontsize: size.height * 0.015,
                                                fontcolor: textColorW,
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(top: 10),
                                                width: size.width * 0.24,
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.topCenter,
                                                      child: Image.asset("assets/images/package_border.png"),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          VariableText(
                                                            text: "1",
                                                            fontFamily: fontBold,
                                                            fontsize: size.height * 0.033,
                                                            fontcolor: primaryColor1,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                          VariableText(
                                                            text: "Month",
                                                            fontFamily: fontBold,
                                                            fontsize: size.height * 0.017,
                                                            fontcolor: primaryColor1,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                          VariableText(
                                                            text: "\$ ${allBoosters[index].price.toStringAsFixed(2)}/mo",
                                                            fontFamily: fontRegular,
                                                            fontsize: size.height * 0.014,
                                                            fontcolor: primaryColor1,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              /*Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1, vertical: 1),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor1, primaryColor2],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(size.height * 0.01),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      VariableText(
                                        text: "6",
                                        fontFamily: fontBold,
                                        fontsize: size.height * 0.03,
                                        fontcolor: primaryColor2,
                                        textAlign: TextAlign.left,
                                      ),
                                      VariableText(
                                        text: "months",
                                        fontFamily: fontBold,
                                        fontsize: size.height * 0.017,
                                        fontcolor: primaryColor2,
                                        textAlign: TextAlign.left,
                                      ),
                                      VariableText(
                                        text: "\$ 23.00/mo",
                                        fontFamily: fontRegular,
                                        fontsize: size.height * 0.014,
                                        fontcolor: primaryColor2,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 5,
                                  width: size.width * 0.12,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.03),
                                  decoration: BoxDecoration(
                                    // color: Colors.yellow,
                                    gradient: LinearGradient(
                                      colors: [primaryColor1, primaryColor2],
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(size.height * 0.01),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1, vertical: 1),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor1, primaryColor2],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(size.height * 0.01),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      VariableText(
                                        text: "1",
                                        fontFamily: fontBold,
                                        fontsize: size.height * 0.03,
                                        fontcolor: primaryColor2,
                                        textAlign: TextAlign.left,
                                      ),
                                      VariableText(
                                        text: "months",
                                        fontFamily: fontBold,
                                        fontsize: size.height * 0.017,
                                        fontcolor: primaryColor2,
                                        textAlign: TextAlign.left,
                                      ),
                                      VariableText(
                                        text: "\$ 23.00/mo",
                                        fontFamily: fontRegular,
                                        fontsize: size.height * 0.014,
                                        fontcolor: primaryColor2,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 5,
                                  width: size.width * 0.12,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.03),
                                  decoration: BoxDecoration(
                                    // color: Colors.yellow,
                                    gradient: LinearGradient(
                                      colors: [primaryColor1, primaryColor2],
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(size.height * 0.01),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*/
                                            ],
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: (){
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Container(
                                              height: 35,
                                              width: size.width * 0.40,
                                              margin: EdgeInsets.all(size.height * 0.015),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [primaryColor1, primaryColor2],
                                                ),
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              child: Center(
                                                child: VariableText(
                                                  text: "Continue",
                                                  fontsize: size.height * 0.020,
                                                  fontcolor: textColorW,
                                                  weight: FontWeight.w700,
                                                  fontFamily: fontSemiBold,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).then((value){
                                if(value != null){
                                  if(value){
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: textColorW,
                                              borderRadius: BorderRadius.circular(size.height * 0.02)),
                                          margin: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.35),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.height * 0.02, vertical: size.height * 0.01),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              VariableText(
                                                text: "CONTINUE WITH PAYMENT",
                                                fontFamily: fontBold,
                                                fontsize: size.height * 0.021,
                                                fontcolor: primaryColor2,
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(height: size.height * 0.02),
                                              Container(
                                                width: size.width * 0.3,
                                                height: size.height * 0.03,
                                                padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
                                                decoration: BoxDecoration(
                                                  // color: primaryColor1.withOpacity(0.1),
                                                    border: Border.all(color: primaryColor2),
                                                    borderRadius: BorderRadius.circular(size.height * 0.03)),
                                                child: Image.asset(
                                                  "assets/images/paypal.png",
                                                  height: size.height * 0.01,
                                                  fit: BoxFit.scaleDown,
                                                  // width: size.width * 0.6,
                                                ),
                                              ),
                                              SizedBox(height: size.height * 0.02),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: primaryColor1.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(size.height * 0.005)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 8.0, vertical: 3),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            VariableText(
                                                              text: allBoosters[index].boosterName + " Booster",
                                                              fontFamily: fontRegular,
                                                              fontsize: size.height * 0.017,
                                                              fontcolor: textColorB,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            VariableText(
                                                              text: "\$ ${allBoosters[index].price}",
                                                              fontFamily: fontRegular,
                                                              fontsize: size.height * 0.017,
                                                              fontcolor: textColorB,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: size.height * 0.02),
                                              MyButton(
                                                onTap: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                                btnTxt: "Proceed with Payment",
                                                borderColor: primaryColor1,
                                                btnColor: primaryColor1,
                                                txtColor: textColorW,
                                                btnRadius: 5,
                                                btnWidth: size.width * 0.60,
                                                btnHeight: 35,
                                                fontSize: size.height * 0.018,
                                                weight: FontWeight.w700,
                                                fontFamily: fontSemiBold,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ).then((value){
                                      if(value != null){
                                        if(value){
                                          processPaypal(allBoosters[index]);
                                        }
                                      }
                                    });
                                  }
                                }
                              });

                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  // horizontal: size.width * 0.08,
                                  vertical: size.width * 0.005),
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.1,
                                        vertical: size.width * 0.03),
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.width * 0.025),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: primaryColor1, width: 1),
                                        borderRadius: BorderRadius.circular(
                                            size.height * 0.015)),
                                    child: Container(
                                      height: size.height * 0.08,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.04),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: allBoosters[index].icon,
                                            fit: BoxFit.contain,
                                            height: size.height * 0.07,
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
                                          SizedBox(width: size.width * 0.02),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                VariableText(
                                                  text: "Booster",
                                                  fontFamily: fontSemiBold,
                                                  fontcolor: primaryColor2,
                                                  fontsize: size.height * 0.03,
                                                  textAlign: TextAlign.center,
                                                  max_lines: 2,
                                                  line_spacing:
                                                      size.height * 0.0017,
                                                ),
                                                VariableText(
                                                  text: subscriptionsList[index]
                                                      ['subtitle'],
                                                  fontFamily: fontSemiBold,
                                                  fontcolor: textColorG,
                                                  fontsize: size.height * 0.015,
                                                  textAlign: TextAlign.center,
                                                  max_lines: 2,
                                                  line_spacing:
                                                      size.height * 0.0017,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.03),
                                      margin: EdgeInsets.only(
                                        left: size.width * 0.13,
                                        top: size.height * 0.005,
                                      ),
                                      color: Colors.white,
                                      child: VariableText(
                                        text: allBoosters[index].boosterName,
                                        fontFamily: fontSemiBold,
                                        fontcolor: primaryColor2,
                                        fontsize: size.height * 0.018,
                                        textAlign: TextAlign.center,
                                        max_lines: 1,
                                        line_spacing: size.height * 0.0017,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          if(isLoadingPayment) ProcessLoadingLight()
        ],
      ),
    );
  }
}
