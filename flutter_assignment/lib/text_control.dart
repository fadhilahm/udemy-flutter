import 'package:flutter/material.dart';

import 'text_output.dart' as t;

class TextControl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TextControlState();
}

class _TextControlState extends State<TextControl> {
  var _content = 'This is the initial text';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          t.TextOutput(_content),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _content = 'このテクストは今日本語で書いてあります。';
                });
              },
              child: t.TextOutput('Click this!'))
        ],
      ),
    );
  }
}
