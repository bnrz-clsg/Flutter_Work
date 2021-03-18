import 'package:flutter/material.dart';
import 'package:login_registration_page/widgets/text_field_callback.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          TextFieldCallBack(
            obscure: false,
            hint: 'email address',
            label: 'Email Address',
            textInputType: TextInputType.emailAddress,
          ),
          if (!_isLogin)
            TextFieldCallBack(
              textCap: TextCapitalization.words,
              obscure: false,
              hint: 'Full Name',
              label: 'Username',
            ),
          if (!_isLogin)
            TextFieldCallBack(
              obscure: false,
              hint: '# 0999 000 00 00',
              label: 'Phone Number',
              textInputType: TextInputType.phone,
            ),
          TextFieldCallBack(
            obscure: true,
            hint: 'password',
            label: 'Password',
            textInputType: TextInputType.visiblePassword,
          ),
          SizedBox(height: 12.0),
          RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5)),
            color: Colors.blue,
            textColor: Colors.white,
            child: Center(
                child: Text(
              _isLogin ? 'LOGIN' : 'SIGNUP',
              style: TextStyle(letterSpacing: 2, fontFamily: 'Brand-Bold'),
            )),
            onPressed: () {},
          ),
          FlatButton(
            child: Text(
              _isLogin
                  ? 'Don\'t have an account? Sign up here!'
                  : 'Already have account? Login here!',
              style: TextStyle(fontSize: 12.0, letterSpacing: 1),
            ),
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
          ),
        ],
      ),
    );
  }
}
