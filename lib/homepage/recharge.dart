import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'StoreUid.dart';
import 'package:flutter/services.dart';

class RechargeScreen extends StatefulWidget {
  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _rechargeController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardholderNameController = TextEditingController();

  Future<void> _newRecharge() async {
    // Validate input fields
    if (_rechargeController.text.isEmpty ||
        _cardNumberController.text.isEmpty ||
        _expiryDateController.text.isEmpty ||
        _cvvController.text.isEmpty ||
        _cardholderNameController.text.isEmpty) {
      _showErrorMessage("All fields are required");
      return;
    }

    // Send payment details along with recharge amount to backend
    final Uri cidUrl = Uri.parse("http://10.0.2.2:8090/ciduid.php?uid=${StoreUid.uid}");
    final http.Response cidResponse = await http.get(cidUrl);
    final cidData = json.decode(cidResponse.body);
    final cid = cidData['cid'];

    if (cid != null) {
      final Uri url = Uri.parse("http://10.0.2.2:8090/recharge.php?uid=${StoreUid.uid}");
      final http.Response response = await http.post(url, body: {
        "Recharge": _rechargeController.text,
        "CardNumber": _cardNumberController.text,
        "ExpiryDate": _expiryDateController.text,
        "CVV": _cvvController.text,
        "CardholderName": _cardholderNameController.text,
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
    } else {
      _showErrorMessage("Please apply for a connection first.");
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
        title: Text("Payment"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(labelText: "Card Number"),
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(16)],
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Card number is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(labelText: "Expiry Date"),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Expiry date is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(labelText: "CVV"),
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(3)],
                validator: (value) {
                  if (value!.isEmpty) {
                    return "CVV is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cardholderNameController,
                decoration: InputDecoration(labelText: "Cardholder Name"),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Cardholder name is required";
                  }
                  return null;
                },
              ),
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
                onPressed: _newRecharge,
                child: Text("Submit Payment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
