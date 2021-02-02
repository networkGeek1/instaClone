import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaClone/models/user.dart';
import 'package:instaClone/services/database.dart';
import 'package:instaClone/widgets/appBar.dart';
import 'package:path/path.dart' as path;
import 'home.dart' as home;

class PostScreen extends StatefulWidget {
  bool isFromHome;
  PostScreen(this.isFromHome);
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  UserRef currentUser = home.user;
  File file;
  final ImagePicker picker = ImagePicker();
  bool isUploaded = false;
  String url;
  FirebaseStorage _storage = FirebaseStorage.instance;
  bool uploading = false;
  bool isImageCropped = false;
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  Future getImage(bool IsImageFromGallery) async {
    PickedFile pickedFile = await picker.getImage(
      source: IsImageFromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        cropImage();
      } else {
        print('No image selected.');
        isUploaded = false;
      }
    });
  }

  Future<void> cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: file.path,
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It');

    setState(() {
      file = cropped ?? file;
      isUploaded = true;
    });
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    setState(() {
      locationController.text = formattedAddress;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  _showMaterialDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Upload"),
        content: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                getImage(true);
              },
              child: Text(
                "Image from Gallery",
                style: GoogleFonts.aBeeZee(fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                getImage(false);
              },
              child: Text(
                "Image from Camera",
                style: GoogleFonts.aBeeZee(fontSize: 20.0),
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Map<String, String> userDataMap;
  Future PostMessage() async {
    if (formKey.currentState.validate()) {
      setState(() {
        uploading = true;
      });
      String fileName = path.basename("${file.path}${DateTime.now()}");
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(file);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      setState(() {
        url = imageUrl.toString();
        print(url);
      });

      Map<String, String> userDataMap = {
        "title": titleController.text,
        "description": descriptionController.text,
        "postedOn": DateTime.now().toString(),
        'location': locationController.text,
        'url': url.toString(),
        "type": "Image",
        "username": currentUser.userName,
        "profileImageUrl": currentUser.profileimage,
      };
      DatabaseMethods().addMessage(userDataMap);
      setState(() {
        url = null;
        file = null;
        isUploaded = false;
        uploading = false;
        titleController.clear();
        descriptionController.clear();
        uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isFromHome
          ? null
          : appBarMain("Instagram", true, true, 45.0, false, context),
      body: uploading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    isUploaded
                        ? Container(
                            child: Column(
                              children: [
                                Card(
                                  color: Colors.transparent,
                                  elevation: 0.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.file(
                                      File(file.path),
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                  ),
                                ),
                                RaisedButton(
                                    child: Text("Clear Image"),
                                    onPressed: () {
                                      setState(
                                        () {
                                          isUploaded = false;
                                        },
                                      );
                                    }),
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: CupertinoButton(
                              onPressed: () {
                                _showMaterialDialog();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xff007EF4),
                                        const Color(0xff2A75BC)
                                      ],
                                    )),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Add An Image",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextFormField(
                              controller: titleController,
                              validator: (val) {
                                return val.isEmpty
                                    ? "Title cannot be empty"
                                    : null;
                              },
                              decoration: new InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.title_outlined,
                                    color: Colors.black,
                                  ),
                                  hintText: "Title of the post",
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0),
                                  ),
                                  border: InputBorder.none,
                                  suffixStyle:
                                      const TextStyle(color: Colors.black54)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextFormField(
                              controller: locationController,
                              validator: (val) {
                                return val.isEmpty
                                    ? "Location cannot be empty"
                                    : null;
                              },
                              decoration: new InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.location_pin,
                                    color: Colors.black,
                                  ),
                                  suffix: GestureDetector(
                                    child: Text("GetCurrentLocation"),
                                    onTap: () {
                                      getUserLocation();
                                    },
                                  ),
                                  hintText: "Location",
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0),
                                  ),
                                  border: InputBorder.none,
                                  suffixStyle:
                                      const TextStyle(color: Colors.black54)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextFormField(
                              controller: descriptionController,
                              validator: (val) {
                                return val.isEmpty
                                    ? "Description cannot be empty"
                                    : null;
                              },
                              maxLines: null,
                              minLines: 1,
                              textInputAction: TextInputAction.newline,
                              decoration: new InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.description,
                                    color: Colors.black,
                                  ),
                                  hintText: "Description of the post",
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0),
                                  ),
                                  border: InputBorder.none,
                                  suffixStyle:
                                      const TextStyle(color: Colors.black54)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isUploaded
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 30),
                            child: CupertinoButton(
                              onPressed: () {
                                PostMessage();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[900],
                                      Colors.blue[800],
                                      Colors.blue[900],
                                    ],
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Post!",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            "You Should Upload An Image",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }
}
