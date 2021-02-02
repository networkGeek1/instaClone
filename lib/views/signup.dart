import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instaClone/helpers/data.dart';
import 'package:instaClone/helpers/helper.dart';
import 'package:instaClone/services/auth.dart';
import 'package:instaClone/services/database.dart';
import 'package:instaClone/views/home.dart';
import 'package:instaClone/helpers/data.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  AuthService authService = new AuthService();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;
  List<String> avatarUrls = new List();
  String selectedAvatarUrl;
  @override
  void initState() {
    super.initState();

    avatarUrls = getAvatarUrls();
    avatarUrls.shuffle();
    selectedAvatarUrl = avatarUrls[0].toString();
  }

  signUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signUpWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "userName": usernameEditingController.text,
            "userEmail": emailEditingController.text,
            "lastLogin": DateTime.now().toString(),
            "profileimage": selectedAvatarUrl,
          };
          databaseMethods.addUserInfo(userDataMap, emailEditingController.text);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    }
  }

  Widget avatarTile(String avatarUrl, _SignUpState context, int index) {
    return GestureDetector(
      onTap: () {
        selectedAvatarUrl = avatarUrl;
        setState(() {});
      },
      child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(
            right: 14,
            left: index == 0 ? 30 : 0,
          ),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              border: selectedAvatarUrl == avatarUrl
                  ? Border.all(color: Color(0xff007EF4), width: 4)
                  : Border.all(color: Colors.transparent, width: 10),
              color: Colors.white,
              borderRadius: BorderRadius.circular(120)),
          child: CachedNetworkImage(imageUrl: avatarUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.7,
                    ),
                    Center(
                      child: Text(
                        "Instagram",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.2,
                          fontFamily: "Billabong",
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: Text(
                              "Choose Your Avatar",
                              style: GoogleFonts.aclonica(),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 100,
                            margin: EdgeInsets.only(bottom: 40),
                            child: ListView.builder(
                                itemCount: avatarUrls.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return avatarTile(
                                      avatarUrls[index], this, index);
                                }),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Center(
                              child: TextFormField(
                                controller: usernameEditingController,
                                validator: (val) {
                                  return val.isEmpty || val.length < 3
                                      ? "Enter Username 3+ characters"
                                      : null;
                                },
                                decoration: new InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.person_outline_outlined,
                                      color: Colors.black54,
                                    ),
                                    hintText: "Username...",
                                    suffixStyle:
                                        const TextStyle(color: Colors.black54)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Center(
                              child: TextFormField(
                                controller: emailEditingController,
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : "Enter correct email";
                                },
                                decoration: new InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.mail_outlined,
                                      color: Colors.black54,
                                    ),
                                    hintText: 'Email...',
                                    suffixStyle:
                                        const TextStyle(color: Colors.black54)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Center(
                              child: TextFormField(
                                obscureText: true,
                                controller: passwordEditingController,
                                validator: (val) {
                                  return val.length < 6
                                      ? "Enter Password 6+ characters"
                                      : null;
                                },
                                decoration: new InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.lock_outlined,
                                      color: Colors.black54,
                                    ),
                                    hintText: 'Password...',
                                    suffixStyle:
                                        const TextStyle(color: Colors.black54)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: CupertinoButton(
                        onPressed: () {
                          signUp();
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
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                        ),
                        InkWell(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Text(
                            "SignIn now",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
