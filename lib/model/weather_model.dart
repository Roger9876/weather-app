class WeatherModel {
  final String cityName;
  final String country;
  final DateTime date;
  final String weatherMain;
  final String weatherDescription;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final double tempFeelsLike;
  final double windSpeed;
  final int humidity;
  final String weatherIcon;
  bool isExpanded = false;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.date,
    required this.weatherMain,
    required this.weatherDescription,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.tempFeelsLike,
    required this.windSpeed,
    required this.humidity,
    required this.weatherIcon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      weatherMain: json['weather'][0]['main'] ?? '',
      weatherDescription: json['weather'][0]['description'] ?? '',
      tempMin: (json['main']['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (json['main']['temp_max'] as num?)?.toDouble() ?? 0.0,
      tempFeelsLike: (json['main']['feels_like'] as num?)?.toDouble() ?? 0.0,
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(json['dt']! * 1000),
      humidity: json['main']['humidity'] ?? 0,
      weatherIcon: json['weather'][0]['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'country': country,
      'date': date.toIso8601String(),
      'weatherMain': weatherMain,
      'weatherDescription': weatherDescription,
      'temperature': temperature,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'tempFeelsLike': tempFeelsLike,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'icon': weatherIcon,
    };
  }
}
