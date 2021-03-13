import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function clickHandler;
  final String text;

  Answer(this.clickHandler, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue,
        child: Text(text),
        onPressed: clickHandler,
      ),
    );
  }
}
