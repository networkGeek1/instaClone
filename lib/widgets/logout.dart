import 'package:flutter/material.dart';
import 'package:instaClone/helpers/authenticate.dart';
import 'package:instaClone/services/auth.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        AuthService().signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Authenticate()));
      },
      child: Text("Logout"),
    );
  }
}
