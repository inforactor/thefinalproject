import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'StoreUid.dart';
import 'package:intl/intl.dart';

class HistoryDashboard extends StatefulWidget {
  @override
  _HistoryDashboardState createState() => _HistoryDashboardState();
}

class _HistoryDashboardState extends State<HistoryDashboard> {
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8090/history.php?uid=${StoreUid.uid}'));

    if (response.statusCode == 200) {
      setState(() {
        Iterable data = json.decode(response.body);
        historyData = List<Map<String, dynamic>>.from(data.map((x) =>
        {
          'date_time': DateTime.parse(x['date_time']),
          'recharge_amount': double.parse(x['recharge_amount']),
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _calculateMaxY(),
            minY: 0, // Minimum value for y-axis
            groupsSpace: 20,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) =>
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                margin: 10,
                rotateAngle: 45, // Rotate labels by 45 degrees
                getTitles: (double value) {
                  // Custom function to format date labels
                  int index = value.toInt();
                  if (index >= 0 && index < historyData.length) {
                    return _getFormattedDateLabel(index);
                  }
                  return '';
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) =>
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                margin: 10,
                reservedSize: 40, // Space for labels
                getTitles: (double value) {
                  // Show labels for every 100th value
                  if (value % 100 == 0) {
                    return value.toStringAsFixed(0);
                  }
                  return '';
                },
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black, width: 1),
            ),
            barGroups: _buildBarGroups(),
          ),
        ),
      ),
    );
  }

  // Function to calculate the maximum y-value for setting the y-axis range
  double _calculateMaxY() {
    double maxY = 0;
    for (var entry in historyData) {
      if (entry['recharge_amount'] > maxY) {
        maxY = entry['recharge_amount'];
      }
    }
    return maxY;
  }

  // Function to build the bar groups for the bar chart
  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> barGroups = [];
    for (var i = 0; i < historyData.length; i++) {
      double x = i.toDouble(); // Convert to double
      double y = historyData[i]['recharge_amount'];
      barGroups.add(
        BarChartGroupData(
          x: x.toInt(), // No need to convert to int
          barRods: [BarChartRodData(y: y, colors: [Colors.blue])],
        ),
      );
    }
    return barGroups;
  }

  // Custom function to format date labels
  String _getFormattedDateLabel(int index) {
    DateTime date = historyData[index]['date_time'];
    return DateFormat('MMM d').format(date);
  }
}
