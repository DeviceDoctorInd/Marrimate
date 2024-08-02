import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Settings/Gift/gift_detail_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/gift_model.dart';
import 'package:marrimate/models/order_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  Order orderDetails;
  Gift itemDetails;
  CheckoutScreen({Key key, this.orderDetails, this.itemDetails}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _lNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _apartmentController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _postalController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  String selectedCountry = 'India';

  List<String> countryList = ['India'];

  RegExp emailValidator = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  renderCheckout() {
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
                              text: "${widget.orderDetails.quantity}x ${widget.itemDetails.name}",
                              fontFamily: fontRegular,
                              fontsize: size.height * 0.017,
                              fontcolor: textColorB,
                              textAlign: TextAlign.left,
                            ),
                            VariableText(
                              text: calculateTotal(),
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
                              text: "0",
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
                              text: calculateTotal(),
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
                  Navigator.of(context).pop();
                  placeOrder();
                },
                btnTxt: "Proceed with Payment",
                borderColor: primaryColor1,
                btnColor: primaryColor1,
                txtColor: textColorW,
                btnRadius: 5,
                btnWidth: size.width * 0.60,
                btnHeight: 40,
                fontSize: size.height * 0.020,
                weight: FontWeight.w700,
                fontFamily: fontSemiBold,
              ),
/*
          setState(() {
            holidayMode = !holidayMode;
          });*/
            ],
          ),
        );
      },
    );
  }

  renderOrderSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "success",
      builder: (context) {
        var size = MediaQuery.of(context).size;

        return WillPopScope(
          onWillPop: ()=> Future.value(false),
          child: Container(
            decoration: BoxDecoration(
                color: textColorW,
                borderRadius: BorderRadius.circular(size.height * 0.02)),
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.35),
            padding: EdgeInsets.symmetric(
                horizontal: size.height * 0.02, vertical: size.height * 0.01),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/success_logo.png",
                  height: size.height * 0.09,
                ),
                VariableText(
                  text: "Order Placed Successfully",
                  fontFamily: fontBold,
                  fontsize: size.height * 0.022,
                  fontcolor: primaryColor2,
                  textAlign: TextAlign.center,
                ),
                MyButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  btnTxt: "Continue",
                  borderColor: primaryColor1,
                  btnColor: primaryColor1,
                  txtColor: textColorW,
                  btnRadius: 5,
                  btnWidth: size.width * 0.60,
                  btnHeight: 40,
                  fontSize: size.height * 0.020,
                  weight: FontWeight.w700,
                  fontFamily: fontSemiBold,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  placeOrder()async{
    setLoading(true);
    widget.orderDetails.firstName = _fNameController.text;
    widget.orderDetails.lastName = _lNameController.text;
    widget.orderDetails.email = _emailController.text;
    widget.orderDetails.contact = _contactController.text;
    widget.orderDetails.country = selectedCountry;
    widget.orderDetails.city = _cityController.text;
    widget.orderDetails.address = _addressController.text;
    widget.orderDetails.zipCode = _postalController.text;
    widget.orderDetails.note = _noteController.text;

    var response = await API.createOrder(orderDetails: widget.orderDetails);
    if(response != null){
      print(response.toString());
      setLoading(false);
      if(response['status']){
        print(response.toString());
        Provider.of<UserModel>(context, listen: false).updateCoins(response['data']['total_coins'].toString());
        renderOrderSuccess();
      }else{
        Fluttertoast.showToast(
            msg: response['msg'],
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  bool validate(){
    bool isOkay = false;
    if(_fNameController.text.isNotEmpty){
      if(_lNameController.text.isNotEmpty){
        if(_addressController.text.isNotEmpty){
          if(_apartmentController.text.isNotEmpty){
            if(_cityController.text.isNotEmpty){
              if(_postalController.text.isNotEmpty){
                if(_contactController.text.isNotEmpty){
                  if(_emailController.text.isNotEmpty){
                    if(_formKey.currentState.validate()){
                      isOkay = true;
                    }
                  }else{
                    Fluttertoast.showToast(
                        msg: "Enter email address",
                        toastLength: Toast.LENGTH_SHORT);
                  }
                }else{
                  Fluttertoast.showToast(
                      msg: "Enter contact number",
                      toastLength: Toast.LENGTH_SHORT);
                }
              }else{
                Fluttertoast.showToast(
                    msg: "Enter postal code",
                    toastLength: Toast.LENGTH_SHORT);
              }
            }else{
              Fluttertoast.showToast(
                  msg: "Enter city",
                  toastLength: Toast.LENGTH_SHORT);
            }
          }else{
            Fluttertoast.showToast(
                msg: "Enter apartment, suite, etc",
                toastLength: Toast.LENGTH_SHORT);
          }
        }else{
          Fluttertoast.showToast(
              msg: "Enter address",
              toastLength: Toast.LENGTH_SHORT);
        }
      }else{
        Fluttertoast.showToast(
            msg: "Enter last name",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      Fluttertoast.showToast(
          msg: "Enter first name",
          toastLength: Toast.LENGTH_SHORT);
    }
    return isOkay;
  }

  proceed(){
    var userDetails = Provider.of<UserModel>(context, listen: false);
    if(double.parse(userDetails.coins.totalCoins) < double.parse(calculateTotal())){
      Fluttertoast.showToast(
          msg: "Not enough coins in your wallet",
          toastLength: Toast.LENGTH_SHORT);
    }else{
      if(validate()){
        FocusScope.of(context).unfocus();
        renderCheckout();
      }
    }
  }

  String calculateTotal(){
    double temp = double.parse(widget.orderDetails.quantity) * double.parse(widget.orderDetails.price);
    return temp.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: CustomSimpleAppBar(
              text: "Gifts",
              isBack: false,
              height: size.height * 0.085,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.01),
                          VariableText(
                            text: "Shipping Address",
                            fontcolor: textColorB,
                            fontFamily: fontRegular,
                            weight: FontWeight.w600,
                          ),
                          SizedBox(height: size.height * 0.01),
                          MyDropDown(
                            onTap: () {},
                            hinttext: selectedCountry,
                            states: countryList,
                            h1: "Country/Region",
                            selectedValue: (String newValue) {
                              setState(() {
                                selectedCountry = newValue;
                              });
                            },
                            // iconPath: const Icon(Icons.arrow_drop_down_outlined),
                            // elevation: 16,
                            // style: TextStyle(
                            //     color: textColorG,
                            //     fontFamily: fontRegular,
                            //     fontSize: size.height * 0.02),
                            onChange: (String newValue) {
                              selectedCountry = newValue;
                            },
                            /*
                            items: <String>['Women', 'Two', 'Free', 'Four']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),*/
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: MyTextField(
                        text: "First Name",
                        cont: _fNameController,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: MyTextField(
                        text: "Last Name",
                        cont: _lNameController,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: MyTextField(
                        text: "Address",
                        cont: _addressController,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: MyTextField(
                        text: "Apartment, suite, etc. (Optional)",
                        cont: _apartmentController,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: MyTextField(
                        text: "City",
                        cont: _cityController,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: MyTextField(
                        text: "Postal Code",
                        cont: _postalController,
                        inputType: TextInputType.number,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: MyTextField(
                        text: "Phone",
                        cont: _contactController,
                        inputType: TextInputType.phone,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(!emailValidator.hasMatch(value)){
                            return 'Invalid email';
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontFamily: fontRegular,
                          color: textColor1,
                          fontSize: size.height * 0.02,
                        ),
                        decoration: InputDecoration(
                            hintText: "Email",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor1, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: borderColor, width: 1.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor1, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor1, width: 1.0),
                            ),
                            contentPadding: EdgeInsets.only(left: 12, right: 8, bottom: 0)),
                      )
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: "COMMENTS ",
                          style: TextStyle(
                            fontFamily: fontSemiBold,
                            color: textColor1,
                            fontSize: size.height * 0.02,
                          ),
                          children: [
                            TextSpan(
                              text: "(Optional)",
                              style: TextStyle(
                                fontFamily: fontRegular,
                                color: textColorG,
                                fontSize: size.height * 0.02,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            maxLines: 3,
                            maxLength: 50,
                            controller: _noteController,
                            buildCounter: (
                              BuildContext context, {
                              int currentLength,
                              int maxLength,
                              bool isFocused,
                            }) {
                              return Text(
                                '$currentLength/$maxLength',
                                semanticsLabel: 'Character count',
                              );
                            },
// maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            style: TextStyle(
                              fontFamily: fontRegular,
                              color: textColor1,
                              fontSize: size.height * 0.02,
                              height: size.height * 0.0018,
                            ),
                            decoration: InputDecoration(
                                hintText: "Order Note",
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: borderColor, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: borderColor, width: 1.0),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 12, right: 8, bottom: 0, top: 8)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffFFFBF4),
                          border: Border.all(color: Color(0xffFEDB61)),
                          borderRadius: BorderRadius.circular(size.height * 0.02)),
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.06,
                          vertical: size.height * 0.02),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.height * 0.03,
                          vertical: size.height * 0.01),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VariableText(
                            text: "ORDER SUMMARY",
                            fontFamily: fontSemiBold,
                            fontsize: size.height * 0.02,
                            fontcolor: textColorB,
                            textAlign: TextAlign.left,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                // color: primaryColor1.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.005)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        VariableText(
                                          text: widget.itemDetails.name,
                                          fontFamily: fontRegular,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        VariableText(
                                          text: "${widget.orderDetails.quantity}x",
                                          fontFamily: fontRegular,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                        VariableText(
                                          text: calculateTotal(),
                                          fontFamily: fontRegular,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Color(0xffFEDB61),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        VariableText(
                                          text: "Sub Total",
                                          fontFamily: fontRegular,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                        VariableText(
                                          text: calculateTotal(),
                                          fontFamily: fontRegular,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        VariableText(
                                          text: "Discount",
                                          fontFamily: fontRegular,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                        VariableText(
                                          text: "0.00",
                                          fontFamily: fontRegular,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        VariableText(
                                          text: "Delivery Fee",
                                          fontFamily: fontRegular,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                        VariableText(
                                          text: "0.00",
                                          fontFamily: fontRegular,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Color(0xffFEDB61),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        VariableText(
                                          text: "Total",
                                          fontFamily: fontSemiBold,
                                          fontsize: size.height * 0.017,
                                          fontcolor: textColorB,
                                          textAlign: TextAlign.left,
                                        ),
                                        VariableText(
                                          text: calculateTotal(),
                                          fontFamily: fontSemiBold,
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
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: textColorW,
                        boxShadow: [
                          BoxShadow(blurRadius: 2, color: borderColor),
                        ],
                      ),
                      margin: EdgeInsets.only(
                          // horizontal: size.width * 0.06,
                          top: size.height * 0.02),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.height * 0.03,
                          vertical: size.height * 0.01),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: size.height * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                VariableText(
                                  text: "Total",
                                  fontFamily: fontSemiBold,
                                  fontsize: size.height * 0.02,
                                  fontcolor: textColorB,
                                  textAlign: TextAlign.left,
                                ),
                                VariableText(
                                  text: "Coins: " + calculateTotal(),
                                  fontFamily: fontRegular,
                                  fontsize: size.height * 0.02,
                                  fontcolor: textColorB,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          MyButton(
                            onTap: () {
                              proceed();
                            },
                            btnTxt: "CHECKOUT",
                            borderColor: primaryColor1,
                            btnColor: primaryColor1,
                            txtColor: textColorW,
                            btnRadius: 5,
                            btnWidth: size.width,
                            btnHeight: 40,
                            fontSize: size.height * 0.020,
                            weight: FontWeight.w700,
                            fontFamily: fontSemiBold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(isLoading) ProcessLoadingLight()
        ],
      ),
    );
  }
}
