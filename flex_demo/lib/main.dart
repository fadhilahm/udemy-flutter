import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flex Demo App'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Text('Item 1'),
              color: Colors.red,
              height: 100,
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Text('Item 2'),
                color: Colors.blue,
                height: 100,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Container(
                child: Text('Item 3'),
                color: Colors.orange,
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
