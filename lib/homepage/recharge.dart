import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'StoreUid.dart';
import 'card.dart';

class RechargeScreen extends StatefulWidget {
  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _rechargeController = TextEditingController();

  Future<void> _checkAndRecharge() async {
    // Check if the user has saved payment details
    final Uri checkPaymentUrl = Uri.parse("http://10.0.2.2:8091/check_payment.php?uid=${StoreUid.uid}");
    final http.Response checkPaymentResponse = await http.get(checkPaymentUrl);

    if (checkPaymentResponse.statusCode == 200) {
      final Map<String, dynamic> checkPaymentData = json.decode(checkPaymentResponse.body);
      if (checkPaymentData["status"] == "success" && checkPaymentData["hasPaymentDetails"] == true) {
        // Proceed with recharge
        _newRecharge();
      } else {
        // Show error message and redirect to card details screen
        _showErrorMessage("No saved payment details found. Please enter your card details.");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CardScreen()),
        );
      }
    } else {
      _showErrorMessage("Failed to check payment details. Please try again.");
    }
  }

  Future<void> _newRecharge() async {
    if (_rechargeController.text.isEmpty) {
      _showErrorMessage("Recharge amount is required");
      return;
    }

    final Uri url = Uri.parse("http://10.0.2.2:8091/recharge.php?uid=${StoreUid.uid}");
    final http.Response response = await http.post(url, body: {
      "Recharge": _rechargeController.text,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["status"] == "success") {
        _showSuccessMessage(data["rechargeAmount"]);
      } else {
        _showErrorMessage("Failed to recharge. Please try again.");
      }
    } else {
      _showErrorMessage("Failed to recharge. Please try again.");
    }
  }

  void _showSuccessMessage(String rechargeAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Recharge successful for amount: $rechargeAmount"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recharge"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _rechargeController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Recharge amount is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkAndRecharge,
                child: Text("Submit Recharge"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardScreen()),
                  );
                },
                child: Text("Add Card Details"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
