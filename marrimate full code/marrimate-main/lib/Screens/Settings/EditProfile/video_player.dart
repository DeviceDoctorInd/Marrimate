import 'package:flutter/material.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:video_player/video_player.dart';

class UserVideoPlayer extends StatefulWidget {
  String videoURL;
  Function onDelete;
  UserVideoPlayer({Key key, this.videoURL, this.onDelete}) : super(key: key);

  @override
  _UserVideoPlayerState createState() => _UserVideoPlayerState();
}

class _UserVideoPlayerState extends State<UserVideoPlayer> {
  VideoPlayerController _controller;

  renderVideo(){
    _controller = VideoPlayerController.network(widget.videoURL);
    _controller.addListener(() {
      if(mounted)
        setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {_controller.play();}));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    renderVideo();
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
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                      color: Colors.grey[300],
                      child: AspectRatio(
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
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.05,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0x65000000)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                          child: Icon(Icons.clear, size: size.height * 0.025, color: Colors.white),
                        )
                    ),
                    if(widget.onDelete != null)
                    InkWell(
                        onTap: (){
                          widget.onDelete();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                          child: Icon(Icons.delete, size: size.height * 0.025, color: Colors.white),
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
