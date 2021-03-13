import 'package:flutter/material.dart';

class OldButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('A Raised Button'),
            onPressed: () {
              print('Pressed raised button');
            },
          ),
          FlatButton(
            child: Text('A Flat Button'),
            onPressed: () {
              print('Pressed flat button');
            },
            textColor: Colors.blue,
          ),
          OutlineButton(
            child: Text('An Outline Button'),
            onPressed: () {
              print('Pressed outline button');
            },
            textColor: Colors.blue,
            borderSide: BorderSide(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
