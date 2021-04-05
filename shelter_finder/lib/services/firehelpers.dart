import 'package:capstone_project/models/nearbyShelter.dart';

class FireHelper {
  //in here: it will provide list of shelter at is available
  static List<NearbyShelter> nearbyShelterList = [];

//in here: it will remove all inactive shelter from list
  static void removeFromList(String key) {
    int index = nearbyShelterList.indexWhere((element) => element.key == key);

    nearbyShelterList.removeAt(index);
  }

//this will update the location of user everytime it move
  static void updateNearbyLocation(NearbyShelter shelter) {
    int index =
        nearbyShelterList.indexWhere((element) => element.key == shelter.key);
    nearbyShelterList[index].longitude = shelter.longitude;
    nearbyShelterList[index].latitude = shelter.latitude;
  }
}
