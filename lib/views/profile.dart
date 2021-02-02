import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instaClone/helpers/authenticate.dart';
import 'package:instaClone/helpers/helper.dart';
import 'package:instaClone/models/user.dart';
import 'package:instaClone/services/auth.dart';
import 'package:instaClone/widgets/post.dart';
import 'package:instaClone/widgets/postonlyimage.dart';

import 'home.dart' as home;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  String orientation = "Grid";
  int postCount = 0;
  List<PostTile> posts = [];
  UserRef user = home.user;
  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc('${user.userEmail}')
        .collection("messages")
        .orderBy('postedOn', descending: true)
        .get();
    setState(() {
      isLoading = false;

      postCount = snapshot.docs.length;
      print(postCount);
      posts = snapshot.docs.map((doc) => PostTile.fromDocument(doc)).toList();
      print(posts);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePosts();
    print(user.profileimage);
  }

  changeOrientation(String orientationchanged) {
    setState(() {
      orientation = orientationchanged;
    });
  }

  buildProfilePosts() {
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (posts.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/nocontent.jpg', height: 260.0),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "No Posts",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (orientation == "Grid") {
      List<GridTile> gridTiles = [];
      posts.forEach((post) {
        gridTiles.add(GridTile(child: PostTileOnlyImage(post)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (orientation == "List") {
      return Column(
        children: posts,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: "${user.profileimage}",
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user.userName}",
                        style: GoogleFonts.abel(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${user.userEmail}",
                        style: GoogleFonts.abel(
                            fontSize: 10.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Spacer(),
                  RaisedButton(
                    onPressed: () {
                      AuthService().signOut();
                      HelperFunctions.saveUserLoggedInSharedPreference(false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Authenticate()));
                    },
                    child: Text("Logout"),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.grid_on),
                  onPressed: () {
                    changeOrientation("Grid");
                  },
                  color: orientation == 'Grid'
                      ? Colors.deepPurpleAccent
                      : Colors.grey,
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.list_dash),
                  onPressed: () {
                    changeOrientation("List");
                  },
                  color: orientation == 'List'
                      ? Colors.deepPurpleAccent
                      : Colors.grey,
                ),
              ],
            ),
            Divider(color: Colors.black),
            SizedBox(
              height: 20.0,
            ),
            buildProfilePosts(),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
// RaisedButton(onPressed: () {
//       AuthService().signOut();
//       HelperFunctions.saveUserLoggedInSharedPreference(false);
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => Authenticate()));
//     })
