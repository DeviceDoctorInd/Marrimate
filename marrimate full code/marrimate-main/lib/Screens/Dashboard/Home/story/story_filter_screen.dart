// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/splash_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class StoryFilter extends StatefulWidget {
  File image;
  StoryFilter({Key key, this.image}) : super(key: key);

  @override
  _StoryFilterState createState() => _StoryFilterState();
}

class _StoryFilterState extends State<StoryFilter> {
  List<Filter> filters = presetFiltersList;
  Map<String, List<int>> cachedFilters = {};
  Filter _filter;
  imageLib.Image _image;
  bool isLoading = false;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    convertImage();
  }

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  convertImage()async{
    _image = imageLib.decodeImage(await widget.image.readAsBytes());
    setState(() {

    });
  }

  uploadStory()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context,listen: false);
    String tempPath = (await getTemporaryDirectory()).path;
    File image = File('$tempPath/${widget.image.path.split("/").last}');
    await image.writeAsBytes(imageLib.encodeNamedImage(_image, widget.image.path.split("/").last));
    print(image.path);
    var response = await API.uploadStory(storyImage: image, userDetails: userDetails);
    if(response['status'] == true){
      setLoading(false);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Story uploaded",
          toastLength: Toast.LENGTH_LONG);
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_LONG);
    }
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
              text: tr("Apply Filters"),
              isBack: false,
              height: size.height * 0.085,
            ),
            body: Column(
              children: [
                if(_image != null)
                  SizedBox(
                    height: size.height * 0.55,
                    child: _buildFilteredImage(
                      _filter,
                      _image,
                      widget.image.path.split("/").last,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: padding, vertical: padding / 2),
                  child: Row(
                    children: [
                      VariableText(
                        text: tr("Filters"),
                        fontFamily: fontBold,
                        fontsize: size.height * 0.024,
                        fontcolor: primaryColor2,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                if(_image != null)
                  Container(
                    padding: EdgeInsets.only(left: padding/2),
                    height: size.height * 0.17,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _buildFilterThumbnail(
                                    filters[index], _image, widget.image.path.split("/").last),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  filters[index].name,
                                )
                              ],
                            ),
                          ),
                          onTap: () => setState(() {
                            _filter = filters[index];
                          }),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: padding * 4, vertical: padding / 2),
                  child: MyButton(
                    onTap: () {
                      uploadStory();
                    },
                    btnTxt: tr("Upload"),
                    borderColor: primaryColor2,
                    btnColor: primaryColor2,
                    txtColor: textColorW,
                    btnRadius: 5,
                    btnWidth: size.width * 0.45,
                    btnHeight: 50,
                    fontSize: size.height * 0.020,
                    weight: FontWeight.w700,
                    fontFamily: fontSemiBold,
                  ),
                ),
              ],
            ),
          ),
          if(isLoading) ProcessLoadingLight()
        ],
      ),
    );
  }

  Widget _buildFilteredImage(
      Filter filter, imageLib.Image image, String filename) {
    var size = MediaQuery.of(context).size;

    if (cachedFilters[filter?.name ?? "_"] == null) {
      return FutureBuilder<List<int>>(
        future: compute(
            applyFilter,
            <String, dynamic>{
              "filter": filter,
              "image": image,
              "filename": filename,
            }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return SizedBox(
                  height: size.height * 0.25,
                  child: Center(child: CircularProgressIndicator()));
            case ConnectionState.active:
            case ConnectionState.waiting:
              return SizedBox(
                  height: size.height * 0.25,
                  child: Center(child: CircularProgressIndicator()));
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              cachedFilters[filter?.name ?? "_"] = snapshot.data;
              return Image.memory(
                snapshot.data as dynamic,
                fit: BoxFit.contain,
              );
          }
          // unreachable
        },
      );
    } else {
      return Image.memory(
        cachedFilters[filter?.name ?? "_"] as dynamic,
        fit: BoxFit.contain,
      );
    }
  }

  _buildFilterThumbnail(
      Filter filter, imageLib.Image image, String filename) {
    if (cachedFilters[filter.name] == null) {
      return FutureBuilder<List<int>>(
        future: compute(
            applyFilter ,
            <String, dynamic>{
              "filter": filter,
              "image": image,
              "filename": filename,
            }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircleAvatar(
                radius: 50.0,
                child: Center(
                  child: Center(child: CircularProgressIndicator()),
                ),
                backgroundColor: Colors.white,
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              cachedFilters[filter.name] = snapshot.data;
              return CircleAvatar(
                radius: 50.0,
                backgroundImage: MemoryImage(
                  snapshot.data as dynamic,
                ),
                backgroundColor: Colors.white,
              );
          }
          // unreachable
        },
      );
    } else {
      return CircleAvatar(
        radius: 50.0,
        backgroundImage: MemoryImage(
          cachedFilters[filter.name] as dynamic,
        ),
        backgroundColor: Colors.white,
      );
    }
  }
}
