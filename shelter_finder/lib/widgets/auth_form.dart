import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;
  final void Function(
    String email,
    String username,
    String phone,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _password = '';
  var _phone = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _password.trim(),
        _phone.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        color: Color.fromRGBO(225, 225, 225, .8),
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //TEXT FORM EMAIL
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Pelase enter a valid email address!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    //TEXT FORM USERNAME
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please provide valid name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Fullname'),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  //TEXTFORM PHONE
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('phone'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 11) {
                          return 'Please provide valid phone';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Phone number (09XX XXX XXXX)'),
                      onSaved: (value) {
                        _phone = value;
                      },
                    ),
                  //TEXTFORM PASSWORD
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'password'),
                    obscureText: true,
                    onSaved: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(height: 12.0),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5)),
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Center(
                          child: Text(
                        _isLogin ? 'LOGIN' : 'SIGNUP',
                        style: TextStyle(
                            letterSpacing: 2, fontFamily: 'Brand-Bold'),
                      )),
                      onPressed: _trySubmit,
                    ),
                  FlatButton(
                    child: Text(
                      _isLogin
                          ? 'Don\'t have an account? Sign up here!'
                          : 'Already have BAYANIHAN   account? Login here!',
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
            ),
          ),
        ),
      ),
    );
  }
}
