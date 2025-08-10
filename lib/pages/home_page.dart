import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Weather {
  String name;
  double temperature;
  String icon;

  Weather({required this.name, required this.temperature, required this.icon});
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  double? latitude;
  double? longitude;
  Weather? weather;

  @override
  void initState() {
    super.initState();
    initLocationAndTemperature();
  }

  void initLocationAndTemperature() async {
    await _getCurrentLocation();
    if (latitude != null && longitude != null) {
      this._fetchTemperature(latitude as double, longitude as double);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
                child: Row(
              children: [
                Text(weather == null
                    ? 'Current location: $latitude $longitude'
                    : 'Current Weather: ${weather?.temperature}K ${weather?.name}'),
                if (weather != null) Image.network((weather as Weather).icon),
              ],
            ))
          ],
        ),
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    // TO DO put this on a service
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location services are disabled")));
      return;
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Location permissions are denied")));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Location permissions are permanently denied")));
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  void _fetchTemperature(double latitude, double longitude) async {
    // TO DO put this on a service
    try {
      // TO DO use env variable for api key
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&exclude=minutely,hourly,daily,alerts&appid=efc2b0a8976da178769b903ce4fe7b81',
        ),
      );

      String data = "";
      if (response.statusCode == 200) {
        data = response.body;
        var decodedData = json.decode(data);
        setState(() {
          weather = Weather(
              name: decodedData['weather'][0]['main'],
              temperature: decodedData['main']
                  ['temp'], // TO DO convert temperature to celsius
              icon:
                  "http://openweathermap.org/img/w/${decodedData["weather"][0]["icon"]}.png");
        });
      } else {
        debugPrint('Failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
