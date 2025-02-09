import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
    String city = "";
    int aqi = 0;
    double temp = 0.0;

    @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.waqi.info/feed/here/?token=2230700c69e4348c84741150c8a91db2bb9fe405'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        city = (data["data"]["city"]["name"]);
        aqi = (data["data"]["aqi"]);
        temp = (data["data"]["iaqi"]["t"]["v"]);
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String getAqiScale(int aqi) {
    if (aqi <= 50) return "Good";
    if (aqi <= 100) return "Moderate";
    if (aqi <= 150) return "Unhealthy for Sensitive Groups";
    if (aqi <= 200) return "Unhealthy";
    if (aqi <= 300) return "Very Unhealthy";
    return "Hazardous";
  }
  Color getColor(int aqi){
    if (aqi <= 50) return Colors.greenAccent;
    if (aqi <= 100) return const Color.fromARGB(255, 255, 233, 31);
    if (aqi <= 150) return const Color.fromARGB(255, 255, 129, 10);
    if (aqi <= 200) return const Color.fromARGB(255, 255, 0, 0);
    return Colors.white ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Air Quality Index (AQI)'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$city',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: getColor(aqi),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$aqi',
                style: TextStyle(
                    fontSize: 50,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Text(
              getAqiScale(aqi),
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: getColor(aqi)),
            ),
            SizedBox(height: 10),
            Text(
              'temperature: $temp °C', 
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchData();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Refresh', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
