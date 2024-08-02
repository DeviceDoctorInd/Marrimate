/*
import 'dart:convert';
import 'dart:io';

import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';

import '../../../../Widgets/common.dart';
import 'create_story_screen.dart';
import 'story_filter_screen.dart';

class ArTest extends StatefulWidget {
  const ArTest({Key key}) : super(key: key);

  @override
  _ArTestState createState() => _ArTestState();
}

class _ArTestState extends State<ArTest> {
  DeepArController _controller;
  String version = '';
  bool _isFaceMask = false;
  bool _isFilter = false;

  final List<String> _effectsList = [];
  final List<String> _maskList = [];
  final List<String> _filterList = [];
  int _effectIndex = 0;
  int _maskIndex = 0;
  int _filterIndex = 0;

  final String _assetEffectsPath = 'assets/effects/';

  @override
  void initState() {
    // TODO: implement initState
    _controller = DeepArController();
    if(!_controller.isInitialized){
      _controller.initialize(
        androidLicenseKey: "5680c3e630d081cba0a037561b43ba32f48fc3cfa6f37fd719314bc5b6c08174842fcc39c205311c",
        iosLicenseKey: "a3908a08f81bbf673e2662441e5ad5ea9c35fc1b53e33639d1fa75692846d4668136a3e1aabf0ec8",
        resolution: Resolution.high,
      ).then((value){
        if(value){
          print("Initialized!!!!");
          _initEffects();
          setState(() {});
        }else{
          print("Not Initialized!!!!");
        }
      });
    }
    super.initState();
    //init();
  }

  init(){
    _controller = DeepArController();
    if(!_controller.isInitialized){
      _controller.initialize(
        androidLicenseKey: "5680c3e630d081cba0a037561b43ba32f48fc3cfa6f37fd719314bc5b6c08174842fcc39c205311c",
        iosLicenseKey: "a3908a08f81bbf673e2662441e5ad5ea9c35fc1b53e33639d1fa75692846d4668136a3e1aabf0ec8",
        resolution: Resolution.high,
      ).then((value){
        if(value){
          print("Initialized!!!!");
          _initEffects();
          setState(() {});
        }else{
          print("Not Initialized!!!!");
        }
      });
    }
  }


  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //_controller.destroy();
  }

  @override
  Widget build(BuildContext context) {
    print(_controller.isInitialized.toString());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _controller.isInitialized
                ? DeepArPreview(_controller)
                : const Center(
              child: Text("Loading..."),
            ),
            if(_controller.isInitialized)
              _topMediaOptions(),
            if(_controller.isInitialized)
              _bottomMediaOptions(),
          ],
        )
      ),
    );
  }

  Positioned _topMediaOptions() {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                await _controller.toggleFlash();
                setState(() {});
              },
              color: Colors.white70,
              iconSize: 30,
              icon:
              Icon(_controller.flashState ? Icons.flash_on : Icons.flash_off),
            ),
            IconButton(
              onPressed: () async {
                _isFaceMask = !_isFaceMask;
                if (_isFaceMask) {
                  _controller.switchFaceMask(_maskList[_maskIndex]);
                } else {
                  _controller.switchFaceMask("null");
                }

                setState(() {});
              },
              color: Colors.white70,
              iconSize: 30,
              icon: Icon(
                _isFaceMask
                    ? Icons.face_retouching_natural_rounded
                    : Icons.face_retouching_off,
              ),
            ),
            IconButton(
              onPressed: () async {
                /*_isFilter = !_isFilter;
                if (_isFilter) {
                  _controller.switchFilter(_filterList[_filterIndex]);
                } else {
                  _controller.switchFilter("null");
                }
                setState(() {});*/
              },
              color: Colors.white70,
              iconSize: 30,
              icon: Icon(
                _isFilter ? Icons.filter_hdr : Icons.filter_hdr_outlined,
              ),
            ),
            IconButton(
                onPressed: () {
                  _controller.flipCamera();
                },
                iconSize: 30,
                color: Colors.white70,
                icon: const Icon(Icons.cameraswitch))
          ],
        ),
      ),
    );
  }
  Positioned _bottomMediaOptions() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(_isFaceMask)
              IconButton(
                  iconSize: 50,
                  onPressed: () {
                    if (_isFaceMask) {
                      String prevMask = _getPrevMask();
                      _controller.switchFaceMask(prevMask);
                    } else if (_isFilter) {
                      String prevFilter = _getPrevFilter();
                      _controller.switchFilter(prevFilter);
                    } else {
                      String prevEffect = _getPrevEffect();
                      _controller.switchEffect(prevEffect);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        SwipeUpAnimationRoute(
                          widget: GalleryStoryScreen(),
                        ));
                  },
                  iconSize: 40,
                  color: Colors.white,
                  icon: const Icon(Icons.image)
              ),
            ),
            InkWell(
              onTap: (){
                _controller.takeScreenshot().then((file) {
                  Navigator.push(
                      context,
                      SwipeLeftAnimationRoute(
                          widget: StoryFilter(
                              image: file,
                          )
                      )
                  );
                });
              },
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(90),
                  border: Border.all(color: Colors.white.withOpacity(0.9), width: 3)
                ),
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(90)
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                  onPressed: () async {
                    if (_controller.isRecording) {
                      File file = await _controller.stopVideoRecording();
                      OpenFile.open(file.path);
                    } else {
                      await _controller.startVideoRecording();
                    }

                    setState(() {});
                  },
                  iconSize: 45,
                  color: Colors.white,
                  icon: Icon(_controller.isRecording
                      ? Icons.videocam_sharp
                      : Icons.videocam_outlined)),
            ),
            /*IconButton(
                onPressed: () {
                  _controller.takeScreenshot().then((file) {
                    Navigator.push(
                        context,
                        SwipeLeftAnimationRoute(
                            widget: FilterProfile(
                                image: file,
                                isProfilePicture:false
                            )
                        )
                    );
                  });
                },
                color: Colors.white70,
                iconSize: 40,
                icon: const Icon(Icons.photo_camera)),*/
            if(_isFaceMask)
              IconButton(
                  iconSize: 50,
                  onPressed: () {
                    if (_isFaceMask) {
                      String nextMask = _getNextMask();
                      _controller.switchFaceMask(nextMask);
                    } else if (_isFilter) {
                      String nextFilter = _getNextFilter();
                      _controller.switchFilter(nextFilter);
                    } else {
                      String nextEffect = _getNextEffect();
                      _controller.switchEffect(nextEffect);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  )),
          ],
        ),
      ),
    );
  }

  /// Add effects which are rendered via DeepAR sdk
  void _initEffects() {
    // Either get all effects
    _getEffectsFromAssets(context).then((values) {
      _effectsList.clear();
      _effectsList.addAll(values);

      _maskList.clear();
      _maskList.add(_assetEffectsPath + 'flower_face.deepar');
      _maskList.add(_assetEffectsPath + 'viking_helmet.deepar');
      _maskList.add(_assetEffectsPath + 'burning_effect.deepar');
      _maskList.add(_assetEffectsPath + 'Hope.deepar');

      _filterList.clear();
      //_filterList.add(_assetEffectsPath + 'burning_effect.deepar');
      //_filterList.add(_assetEffectsPath + 'Hope.deepar');

      _effectsList.removeWhere((element) => _maskList.contains(element));

      _effectsList.removeWhere((element) => _filterList.contains(element));
    });

    // OR

    // Only add specific effects
    /*_effectsList.add(_assetEffectsPath+'burning_effect.deepar');
    _effectsList.add(_assetEffectsPath+'flower_face.deepar');
    _effectsList.add(_assetEffectsPath+'Hope.deepar');
    _effectsList.add(_assetEffectsPath+'viking_helmet.deepar');*/
  }
  /// Get all deepar effects from assets
  ///
  Future<List<String>> _getEffectsFromAssets(BuildContext context) async {
    final manifestContent =
    await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final filePaths = manifestMap.keys
        .where((path) => path.startsWith(_assetEffectsPath))
        .toList();
    return filePaths;
  }

  /// Get next effect
  String _getNextEffect() {
    _effectIndex < _effectsList.length ? _effectIndex++ : _effectIndex = 0;
    return _effectsList[_effectIndex];
  }

  /// Get previous effect
  String _getPrevEffect() {
    _effectIndex > 0 ? _effectIndex-- : _effectIndex = _effectsList.length;
    return _effectsList[_effectIndex];
  }

  /// Get next mask
  String _getNextMask() {
    _maskIndex < _maskList.length ? _maskIndex++ : _maskIndex = 0;
    return _maskList[_maskIndex];
  }

  /// Get previous mask
  String _getPrevMask() {
    _maskIndex > 0 ? _maskIndex-- : _maskIndex = _maskList.length;
    return _maskList[_maskIndex];
  }

  /// Get next filter
  String _getNextFilter() {
    _filterIndex < _filterList.length ? _filterIndex++ : _filterIndex = 0;
    return _filterList[_filterIndex];
  }

  /// Get previous filter
  String _getPrevFilter() {
    _filterIndex > 0 ? _filterIndex-- : _filterIndex = _filterList.length;
    return _filterList[_filterIndex];
  }
}
 */