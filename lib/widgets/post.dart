import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// "title": titleController.text,
// "description": descriptionController.text,
// "postedOn": DateTime.now().toString(),
// 'location': locationController.text,
// 'url': url.toString(),
// "type": "Image",

class PostTile extends StatefulWidget {
  final String title;
  final String url;
  final String username;
  final String profileImageUrl;
  final String description;
  final String location;
  final String type;
  PostTile(
      {this.title,
      this.url,
      this.username,
      this.profileImageUrl,
      this.type,
      this.description,
      this.location});
  factory PostTile.fromDocument(DocumentSnapshot doc) {
    return PostTile(
      title: doc['title'],
      url: doc['url'],
      type: doc['type'],
      // profileImageUrl: doc['profileImageUrl'],
      description: doc['description'],
      location: doc['location'],
      profileImageUrl: doc['profileImageUrl'],
      username: doc['username'],
    );
  }
// description
//location
//postedOn
//title.
// type.
//url.
  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Card(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        '${widget.profileImageUrl}',
                        height: 40.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.username}',
                          style: GoogleFonts.abel(
                              fontWeight: FontWeight.bold, fontSize: 20.0)),
                      Text(
                        "${widget.location}",
                        style: GoogleFonts.abel(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                color: Colors.transparent,
                elevation: 10.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    '${widget.url}',
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      print("Tapped");
                    },
                    child: Icon(CupertinoIcons.heart),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    onTap: () {
                      print("Tapped 1");
                    },
                    child: Icon(CupertinoIcons.chat_bubble),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      print("Tapped 2");
                    },
                    child: Icon(CupertinoIcons.paperplane),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.title}",
                    style: GoogleFonts.acme(fontSize: 17.0),
                  ),
                  Text(
                    "${widget.description}",
                    style: GoogleFonts.acme(fontSize: 15.0),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
