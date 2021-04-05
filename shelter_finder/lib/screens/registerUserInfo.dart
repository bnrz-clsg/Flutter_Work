import 'package:capstone_project/models/user.dart';
import 'package:capstone_project/screens/homescreen.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fa_stepper/fa_stepper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth.dart';

class RegisterUserInfo extends StatefulWidget {
  @override
  RegisterUserInfoState createState() => new RegisterUserInfoState();
}

class RegisterUserInfoState extends State<RegisterUserInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  void showSnackBar(String title) {
    final snackBar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15, wordSpacing: 2),
    ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  static MeUser data = new MeUser();
  DateTime selectedDate = DateTime.now();
  var items = ['Male', 'Female', 'Prefer not to say'];
  var idtype = ['Student ID', 'Private ID', 'Government ID'];
  String title = 'Registration';
  int _current;
  List<FAStepstate> _listState;
  FAStepperType _stepperType = FAStepperType.vertical;

  @override
  void initState() {
    _current = 0;
    _listState = [
      FAStepstate.disabled,
      FAStepstate.editing,
      FAStepstate.complete,
    ];
    super.initState();
  }

  List<FAStep> _createSteps(BuildContext context) {
    List<FAStep> _steps = <FAStep>[
      // name
      FAStep(
        title: new Text('Name'),
        isActive: true,
        state: _current == 0
            ? _listState[1]
            : _current > 0
                ? _listState[2]
                : _listState[0],
        content: Column(
          children: [
            TextFormField(
                onSaved: (String value) {
                  data.firstName = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 7) {
                    return 'Please provide valid name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'First name',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 10),
            TextFormField(
              onSaved: (String value) {
                data.lastName = value;
              },
              validator: (value) {
                if (value.isEmpty || value.length < 1) {
                  return 'Please provide valid Last name';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Last name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
                onSaved: (String value) {
                  data.middleName = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Please provide valid Middle name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Middle name',
                  border: OutlineInputBorder(),
                )),
          ],
        ),
      ),
      // status
      FAStep(
        title: new Text('Status'),
        isActive: true,
        state: _current == 1
            ? _listState[1]
            : _current > 1
                ? _listState[2]
                : _listState[0],
        content: Column(children: <Widget>[
          TextFormField(
            onTap: () => _selectDate(context),
            readOnly: true,
            onSaved: (String value) {
              data.birthday = value;
            },
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return 'invalid input';
            //   }
            //   return null;
            // },
            decoration: InputDecoration(
                hintText:
                    "Birthday:  " + "${selectedDate.toLocal()}".split(' ')[0],
                // labelText: 'Date of birth',
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 10),
          TextFormField(
              onSaved: (String value) {
                data.gender = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Select Gender';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blue,
                      ),
                      onSelected: (String value) {
                        data.gender = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return items.map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
                        }).toList();
                      }))),
          SizedBox(height: 10),
          TextFormField(
              // controller: tecFirstName,
              onSaved: (String value) {
                data.occupation = value;
              },
              validator: (value) {
                if (value.isEmpty || value.length < 4) {
                  return 'Please provide valid occupation';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Occupation /  Profession',
                border: OutlineInputBorder(),
              )),
        ]),
      ),
      //  Contact
      FAStep(
        state: _current == 2
            ? _listState[1]
            : _current > 2
                ? _listState[2]
                : _listState[0],
        title: new Text('Contact info'),
        content: Column(
          children: <Widget>[
            TextFormField(
              onSaved: (String value) {
                data.phone = value;
              },
              validator: (value) {
                if (value.isEmpty || value.length < 11) {
                  return 'Please provide valid phone no.';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Phone number (0900 000 0000)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.phone_android,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    labelText: email,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.blue,
                    ))),
            SizedBox(height: 10),
            TextFormField(
              onSaved: (String value) {
                data.houseAddrs = value;
              },
              validator: (value) {
                if (value.isEmpty || value.length < 11) {
                  return 'Please provide valid House address.';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'House no.#, Street, & Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              onSaved: (String value) {
                data.city = value;
              },
              validator: (value) {
                if (value.isEmpty || value.length < 4) {
                  return 'Please provide valid City.';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'City Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              onSaved: (String value) {
                data.zipcode = value;
              },
              validator: (value) {
                if (value.isEmpty || value.length < 4) {
                  return 'Please provide valid zip.';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Area code / zip code',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        isActive: true,
      ),
      //identification information
      FAStep(
        isActive: false,
        state: _current == 3
            ? _listState[1]
            : _current > 3
                ? _listState[2]
                : _listState[0],
        title: new Text('Validation'),
        content: Column(
          children: <Widget>[
            TextFormField(
                onSaved: (String value) {
                  data.idType = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please select to options';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    labelText: 'ID Type (private, government)',
                    border: OutlineInputBorder(),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blue,
                      ),
                      onSelected: (String value) {
                        data.idType = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return idtype
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
                        }).toList();
                      },
                    ))),
            SizedBox(height: 10),
            TextFormField(
              onSaved: (String value) {
                data.adNumber = value;
              },
              validator: (value) {
                if (value.isEmpty || value.length < 4) {
                  return 'Please provide valid ID number.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'ID  Number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      // incase of emergency
      FAStep(
        isActive: true,
        state: _current == 4
            ? _listState[1]
            : _current > 4
                ? _listState[2]
                : _listState[0],
        title: new Text('In case of emergency'),
        content: Column(
          children: <Widget>[
            TextFormField(
                onSaved: (String value) {
                  data.emergencyName = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Please provide guardian name.';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Complete name of mergency contact person',
                )),
            SizedBox(height: 10),
            TextFormField(
                onSaved: (String value) {
                  data.emergencyPhone = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Please provide phone number.';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Contact no.',
                ))
          ],
        ),
      ),
      FAStep(
        isActive: false,
        state: _current == 5
            ? _listState[2]
            : _current > 5
                ? _listState[2]
                : _listState[0],
        title: new Text('Final Step'),
        content: Column(
          children: [
            new Text(
              '"Select SUBMIT"',
              style: TextStyle(fontSize: 20, wordSpacing: 2),
            ),
            Text(
              'to save the filled-out details',
            ),
            SizedBox(height: 400)
          ],
        ),
      ),
    ];
    return _steps;
  }

  @override
  Widget build(BuildContext context) {
    List<FAStep> _stepList = _createSteps(context);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: new Container(
        // width: double.infinity,
        // height: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: ExactAssetImage('assets/images/loginBG.jpg'),
        //     fit: BoxFit.fill,
        //     alignment: Alignment.topCenter,
        //   ),
        // ),
        padding: new EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: new Column(
            children: <Widget>[
              Expanded(
                child: FAStepper(
                  stepNumberColor: Colors.grey,
                  physics: ClampingScrollPhysics(),
                  type: _stepperType,
                  steps: _stepList,
                  currentStep: _current,
                  onStepContinue: () {
                    setState(() {
                      if (_current < _stepList.length - 1) {
                        _current++;
                      } else {
                        _current = _stepList.length - 1;
                      }
                      //_setStep(context);
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (_current > 0) {
                        _current--;
                      } else {
                        _current = 0;
                      }
                      //_setStep(context);
                    });
                  },
                  onStepTapped: (int i) {
                    setState(() {
                      _current = i;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 50),
          WildRaisedButton(
            title: "SUBMIT",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            color: Colors.blue,
            onPressed: () {
              _saveInfo(context);
            },
          ),
          FloatingActionButton(
            onPressed: _switchStepType,
            backgroundColor: Color(0xFFC41A3B),
            child: Icon(Icons.swap_horizontal_circle),
          ),
        ],
      ),
    );
  }

  void _saveInfo(context) {
    final FormState isValid = _formKey.currentState;
    if (!isValid.validate()) {
      showSnackBar('Kindly fill-out required and valid inputs');
    } else {
      isValid.save();
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Check Details"),
            //content: new Text("Hello World"),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(
                    "Name:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new Text(data.firstName +
                      ", " +
                      data.middleName +
                      ", " +
                      data.lastName),
                  SizedBox(height: 5),
                  Row(children: [
                    new Text("Birthday:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    new Text(data.birthday),
                  ]),
                  Row(
                    children: [
                      new Text("Gender: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data.gender)
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      new Text("Occupation : ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data.occupation),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      new Text("Phone: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data.phone)
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      new Text("Email: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(email),
                    ],
                  ),
                  Divider(),
                  new Text("Address:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  new Text(
                      data.houseAddrs + ", " + data.city + ", " + data.zipcode),
                  Divider(),
                  new Text("Identification:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  new Text(data.adNumber + " (" + data.idType + ")"),
                  Divider(),
                  new Text("Incase of Emegercy:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  new Text("Name : " + data.emergencyName),
                  new Text("Contact : " + data.emergencyPhone),
                  SizedBox(height: 35),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5)),
                        color: Colors.blue,
                        onPressed: () {
                          registerUsersInfo(context);
                        },
                        child: Text('Register',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      SizedBox(width: 30),
                      new FlatButton(
                        child: new Text('cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    }
  }

  void registerUsersInfo(context) {
    String id = currentFirebaseUser.uid;

    // <Start Firebase RD>
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('users/$id');

    // <Start Firebastore>
    DocumentReference _userReg =
        FirebaseFirestore.instance.collection('users').doc('$id');
    Map<String, dynamic> map = {
      'status': 'false',
      'created_at': DateTime.now().toString(),
      'email': email,
      'username': data.firstName + " " + data.middleName + ", " + data.lastName,
      'firstName': data.firstName.trim(),
      'lastName': data.lastName.trim(),
      'midName': data.middleName.trim(),
      'birthday': data.birthday.trim(),
      'gender': data.gender.trim(),
      'occupation': data.occupation.trim(),
      'address': data.houseAddrs.trim() +
          " " +
          data.city.trim() +
          " " +
          data.zipcode.trim(),
      'phone': data.phone.trim(),
      'idType': data.idType.trim(),
      'idNumber': data.adNumber.trim(),
      'emergencyName': data.emergencyName.trim(),
      'emergencyPhone': data.emergencyPhone.trim(),
    };

    // Firebase map,
    // In here we push user details into Firebase realtime and firestore
    //<Map for firebase realtimeDatabase>
    userRef.set(map);
    //<Firestore map. Should be Dynamic>
    _userReg.set(map);
    // <Navigator push "If registration successful" back
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  _switchStepType() {
    setState(() => _stepperType == FAStepperType.vertical
        ? _stepperType = FAStepperType.horizontal
        : _stepperType = FAStepperType.vertical);
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2001), // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        data.birthday = DateFormat.yMd().format(selectedDate);
      });
  }
}
