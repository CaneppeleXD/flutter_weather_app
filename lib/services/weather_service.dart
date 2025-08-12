import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Weather {
  String name;
  double temperature;
  String icon;
  String cityName;

  Weather(
      {required this.name,
      required this.temperature,
      required this.icon,
      required this.cityName});
}

abstract class AbstractTemperatureScale {
  abstract String unit;

  double kelvinToScale(kelvinTemperature);
}

class CelsiusScale extends AbstractTemperatureScale {
  @override
  String unit = "C°";

  @override
  double kelvinToScale(kelvinTemperature) {
    return WeatherService().kelvinToCelsius(kelvinTemperature);
  }
}

class FahrenheitScale extends AbstractTemperatureScale {
  @override
  String unit = "F°";

  @override
  double kelvinToScale(kelvinTemperature) {
    return WeatherService().kelvinToFahrenheit(kelvinTemperature);
  }
}

enum TemperatureScaleTypes { celsius, fahrenheit }

class WeatherService {
  Future<Weather> fetchTemperature(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&exclude=minutely,hourly,daily,alerts&appid=${dotenv.env['OPEN_WEATHER_APP_ID']!}',
        ),
      );

      String data = "";
      if (response.statusCode == 200) {
        data = response.body;
        var decodedData = json.decode(data);
        debugPrint(data);
        return Weather(
            name: decodedData['weather'][0]['main'],
            temperature: decodedData['main']['temp'],
            icon:
                "https://openweathermap.org/img/wn/${decodedData["weather"][0]["icon"]}.png",
            cityName: decodedData['name']);
      } else {
        throw ErrorDescription('Temperature API returned code other than 200');
      }
    } catch (e) {
      rethrow;
    }
  }

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  double kelvinToFahrenheit(double kelvin) {
    return (kelvin - 273.15) * 9 / 5 + 32;
  }
}
