import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

import 'story_filter_screen.dart';

class GalleryStoryScreen extends StatefulWidget {
  const GalleryStoryScreen({Key key}) : super(key: key);

  @override
  State<GalleryStoryScreen> createState() => _GalleryStoryScreenState();
}

class _GalleryStoryScreenState extends State<GalleryStoryScreen> {
  List<Album> _allMedia = [];
  bool _loading = false;
  File selectedImage;

  @override
  void initState() {
    super.initState();
    _loading = true;
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);
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

  Future _imgFromCamera() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      selectedImage = File(image.path);
      proceed();
    }
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
              widget: StoryFilter(
                  image: croppedFile,
              )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;
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
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
                              InkWell(
                                onTap: (){
                                  _imgFromCamera();
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
                  //AlbumPage(_allMedia),
                  // AlbumPage(_albums),
                ],
              ),
      ),
    );
  }
}

class AlbumPage extends StatefulWidget {
  final List<Album> album;

  AlbumPage(List<Album> album) : album = album;

  @override
  State<StatefulWidget> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  List<Medium> _media = [];
  bool isDone = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          itemCount: _media.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
          ),
          itemBuilder: (context, index) {
            return isDone
                ? CircularProgressIndicator()
                : GestureDetector(
                    onTap: ()async{
                      File tempFile = await _media[index].getFile();
                      Navigator.pushReplacement(
                          context,
                          SwipeLeftAnimationRoute(
                            widget: StoryFilter(
                                image: tempFile,
                            ),
                          ));
                    },
                    child: Container(
                      color: Colors.grey[300],
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: AssetImage("assets/images/keychain.png"),
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
