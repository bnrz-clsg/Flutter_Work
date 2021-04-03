import 'package:expense_planner/widgets/text_field_callback.dart';
import 'package:flutter/material.dart';

class NewTransactions extends StatelessWidget {
  final Function addTx;
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  NewTransactions(this.addTx);
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextFieldCallBack(
                hint: 'Title',
                label: 'Title',
                textCap: TextCapitalization.words,
                controller: titleController,
              ),
              TextFieldCallBack(
                hint: 'Amount',
                label: 'Amount',
                textCap: TextCapitalization.words,
                textInputType: TextInputType.number,
                controller: amountController,
              ),
              FlatButton(
                  onPressed: () {
                    addTx(titleController.text,
                        double.parse(amountController.text));
                  },
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ),
        ));
  }
}
