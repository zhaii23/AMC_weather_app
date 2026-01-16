import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';
import 'package:flutter/foundation.dart';

class WeatherService {
  static const String apiKey = '';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Weather> getWeather(String cityName) async {
    String url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';

    try {
      // FIXED: Added missing parenthesis and fixed proxy URL string
      if (kIsWeb) {
        url = 'https://corsproxy.io/?' + Uri.encodeComponent(url);
      }

      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City Not Found');
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}
