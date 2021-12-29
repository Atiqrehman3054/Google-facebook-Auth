import 'package:flutter/material.dart';


// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  Map _userObj = {};
  bool _isLoggedIn = false;
  GoogleSignInAccount _userObjj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facebook/google_Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _isLoading
              ? Column(
                  children: [
                    Image.network(_userObj["picture"]["data"]["url"]),
                    Text(_userObj["name"]),
                    Text(_userObj["email"]),
                    TextButton(
                        onPressed: () async {
                          FacebookAuth.instance.logOut().then((value) {
                            setState(() {
                              _isLoading = false;
                              _userObj = {};
                            });
                          });
                        },
                        child: Text("LogOut"))
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          FacebookAuth.instance.login(permissions: [
                            "public_profile",
                            "email"
                          ]).then((value) {
                            FacebookAuth.instance
                                .getUserData()
                                .then((userData) {
                              setState(() {
                                _isLoading = true;
                                _userObj = userData;
                              });
                            });
                          });
                        },
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              // SvgPicture.asset("assets/image/vector.svg"),
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                'CONTINUE WITH FACEBOOK',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.blueAccent),
                          height: 63,
                          width: 373,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),
                ),
          Container(
            height: 200,
            child: _isLoggedIn
                ? Column(
                    children: [
                      Image.network(_userObjj.photoUrl),
                      Text(_userObjj.displayName),
                      Text(_userObjj.email),
                      TextButton(
                          onPressed: () {
                            _googleSignIn.signOut().then((value) {
                              setState(() {
                                _isLoggedIn = false;
                              });
                            }).catchError((e) {});
                          },
                          child: Text("Logout"))
                    ],
                  )
                : Center(
                    child: ElevatedButton(

                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text("Login with Google"),
                      ),
                      onPressed: () {
                        _googleSignIn.signIn().then((userData) {
                          setState(() {
                            _isLoggedIn = true;
                            _userObjj = userData;
                          });
                        }).catchError((e) {
                          print(e);
                        });
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
