import 'package:cloud_firestore/cloud_firestore.dart';

class UserRef {
  final String lastLogin;
  final String profileimage;
  final String userEmail;
  final String userName;

  UserRef({
    this.lastLogin,
    this.profileimage,
    this.userEmail,
    this.userName,
  });

  factory UserRef.fromDocument(DocumentSnapshot doc) {
    return UserRef(
      lastLogin: doc['lastLogin'],
      profileimage: doc['profileimage'],
      userEmail: doc['userEmail'],
      userName: doc['userName'],
    );
  }
}
