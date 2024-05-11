import 'package:flutter/material.dart';

class UidScreen extends StatelessWidget {
  final String uid;

  UidScreen(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UID'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your UID:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              uid,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
