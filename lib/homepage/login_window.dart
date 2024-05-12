import 'package:flutter/material.dart';
import 'registration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homepge.dart';
import 'StoreUid.dart';

class Login extends StatefulWidget {
  final String uid;

  const Login({Key? key, required this.uid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginScreen(uid);
}

class LoginScreen extends State<Login> {
  final String uid;
  final _valid1key = GlobalKey<FormState>();
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen(this.uid);

  Future _login() async {
    if (_valid1key.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8091/passvalid.php'),
          body: {
            'uid': _uidController.text,
            'password': _passwordController.text,
          },
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['success']) {
            StoreUid.uid = _uidController.text; // Set UID globally
            print('UID set: ${StoreUid.uid}'); // Add this line to verify the U

            // Navigate to homepage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            print('Login successful');
          } else {
            // Display error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
            );
          }
        } else {
          // Handle server error
          print('Server error: ${response.statusCode}');
        }
      } catch (e) {
        // Handle network error
        print('Network error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
        child: Form(
          key: _valid1key,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (state) {
                    if(state!.length < 3) {
                      return "State should be at least three characters";
                    }
                    return null;
                  },
                  controller: _uidController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Phone UID",
                      hintText: "Enter your UID",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      )
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      )
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: 100,
                    color: Colors.white,
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green,
                            padding: const EdgeInsets.all(20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            _login();
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    )
                ),
              ),

              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'Do not have an account?',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                  )
              ),

              Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Registration()),
                      );
                    },
                    child: const Text(
                        'Register Now',
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        )
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
