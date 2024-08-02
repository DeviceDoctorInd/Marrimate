import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Settings/Gift/checkout_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/gift_model.dart';
import 'package:marrimate/models/order_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:provider/provider.dart';

class GiftDetailScreen extends StatefulWidget {
  Gift giftDetails;

  GiftDetailScreen({Key key, this.giftDetails}) : super(key: key);

  @override
  _GiftDetailScreenState createState() => _GiftDetailScreenState();
}

class _GiftDetailScreenState extends State<GiftDetailScreen> {
  int selectedVariantIndex = -1;
  int itemQuantity = 1;

  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    onSelectedIndex(int index) {
      setState(() {
        selectedVariantIndex = index;
      });
    }

    increment() {
      setState(() {
        itemQuantity++;
      });
    }

    decrement() {
      if (itemQuantity > 1)
        setState(() {
          itemQuantity--;
        });
    }

    return SafeArea(
      child: Scaffold(
        appBar: CustomSimpleAppBar(
          text: tr("Gifts"),
          isBack: false,
          height: size.height * 0.085,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.giftDetails.images[selectedImage],
                fit: BoxFit.contain,
                height: size.height * 0.3,
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
              Container(
                height: size.height * 0.1,
                padding: EdgeInsets.symmetric(vertical: padding / 4),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: padding / 2),
                  shrinkWrap: false,
                  itemCount: widget.giftDetails.images.length,
                  scrollDirection: Axis.horizontal,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          selectedImage = index;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: padding / 4),
                        child: CachedNetworkImage(
                          imageUrl: widget.giftDetails.images[index],
                          fit: BoxFit.fill,
                          width: size.width * 0.2,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Padding(
                                padding: const EdgeInsets.all(45.0),
                                child: CircularProgressIndicator(value: downloadProgress.progress, color: primaryColor2),
                              ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )
                      ),
                    );
                  },
                ),
              ),
              Divider(
                color: borderColor,
                height: size.height * 0.01,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: padding / 2.5, top: padding / 2.2),
                child: Row(
                  children: [
                    VariableText(
                      text: widget.giftDetails.name,
                      fontFamily: fontBold,
                      fontsize: size.height * 0.024,
                      fontcolor: textColorB,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: padding / 2, top: padding / 2.5),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/coin.png",
                      scale: 1.5,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    VariableText(
                      text: "x${widget.giftDetails.price}",
                      fontFamily: fontSemiBold,
                      fontsize: size.height * 0.017,
                      fontcolor: textColorG,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: padding / 2, top: padding),
                child: Row(
                  children: [
                    VariableText(
                      text: tr("Select Size"),
                      fontFamily: fontSemiBold,
                      fontsize: size.height * 0.017,
                      fontcolor: textColorB,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height * 0.05,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: padding / 2),
                margin: EdgeInsets.only(
                  top: padding / 4,
                  bottom: padding / 4,
                ),
                child: ListView.builder(
                  itemCount: widget.giftDetails.variants.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        onSelectedIndex(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedVariantIndex == index
                              ? primaryColor1
                              : textColorW,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: selectedVariantIndex == index
                              ? primaryColor1 : borderLightColor),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.035,
                            vertical: size.height * 0.01),
                        margin: EdgeInsets.only(
                          right: size.width * 0.01,
                        ),
                        child: Center(
                          child: VariableText(
                            text: widget.giftDetails.variants[index],
                            fontFamily: fontSemiBold,
                            fontsize: size.height * 0.018,
                            fontcolor:
                                selectedVariantIndex == index ? textColorW : textColorG,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(
                color: borderColor,
              ),
              Padding(
                padding: EdgeInsets.only(left: padding / 2, top: padding / 2),
                child: Row(
                  children: [
                    VariableText(
                      text: tr("Item Description"),
                      fontFamily: fontSemiBold,
                      fontsize: size.height * 0.02,
                      fontcolor: textColorB,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: padding / 2, top: padding / 3),
                child: Row(
                  children: [
                    Expanded(
                      child: VariableText(
                        text: widget.giftDetails.description,
                        fontFamily: fontSemiBold,
                        fontsize: size.height * 0.018,
                        line_spacing: size.height * 0.0016,
                        fontcolor: textColorG,
                        max_lines: 30,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: size.height * 0.07,
          width: double.infinity,
          decoration: BoxDecoration(
            // color: selectedIndex == index ? primaryColor1 : textColorW,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderLightColor),
          ),
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: size.height * 0.07,
                width: size.width * 0.3,
                padding: EdgeInsets.symmetric(vertical: size.height * 0.004),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: borderLightColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        decrement();
                      },
                      child: Container(
                        padding: EdgeInsets.all(size.height * 0.005),
                        decoration: BoxDecoration(
                          color: Color(0xffF1F1F1),
                          borderRadius:
                              BorderRadius.circular(size.height * 0.05),
                          border: Border.all(color: Color(0xffF1F1F1)),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: textColorB,
                          size: size.height * 0.02,
                        ),
                      ),
                    ),
                    Center(
                      child: VariableText(
                        text: "$itemQuantity",
                        fontFamily: fontRegular,
                        fontsize: size.height * 0.024,
                        fontcolor: textColorB,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        increment();
                      },
                      child: Container(
                        // height: size.height * 0.02,
                        // width: size.width * 0.3,
                        padding: EdgeInsets.all(size.height * 0.005),
                        decoration: BoxDecoration(
                          color: primaryColor1,
                          borderRadius:
                              BorderRadius.circular(size.height * 0.05),
                          border: Border.all(color: primaryColor1),
                        ),
                        child: Icon(
                          Icons.add,
                          color: textColorW,
                          size: size.height * 0.02,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CommonButtonWithIcon(
                onTap: () {
                  if(selectedVariantIndex < 0){
                    Fluttertoast.showToast(
                        msg: "Please select size",
                        toastLength: Toast.LENGTH_SHORT);
                  }else{
                    Order orderDetails = Order(
                      quantity: itemQuantity.toString(),
                      variant: widget.giftDetails.variants[selectedVariantIndex],
                      price: widget.giftDetails.price,
                      giftID: widget.giftDetails.id.toString(),
                      userID: userDetails.id.toString()
                    );
                    Navigator.push(
                        context,
                        SwipeLeftAnimationRoute(
                          widget: CheckoutScreen(
                            orderDetails: orderDetails,
                            itemDetails: widget.giftDetails,
                          ),
                        ));
                  }
                },
                btnTxt: tr("Buy Now"),
                btnColor: primaryColor1,
                txtColor: textColorW,
                btnRadius: 5,
                btnWidth: size.width * 0.55,
                btnHeight: 50,
                fontSize: size.height * 0.018,
                weight: FontWeight.w600,
                icon: "assets/icons/ic_shopping.png",
                iconColor: textColorW,
                iconHeight: size.height * 0.020,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
