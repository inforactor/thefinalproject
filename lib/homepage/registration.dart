import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'uid.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Validation function for phone number
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length != 10) {
      return 'Phone number should be 10 digits';
    }
    return null;
  }

  // Validation function for password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Regex pattern for password validation
    final RegExp passwordRegex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    );
    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain at least 8 characters, including uppercase, lowercase, numbers, and special characters';
    }
    return null;
  }

  // Function to handle registration
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Registration logic
      var url = Uri.parse("http://10.0.2.2:8090/register.php");
      var response = await http.post(
        url,
        body: {
          "firstname": _fnameController.text,
          "lastname": _lnameController.text,
          "phonenumber": _phoneController.text,
          "password": _passController.text,
        },
      );
      var data = json.decode(response.body);
      print(data);//debug line
      if (data['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UidScreen(data['uid'])),
        );
      } else {
        // Handle error
        Fluttertoast.showToast(
          msg: "Registration Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BillSpark'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // First Name Field
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _fnameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    hintText: "Enter your first name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),

              // Last Name Field
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _lnameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    hintText: "Enter your last name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
              ),

              // Phone Number Field
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter your phone number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: _validatePhoneNumber,
                ),
              ),

              // Password Field
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: _validatePassword,
                ),
              ),

              // Register Button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  color: Colors.white,
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Call the _registerUser() method to initiate registration
                          _registerUser();
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),

              // Do not have an account?
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      'Do not have an account?',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

