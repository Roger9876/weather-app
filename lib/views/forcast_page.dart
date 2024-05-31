import 'package:flutter/material.dart';
import 'package:mp5/model/weather_model.dart';
import 'package:mp5/utils/api_service.dart';
import 'package:intl/intl.dart';

class ForcastPage extends StatefulWidget {
  final String cityName;

  const ForcastPage({super.key, required this.cityName});

  @override
  State<ForcastPage> createState() => _ForcastPageState();
}

class _ForcastPageState extends State<ForcastPage> {
  List<WeatherModel>? _fiveDayForecast = [];

  @override
  void initState() {
    super.initState();
    if (widget.cityName.isNotEmpty) _fetchFiveDayForecast(widget.cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('5 Day Forecast for ${widget.cityName}'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade300,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_fiveDayForecast != null) _loadForecastList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Load forecast list
  Widget _loadForecastList() {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _fiveDayForecast![index].isExpanded = isExpanded;
        });
      },
      children:
          _fiveDayForecast!.map<ExpansionPanel>((WeatherModel weatherOfTheDay) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title:
                  Text(DateFormat('dd MMM.').format(weatherOfTheDay.date).toString()),
              subtitle: Text(
                '${weatherOfTheDay.weatherMain}, ${weatherOfTheDay.weatherDescription}',
              ),
            );
          },
          body: ListTile(
            title: Text('Temperature: ${tempInCelsius(weatherOfTheDay.temperature)}°C'),
            subtitle: Text(
           """Min: ${tempInCelsius(weatherOfTheDay.tempMin)}°C
Max: ${tempInCelsius(weatherOfTheDay.tempMax)}°C
Feels Like: ${tempInCelsius(weatherOfTheDay.tempFeelsLike)}°C
Humidity: ${weatherOfTheDay.humidity}%
Wind Speed: ${weatherOfTheDay.windSpeed} m/s"""),
            trailing: Image.network(
              'https://openweathermap.org/img/w/${weatherOfTheDay.weatherIcon}.png',
              scale: 0.5,
            ),
          ),
          isExpanded: weatherOfTheDay.isExpanded,
        );
      }).toList(),
    );
  }

  // Fetch 5 day weather forecast data from OpenWeatherMap API
  Future<void> _fetchFiveDayForecast(String cityName) async {
    var forecast = [];
    var selectedForecasts = [];
    int day = DateTime.now().day;
    await ApiService().getWeatherForecastData(cityName).then((data) => {
      Future.delayed(const Duration(seconds: 2)),
      if (data.isNotEmpty) {
        forecast = (data['list'] as List)
          .map((json) => WeatherModel.fromJson(json))
          .toList(),
        selectedForecasts = forecast.where((element) {
          if (element.date.day != day) {
            day = element.date.day;
            return true;
          } else {
            return false;
          }
        }).toList(),
        setState(() {
          _fiveDayForecast = selectedForecasts as List<WeatherModel>;
        }),
      } else {
        _showErrorSnackBar('Failed to load weather forecast data.')
      }
    });
  }

  // Convert temperature from Kelvin to Celsius
  String tempInCelsius(double temp) {
    return (temp - 273.15).toStringAsFixed(0);
  }

  // Show error message in a snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
