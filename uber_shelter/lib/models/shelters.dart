import 'package:firebase_database/firebase_database.dart';

class Shelters {
  String fullname;
  String phone;
  String email;
  String id;
  String addrs;
  String cityaddrs;
  String zipcpde;

  Shelters(
      {this.fullname,
      this.phone,
      this.email,
      this.id,
      this.addrs,
      this.cityaddrs,
      this.zipcpde});

  Shelters.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    fullname = snapshot.value['username'];
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    addrs = snapshot.value['shelter_details']['addrs_1'];
    cityaddrs = snapshot.value['shelter_details']['addres_3'];
    zipcpde = snapshot.value['shelter_details']['addrs_2'];
  }
}
