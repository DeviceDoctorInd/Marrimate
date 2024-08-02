import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marrimate/Screens/Settings/EditProfile/filter_profile.dart';
import 'package:marrimate/Screens/Settings/EditProfile/video_timmer.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_player/video_player.dart';

class VariableText extends StatelessWidget {
  final String text;
  final Color fontcolor;
  final TextAlign textAlign;
  final FontWeight weight;
  final bool underlined, linethrough;
  final String fontFamily;
  final double fontsize, line_spacing, letter_spacing;
  final int max_lines;
  final TextOverflow overflow;
  final FontStyle fontStyle;
//final double minfontsize,scalefactor,fontsize;

  const VariableText({
    this.text,
    this.fontcolor = textColor1,
    this.fontsize = 15,
    this.textAlign,
    this.weight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.underlined = false,
    this.line_spacing,
    this.letter_spacing = 0.6,
    this.max_lines, //double line_spacing=1.2,
    this.fontFamily = fontRegular,
    this.overflow = TextOverflow.ellipsis,
    this.linethrough = false,
// this.minfontsize=10,//this.scalefactor,
  });

  @override
  Widget build(BuildContext context) {
    //var media=MediaQuery.of(context);
    return Text(
      text,
      maxLines: max_lines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        color: fontcolor, fontWeight: weight,
        height: line_spacing,
        letterSpacing: letter_spacing,
        fontSize: fontsize,
        fontStyle: fontStyle,
        //  fontSize: fontsize,
        fontFamily: fontFamily,
        decorationThickness: 3.0,
        decoration: underlined
            ? TextDecoration.underline
            : (linethrough ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String btnTxt;
  final double btnHeight;
  final double btnWidth;
  final Function onTap;
  final Color btnColor;
  final Color txtColor;
  final double btnRadius;
  final double fontSize;
  final FontWeight weight;
  final Color borderColor;
  final fontFamily;

  MyButton({
    this.btnTxt,
    this.borderColor,
    this.weight,
    this.fontSize,
    this.btnRadius,
    this.onTap,
    this.btnHeight,
    this.btnWidth,
    this.btnColor,
    this.txtColor,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: btnHeight,
      width: btnWidth != null ? btnWidth : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: btnColor, //textStyle: TextStyle(color: Color(0xff000000)),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: borderColor != null ? borderColor : btnColor,
                  width: 2),
              borderRadius: BorderRadius.circular(btnRadius)),
        ),
        onPressed: onTap,
        child: Center(
          child: FittedBox(
            child: VariableText(
              text: btnTxt,
              fontcolor: txtColor,
              weight: weight,
              max_lines: 1,
              fontsize: fontSize,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}

class NoAnimationRoute extends PageRouteBuilder {
  final Widget widget;

  NoAnimationRoute({this.widget})
      : super(
          transitionDuration: Duration(seconds: 0),
          pageBuilder: (context, anim1, anim2) {
            return widget;
          },
        );
}

class SwipeLeftAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;
  SwipeLeftAnimationRoute({this.widget, this.milliseconds = 400})
      : super(
          transitionDuration: Duration(
            milliseconds: milliseconds,
          ),
          pageBuilder: (context, anim1, anim2) => widget,
          transitionsBuilder: (context, anim1, anim2, child) {
            var begin = Offset(1, 0);
            var end = Offset(0, 0);
            var tween = Tween<Offset>(begin: begin, end: end);
            var offsetAnimation = anim1.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class SwipeRightAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;
  SwipeRightAnimationRoute({
    this.widget,
    this.milliseconds = 500,
  }) : super(
          transitionDuration: Duration(
            milliseconds: milliseconds,
          ),
          pageBuilder: (context, anim1, anim2) => widget,
          transitionsBuilder: (context, anim1, anim2, child) {
            var begin = Offset(-1, 0);
            var end = Offset(0, 0);
            var tween = Tween<Offset>(begin: begin, end: end);
            var offsetAnimation = anim1.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class SwipeUpAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;
  SwipeUpAnimationRoute({
    this.widget,
    this.milliseconds = 400,
  }) : super(
          transitionDuration: Duration(
            milliseconds: milliseconds,
          ),
          pageBuilder: (context, anim1, anim2) => widget,
          transitionsBuilder: (context, anim1, anim2, child) {
            var begin = Offset(0, 1);
            var end = Offset(0, 0);
            var tween = Tween<Offset>(begin: begin, end: end);
            var offsetAnimation = anim1.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class FadeAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milliseconds;
  FadeAnimationRoute({
    this.widget,
    this.milliseconds = 400,
  }) : super(
          transitionDuration: Duration(
            milliseconds: milliseconds,
          ),
          pageBuilder: (context, anim1, anim2) => widget,
          transitionsBuilder: (context, anim1, anim2, child) {
            var begin = Offset(0, 1);
            var end = Offset(0, 0);
            var tween = Tween<Offset>(begin: begin, end: end);
            //var offsetAnimation = anim1.drive(tween);
            return FadeTransition(
              opacity: anim1,
              //position: offsetAnimation,
              child: child,
            );
          },
        );
}

class SocialLoginButton extends StatelessWidget {
  final String btnTxt;
  final double btnHeight;
  final double btnWidth;
  final Function onTap;
  final Color btnColor;
  final Color txtColor;
  final double btnRadius;
  final double fontSize;
  final FontWeight weight;
  final Color borderColor;
  final String icon;
  final double iconHeight;
  final Color iconColor;

  SocialLoginButton({
    this.btnTxt,
    this.icon,
    this.iconHeight,
    this.iconColor,
    this.borderColor,
    this.weight,
    this.fontSize,
    this.btnRadius,
    this.onTap,
    this.btnHeight,
    this.btnWidth,
    this.btnColor,
    this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: btnHeight,
      width: btnWidth != null ? btnWidth : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: btnColor, //textStyle: TextStyle(color: Color(0xff000000)),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: borderColor != null ? borderColor : btnColor,
                    width: 1),
                borderRadius: BorderRadius.circular(btnRadius))),
        onPressed: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              icon,
              height: iconHeight,
              color: iconColor,
            ),
            SizedBox(width: size.width * 0.04),
            VariableText(
              text: btnTxt,
              fontcolor: txtColor,
              weight: weight,
              max_lines: 1,
              fontsize: fontSize,
              textAlign: TextAlign.left,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class CommonButtonWithIcon extends StatelessWidget {
  final String btnTxt;
  final double btnHeight;
  final double btnWidth;
  final Function onTap;
  final Color btnColor;
  final Color txtColor;
  final double btnRadius;
  final double fontSize;
  final FontWeight weight;
  final Color borderColor;
  final String icon;
  final double iconHeight;
  final Color iconColor;

  CommonButtonWithIcon({
    this.btnTxt,
    this.icon,
    this.iconHeight,
    this.iconColor,
    this.borderColor,
    this.weight,
    this.fontSize,
    this.btnRadius,
    this.onTap,
    this.btnHeight,
    this.btnWidth,
    this.btnColor,
    this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: btnHeight,
      width: btnWidth != null ? btnWidth : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: btnColor, //textStyle: TextStyle(color: Color(0xff000000)),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: borderColor != null ? borderColor : btnColor,
                    width: 1),
                borderRadius: BorderRadius.circular(btnRadius))),
        onPressed: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: iconHeight,
              color: iconColor,
            ),
            Expanded(
              child: VariableText(
                text: btnTxt,
                fontcolor: txtColor,
                weight: weight,
                max_lines: 1,
                fontsize: fontSize,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InterestButton extends StatelessWidget {
  final String btnTxt;
  final double btnHeight;
  final double btnWidth;
  final Function onTap;
  final Color btnColor;
  final Color txtColor;
  final double btnRadius;
  final double fontSize;
  final FontWeight weight;
  final Color borderColor;
  final String icon;
  final double iconHeight;
  final Color iconColor;

  InterestButton({
    this.btnTxt,
    this.icon,
    this.iconHeight,
    this.iconColor,
    this.borderColor,
    this.weight,
    this.fontSize,
    this.btnRadius,
    this.onTap,
    this.btnHeight,
    this.btnWidth,
    this.btnColor,
    this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: btnHeight,
      width: btnWidth != null ? btnWidth : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: btnColor, //textStyle: TextStyle(color: Color(0xff000000)),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: borderColor != null ? borderColor : btnColor,
                    width: 1),
                borderRadius: BorderRadius.circular(btnRadius))),
        onPressed: (){},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              icon,
              height: iconHeight,
              color: iconColor,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
              errorBuilder: (BuildContext context, obj, trace) {
                return const Center(
                    child: Icon(Icons.error_outline,
                        size: 20, color: Colors.white));
              },
            ),
            SizedBox(width: size.width * 0.02),
            VariableText(
              text: btnTxt,
              fontcolor: txtColor,
              weight: weight,
              max_lines: 1,
              fontsize: fontSize,
              textAlign: TextAlign.left,
            ),
            SizedBox(width: size.width * 0.02),
            InkWell(
              onTap: onTap,
              child: Icon(
                Icons.clear,
                color: textColorW,
                size: size.height * 0.023,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeField extends StatelessWidget {
  final TextEditingController cont, next_cont;
  final String hinttext;
  // final Widget icon;
  final bool texthidden, readonly;
  final TextAlign textAlign;
  Function onComplete;
  final Color enableColor;
  final Color focusColor;
  final double radius;

  CodeField({
    this.cont,
    this.hinttext,
    this.texthidden = false,
    this.readonly = false,
    //this.icon,
    this.onComplete,
    this.next_cont,
    this.textAlign = TextAlign.center,
    this.radius,
    this.enableColor,
    this.focusColor,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // var radius = size.width * 0.25;
    return TextField(
      onChanged: (x) {
        print("onchange");
        if (cont.text.isNotEmpty) {
          FocusScope.of(context).nextFocus();
        } else {
          FocusScope.of(context).previousFocus();
        }
        if (next_cont != null) {
          next_cont.text = "";
        }
        onComplete(x);
      },
      controller: cont,
      maxLength: 1,
      obscureText: texthidden,
      readOnly: readonly,
      textAlign: textAlign,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 18, //fontFamily: fontNormal
      ),
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 2),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                radius == null ? size.width * 0.25 : radius)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              radius == null ? size.width * 0.25 : radius),
          borderSide: BorderSide(
              color: enableColor == null ? primaryColor1 : enableColor,
              width: enableColor == null ? 2.0 : 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              radius == null ? size.width * 0.25 : radius),
          borderSide: BorderSide(
              color: focusColor == null ? Color(0xffFC1F61) : focusColor,
              width: 1.0),
        ),
        fillColor: Colors.white,
        // fillColor: Colors.black,
        filled: true,
        hintText: hinttext,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String text;
  bool isBack;
  String actionImage;
  double height;
  PopupMenuButton actionOnTap;
  bool isActionBar;

  CustomAppBar({
    Key key,
    this.text,
    this.isBack,
    this.actionImage,
    this.height,
    this.actionOnTap,
    this.isActionBar = true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/appbar_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      leading: isBack
          ? InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                "assets/icons/ic_back.png",
                scale: 2,
              ),
            )
          : null,
      title: VariableText(
        text: text,
        fontFamily: fontSemiBold,
        fontsize: size.height * 0.026,
        fontcolor: textColorW,
      ),
      actions: isActionBar ? [
        actionOnTap == null
            ? InkWell(
                onTap: () {
                  actionOnTap;
                },
                child: Image.asset(
                  actionImage,
                  scale: 2.2,
                ),
              )
            : actionOnTap,
      ] : [],
      backgroundColor: textColorW,
      centerTitle: true,
    );
  }
}

class CustomVideoAppBar extends StatelessWidget implements PreferredSizeWidget {
  String text;
  bool isBack;
  String actionImage;
  double height;

  CustomVideoAppBar({
    Key key,
    this.text,
    this.isBack,
    this.actionImage,
    this.height,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppBar(
      toolbarHeight: preferredSize.height,
      leading: isBack
          ? InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                "assets/icons/ic_back.png",
                scale: 2,
              ),
            )
          : null,
      title: text != "" && text != null
          ? VariableText(
              text: text,
              fontFamily: fontSemiBold,
              fontsize: size.height * 0.026,
              fontcolor: textColorW,
            )
          : null,
      actions: [
        InkWell(
          onTap: () {},
          child: Image.asset(
            actionImage,
            scale: 2.2,
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }
}

class CustomSimpleAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  String text;
  double height;
  bool isBack;
  Function onBack;

  CustomSimpleAppBar({Key key, this.text, this.isBack, this.height, this.onBack})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppBar(
      toolbarHeight: height,
      leading: InkWell(
        onTap: () {
          if(onBack != null){
            onBack();
          }else{
            Navigator.of(context).pop();
          }
        },
        child: Image.asset(
          "assets/icons/ic_back.png",
          scale: 2,
          color: textColorW,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/appbar_background.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      elevation: 0,
      centerTitle: true,
      title: VariableText(
        text: text,
        fontFamily: fontSemiBold,
        fontsize: size.height * 0.026,
        fontcolor: textColorW,
      ),
    );
  }
}

class MyDropDown extends StatefulWidget {
  final List<String> states;
  final TextEditingController cont;
  final String hinttext;
  final bool readonly, expands;
  final double radius;
  final TextInputType keytype;
  final Function onChange;
  final FocusNode focusNode;
  final Function onTap;
  final Color color;
  final int length;
  final String fontFamily;
  final FontWeight weight;
  final double fontsize;
  final String obscuringCharacter;
  final double height;
  final double width;
  final String h1;
  final String iconPath;
  bool texthidden;
  final TextInputAction textInputAction;
  Function selectedValue;

  MyDropDown({
    this.states,
    this.keytype = TextInputType.text,
    this.color,
    this.selectedValue,
    this.textInputAction = TextInputAction.done,
    this.h1 = 'Test',
    this.onChange,
    this.height = 80,
    this.width = double.infinity,
    this.cont,
    this.iconPath,
    this.weight,
    this.hinttext,
    this.texthidden = false,
    this.readonly = false,
    this.expands = false,
    this.fontFamily = fontRegular,
    this.radius = 0,
    this.length,
    this.obscuringCharacter = "*",
    this.focusNode,
    this.onTap,
    this.fontsize = 14,
  });

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  String _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.only(top: widget.height * 0.1),
            child: VariableText(
                text: widget.h1,
                fontsize: widget.height * 0.20,
                weight: FontWeight.w500,
                fontFamily: fontMedium),
          ),
          Container(
            height: widget.height * 0.40,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: _chosenValue,
                    isExpanded: true,
                    onTap: widget.onTap,
                    underline: Container(
                      height: 0,
                      color: textColorG,
                    ),
                    hint: Text(
                      widget.hinttext,
                      style: TextStyle(
                          color: textColorG,
                          fontSize: widget.height * 0.21,
                          fontFamily: fontSemiBold),
                    ),
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: widget.states
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Colors.black, fontFamily: fontSemiBold),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                        widget.selectedValue(value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    //  prefix: Icon(Icons.email,color: Colors.green,),
    // suffixIcon: icon,
  }
}

class MyTextField extends StatelessWidget {
  String text;
  TextEditingController cont;
  TextInputAction inputAction;
  TextInputType inputType;
  Function validator;


  MyTextField({Key key, this.text, this.cont, this.validator,
    this.inputAction = TextInputAction.next, this.inputType = TextInputType.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return TextFormField(
      controller: cont,
      textInputAction: inputAction,
      keyboardType: inputType,
      //validator: (value)=> validator(value),
      style: TextStyle(
        fontFamily: fontRegular,
        color: textColor1,
        fontSize: size.height * 0.02,
      ),
      decoration: InputDecoration(
          hintText: text,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor1, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1.0),
          ),
          contentPadding: EdgeInsets.only(left: 12, right: 8, bottom: 0)),
    );
  }
}

class ProcessLoadingLight extends StatefulWidget {
  @override
  State createState() {
    return _ProcessLoadingLightState();
  }
}
class _ProcessLoadingLightState extends State<ProcessLoadingLight>
    with SingleTickerProviderStateMixin {
  AnimationController _cont;
  Animation<Color> _anim;

  @override
  void initState() {
    _cont = AnimationController(
        duration: Duration(
          seconds: 1,
        ),
        vsync: this);
    _cont.addListener(() {
      setState(() {});
    });
    ColorTween col = ColorTween(begin: primaryColor1, end: primaryColor2);
    _anim = col.animate(_cont);
    _cont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 0, 0, 0.4),
        child: Center(
          child: Container(
              width: 50 * _cont.value,
              height: 50 * _cont.value,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  _anim.value,
                ),
              )),
        ));
  }
}

class ProcessLoadingTextLight extends StatefulWidget {
  @override
  State createState() {
    return _ProcessLoadingTextLightState();
  }
}
class _ProcessLoadingTextLightState extends State<ProcessLoadingTextLight>
    with SingleTickerProviderStateMixin {
  AnimationController _cont;
  Animation<Color> _anim;

  @override
  void initState() {
    _cont = AnimationController(
        duration: Duration(
          seconds: 1,
        ),
        vsync: this);
    _cont.addListener(() {
      setState(() {});
    });
    ColorTween col = ColorTween(begin: primaryColor1, end: primaryColor2);
    _anim = col.animate(_cont);
    _cont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 0, 0, 0.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Center(
                child: Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        _anim.value,
                      ),
                    )),
              ),
            SizedBox(height: 15),
            VariableText(
              text: "Uploading video...",
              fontcolor: Colors.white,
              fontsize: 20,
              weight: FontWeight.w600,
            )
          ],
        ));
  }
}

class ProcessLoadingExtraLight extends StatefulWidget {
  @override
  State createState() {
    return _ProcessLoadingExtraLightState();
  }
}
class _ProcessLoadingExtraLightState extends State<ProcessLoadingExtraLight>
    with SingleTickerProviderStateMixin {
  AnimationController _cont;
  Animation<Color> _anim;

  @override
  void initState() {
    _cont = AnimationController(
        duration: Duration(
          seconds: 1,
        ),
        vsync: this);
    _cont.addListener(() {
      setState(() {});
    });
    ColorTween col = ColorTween(begin: primaryColor1, end: primaryColor2);
    _anim = col.animate(_cont);
    _cont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        child: Center(
          child: Container(
              width: 50 * _cont.value,
              height: 50 * _cont.value,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  _anim.value,
                ),
              )),
        ));
  }
}

class ProcessLoadingWhite extends StatefulWidget {
  @override
  State createState() {
    return _ProcessLoadingWhiteState();
  }
}
class _ProcessLoadingWhiteState extends State<ProcessLoadingWhite>
    with SingleTickerProviderStateMixin {
  AnimationController _cont;
  Animation<Color> _anim;

  @override
  void initState() {
    _cont = AnimationController(
        duration: Duration(
          seconds: 1,
        ),
        vsync: this);
    _cont.addListener(() {
      setState(() {});
    });
    ColorTween col = ColorTween(begin: primaryColor1, end: primaryColor2);
    _anim = col.animate(_cont);
    _cont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Container(
              width: 50 * _cont.value,
              height: 50 * _cont.value,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  _anim.value,
                ),
              )),
        ));
  }
}

class GalleryImagePicker extends StatefulWidget {
  bool isProfilePicture;
  GalleryImagePicker({Key key, this.isProfilePicture = true}) : super(key: key);

  @override
  _GalleryImagePickerState createState() => _GalleryImagePickerState();
}
class _GalleryImagePickerState extends State<GalleryImagePicker> {
  List<Album> _allMedia = [];
  bool _loading = true;
  File selectedImage;
  String fileName;
  File imageFile;


  Future<void> loadGallery() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums =
      await PhotoGallery.listAlbums(mediumType: MediumType.image);
      //print("albums: " + albums.length.toString());
      // List<Album> videoAlbums = await PhotoGallery.listAlbums(
      //     mediumType: MediumType.video, hideIfEmpty: false);
      final List<Album> allMedia = [
        // ...videoAlbums,
        ...albums,
      ];
      setState(() {
        _allMedia = allMedia;
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
        await Permission.storage.request().isGranted &&
        await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadGallery();
  }
  proceed()async{
    File croppedFile = await ImageCropper().cropImage(
      sourcePath: selectedImage.path,
      maxWidth: 1200,
      aspectRatioPresets: Platform.isAndroid
      ? [
       CropAspectRatioPreset.ratio3x2,
       CropAspectRatioPreset.original,
       CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
      ]
          : [
       CropAspectRatioPreset.ratio3x2,
       CropAspectRatioPreset.ratio4x3,
       CropAspectRatioPreset.ratio5x3,
       CropAspectRatioPreset.ratio5x4,
       CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: primaryColor2,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio5x3,
          lockAspectRatio: false),
      iosUiSettings: const IOSUiSettings(
        title: 'Crop Image',
      ),
    );
    if(croppedFile != null) {
      Navigator.push(
          context,
          SwipeLeftAnimationRoute(
              widget: FilterProfile(
                  image: croppedFile,
                  isProfilePicture: widget.isProfilePicture
              )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor2,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: VariableText(
              text: "Select Media",
              fontsize: size.height * 0.020,
              weight: FontWeight.w500,
              fontFamily: fontMedium,
              fontcolor: Colors.white,
          ),
          leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Container(
              child: Icon(Icons.clear, color: Colors.white),
            ),
          ),
          actions: [
            InkWell(
              onTap: (){
                proceed();
              },
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white)
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 20,
              child: Container(
                  color: Colors.grey[300],
                  child: selectedImage != null ?
                  Image.file(selectedImage)
                      : Container()
              ),
            ),
            Expanded(
              flex: 18,
              child: Column(
                children: [
                  Container(
                    color: Colors.black87,
                    height: size.height * 0.055,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            VariableText(
                              text: "Gallery",
                              fontsize: size.height * 0.018,
                              fontFamily: fontSemiBold,
                              fontcolor: Colors.white,
                            ),
                            Icon(
                                Icons.arrow_drop_down_sharp,
                                size: size.height * 0.025,
                                color: Colors.white
                            )
                          ],
                        ),
                        Container(
                          height: size.height * 0.04,
                          width: size.height * 0.04,
                          //padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(55)
                          ),
                          child: Center(
                            child: Icon(
                                Icons.camera_alt_outlined,
                                size: size.height * 0.025,
                                color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _loading
                      ? Column(
                        children: [
                          SizedBox(height: size.height * 0.15),
                          CircularProgressIndicator(),
                        ],
                      )
                      :
                  GalleryAlbum(
                      album: _allMedia,
                    onPictureSelect: (id)async{
                      MediaPage media = await _allMedia.first.listMedia();
                      print(id.toString());
                      Medium item = media.items.where((element) => element.id == id).first;
                      print(item.id);
                      selectedImage = await item.getFile();
                      setState(() {
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GalleryVideoPicker extends StatefulWidget {
  GalleryVideoPicker({Key key}) : super(key: key);

  @override
  _GalleryVideoPickerState createState() => _GalleryVideoPickerState();
}
class _GalleryVideoPickerState extends State<GalleryVideoPicker> {
  VideoPlayerController _controller;
  List<Album> _allMedia = [];
  bool _loading = true;
  File selectedVideo;
  String fileName;
  File imageFile;


  Future _videoFromCamera() async {
    var image = await ImagePicker.platform
        .pickVideo(source: ImageSource.camera, maxDuration: Duration(seconds: 20));
    if (image != null) {
      selectedVideo = File(image.path);
      proceed();
    }
  }

  Future<void> loadGallery() async {
    if (await _promptPermissionSetting()) {
      //List<Album> albums = await PhotoGallery.listAlbums(mediumType: MediumType.image);
      //print("albums: " + albums.length.toString());
       List<Album> videoAlbums = await PhotoGallery.listAlbums(
           mediumType: MediumType.video, hideIfEmpty: false);
      final List<Album> allMedia = [
         ...videoAlbums,
        //...albums,
      ];
      setState(() {
        _allMedia = allMedia;
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  renderVideo(){
    _controller = VideoPlayerController.file(selectedVideo);
    _controller.addListener(() {
      if(mounted)
        setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
        await Permission.storage.request().isGranted &&
        await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadGallery();
  }
  proceed()async{
    _controller.pause();
    Navigator.push(
        context,
        SwipeRightAnimationRoute(
            widget: TrimmerView(file: selectedVideo)));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.removeListener((){});
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor2,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: VariableText(
            text: "Select Media",
            fontsize: size.height * 0.020,
            weight: FontWeight.w500,
            fontFamily: fontMedium,
            fontcolor: Colors.white,
          ),
          leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Container(
              child: Icon(Icons.clear, color: Colors.white),
            ),
          ),
          actions: [
            InkWell(
              onTap: (){
                proceed();
              },
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white)
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 20,
              child: Container(
                  color: Colors.grey[300],
                  child: selectedVideo != null ?
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(

                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        VideoPlayer(_controller),
                        ControlsOverlay(controller: _controller),
                        VideoProgressIndicator(_controller, allowScrubbing: true),
                      ],
                    ),
                  )
                      : Container()
              ),
            ),
            Expanded(
              flex: 18,
              child: Column(
                children: [
                  Container(
                    color: Colors.black87,
                    height: size.height * 0.055,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            VariableText(
                              text: "Gallery",
                              fontsize: size.height * 0.018,
                              fontFamily: fontSemiBold,
                              fontcolor: Colors.white,
                            ),
                            Icon(
                                Icons.arrow_drop_down_sharp,
                                size: size.height * 0.025,
                                color: Colors.white
                            )
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            _videoFromCamera();
                          },
                          child: Container(
                            height: size.height * 0.04,
                            width: size.height * 0.04,
                            //padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(55)
                            ),
                            child: Center(
                              child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: size.height * 0.025,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _loading
                      ? Column(
                    children: [
                      SizedBox(height: size.height * 0.15),
                      CircularProgressIndicator(),
                    ],
                  )
                      :
                  GalleryAlbum(
                    album: _allMedia,
                    onPictureSelect: (id)async{
                      MediaPage media = await _allMedia.first.listMedia();
                      Medium item = media.items.where((element) => element.id == id).first;
                      print(item.id);
                      selectedVideo = await item.getFile();
                      print(selectedVideo.path);
                      setState(() {
                      });
                      renderVideo();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GalleryAlbum extends StatefulWidget {
  final List<Album> album;
  Function onPictureSelect;

  GalleryAlbum({this.album, this.onPictureSelect});

  @override
  State<StatefulWidget> createState() => GalleryAlbumState();
}
class GalleryAlbumState extends State<GalleryAlbum> {
  List<Medium> _media = [];
  bool isDone = false;
  int selectedPictureIndex = 1;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    setState(() {
      isDone = true;
    });
    MediaPage mediaPage = await widget.album[0].listMedia();
    setState(() {
      _media = mediaPage.items;
      isDone = false;
    });
    widget.onPictureSelect(_media.first.id);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          itemCount: _media.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
          ),
          itemBuilder: (context, index) {
            return isDone
                ? CircularProgressIndicator()
                : GestureDetector(
              onTap: (){
                widget.onPictureSelect(_media[index].id);
              },
              child: Container(
                color: Colors.grey[300],
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage("assets/images/gallery_placeholder.png"),
                  image: ThumbnailProvider(
                    mediumId: _media[index].id,
                    mediumType: _media[index].mediumType,
                    highQuality: true,
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class FullScreenImage extends StatefulWidget {
  FullScreenImage({this.child, this.dark, this.onDelete, this.hasDelete = true});

  final Image child;
  final bool dark;
  final Function onDelete;
  final bool hasDelete;

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}
class _FullScreenImageState extends State<FullScreenImage> {
  @override
  void initState() {
    var brightness = widget.dark ? Brightness.light : Brightness.dark;
    var color = widget.dark ? Colors.black12 : Colors.white70;

    /*SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
      statusBarColor: color,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarDividerColor: color,
      systemNavigationBarIconBrightness: brightness,
    ));*/
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.dark ? Colors.black : Colors.white,
        body: Stack(
          children: [
            Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 333),
                  curve: Curves.fastOutSlowIn,
                  top: 0,
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4,
                    child: widget.child,
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: MaterialButton(
                  padding: const EdgeInsets.all(15),
                  elevation: 0,
                  child: Icon(
                    Icons.arrow_back,
                    color: widget.dark ? Colors.white : Colors.black,
                    size: 25,
                  ),
                  color: widget.dark ? Colors.black12 : Colors.white70,
                  highlightElevation: 0,
                  minWidth: double.minPositive,
                  height: double.minPositive,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            if(widget.hasDelete)
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: MaterialButton(
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    child: Icon(
                      Icons.delete,
                      color: widget.dark ? Colors.white : Colors.black,
                      size: 25,
                    ),
                    color: widget.dark ? Colors.black12 : Colors.white70,
                    highlightElevation: 0,
                    minWidth: double.minPositive,
                    height: double.minPositive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onPressed: () {
                      widget.onDelete();
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationPopup extends StatelessWidget {
  double height;
  double width;
  String title;
  String subtitle;
  Function onDelete;
  ConfirmationPopup({this.title="Are you sure?", this.subtitle="You wont be able to revert this!",
    this.height, this.width, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Container(
            height: height * 0.26,
            width: width * 0.90,
            color: Colors.transparent,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.04),
                  child: Container(
                    height: height * 0.22,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        VariableText(
                          text: title,
                          fontsize: height * 0.020,
                          //fontFamily: 'psemibold',
                        ),
                        VariableText(
                          text: subtitle,
                          textAlign: TextAlign.center,
                          fontsize: height * 0.016,
                          //fontFamily: 'pregular',
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.10,
                              vertical: height * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: MyButton(
                                    btnHeight: height * 0.045,
                                    btnRadius: 8,
                                    fontSize: height * 0.018,
                                    btnColor: themeRemoveBotton,
                                    borderColor: themeRemoveBotton,
                                    txtColor: Colors.white,
                                    btnTxt: "Yes",
                                    //buttonFontFamily: 'pmedium',
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      onDelete();
                                    }),
                              ),
                              SizedBox(width: width * 0.02),
                              Expanded(
                                child: MyButton(
                                    btnHeight: height * 0.045,
                                    btnRadius: 8,
                                    fontSize: height * 0.018,
                                    btnColor: Colors.white,
                                    txtColor: textColor1,
                                    borderColor: borderColor.withOpacity(0.5),
                                    btnTxt: "No",
                                    //buttonFontFamily: 'pmedium',
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    }),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: height * 0.08,
                    width: height * 0.08,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[200], width: 3),
                        borderRadius: BorderRadius.circular(55)),
                    child: Center(
                      child: Icon(
                        Icons.delete_outline,
                        size: height * 0.035,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ControlsOverlay extends StatelessWidget {
  VideoPlayerController controller;
  ControlsOverlay({Key key, this.controller})
      : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration(milliseconds: 0),
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  //final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        /*Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}mss'),
            ),
          ),
        ),*/
        /*Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),*/
      ],
    );
  }
}

class CropScreen extends StatelessWidget {
  CropScreen({Key key, /*this.controller*/}) : super(key: key);

  //VideoEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            /*Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      controller.rotate90Degrees(RotateDirection.left),
                  icon: const Icon(Icons.rotate_left),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      controller.rotate90Degrees(RotateDirection.right),
                  icon: const Icon(Icons.rotate_right),
                ),
              )
            ]),
            const SizedBox(height: 15),
            Expanded(
              child: AnimatedInteractiveViewer(
                maxScale: 2.4,
                child: CropGridViewer(
                    controller: controller, horizontalMargin: 60),
              ),
            ),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Center(
                    child: Text(
                      "CANCEL",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              buildSplashTap("16:9", 16 / 9,
                  padding: const EdgeInsets.symmetric(horizontal: 10)),
              buildSplashTap("1:1", 1 / 1),
              buildSplashTap("4:5", 4 / 5,
                  padding: const EdgeInsets.symmetric(horizontal: 10)),
              buildSplashTap("NO", null,
                  padding: const EdgeInsets.only(right: 10)),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    //2 WAYS TO UPDATE CROP
                    //WAY 1:
                    controller.updateCrop();
                    *//*WAY 2:
                    controller.minCrop = controller.cacheMinCrop;
                    controller.maxCrop = controller.cacheMaxCrop;
                    *//*
                    Navigator.pop(context);
                  },
                  icon: const Center(
                    child: Text(
                      "OK",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]),*/
          ]),
        ),
      ),
    );
  }

  /*Widget buildSplashTap(
      String title,
      double aspectRatio, {
        EdgeInsetsGeometry padding,
      }) {
    return InkWell(
      onTap: () => controller.preferredCropAspectRatio = aspectRatio,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.aspect_ratio, color: Colors.white),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }*/
}