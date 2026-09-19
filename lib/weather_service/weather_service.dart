import 'dart:convert';

import 'package:geocoding/geocoding.dart' ;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app2/weather_model/weather_model.dart';

import '../weather_model/forecast_model.dart';

class WeatherServices {
  static const url = 'https://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherServices({required String apikey}) : apikey = apikey.trim();

Future<Weather> getWeather(String cityName) async {
  final uri = Uri.parse(url).replace(queryParameters: {
    'q': cityName,
    'appid': apikey,
    'units': 'metric',
  });

  print('Request URL: $uri');

  final response = await http.get(uri);

  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    return Weather.fromjson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<List<ForecastItem>> getForecast(String cityName) async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apikey&units=metric'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> list = data['list'];
    return list.map((item) => ForecastItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load forecast data');
  }
}

  Future<String> getCurrentCity() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  Position position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );

  final geocoding = Geocoding(); // naya instance banao

  List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isEmpty) {
    throw Exception('Could not resolve city from coordinates');
  }

  String city = placemarks.first.locality ?? "";
  return city;
}
}