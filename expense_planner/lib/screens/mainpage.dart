import 'package:expense_planner/model/transaction.dart';
import 'package:expense_planner/widgets/new_transactions.dart';
import '../widgets/transaction_list.dart';

import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1', title: 'grocery', amount: 69.99, date: DateTime.now()),
    Transaction(id: 't2', title: 'bill', amount: 500.00, date: DateTime.now()),
  ];
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransactions(_addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3,
                            spreadRadius: 0.8,
                            offset: Offset(0.7, 0.7)),
                      ]),
                  child: Text('hello world')),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TransactionList(_userTransactions),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
    );
  }
}
