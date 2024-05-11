import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'StoreUid.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  bool _isMaxConnectionsReached = false;

  Future<void> _applyConnection() async {
    if (_isMaxConnectionsReached) return;

    final Uri url = Uri.parse("http://10.0.2.2:8090/newapply.php?uid=${StoreUid.uid}");
    final http.Response response = await http.post(url, body: {
      "state": _stateController.text,
      "district": _districtController.text,
      "city": _cityController.text,
      "pin": _pinController.text,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        if (data["message"] == "You have reached the maximum connection limit") {
          _isMaxConnectionsReached = true;
        } else {
          // Show success message if CID is generated successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data["message"]),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    } else {
      print("Failed to connect to the server.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: _districtController,
              decoration: InputDecoration(labelText: 'District'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _pinController,
              decoration: InputDecoration(labelText: 'PIN'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _applyConnection,
              child: Text('Apply Connection'),
              // Disable button if maximum connections reached
              // Show message if maximum connections reached
              style: ButtonStyle(
                backgroundColor: _isMaxConnectionsReached
                    ? MaterialStateProperty.all(Colors.grey)
                    : MaterialStateProperty.all(Colors.blue),
              ),
            ),
            if (_isMaxConnectionsReached)
              Text(
                'You have reached the maximum connection limit',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ConnectionScreen(),
  ));
}
