import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:provider/provider.dart';

import '../../../../models/my_story_model.dart';

class ViewMyStoryScreen extends StatefulWidget {
  MyStories myStories;
  Size size;

  ViewMyStoryScreen({Key key, this.myStories, this.size}) : super(key: key);

  @override
  State<ViewMyStoryScreen> createState() => _ViewMyStoryScreenState();
}

class _ViewMyStoryScreenState extends State<ViewMyStoryScreen>
    with TickerProviderStateMixin{

  TabController tabController;
  List<AnimationController> controllers = [];
  List<Animation<double>> tween = [];
  List<double> storyProgress = [];
  double storyIndicator = 0.0;
  int activeIndex = 0;

  bool storyLoaded = false;
  bool downloadedCheck = true;

  @override
  void initState() {
    tabController = TabController(length: widget.myStories.myStories.length, initialIndex: 0, vsync: this);
    tabController.addListener(handleTabSelection);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    storyIndicator = ((widget.size.width - 10) - (widget.myStories.myStories.length * 3)) / widget.myStories.myStories.length;

    for(int i=0; i < widget.myStories.myStories.length; i++){
      controllers.add(AnimationController(duration: const Duration(seconds: 6), vsync: this));
    }
    for(int i=0; i < widget.myStories.myStories.length; i++){
      tween.add(Tween<double>(begin:0,end:1).animate(
          CurvedAnimation(parent: controllers[i], curve: Curves.linear)
      ));
    }
    storyProgress = List.filled(widget.myStories.myStories.length, 0.0);
    // TODO: implement initState
    super.initState();
  }

  go(int currentIndex){
    print("go: " + currentIndex.toString());
    if(storyLoaded){
      tabController.animateTo(activeIndex, duration: Duration(milliseconds: 300));
      storyProgress[activeIndex] = storyIndicator;
      controllers[activeIndex].addListener(() {
        setState(() {});
      });

      controllers[activeIndex].forward().whenComplete((){
        if(activeIndex < widget.myStories.myStories.length - 1){
          activeIndex++;
          storyLoaded = false;
          downloadedCheck = true;
          tabController.animateTo(activeIndex, duration: const Duration(milliseconds: 300));
        }else{
          print("Exit");
          Navigator.of(context).pop();
        }
      });
      storyLoaded = false;
    }
  }

  handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    for(int i=0; i < widget.myStories.myStories.length; i++){
      controllers[i].dispose();
    }
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  List<Widget> _renderStories(){
    final children = <Widget>[];
    for(int i=0; i < widget.myStories.myStories.length; i++){
      children.add(
          Align(
              alignment: Alignment.center,
              child: Image.network(
                widget.myStories.myStories[i].image,
                frameBuilder: (BuildContext context, Widget child, int a, bool downloaded){
                  if(downloaded && downloadedCheck){
                    storyLoaded = true;
                    downloadedCheck = false;
                  }
                  return child;
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null && storyLoaded){
                    go(i);
                    return child;
                  }else if(loadingProgress == null){
                    return child;
                  }
                  if(loadingProgress.expectedTotalBytes != null){
                    storyLoaded = true;
                  }else{
                    storyLoaded = false;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              )
          )
      );
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ..._renderStories()
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  child: Row(
                    children: List.generate(widget.myStories.myStories.length, (index){
                      return Padding(
                        padding: EdgeInsets.only(right: widget.myStories.myStories.length-1 == index ? 0 : 3),
                        child: Container(
                          height: 2,
                          width: storyIndicator,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                      );
                    }),
                  )
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  child: Row(
                    children: List.generate(widget.myStories.myStories.length, (index){
                      return Padding(
                        padding: EdgeInsets.only(right: widget.myStories.myStories.length-1 == index ? 0 : 3),
                        child: Container(
                          height: 2,
                          width: (storyProgress[index] * tween[index].value),
                          decoration: BoxDecoration(
                              color: primaryColor1,
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                      );
                    }),
                  )
              ),
              Positioned(
                top: 35,
                left: 15,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/ic_back.png",
                        scale: 2,color: Colors.white.withOpacity(0.7),
                      ),
                      SizedBox(width: 15),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(size.height * 0.1),
                          child: CachedNetworkImage(
                            imageUrl: userDetails.profilePicture,
                            fit: BoxFit.cover,
                            height: size.height * 0.045,
                            width: size.height * 0.045,
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
                      SizedBox(width: 8),
                      VariableText(
                        text: userDetails.name,
                        fontFamily: fontMedium,
                        fontsize: size.height * 0.024,
                        fontcolor: textColorW,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ), // To disable vertical swipe gestures, ignore this parameter.
        /*bottomNavigationBar: MyButton(
          onTap: () {
            // Navigator.push(
            //     context,
            //     SwipeLeftAnimationRoute(
            //       widget: OtpScreen(),
            //     ));
          },
          btnTxt: "Seen by 2",
          btnColor: textColorB,
          txtColor: textColorW,
          btnRadius: 0,
          btnWidth: size.width,
          btnHeight: 50,
          fontSize: size.height * 0.022,
          weight: FontWeight.w700,
          fontFamily: fontSemiBold,
        ),*/
      ),
    );
  }
}
