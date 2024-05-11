import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'connection.dart';
import 'recharge.dart';
import 'StoreUid.dart';
import 'dashboard.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("BillSpark"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _NumberDisplay(),

            const SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CustomButton(
                    text: "Apply New",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConnectionScreen()),
                      );
                    },
                  ),
                  _CustomButton(
                    text: "Recharge",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RechargeScreen()),
                      );
                    },
                  ),
                  _CustomButton(
                    text: "History",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryDashboard()),
                      );
                    },
                  ),
                  _CustomButton(
                    text: "Details",
                    onPressed: () {
                      print("Button 4 pressed");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberDisplay extends StatefulWidget {
  @override
  _NumberDisplayState createState() => _NumberDisplayState();
}

class _NumberDisplayState extends State<_NumberDisplay> {
  String number = '';

  @override
  void initState() {
    super.initState();
    // Call _refreshBalance once initially
    _refreshBalance();

    // Schedule _refreshBalance to be called every 10 seconds
    Timer.periodic(Duration(seconds: 10), (timer) {
      _refreshBalance();
    });
  }

  Future<void> _refreshBalance() async {
    final Uri url = Uri.parse("http://10.0.2.2:8090/homeenergy.php?uid=${StoreUid.uid}");
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["success"]) {
        setState(() {
          number = data["balance"].toString();
        });
      } else {
        // Handle error
      }
    } else {
      // Handle HTTP error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      number,
      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }
}


class _CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
