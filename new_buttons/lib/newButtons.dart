import 'package:flutter/material.dart';

class NewButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            // style: ButtonStyle(
            //   backgroundColor: MaterialStateProperty.all(Colors.orange),
            //   foregroundColor: MaterialStateProperty.all(Colors.white),
            // ),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
            child: Text('A Raised Button'),
            onPressed: () {
              print('Pressed raised button');
            },
          ),
          TextButton(
            child: Text('A Flat Button'),
            onPressed: () {
              print('Pressed flat button');
            },
            // textColor: Colors.blue,
            // style: ButtonStyle(
            //   foregroundColor: MaterialStateProperty.all(Colors.orange),
            // ),
            style: TextButton.styleFrom(
              primary: Colors.orange,
            ),
          ),
          OutlinedButton(
              child: Text('An Outline Button'),
              onPressed: () {
                print('Pressed outline button');
              },
              // textColor: Colors.blue,
              // borderSide: BorderSide(color: Colors.blue),
              // style: OutlinedButton.styleFrom(
              //   primary: Colors.orange,
              //   side: BorderSide(color: Colors.orange),
              // ),
              style: ButtonStyle(
                side:
                    MaterialStateProperty.all(BorderSide(color: Colors.orange)),
                foregroundColor: MaterialStateProperty.all(Colors.orange),
              )),
        ],
      ),
    );
  }
}
