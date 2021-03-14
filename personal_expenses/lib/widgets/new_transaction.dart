import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function submitHandler;

  NewTransaction(this.submitHandler);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void _submit() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.tryParse(amountController.text) ?? 0;

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.submitHandler(enteredTitle, enteredAmount);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              // onChanged: (val) {
              //   titleInput = val;
              // },
              controller: titleController,
              onSubmitted: (_) => _submit(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              // onChanged: (val) => amountInput = val,
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submit(),
            ),
            TextButton(
              child: Text('Add Transaction'),
              onPressed: _submit,
              style: TextButton.styleFrom(
                primary: Colors.purple,
              ),
            )
          ],
        ),
      ),
    );
  }
}
