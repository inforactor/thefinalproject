import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thefinalproject/homepage/login_window.dart';
import 'login_window.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<UserData> userData = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8091/admin_dashboard.php'));
    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> data = json.decode(response.body);
        userData = data.map((item) => UserData.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _logout() {
    // Handle logout logic here
    Future.delayed(Duration.zero, () {
      Navigator.of(context, rootNavigator: true).pop(); // Example: navigate back to login screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2,
            ),
            itemCount: userData.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${userData[index].firstname} ${userData[index].lastname}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('Phone: ${userData[index].phonenumber}'),
                      Text('UID: ${userData[index].uid}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class UserData {
  final String firstname;
  final String lastname;
  final String phonenumber;
  final String uid;
  final int rechargeAmount;

  UserData({
    required this.firstname,
    required this.lastname,
    required this.phonenumber,
    required this.uid,
    required this.rechargeAmount,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      firstname: json['firstname'],
      lastname: json['lastname'],
      phonenumber: json['phonenumber'],
      uid: json['uid'],
      rechargeAmount: json.containsKey('total_recharge') ? json['total_recharge'] : 0,
    );
  }
}
