import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/widgets/auth_form.dart';
import 'package:capstone_project/widgets/auth_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  static const id = 'LoginPage';
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  void showSnackBar(String title) {
    final snackBar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String username,
    String password,
    String phone,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        currentFirebaseUser = userCredential as User;
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(userCredential.user.uid)
            .set({
          'username': username,
          'email': email,
          'phone': phone,
        });

        // await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(userCredential.user.uid)
        //     .set({
        //   'username': username,
        //   'email': email,
        //   'phone': phone,
        // });
      }
    } on PlatformException catch (err) {
      var message = 'Error occured, please check your credentials';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/loginBG.jpg'),
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 43.0,
                      backgroundColor: Color.fromRGBO(110, 110, 110, 10),
                      backgroundImage:
                          AssetImage("assets/images/logo_icon_final.png"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "BAYANIHAN",
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 25,
                        letterSpacing: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "evacuation system",
                      style: TextStyle(
                        fontFamily: 'Brand-Regular',
                        color: Colors.black,
                        fontSize: 18.0,
                        letterSpacing: 1.10,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 50),
                    //email login and regist registration
                    AuthForm(
                      _submitAuthForm,
                      _isLoading,
                    ),
                    Divider(),
                    Text('OR'),
                    SizedBox(height: 50),
                    //Google Signin
                    GoogleSignin(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
