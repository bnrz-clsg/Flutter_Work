import 'package:capstone_project/dataprovider/appdata.dart';
import 'package:capstone_project/models/address.dart';
import 'package:capstone_project/models/predictions.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/requesthelper.dart';
import 'package:capstone_project/widgets/preogressDialog.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

class PredictionTile extends StatelessWidget {
  final Prediction prediction;

  PredictionTile({this.prediction});

  void getPlaceDetails(String placeID, context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'please wait.',
            ));

    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    Navigator.pop(context);

    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeId = placeID;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.longitude = response['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false)
          .updateDestinationAddress(thisPlace);
      print(thisPlace.placeName);

      Navigator.pop(context, 'getDirection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceDetails(prediction.placeID, context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Icon(
                  OMIcons.locationOn,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        prediction.mainText,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        prediction.secondaryText,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
