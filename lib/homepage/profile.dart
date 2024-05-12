import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'StoreUid.dart';
import 'login_window.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse('http://10.0.2.2:8091/profile.php?uid=${StoreUid.uid}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _logout() {
    // Clear user session (if needed)
    StoreUid.uid = ""; // Clear UID globally

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login(uid: "")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: userData == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Display user information
          ListTile(
            title: Text(
              '${userData!['userInfo']['firstname']} ${userData!['userInfo']['lastname']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone: ${userData!['userInfo']['phonenumber']}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'UID: ${StoreUid.uid}',
                  style: TextStyle(fontSize: 16),
                ), // Add UID here
              ],
            ),
          ),
          // Add other list tile children here
          Divider(),
          ListTile(
            title: Text(
              'Addresses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (userData?['addresses'] != null &&
              (userData?['addresses'] as List).isNotEmpty)
          // To handle the potential null value of userData['addresses'], you can use the null-aware operator (?.) to access the field safely.
            SizedBox(
              height: 200, // Adjust height as needed
              child: PageView.builder(
                itemCount: userData!['addresses'].length,
                itemBuilder: (context, index) {
                  final address = userData!['addresses'][index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        'State: ${address['state']}\n'
                            'District: ${address['district']}\n'
                            'City: ${address['city']}\n'
                            'PIN: ${address['pin']}\n'
                            'CID: ${address['cid']}\n', // Include CID here
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Center(
              child: Text('No addresses found.'),
            ),

          Divider(),
          // Display payment information
          ListTile(
            title: Text(
              'Payment Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Card Number: ${userData!['paymentInfo']['card_number']}\n'
                  'Expiry Date: ${userData!['paymentInfo']['expiry_date']}\n'
                  'CVV: ${userData!['paymentInfo']['cvv']}\n'
                  'Card Holder Name: ${userData!['paymentInfo']['cardholder_name']}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Divider(),
          // Logout button
          ElevatedButton(
            onPressed: _logout,
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
