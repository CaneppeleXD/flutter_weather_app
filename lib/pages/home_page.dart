import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/auth/auth_service.dart';

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

enum TemperatureScale { celsius, fahrenheit }

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  double? latitude;
  double? longitude;
  Weather? weather;
  TemperatureScale scale = TemperatureScale.celsius;

  @override
  void initState() {
    super.initState();
    initLocationAndTemperature();
  }

  void initLocationAndTemperature() async {
    await _getCurrentLocation();
    if (latitude != null && longitude != null) {
      _fetchTemperature(latitude as double, longitude as double);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = weather;
    final scaleSymbol = scale == TemperatureScale.celsius ? 'C°' : 'F°';
    final altSymbol = scale == TemperatureScale.celsius
        ? 'F°'
        : 'C°'; // Create a class to abstract this exuastive comparisons
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            SizedBox(
              width: 250, // TO DO make it bigger
              height: 120,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: w == null
                      ? const _WeatherSkeleton()
                      : Row(
                          children: [
                            Image.network(
                              // TO DO make skeleton show when the image is loading
                              w.icon,
                              width: 64,
                              height: 64,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${(scale == TemperatureScale.celsius ? _kelvinToCelsius(w.temperature) : _kelvinToFahrenheit(w.temperature)).round()} $scaleSymbol',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              scale = scale ==
                                                      TemperatureScale.celsius
                                                  ? TemperatureScale.fahrenheit
                                                  : TemperatureScale.celsius;
                                            });
                                          },
                                          child: Text(
                                            altSymbol,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  w.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => AuthService().signOut(),
                child: Text('Logout')),
          ],
        ),
      )),
    );
  }

  double _kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  double _kelvinToFahrenheit(double kelvin) {
    return (kelvin - 273.15) * 9 / 5 + 32;
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
          'https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&exclude=minutely,hourly,daily,alerts&appid=${dotenv.env['OPEN_WEATHER_APP_ID']!}',
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
                  "https://openweathermap.org/img/wn/${decodedData["weather"][0]["icon"]}.png");
        });
      } else {
        debugPrint('Failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}

// TO DO refactor code into different components
class _WeatherSkeleton extends StatefulWidget {
  // TO DO take a look at the docs if this follows correct standard name
  const _WeatherSkeleton();

  @override
  State<_WeatherSkeleton> createState() => _WeatherSkeletonState();
}

class _WeatherSkeletonState extends State<_WeatherSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _colorAnim = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnim,
      builder: (context, _) {
        return Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _colorAnim.value,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _colorAnim.value,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _colorAnim.value,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
