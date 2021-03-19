import 'package:capstone_project/widgets/brandcolor.dart';
import 'package:capstone_project/widgets/wildoutlinebutton.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:flutter/material.dart';

class ConfirmSheets extends StatelessWidget {
  //< start : Here we pass value to are button widget >
  final String title;
  final String subtitle;
  final Function onPress;
  ConfirmSheets({this.title, this.subtitle, this.onPress});
  // <end>

  static const id = 'ConfirmSheets';

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                spreadRadius: 0.8,
                offset: Offset(0.7, 0.7))
          ],
        ),
        height: 240,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(children: <Widget>[
            SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Brand-Bold',
                    color: BrandColors.colorText)),
            SizedBox(height: 20),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: BrandColors.colorTextLight),
            ),
            SizedBox(height: 25),
            Row(children: <Widget>[
              Expanded(
                child: Container(
                  child: WildOutlineButton(
                    title: 'CANCEL',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: BrandColors.colorTextLight,
                    style: TextStyle(
                      color: BrandColors.colorTextLight,
                      fontFamily: 'Brand-Bold',
                      fontSize: 17,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Container(
                  child: WildRaisedButton(
                    title: 'CONFIRM',
                    onPressed: onPress,
                    color: (title == 'GO ONLINE')
                        ? BrandColors.colorAccent
                        : Colors.red,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Brand-Bold',
                      fontSize: 17,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ])
          ]),
        ));
  }
}
