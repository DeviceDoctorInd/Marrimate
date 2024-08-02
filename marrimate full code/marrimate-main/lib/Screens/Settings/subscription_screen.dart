import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/LoginRegistration/sexual_orientation_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/plan_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:marrimate/services/paypal_api.dart';
import 'package:provider/provider.dart';

import 'subscription_success_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedIndex;

  List<Plan> allPlans = [];
  bool isLoading = false;
  bool isLoadingMain = false;
  Plan selectedPlan;
  Map transactionData;
  String transactionID;

  setLoading(bool loading){
    if(mounted){
      setState(() {
        isLoading = loading;
      });
    }
  }
  setLoadingMain(bool loading){
    if(mounted){
      setState(() {
        isLoadingMain = loading;
      });
    }
  }

  onSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  getAllPlans()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getAllSubscription(userDetails);
    if(response != null){
      if(response['status']){
        for(var item in response['data']){
          allPlans.add(Plan.fromJson(item));
        }
        setLoading(false);
      }else{
        allPlans.clear();
        setLoading(false);
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  updateSubscription()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.updateSubscription(
      planID: selectedPlan.id,
      transactionID: transactionID,
      userDetails: userDetails
    );
    if(response != null){
      if(response['status']){
        Provider.of<UserModel>(context, listen: false).updateUserPlan(selectedPlan, response['data']['updated_at']);
        setLoadingMain(false);
        Navigator.push(
          context,
          SwipeLeftAnimationRoute(
            milliseconds: 200,
            widget: SubscriptionSuccessScreen(
              planDetails: selectedPlan,
            ),
          ),
        );
      }else{
        setLoadingMain(false);
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_LONG);
      }
    }else{
      setLoadingMain(false);
      Fluttertoast.showToast(
          msg: "Something went wrong, Please contact Admin",
          toastLength: Toast.LENGTH_LONG);
    }
  }

  processPaypal(){
    setLoadingMain(true);
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
                  "total": selectedPlan.price,
                  "currency": "USD",

                  "details": {
                    "subtotal": selectedPlan.price,
                  }
                },
                "description": "The payment for buying merrimate subscription",
                "item_list": {
                  "items": [
                    {
                      "name": selectedPlan.planName,
                      "quantity": 1,
                      "price": selectedPlan.price,
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
                updateSubscription();
              });
            },
            onError: (error) {
              //ngMain(false);
              print("onError: $error");
              Fluttertoast.showToast(
                  msg: "Transaction Failed",
                  toastLength: Toast.LENGTH_SHORT);
            },
            onCancel: (params) {
              //setLoadingMain(false);
              print('cancelled: $params');
            }
        ),
      ),
    );
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPlans();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.06;

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: textColorW,
            appBar: CustomSimpleAppBar(
              text: tr("Subscription"),
              isBack: true,
              height: size.height * 0.085,
            ),
            body: SingleChildScrollView(
              child: Container(
                //height: size.height * 0.8,
                width: size.width,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                      child: Row(
                        children: [
                          VariableText(
                            text: tr("For Best Access"),
                            fontFamily: fontSemiBold,
                            fontcolor: primaryColor1,
                            fontsize: size.height * 0.036,
                            textAlign: TextAlign.center,
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
                            text: tr("Subscribe a plan"),
                            fontFamily: fontMedium,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.018,
                            textAlign: TextAlign.center,
                            max_lines: 2,
                            line_spacing: size.height * 0.0017,
                          ),
                          SizedBox(width: size.width * 0.01),
                          Image.asset(
                            "assets/icons/ic_heart_fill.png",
                            height: size.height * 0.02,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                      child: Row(
                        children: [
                          VariableText(
                            text: "Top features you will get",
                            fontFamily: fontSemiBold,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.028,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_forward_outlined,
                            color: primaryColor1,
                            size: size.height * 0.03,
                          ),
                          SizedBox(width: size.width * 0.02),
                          VariableText(
                            text: "Find out whose following you",
                            fontFamily: fontMedium,
                            fontcolor: textColorG,
                            fontsize: size.height * 0.018,
                            textAlign: TextAlign.center,
                            max_lines: 2,
                            line_spacing: size.height * 0.0017,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_forward_outlined,
                            color: primaryColor1,
                            size: size.height * 0.03,
                          ),
                          SizedBox(width: size.width * 0.02),
                          VariableText(
                            text: "Contact popular and new users",
                            fontFamily: fontMedium,
                            fontcolor: textColorG,
                            fontsize: size.height * 0.018,
                            textAlign: TextAlign.center,
                            max_lines: 2,
                            line_spacing: size.height * 0.0017,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_forward_outlined,
                            color: primaryColor1,
                            size: size.height * 0.03,
                          ),
                          SizedBox(width: size.width * 0.02),
                          VariableText(
                            text: "Browse profile invisible",
                            fontFamily: fontMedium,
                            fontcolor: textColorG,
                            fontsize: size.height * 0.018,
                            textAlign: TextAlign.center,
                            max_lines: 2,
                            line_spacing: size.height * 0.0017,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                      child: Row(
                        children: [
                          VariableText(
                            text: "Select Your Plan",
                            fontFamily: fontSemiBold,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.028,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    isLoading ?
                    SizedBox(
                      height: size.height * 0.08,
                      child: ProcessLoadingWhite(),
                    ) :
                    ListView.builder(
                        itemCount: allPlans.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              onSelectedIndex(index);
                              selectedPlan = allPlans[index];
                            },
                            child: Container(
                              height: size.height * 0.06,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedIndex == index
                                          ? primaryColor1
                                          : primaryColor1.withOpacity(0.3),
                                      width: 2),
                                  borderRadius:
                                  BorderRadius.circular(size.height * 0.05)),
                              margin: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.1,
                                  vertical: size.width * 0.025),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04),
                              child: Row(
                                children: [
                                  Image.network(
                                    allPlans[index].icon,
                                    color: selectedIndex == index
                                        ? primaryColor1
                                        : null,
                                    scale: 2.2,
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  VariableText(
                                    text: allPlans[index].planName,
                                    fontFamily: fontSemiBold,
                                    fontcolor: selectedIndex == index
                                        ? primaryColor1
                                        : primaryColor2,
                                    fontsize: size.height * 0.02,
                                    textAlign: TextAlign.center,
                                    max_lines: 2,
                                    line_spacing: size.height * 0.0017,
                                  ),
                                  Spacer(),
                                  VariableText(
                                    text: "\$ ${allPlans[index].price}",
                                    fontFamily: fontSemiBold,
                                    fontcolor: selectedIndex == index
                                        ? primaryColor1
                                        : primaryColor2,
                                    fontsize: size.height * 0.018,
                                    textAlign: TextAlign.center,
                                    max_lines: 2,
                                    line_spacing: size.height * 0.0017,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    if(!isLoading)
                      Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding * 4, vertical: size.height * 0.01),
                      child: MyButton(
                        onTap: () {
                          if(selectedPlan != null){
                            //onClickSubscription();
                            showDialog(
                              context: context,
                              builder: (context) {
                                var size = MediaQuery.of(context).size;
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
                                                      text: selectedPlan.planName,
                                                      fontFamily: fontRegular,
                                                      fontsize: size.height * 0.017,
                                                      fontcolor: textColorB,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    VariableText(
                                                      text: "\$ ${selectedPlan.price}",
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
                                  processPaypal();
                                }
                              }
                            });
                          }else{
                            Fluttertoast.showToast(
                                msg: "Please choose plan",
                                toastLength: Toast.LENGTH_SHORT);
                          }
                        },
                        btnTxt: tr("Continue"),
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
                    ),
                    // SizedBox(height: size.height * 0.05),
                  ],
                ),
              ),
            ),
          ),
          if(isLoadingMain) ProcessLoadingLight()
        ],
      ),
    );
  }
}
