
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/common.dart';
import '../../../Widgets/styles.dart';
import '../../../models/story_model.dart';
import '../../../models/user_model.dart';
import '../../../services/api.dart';

class ViewStoryScreen extends StatefulWidget {
  Story storyDetails;
  Size size;

  ViewStoryScreen({Key key, this.storyDetails, this.size}) : super(key: key);

  @override
  _ViewStoryScreenState createState() => _ViewStoryScreenState();
}

class _ViewStoryScreenState extends State<ViewStoryScreen>
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
    tabController = TabController(length: widget.storyDetails.userStories.length, initialIndex: 0, vsync: this);
    tabController.addListener(handleTabSelection);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    storyIndicator = ((widget.size.width - 10) - (widget.storyDetails.userStories.length * 3)) / widget.storyDetails.userStories.length;

    for(int i=0; i < widget.storyDetails.userStories.length; i++){
      controllers.add(AnimationController(duration: const Duration(seconds: 6), vsync: this));
    }
    for(int i=0; i < widget.storyDetails.userStories.length; i++){
      tween.add(Tween<double>(begin:0,end:1).animate(
          CurvedAnimation(parent: controllers[i], curve: Curves.linear)
      ));
    }
    storyProgress = List.filled(widget.storyDetails.userStories.length, 0.0);

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

      updateIsSeen();
      controllers[activeIndex].forward().whenComplete((){
        if(activeIndex < widget.storyDetails.userStories.length - 1){
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

  updateIsSeen()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.updateStorySeen(userDetails, storyID: widget.storyDetails.userStories[activeIndex].id);
    Provider.of<MatchedStories>(context, listen: false).updateIsSeen(widget.storyDetails.userDetails.id, widget.storyDetails.userStories[activeIndex].id);
  }

  @override
  void dispose() {
    tabController.dispose();
    for(int i=0; i < widget.storyDetails.userStories.length; i++){
      controllers[i].dispose();
    }
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  handleTabSelection() {
    setState(() {});
  }

  List<Widget> _renderStories(){
    final children = <Widget>[];
    for(int i=0; i < widget.storyDetails.userStories.length; i++){
      children.add(
          Align(
              alignment: Alignment.center,
              child: Image.network(
                widget.storyDetails.userStories[i].image,
                frameBuilder: (BuildContext context, Widget child, int a, bool downloaded){
                  if(downloaded && downloadedCheck){
                    print(downloaded.toString());
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
              /*Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        print("Back!!");
                      },
                      child: Container(
                        //color: Colors.redAccent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        print("Forward!!");
                      },
                      child: Container(
                        //color: Colors.yellowAccent,
                      ),
                    ),
                  )
                ],
              ),*/
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  child: Row(
                    children: List.generate(widget.storyDetails.userStories.length, (index){
                      return Padding(
                        padding: EdgeInsets.only(right: widget.storyDetails.userStories.length-1 == index ? 0 : 3),
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
                    children: List.generate(widget.storyDetails.userStories.length, (index){
                      return Padding(
                        padding: EdgeInsets.only(right: widget.storyDetails.userStories.length-1 == index ? 0 : 3),
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
                          imageUrl: widget.storyDetails.userDetails.profilePicture,
                          fit: BoxFit.fill,
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
                        text: widget.storyDetails.userDetails.name,
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
      ),
    );
  }
}
