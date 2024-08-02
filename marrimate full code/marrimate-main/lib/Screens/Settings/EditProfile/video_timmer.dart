import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimmerView extends StatefulWidget {
  final File file;

  TrimmerView({Key key, this.file}) : super(key: key);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool isLoading = false;
  bool isTrimming = false;
  bool isUploading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  renderVideoUpload(context, Size size){
    showGeneralDialog(
      barrierLabel: "Trim",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Align(
              alignment: Alignment.center,
              child: Container(
                height: size.height * 0.16,
                width: size.width * 0.85,
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.08),
                decoration: BoxDecoration(
                    color: Color(0x90000000),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: size.height * 0.04,
                        width: size.height * 0.04,
                        child: CircularProgressIndicator(strokeWidth: 4.0, color: primaryColor2)
                    ),
                    SizedBox(height: size.height * 0.02),
                    if(isTrimming)
                      VariableText(
                        text: "Trimming Video...",
                        fontFamily: fontMedium,
                        fontsize: size.height * 0.020,
                        fontcolor: textColorW,
                      ),
                    if(isUploading)
                      VariableText(
                        text: "Uploading Video...",
                        fontFamily: fontMedium,
                        fontsize: size.height * 0.020,
                        fontcolor: textColorW,
                      ),
                  ],
                ),
              ),
            );
          }
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          //position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  uploadVideo(File video)async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.uploadUserVideo(
        video: video,
        userDetails: userDetails
    );
    if(response['status'] == true){
      Provider.of<UserModel>(context, listen: false).updateUserVideo(response['data']);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop(true);
    }else{
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_SHORT);

    }
  }

  Future<String> _saveVideo(var size) async {
    String _value;
    await _trimmer
        .saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
      onSave: (v){
          Navigator.of(context).pop();
          setState(() {
            isTrimming = false;
            isUploading = true;
            _value = v;
            print('OUTPUT PATH: $_value');
            renderVideoUpload(context, size);
            File trimmedVideo = File(v);
            uploadVideo(trimmedVideo);
          });
      }
    );
    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor2,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: VariableText(
          text: "Edit Video",
          fontsize: size.height * 0.020,
          weight: FontWeight.w500,
          fontFamily: fontMedium,
          fontcolor: Colors.white,
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset(
            "assets/icons/ic_back.png",
            scale: 2,
            color: textColorW,
          ),
        ),
        actions: [
          InkWell(
            onTap: (){
              setState(() {
                isTrimming = true;
                isUploading = false;
              });
              renderVideoUpload(context, size);
              _saveVideo(size);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                  padding: const EdgeInsets.all(13),
                  child: Icon(Icons.check, color: Colors.white)
              ),
            ),
          )
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 2),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                SizedBox(height: 5),
                Center(
                  child: TrimEditor(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: Duration(seconds: 20),
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                TextButton(
                  child: _isPlaying
                      ? Icon(
                    Icons.pause,
                    size: 50.0,
                    color: Colors.white,
                  )
                      : Icon(
                    Icons.play_arrow,
                    size: 50.0,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() {
                      _isPlaying = playbackState;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
