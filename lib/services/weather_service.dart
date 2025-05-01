import 'dart:convert';
import 'package:flutter_bloc_learning/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = 'd8b363a3c8b557b728afc83ec7c3955a';

  Future<Weather> getWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);
    print("Response");
    print(response.statusCode);
    print(response.toString());
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
