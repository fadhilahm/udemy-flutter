import 'package:flutter/material.dart';

// import './oldButtons.dart';
import './newButtons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('New Buttons'),
        ),
        body: NewButtons(),
      ),
    );
  }
}
