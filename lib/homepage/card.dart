import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'StoreUid.dart';
import 'recharge.dart';

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardholderNameController = TextEditingController();

  bool _hasCardDetails = false;

  @override
  void initState() {
    super.initState();
    _fetchCardDetails();
  }

  Future<void> _fetchCardDetails() async {
    final Uri url = Uri.parse("http://10.0.2.2:8091/card.php?uid=${StoreUid.uid}");
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data["status"] == "success" && data["cardDetails"] != null) {
        setState(() {
          _cardNumberController.text = data["cardDetails"]["card_number"];
          _expiryDateController.text = data["cardDetails"]["expiry_date"];
          _cvvController.text = data["cardDetails"]["cvv"];
          _cardholderNameController.text = data["cardDetails"]["cardholder_name"];
          _hasCardDetails = true;
        });
      }
    } else {
      _showErrorMessage("Failed to fetch card details. Please try again.");
    }
  }

  Future<void> _submitCardDetails() async {
    final Uri url = Uri.parse("http://10.0.2.2:8091/card.php?uid=${StoreUid.uid}");
    final http.Response response = await http.post(url, body: {
      "CardNumber": _cardNumberController.text,
      "ExpiryDate": _expiryDateController.text,
      "CVV": _cvvController.text,
      "CardholderName": _cardholderNameController.text,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data["status"] == "success") {
        _showSuccessMessage();
      } else {
        _showErrorMessage("Failed to save card details. Please try again.");
      }
    } else {
      _showErrorMessage("Failed to save card details. Please try again.");
    }
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Card details saved successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RechargeScreen()));
              },
              child: Text("Go to Recharge"),
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
        title: Text("Card Details"),
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
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(labelText: "Expiry Date"),
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(labelText: "CVV"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _cardholderNameController,
                decoration: InputDecoration(labelText: "Cardholder Name"),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCardDetails,
                child: Text("Submit"),
              ),
              if (_hasCardDetails)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RechargeScreen()));
                  },
                  child: Text("Go to Recharge"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
