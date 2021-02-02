import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaClone/models/user.dart';
import 'package:instaClone/services/auth.dart';
import 'package:instaClone/services/database.dart';
import 'package:instaClone/views/postScreen.dart';
import 'package:instaClone/views/profile.dart';
import 'package:instaClone/views/search.dart';
import 'package:instaClone/widgets/BottomNavBar.dart';
import 'package:instaClone/widgets/BottomNavBarItems.dart';
import 'package:instaClone/widgets/appBar.dart';
import 'package:instaClone/widgets/logout.dart';
import 'package:instaClone/widgets/post.dart';

UserRef user;
final usersRef = Firestore.instance.collection('users');

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  bool isPosting = false;
  getProfile() async {
    User usercreds = FirebaseAuth.instance.currentUser;
    DocumentSnapshot doc = await usersRef.doc(usercreds.email).get();

    user = UserRef.fromDocument(doc);
    print(user);
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  List<Widget> pages = [
    Container(
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              PostTile(
                title: "Hello World",
                username: "Varun Potti",
                url:
                    "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/macbook-pro-13-og-202011?wid=600&hei=315&fmt=jpeg&qlt=95&op_usm=0.5,0.5&.v=1604347427000",
                profileImageUrl: "https://picsum.photos/250?image=9",
                description: "Nothing",
              ),
              PostTile(
                title: "Hello World",
                username: "VarunPotti",
                url:
                    "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/macbook-pro-13-og-202011?wid=600&hei=315&fmt=jpeg&qlt=95&op_usm=0.5,0.5&.v=1604347427000",
                profileImageUrl: "https://picsum.photos/250?image=9",
                description: "Nothing",
              ),
              PostTile(
                title: "Hello World",
                username: "Varun Potti",
                url:
                    "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/macbook-pro-13-og-202011?wid=600&hei=315&fmt=jpeg&qlt=95&op_usm=0.5,0.5&.v=1604347427000",
                profileImageUrl: "https://picsum.photos/250?image=9",
                description: "Nothing",
              ),
            ],
          ),
        ),
      ),
    ),
    Container(
      color: Colors.black,
      child: Search(true),
    ),
    Container(
      color: Colors.green,
      child: PostScreen(true),
    ),
    Container(
      color: Colors.teal,
    ),
    Container(
      child: Profile(),
    ),
  ];

  changeTab(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(
          "Instagram", true, true, 45.0, isPosting ? false : true, context),
      extendBody: true,
      body: Container(
        child: Center(child: pages[currentPageIndex]),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavBar(
          selectedBackgroundColor: Colors.transparent,
          unselectedItemColor: Colors.black,
          borderRadius: 30.0,
          iconSize: 30.0,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          backgroundColor: Colors.grey.withAlpha(99),
          onTap: (int val) {
            setState(() => currentPageIndex = val);
            if (val == 2) {
              setState(() {
                isPosting = true;
              });
            } else {
              setState(() {
                isPosting = false;
              });
            }
          },
          currentIndex: currentPageIndex,
          items: [
            FloatingNavbarItem(icon: Icons.home_outlined, title: 'Home'),
            FloatingNavbarItem(icon: CupertinoIcons.search, title: 'Search'),
            FloatingNavbarItem(icon: CupertinoIcons.add_circled, title: 'Post'),
            FloatingNavbarItem(
                icon: CupertinoIcons.chat_bubble_2, title: 'Chats'),
            FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
          ],
        ),
      ),
    );
  }
}
