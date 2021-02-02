import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaClone/views/postScreen.dart';
import 'package:instaClone/views/search.dart';

AppBar appBarMain(String title, bool centerTitle, bool useFont, double fontSize,
    bool isSearchAppBar, BuildContext context) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: isSearchAppBar ? false : true,
    title: Text(
      "$title",
      style: TextStyle(
        fontFamily: useFont ? 'Billabong' : null,
        fontSize: fontSize,
      ),
    ),
    centerTitle: centerTitle,
    actions: isSearchAppBar
        ? [
            ClipOval(
              child: Material(
                color: Colors.white,
                child: InkWell(
                  splashColor: Colors.grey,
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      CupertinoIcons.paperplane,
                      size: 30.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostScreen(false)),
                    );
                  },
                ),
              ),
            )
          ]
        : null,
  );
}
