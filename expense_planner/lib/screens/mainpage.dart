import 'package:expense_planner/model/transaction.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Transaction> transaction = [
    Transaction(
        id: 't1', title: 'grocery', amount: 69.99, date: DateTime.now()),
    Transaction(id: 't2', title: 'bill', amount: 500.00, date: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 15,
                      spreadRadius: 0.8,
                      offset: Offset(0.7, 0.7)),
                ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
            Card() 
          ],)
        ],
      ),
    );
  }
}
