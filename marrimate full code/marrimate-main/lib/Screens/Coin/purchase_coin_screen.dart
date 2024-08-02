import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Dashboard/Chat/chatting_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/coins_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:marrimate/services/paypal_api.dart';
import 'package:provider/provider.dart';

class PurchaseCoinScreen extends StatefulWidget {
  const PurchaseCoinScreen({Key key}) : super(key: key);

  @override
  State<PurchaseCoinScreen> createState() => _PurchaseCoinScreenState();
}

class _PurchaseCoinScreenState extends State<PurchaseCoinScreen> {
  List<BuyCoin> coinPackages = [];
  BuyCoin selectedPackage;
  bool isLoading = false;
  bool isLoadingBuy = false;
  Map transactionData;
  String transactionID;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }
  setLoadingBuy(bool loading){
    setState(() {
      isLoadingBuy = loading;
    });
  }

  getCoinPackages()async{
    setLoading(true);
    var response = await API.getCoinPackages();
    if(response != null){
      if(response['status']){
        for(var item in response['data']){
          coinPackages.add(BuyCoin.fromJson(item));
        }
        setLoading(false);
      }else{
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.of(context).pop();
      }
    }else{
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
      Navigator.of(context).pop();
    }
  }

  processPaypal(){
    //setLoadingBuy(true);
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
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": selectedPackage.price.toStringAsFixed(2),
                  "currency": "USD",

                  "details": {
                    "subtotal": selectedPackage.price.toStringAsFixed(2),
                  }
                },
                "description": "The payment for buying coins",
                "item_list": {
                  "items": [
                    {
                      "name": "${selectedPackage.coins} coins",
                      "quantity": 1,
                      "price": selectedPackage.price.toStringAsFixed(2),
                      "currency": "USD"
                    },
                  ]
                }
              }
            ],
            note: "Contact us for any questions on your purchase.",
            onSuccess: (Map params)async{
              setLoadingBuy(true);
              transactionData = params;
              transactionID = transactionData['data']['transactions'][0]['related_resources'][0]['sale']['id'].toString();
              print("onSuccess: $transactionID");
              Future.delayed(Duration(seconds: 2)).then((value){
                updateCoinsPackage();
              });
            },
            onError: (error) {
              setLoadingBuy(false);
              print("onError: $error");
              Fluttertoast.showToast(
                  msg: "Transaction Failed",
                  toastLength: Toast.LENGTH_SHORT);
            },
            onCancel: (params) {
              setLoadingBuy(false);
              print('cancelled: $params');
            }
        ),
      ),
    );

  }

  updateCoinsPackage()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.buyCoins(
        totalCoins: selectedPackage.coins,
        transactionID: transactionID,
        userDetails: userDetails
    );
    if(response != null){
      if(response['status']){
        Provider.of<UserModel>(context, listen: false).updateCoins(response['data']['total_coins']);
        setLoadingBuy(false);
        Fluttertoast.showToast(
            msg: "Coins added successfully",
            toastLength: Toast.LENGTH_LONG);
      }else{
        setLoadingBuy(false);
        Fluttertoast.showToast(
            msg: "Something went wrong, Please contact Admin",
            toastLength: Toast.LENGTH_LONG);
      }
    }else{
      setLoadingBuy(false);
      Fluttertoast.showToast(
          msg: "Something went wrong, Please contact Admin",
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoinPackages();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: textColorW,
            appBar: CustomSimpleAppBar(
              text: tr("Purchase Coins"),
              isBack: false,
              height: size.height * 0.085,
            ),
            body: isLoading ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProcessLoadingWhite()
              ],
            ) :
            Container(
              width: size.width,
              height: size.height,
              color: textColorBlue,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/purchase_background.png",
                    fit: BoxFit.cover,
                    width: size.width,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: padding / 3,
                        right: padding / 3,
                        top: padding * 2,
                        bottom: padding),
                    child: ShaderMask(
                      shaderCallback: (bound) {
                        return RadialGradient(
                          tileMode: TileMode.mirror,
                          radius: 1,
                          center: Alignment.topCenter,
                          colors: <Color>[Colors.amberAccent, Colors.red],
                        ).createShader(bound);
                      },
                      child: Text(
                        "Purchase Coins",
                        style: TextStyle(
                          fontFamily: fontMatchMaker,
                          color: textColorW,
                          fontSize: size.height * 0.07,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: coinPackages.length,
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: textColorW, width: 2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: padding / 3, vertical: padding / 4),
                          padding: EdgeInsets.all(10),
                          height: size.height * 0.11,
                          width: 80,
                          child: Container(
                            // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // color: borderLightColor.withOpacity(0.1),
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
                                    "assets/images/coins.png",
                                    // fit: BoxFit.fill,
                                    height: size.height * 0.05,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        VariableText(
                                          text: coinPackages[index].coins,
                                          fontFamily: fontSemiBold,
                                          fontcolor: textColorW,
                                          fontsize: size.height * 0.028,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    selectedPackage = coinPackages[index];
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        var size = MediaQuery.of(context).size;
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: textColorW,
                                              borderRadius: BorderRadius.circular(size.height * 0.02)),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.1, vertical: size.height * 0.35),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.height * 0.03, vertical: size.height * 0.01),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              VariableText(
                                                text: "CONTINUE WITH PAYMENT",
                                                fontFamily: fontBold,
                                                fontsize: size.height * 0.021,
                                                fontcolor: primaryColor2,
                                                textAlign: TextAlign.left,
                                              ),
                                              /*Container(
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
              ),*/
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
                                                              text: "${selectedPackage.coins} Coins",
                                                              fontFamily: fontRegular,
                                                              fontsize: size.height * 0.017,
                                                              fontcolor: textColorB,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            VariableText(
                                                              text: "\$${selectedPackage.price.toStringAsFixed(2)}",
                                                              fontFamily: fontRegular,
                                                              fontsize: size.height * 0.017,
                                                              fontcolor: textColorB,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: primaryColor1.withOpacity(0.5),
                                                        height: 3,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 8.0, vertical: 3),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            VariableText(
                                                              text: "Inc. tax",
                                                              fontFamily: fontRegular,
                                                              fontsize: size.height * 0.017,
                                                              fontcolor: textColorB,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            VariableText(
                                                              text: "\$0.00",
                                                              fontFamily: fontRegular,
                                                              fontsize: size.height * 0.017,
                                                              fontcolor: textColorB,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: primaryColor1.withOpacity(0.5),
                                                        height: 3,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 8.0, vertical: 3),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            VariableText(
                                                              text: "Total Bill",
                                                              fontFamily: fontBold,
                                                              fontsize: size.height * 0.017,
                                                              fontcolor: textColorB,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            VariableText(
                                                              text: "\$${selectedPackage.price.toStringAsFixed(2)}",
                                                              fontFamily: fontBold,
                                                              fontsize: size.height * 0.017,
                                                              fontcolor: textColorB,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                                                btnHeight: 30,
                                                fontSize: size.height * 0.020,
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
                                  },
                                  child: Container(
                                    width: size.width * 0.5,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.amberAccent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: "\$ ${coinPackages[index].price.toStringAsFixed(2)}  ",
                                        style: TextStyle(
                                          fontFamily: fontSemiBold,
                                          color: textColorW,
                                          fontSize: size.height * 0.024,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "Buy\nNow",
                                            style: TextStyle(
                                              fontFamily: fontBold,
                                              color: textColorW,
                                              fontSize: size.height * 0.024,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(isLoadingBuy) ProcessLoadingLight()
        ],
      ),
    );
  }
}
