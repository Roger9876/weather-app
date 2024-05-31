import 'package:flutter/material.dart';
import 'package:mp5/model/weather_model.dart';
import 'package:mp5/utils/api_service.dart';
import 'package:mp5/utils/sessionmanager.dart';
import 'package:mp5/views/weather_page.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<String> favCities = [];
  List<WeatherModel> cityListWithDetails = [];

  @override
  void initState() {
    super.initState();
    SessionManager.getSessionDetails().then((value) {
      if (value != null) {
        setState(() {
          favCities = [...value];
        });
        for (var city in favCities) {
          _fetchCurrentWeather(city);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> favCityWidgetList = [];

    if (cityListWithDetails.isNotEmpty) {
      for (var city in cityListWithDetails) {
        favCityWidgetList.add(favouriteCityRow(city));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade300,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, favCities);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10.0),
            Expanded(
              child: SingleChildScrollView(
                child: ListView(
                  shrinkWrap: true,
                  children: favCityWidgetList,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fetch current weather data from OpenWeatherMap API
  Future<void> _fetchCurrentWeather(String cityName) async {
    final weatherData = await ApiService().getWeatherData(cityName);
    if (weatherData.isNotEmpty) {
      setState(() {
        cityListWithDetails.add(WeatherModel.fromJson(weatherData));
      });
    } else {
      _showErrorSnackBar('Failed to load favourites.');
    }
  }

  Widget favouriteCityRow(WeatherModel details) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WeatherPage(
              weather: details,
            ),
          ),
        );
      },
      child: Container(
        height: 75,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _locationWidget(details.cityName, details.country),
            _temparateWidget(details.temperature),
            _weatherWidget(details.weatherMain, details.weatherDescription),
            _weatherIconWidget(details.weatherIcon),
            _deleteIconWidget(details.cityName),
          ],
        ),
      ),
    );
  }

  Widget _locationWidget(String cityName, String country) {
    return SizedBox(
      height: 40,
      child: Center(child: Text('$cityName, $country')),
    );
  }

  Widget _temparateWidget(double temperature) {
    return SizedBox(
      height: 40,
      child: Center(child: Text("${tempInCelsius(temperature)}° C")),
    );
  }

  Widget _weatherWidget(String main, String description) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: [
            Text(main),
            Text(description),
          ],
        ),
      ),
    );
  }

  Widget _weatherIconWidget(String icon) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Image.network('http://openweathermap.org/img/wn/$icon.png'),
      ),
    );
  }

  Widget _deleteIconWidget(String cityName) {
    return SizedBox(
      height: 40,
      child: Center(
        child: IconButton(
          icon: Icon(Icons.delete, color: Colors.red.shade500),
          onPressed: () {
            removeCity(cityName);
          },
        ),
      ),
    );
  }

  // Remove city from favourites
  void removeCity(String cityName) {
    favCities.removeWhere((city) => city == cityName);
    SessionManager.setSessionDetails(favCities);
    setState(() {
      cityListWithDetails.removeWhere((city) => city.cityName == cityName);
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
