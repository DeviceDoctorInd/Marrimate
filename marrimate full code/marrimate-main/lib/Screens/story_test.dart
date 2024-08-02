import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:marrimate/Widgets/styles.dart';

class StoryTest extends StatefulWidget {
  Size size;
  StoryTest({Key key, this.size}) : super(key: key);

  @override
  State<StoryTest> createState() => _StoryTestState();
}

class _StoryTestState extends State<StoryTest> with TickerProviderStateMixin{

  TabController tabController;
  List<AnimationController> controllers = [];
  List<Animation<double>> tween = [];

  List stories = [
    "assets/images/dummy_story.png",
    "assets/images/dummy_story.png",
    "assets/images/dummy_story.png",
    "assets/images/dummy_story.png",
    "assets/images/dummy_story.png",
    "assets/images/dummy_story.png",
    "assets/images/dummy_story.png",
  ];

  int activeIndex = 0;

  List<double> storyProgress = [];
  double storyIndicator = 0.0;

  handleTabSelection() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: stories.length, initialIndex: 0, vsync: this);
    tabController.addListener(handleTabSelection);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    print(widget.size.width.toString());
    storyIndicator = ((widget.size.width - 10) - (stories.length * 3)) / stories.length;
    print(storyIndicator.toString());
    for(int i=0; i < stories.length; i++){
      controllers.add(AnimationController(duration: Duration(seconds: 3), vsync: this));
    }
    for(int i=0; i < stories.length; i++){
      tween.add(Tween<double>(begin:0,end:1).animate(
          CurvedAnimation(parent: controllers[i], curve: Curves.linear)
      ));
    }
    storyProgress = List.filled(stories.length, 0.0);
    go();
  }

  go(){
    tabController.animateTo(activeIndex, duration: Duration(milliseconds: 300));
    storyProgress[activeIndex] = storyIndicator;
    controllers[activeIndex].addListener(() {
      setState(() {});
    });

    controllers[activeIndex].forward().whenComplete((){
      if(activeIndex < stories.length - 1){
        activeIndex++;
        go();
      }else{
        print("Exit");
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  List<Widget> _renderStories(){
    final children = <Widget>[];
    for(var item in stories){
      children.add(
          Align(
              alignment: Alignment.center,
              child: Image.asset("assets/images/dummy_story.png")
          )
      );
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //print(tween.first.value.toString());

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
              /*Align(
                alignment: Alignment.center,
                  //child: Image.asset("assets/images/dummy_story.png")
              ),*/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: Row(
                  children: List.generate(stories.length, (index){
                    return Padding(
                      padding: EdgeInsets.only(right: stories.length-1 == index ? 0 : 3),
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
                    children: List.generate(stories.length, (index){
                      return Padding(
                        padding: EdgeInsets.only(right: stories.length-1 == index ? 0 : 3),
                        child: Container(
                          height: 2,
                          width: (storyProgress[index] * tween[index].value),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                      );
                    }),
                  )
              )
            ]
          ),
        ),
      ),
    );
  }
}
