import 'package:firebase_database/firebase_database.dart';

class MeUser {
  String id;
  String fullName;
  String firstName;
  String lastName;
  String middleName;
  String phone;
  String email;
  String birthday;
  String houseAddrs;
  String city;
  String zipcode;
  String address;
  String gender;
  String occupation;
  String emergencyName;
  String emergencyPhone;
  String idType;
  String adNumber;
  String status;

  MeUser({
    this.email, //
    this.fullName, //
    this.phone, //
    this.id, //
    this.firstName, //
    this.lastName, //
    this.middleName, //
    this.birthday, //
    this.houseAddrs,
    this.city,
    this.zipcode,
    this.address, //
    this.gender, //
    this.occupation, //
    this.emergencyName, //
    this.emergencyPhone, //
    this.idType, //
    this.adNumber, //
    this.status, //
  });

  String get fname => fullName;
  String get statuses => status;

  MeUser.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    status = snapshot.value['status'];
    fullName = snapshot.value['username'];
    firstName = snapshot.value['firstName'];
    lastName = snapshot.value['lastName'];
    middleName = snapshot.value['midName'];
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    birthday = snapshot.value['birthday'];
    address = snapshot.value['address'];
    gender = snapshot.value['gender'];
    occupation = snapshot.value['occupation'];
    idType = snapshot.value['idType'];
    adNumber = snapshot.value['idNumber'];
    emergencyName = snapshot.value['emergencyName'];
    emergencyPhone = snapshot.value['emergencyPhone'];
  }
}
