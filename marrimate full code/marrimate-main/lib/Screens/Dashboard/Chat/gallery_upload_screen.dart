import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

class MessageGalleryScreen extends StatefulWidget {
  const MessageGalleryScreen({Key key}) : super(key: key);

  @override
  State<MessageGalleryScreen> createState() => _MessageGalleryScreenState();
}

class _MessageGalleryScreenState extends State<MessageGalleryScreen> {
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
    if(selectedImage != null) {
      Navigator.of(context).pop(selectedImage);
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
                  child: Icon(Icons.send, color: Colors.white)
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
