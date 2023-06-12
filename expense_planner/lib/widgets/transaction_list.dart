import 'package:intl/intl.dart';

import '../model/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            shadowColor: Colors.grey[200],
            elevation: 7,
            child: Padding(
              padding: EdgeInsets.all(7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('₱  ${transactions[index].amount}'),
                  SizedBox(width: 35),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        transactions[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      Text(
                        DateFormat('MM-dd-yyyy')
                            .format(transactions[index].date),
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        itemCount: transactions.length,
      ),
    );
  }
}

//in here Ill name this TransactionList using pascal case naming
//convetion of having upperscase on first character of the each word but having only one word(meaning without space in between words)
//
//in here i need to import material.Dart from the flutter package
//because we are using stateful widget which is expose that
//also Sttae, Buldcontexty and widgets are coming from material.dart package.
//
//and with all of that we have base widgets setup
