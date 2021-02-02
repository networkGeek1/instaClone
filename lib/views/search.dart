import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaClone/services/database.dart';
import 'package:instaClone/widgets/appBar.dart';

class Search extends StatefulWidget {
  bool isFromHome;
  Search(this.isFromHome);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  QuerySnapshot searchResultSnapshot;

  DatabaseMethods database = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await database
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                searchResultSnapshot.docs[index].data()['profileimage'],
                searchResultSnapshot.docs[index].data()['userName'],
                searchResultSnapshot.docs[index].data()['userEmail'],
              );
            })
        : Container();
  }

  Widget userTile(String userProfilePic, String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: userProfilePic,
            height: 50,
          ),
          SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              // sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "View Profile",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isFromHome
          ? null
          : appBarMain("Search", true, true, 40.0, false, context),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          children: [
            TextField(
              onChanged: (String str) {
                initiateSearch();
              },
              controller: searchEditingController,
              decoration: new InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintText: "Type to search...(It iS CAsE SeNsiTIve)",
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0),
                  ),
                  border: InputBorder.none,
                  suffixStyle: const TextStyle(color: Colors.black54)),
            ),
            userList()
          ],
        ),
      ),
    );
  }
}
