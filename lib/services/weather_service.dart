import 'dart:convert';
import 'package:flutter_bloc_learning/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  String get _apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  Future<Weather> getWeather(String city) async {
    if (_apiKey.isEmpty) {
      throw Exception('API key not found in environment variables');
    }

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
