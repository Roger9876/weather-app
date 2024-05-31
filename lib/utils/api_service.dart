import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const apiKey = 'your_api_key_here';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Fetch weather data from OpenWeatherMap API
  Future<Map<String, dynamic>> getWeatherData(String cityName) async {
    final String url = '$_baseUrl/weather?q=$cityName&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to load weather data');
      }
    } catch (e) {
      print('Failed to load weather data: $e');
    }
    return {};
  }

  // Fetch weather forecast data from OpenWeatherMap API
  Future<Map<String, dynamic>> getWeatherForecastData(String cityName) async {
    final String url = '$_baseUrl/forecast?q=$cityName&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to load weather forecast data');
      }
    } catch (e) {
      print('Failed to load weather forecast data: $e');
    }
    return {};
  }
}
