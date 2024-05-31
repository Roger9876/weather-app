import 'package:flutter/material.dart';
import 'package:mp5/model/weather_model.dart';
import 'package:mp5/utils/api_service.dart';
import 'package:mp5/utils/sessionmanager.dart';
import 'package:mp5/views/favourites_page.dart';
import 'package:mp5/widget/weather_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  WeatherModel? _currentWeather;
  List<String> favCities = [];

  @override
  void initState() {
    super.initState();
    if (SessionManager.isFirstTime() == true) {
      SessionManager.setSessionDetails(favCities);
    } else {
      SessionManager.getSessionDetails().then((value) {
        if (value != null) {
          setState(() {
            favCities = [...value];
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherWise 🌦️',
            style: TextStyle(
                color: Colors.black, fontFamily: 'cursive', fontSize: 30.0)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade300,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.star, color: Colors.yellow),
            onPressed: () async {
              List<String> result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavouritesPage(),
                ),
              );
              setState(() {
                favCities = result;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10.0),
            _searchBar(),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_currentWeather != null)
                      _loadWeatherCard()
                    else
                      const Text(
                          'Search for a city to get the weather details!!!'),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search bar widget
  Widget _searchBar() {
    return SearchBar(
      leading: const Icon(Icons.search),
      constraints: const BoxConstraints(minHeight: 40.0),
      hintText: 'Search for a city',
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
      overlayColor: MaterialStateColor.resolveWith(
          (states) => Colors.blue.withOpacity(0.1)),
      textStyle: const MaterialStatePropertyAll(
          TextStyle(color: Colors.black54, fontSize: 18.0)),
      onSubmitted: (value) => _fetchCurrentWeather(value),
    );
  }

  // Fetch current weather data from OpenWeatherMap API
  Future<void> _fetchCurrentWeather(String cityName) async {
    final weatherData = await ApiService().getWeatherData(cityName);
    if (weatherData.isNotEmpty) {
      setState(() {
        _currentWeather = WeatherModel.fromJson(weatherData);
      });
    } else {
      _showErrorSnackBar('Failed to load weather data. Please try again.');
    }
  }

  // Show error message in a snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Load weather card widget
  Widget _loadWeatherCard() {
    return WeatherCard(
        weather: _currentWeather!,
        favCities: favCities,
        routingFromFavPage: false);
  }
}
