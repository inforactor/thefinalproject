import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.white,
          title: Center(
            child: Container(
              child: const Text(
                'Bill Spark Helpline',
                style: TextStyle(
                  color: Color(0xFF25CC40),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF25CC40),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Helpline',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF25CC40),
                ),
              ),
              const SizedBox(height: 16.0),
              const Card(
                color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill Spark',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.black),
                          SizedBox(width: 8.0),
                          Text(
                            '+919706673946',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.email, color: Colors.black),
                          SizedBox(width: 8.0),
                          Text(
                            'spandan@yahoo.com',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Visit us: billspark.org',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22CE3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    //backgroundColor: const Color(0xFF00FF00),
                  ),
                  child:  const Text('Chat with us'),
                ),
              ),
              const SizedBox(height: 28.0),
              Container(
                height: 500.0,
                color: const Color(0xFF00FF00),
              ),
            ],
          ),
        ),
      ),
    );
  }
}