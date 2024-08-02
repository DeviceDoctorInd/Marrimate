import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Settings/EditProfile/filter_profile.dart';
import 'package:marrimate/Screens/Settings/EditProfile/video_player.dart';
import 'package:marrimate/Screens/Settings/setting_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/hobbies_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:video_player/video_player.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _shortBioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TabController tabController;
  bool isLoadingMain = false;
  bool isLoadingProfile = false;
  bool addEmail = false;
  List<Hobby> hobbies = [];
  List<Hobby> backupHobbies = [];
  //List<Album> videoAlbums = [];
  bool updateVideos = false;

  setLoadingProfile(bool loading){
    if(mounted){
      setState(() {
        isLoadingProfile = loading;
      });
    }
  }
  setLoadingMain(bool loading){
    if(mounted) {
      setState(() {
        isLoadingMain = loading;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHobbies();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(handleTabSelection);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    _fullNameController.text = userDetails.name;
    _contactController.text = userDetails.contactNumber;
    _emailController.text = userDetails.email;
    _shortBioController.text = userDetails.shortBio;
    backupHobbies.addAll(userDetails.hobbies);
    if(_emailController.text.isEmpty){
      addEmail = true;
    }
    loadVideos();
  }

  List<VideoPlayerController> _controllers = [];

  loadVideos()async{
    print("Loading Videos...");
    _controllers.clear();
    var userDetails = Provider.of<UserModel>(context, listen: false);
    for(var item in userDetails.userVideos){
      _controllers.add(VideoPlayerController.network(item.videoUrl));
    }
    for(var item in _controllers){
      item.setLooping(true);
      item.initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for(var item in _controllers){
      item.dispose();
    }
  }

  handleTabSelection(){
    setState(() {});
  }

  getHobbies()async{
    setLoadingMain(true);
    var response = await API.getAllHobbies();
    if(response != null){
      for(var item in response){
        hobbies.add(Hobby.fromJson(item));
      }
      setLoadingMain(false);
    }else{
      setLoadingMain(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  updateProfile(UserModel userDetails)async{
    if(_formKey.currentState.validate()){
      setLoadingProfile(true);
      UserModel newDetails = UserModel(
        name: _fullNameController.text,
        hobbies: userDetails.hobbies,
        shortBio: _shortBioController.text,
        email: addEmail ? _emailController.text.isEmpty ? null : _emailController.text : null,
        accessToken: userDetails.accessToken
      );
      var response = await API.editProfile(userDetails: newDetails, newImage: false);
      if(response['status'] == true){
        UserModel updateDetails = UserModel(
            name: _fullNameController.text,
            shortBio: _shortBioController.text,
            email: userDetails.email
        );
        if(addEmail && _emailController.text.isNotEmpty){
          updateDetails.email = _emailController.text;
        }
        Provider.of<UserModel>(context, listen: false).updateUser(updateDetails);
        setLoadingProfile(false);
        Navigator.of(context).pop();
      }else{
        setLoadingProfile(false);
        Fluttertoast.showToast(
            msg: response['msg'],
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  uploadProfilePicture(){
    Navigator.push(
        context,
        SwipeRightAnimationRoute(
            widget: GalleryImagePicker(isProfilePicture: true)));
  }
  addUserImage(){
    Navigator.push(
        context,
        SwipeRightAnimationRoute(
            widget: GalleryImagePicker(isProfilePicture: false)));
  }

  deleteUserImage(int imgID)async{
    Navigator.of(context).pop();
    var userDetails = Provider.of<UserModel>(context, listen: false);
    setLoadingMain(true);
    var response = await API.deleteUserImage(imgID, userDetails.accessToken);
    if(response['status'] == true){
      Provider.of<UserModel>(context, listen: false).deleteUserImage(imgID);
      setLoadingMain(false);
    }else{
      setLoadingMain(false);
      Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_LONG);
    }
  }

  addUserVideo(){
    Navigator.push(
        context,
        SwipeRightAnimationRoute(
            widget: GalleryVideoPicker())).then((value){
              print(value.toString());
              if(value != null){
                updateVideos = value;
                loadVideos();
              }
    });
  }
  deleteUserVideo(int videoID)async{
    Navigator.of(context).pop();
    var userDetails = Provider.of<UserModel>(context, listen: false);
    setLoadingMain(true);
    var response = await API.deleteUserVideo(videoID, userDetails.accessToken);
    if(response['status'] == true){
      Provider.of<UserModel>(context, listen: false).deleteUserVideo(videoID);
      loadVideos();
      setLoadingMain(false);
    }else{
      setLoadingMain(false);
      Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context, listen: true);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: WillPopScope(
        onWillPop: (){
          userDetails.hobbies.clear();
          userDetails.hobbies.addAll(backupHobbies);
          Navigator.of(context).pop(updateVideos);
          //return Future.value(true);
        },
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                toolbarHeight: size.height * 0.085,
                leading: InkWell(
                  onTap: () {
                    userDetails.hobbies.clear();
                    userDetails.hobbies.addAll(backupHobbies);
                    Navigator.of(context).pop(updateVideos);
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
                  text: tr("Edit Profile"),
                  fontFamily: fontSemiBold,
                  fontsize: size.height * 0.026,
                  fontcolor: textColorW,
                ),
                actions: [
                  isLoadingProfile ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                    child: Container(
                      padding: const EdgeInsets.all(13),
                        child:
                        SizedBox(
                          height: size.height * 0.02,
                            width: size.height * 0.02,
                            child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white))
                          //Icon(Icons.check, color: Colors.blue)
                    ),
                  ) : InkWell(
                    onTap: (){
                      updateProfile(userDetails);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                      child: Container(
                          padding: const EdgeInsets.all(13),
                          child: Icon(Icons.check, color: Colors.white)
                      ),
                    ),
                  )
                ],
              ),
              body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: size.height * 0.04),
                            ///Profile picture
                            Container(
                              height: size.height * 0.18,
                              width: size.height * 0.18,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  //color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(99)
                              ),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Image _img = Image.network(userDetails.profilePicture);
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          opaque: false,
                                          barrierColor: true ? Colors.black : Colors.white,
                                          pageBuilder: (BuildContext context, _, __) {
                                            return FullScreenImage(
                                              child: _img,
                                              dark: true,
                                              hasDelete: false,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: size.height * 0.18,
                                      width: size.height * 0.18,
                                      //color: Colors.red,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(99),
                                        child: Image.network(
                                          userDetails.profilePicture,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
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
                                                    size: 25, color: Colors.red));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: () {
                                        uploadProfilePicture();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(size.height * 0.008,),
                                        margin: const EdgeInsets.only(right: 15),
                                        height: size.height * 0.035,
                                        width: size.height * 0.035,
                                        decoration: BoxDecoration(
                                          color: primaryColor2,
                                          borderRadius:
                                              BorderRadius.circular(55),
                                        ),
                                        child: Image.asset(
                                          "assets/icons/ic_camera.png",
                                          color: textColorW,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            ///Full name
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding, vertical: padding / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VariableText(
                                    text: "Full Name",
                                    fontcolor: textColorB,
                                    fontFamily: fontRegular,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  TextFormField(
                                    controller: _fullNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter full name';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      fontFamily: fontRegular,
                                      color: textColor1,
                                      fontSize: size.height * 0.02,
                                    ),
                                    decoration: const InputDecoration(
                                        hintText: "Enter full name",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 12, right: 8, bottom: 0)),
                                  ),
                                ],
                              ),
                            ),
                            ///Contact
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding, vertical: padding / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VariableText(
                                    text: "Phone Number",
                                    fontcolor: textColorB,
                                    fontFamily: fontRegular,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  TextFormField(
                                    controller: _contactController,
                                    enabled: false,
                                    style: TextStyle(
                                      fontFamily: fontRegular,
                                      color: textColor1,
                                      fontSize: size.height * 0.02,
                                    ),
                                    decoration: const InputDecoration(
                                        hintText: "0123456789",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 12, right: 8, bottom: 0)),
                                  ),
                                ],
                              ),
                            ),
                            ///Email
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding, vertical: padding / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VariableText(
                                    text: "Email",
                                    fontcolor: textColorB,
                                    fontFamily: fontRegular,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  TextFormField(
                                    controller: _emailController,
                                    enabled: addEmail,
                                    style: TextStyle(
                                      fontFamily: fontRegular,
                                      color: textColor1,
                                      fontSize: size.height * 0.02,
                                    ),
                                    decoration: const InputDecoration(
                                        hintText: "example@gmail.com",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 12, right: 8, bottom: 0)),
                                  ),
                                ],
                              ),
                            ),
                            ///Short Bio
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding, vertical: padding / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VariableText(
                                    text: "Short Bio",
                                    fontcolor: textColorB,
                                    fontFamily: fontRegular,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  TextFormField(
                                    maxLines: 3,
                                    controller: _shortBioController,
                                    // maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    style: TextStyle(
                                      fontFamily: fontRegular,
                                      color: textColor1,
                                      fontSize: size.height * 0.02,
                                      height: size.height * 0.0018,
                                    ),
                                    decoration: const InputDecoration(
                                        hintText: "Enter short bio",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 12, right: 8, top: 8, bottom: 0)),
                                  ),
                                ],
                              ),
                            ),
                            ///Interest
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding, vertical: padding / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const VariableText(
                                    text: "Interests",
                                    fontcolor: textColorB,
                                    fontFamily: fontRegular,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  ///Hobbies
                                  //if(!isLoadingProfile)
                                  DropdownFormField<Hobby>(
                                    //onEmptyActionPressed: () async {},
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.clear),
                                        hintText: "Search here..."
                                        //labelText: "Search"
                                    ),
                                    onSaved: (dynamic str) {
                                      print("Saved");
                                    },
                                    onChanged: (dynamic str) {
                                      print("Changed: " + str.name.toString());
                                      userDetails.hobbies.add(Hobby(id: str.id, name: str.name, icon: str.icon));
                                    },
                                    validator: (dynamic str) {},
                                    displayItemFn: (dynamic item) => Text(
                                      item != null ? item.name : '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    findFn: (dynamic str) async => hobbies,
                                    filterFn: (dynamic item, str) =>
                                    item.name.toLowerCase().indexOf(str.toLowerCase()) >= 0,
                                    dropdownItemFn: (dynamic item, position, focused,
                                        dynamic lastSelectedItem, onTap) =>
                                        ListTile(
                                          title: Text(item.name),
                                          //subtitle: Text(item['desc'] ?? ''),
                                          ///tileColor: focused ? Colors.redAccent : Colors.transparent,
                                          tileColor: Colors.transparent,
                                          onTap: onTap,
                                        ),
                                  ),
                                 /* SizedBox(height: size.height * 0.01),
                                  TextFormField(
                                    style: TextStyle(
                                      fontFamily: fontRegular,
                                      color: textColor1,
                                      fontSize: size.height * 0.02,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Search here...",
                                        suffixIcon: Icon(
                                          Icons.clear,
                                          color: textColorG,
                                          size: size.height * 0.025,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 12, right: 8, bottom: 0)),
                                  ),*/
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding, vertical: padding / 5),
                              child: Wrap(
                                spacing: 7,
                                runSpacing: 5,
                                runAlignment: WrapAlignment.start,
                                alignment: WrapAlignment.start,
                                children: List.generate(userDetails.hobbies.length,
                                        (index){
                                          return InterestButton(
                                            onTap: () {
                                              Provider.of<UserModel>(context, listen: false).removeHobby(userDetails.hobbies[index].id);
                                            },
                                            btnTxt: userDetails.hobbies[index].name,
                                            btnColor: primaryColor1,
                                            txtColor: textColorW,
                                            btnRadius: 5,
                                            btnHeight: size.height * 0.05,
                                            fontSize: size.height * 0.016,
                                            weight: FontWeight.bold,
                                            icon: userDetails.hobbies[index].icon,
                                            iconHeight: size.height * 0.021,
                                            iconColor: textColorW,
                                          );
                                        })
                                /*[
                                  InterestButton(
                                    onTap: () {},
                                    btnTxt: "Art & Crafts",
                                    btnColor: primaryColor1,
                                    txtColor: textColorW,
                                    btnRadius: 5,
                                    btnHeight: size.height * 0.05,
                                    fontSize: size.height * 0.018,
                                    weight: FontWeight.bold,
                                    icon: "assets/icons/ic_camera.png",
                                    iconHeight: size.height * 0.023,
                                    iconColor: textColorW,
                                  ),
                                  InterestButton(
                                    onTap: () {},
                                    btnTxt: "Music",
                                    btnColor: primaryColor1,
                                    txtColor: textColorW,
                                    btnRadius: 5,
                                    btnHeight: size.height * 0.05,
                                    fontSize: size.height * 0.018,
                                    weight: FontWeight.bold,
                                    icon: "assets/icons/ic_music.png",
                                    iconHeight: size.height * 0.023,
                                    iconColor: textColorW,
                                  ),
                                ],*/
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                          ],
                        ),
                      ),
                    ),
                    SliverAppBar(
                        expandedHeight: size.height * 0.01,
                        toolbarHeight: size.height * 0.01,
                        backgroundColor: textColorW,
                        pinned: true,
                        // floating: true,
                        // forceElevated: value,
                        bottom: PreferredSize(
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xffE5E5E5), width: 3))),
                              // padding: EdgeInsets.only(right: size.width * 0.5),
                              child: TabBar(
                                controller: tabController,
                                // physics: NeverScrollableScrollPhysics(),
                                indicator: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: primaryColor1, width: 2))),
                                labelColor: primaryColor1,
                                indicatorSize: TabBarIndicatorSize.label,
                                unselectedLabelColor: primaryColor2,
                                padding: EdgeInsets.all(0),
                                labelPadding: EdgeInsets.all(0),
                                labelStyle: TextStyle(fontFamily: fontRegular),
                                tabs: [
                                  Tab(
                                    text: tr("Photos"),
                                  ),
                                  Tab(
                                    text: tr("Videos"),
                                  ),
                                  Tab(
                                    text: tr("Bio"),
                                  ),
                                ],
                              ),
                            ),
                            preferredSize: Size(0, size.height * 0.06))),
                  ];
                },
                body: TabBarView(
                  controller: tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GridView.builder(
                      itemCount: userDetails.userImages.length + 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        // mainAxisExtent: 100,
                      ),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return InkWell(
                            onTap: (){
                              addUserImage();
                            },
                            child: Image.asset(
                              "assets/images/add_image.png",
                              fit: BoxFit.cover,
                            ),
                          );
                        }

                        return InkWell(
                          onTap: (){
                            Image _img = Image.network(userDetails.userImages[index-1].imageUrl);
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                barrierColor: true ? Colors.black : Colors.white,
                                pageBuilder: (BuildContext context, _, __) {
                                  return FullScreenImage(
                                    child: _img,
                                    dark: true,
                                    hasDelete: true,
                                    onDelete: (){
                                      renderDeleteImagePopup(context,
                                          userDetails.userImages[index-1].id,
                                          size.height,
                                          size.width);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          child: Image.network(
                            userDetails.userImages[index-1].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    GridView.builder(
                      itemCount: userDetails.userVideos.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return InkWell(
                            onTap: (){
                              addUserVideo();
                            },
                            child: Image.asset(
                              "assets/images/add_image.png",
                              fit: BoxFit.cover,
                            ),
                          );
                        }

                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                FadeAnimationRoute(
                                  milliseconds: 200,
                                    widget: UserVideoPlayer(
                                      videoURL: userDetails.userVideos[index-1].videoUrl,
                                      onDelete: (){
                                        renderDeleteVideoPopup(
                                            context,
                                            userDetails.userVideos[index-1].id,
                                            size.height, size.width);
                                      },
                                    )));
                          },
                            child: VideoPlayer(_controllers[index-1]));
                        /*return Image.asset(
                          "assets/images/dummy_profile.png",
                          fit: BoxFit.cover,
                        );*/
                      },
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: padding,
                              right: padding,
                              top: padding,
                              bottom: padding - 17,
                            ),
                            child: Row(
                              children: [
                                VariableText(
                                  text: "Short Bio:",
                                  fontFamily: fontBold,
                                  fontsize: size.height * 0.021,
                                  fontcolor: primaryColor2,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: padding,
                              right: padding,
                              // top: padding - 10,
                              bottom: padding,
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  child: VariableText(
                                    text: userDetails.shortBio??"",
                                    fontFamily: fontSemiBold,
                                    fontsize: size.height * 0.0162,
                                    fontcolor: textColorG,
                                    max_lines: 3,
                                    line_spacing: size.height * 0.0017,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(isLoadingMain) ProcessLoadingLight()
          ],
        ),
      ),
    );
  }

  renderDeleteImagePopup(BuildContext context, int imgID, double height, double width){
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return ConfirmationPopup(
          height: height,
          width: width,
          subtitle: "Do you want to delete this image?",
          onDelete: (){
            deleteUserImage(imgID);
          },
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
  renderDeleteVideoPopup(BuildContext context, int videoID, double height, double width){
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return ConfirmationPopup(
          height: height,
          width: width,
          subtitle: "Do you want to delete this video?",
          onDelete: (){
            deleteUserVideo(videoID);
          },
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
}
