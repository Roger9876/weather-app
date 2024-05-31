import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mp5/model/weather_model.dart';
import 'package:mp5/utils/sessionmanager.dart';
import 'package:mp5/views/forcast_page.dart';

class WeatherCard extends StatefulWidget {
  final WeatherModel weather;
  final List<String> favCities;
  final bool routingFromFavPage;

  const WeatherCard(
      {super.key,
      required this.weather,
      required this.favCities,
      required this.routingFromFavPage});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  List<String> favCities = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _locationHeader(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            _dateTimeInfo(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            _weatherIcon(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            _currentTemp(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            size.width > 600 ? _extraInfo() : _extraInfoSqueezed(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.01,
            ),
            _forecastLink(),
          ],
        ),
      ),
    );
  }

  Widget _locationHeader() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${widget.weather.cityName}, ${widget.weather.country}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: widget.favCities.contains(widget.weather.cityName)
              ? const Icon(Icons.star, color: Colors.yellow, size: 20)
              : const Icon(Icons.star_border_outlined, size: 20),
          onPressed: () {
            if (widget.favCities.contains(widget.weather.cityName)) {
              widget.favCities.remove(widget.weather.cityName);
              setState(() {
                favCities = widget.favCities;
              });
              _showErrorSnackBar('Removed from favorites!');
            } else {
              widget.favCities.add(widget.weather.cityName);
              setState(() {
                favCities = widget.favCities;
              });
              _showErrorSnackBar('Added to favorites!');
            }
            SessionManager.setSessionDetails(widget.favCities);
          },
          alignment: Alignment.centerRight,
        ),
      ],
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = widget.weather.date;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "  ${DateFormat("d.MM.y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${widget.weather.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          widget.weather.weatherDescription,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${tempInCelsius(widget.weather.temperature)}° C",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 75,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Extra info(temperature, wind, humidity, etc.) widget
  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${tempInCelsius(widget.weather.tempMax)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                "Min: ${tempInCelsius(widget.weather.tempMin)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${widget.weather.windSpeed.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                "Humidity: ${widget.weather.humidity.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // Extra info(temperature, wind, humidity, etc.) widget
  Widget _extraInfoSqueezed() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.25,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${tempInCelsius(widget.weather.tempMax)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Min: ${tempInCelsius(widget.weather.tempMin)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${widget.weather.windSpeed.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Humidity: ${widget.weather.humidity.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // Five day forecast widget
  Widget _forecastLink() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForcastPage(
              cityName: widget.weather.cityName,
            ),
          ),
        );
      },
      child: const Text(
        '5 Day Forecast -→',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // Convert temperature from Kelvin to Celsius
  String tempInCelsius(double temp) {
    return (temp - 273.15).toStringAsFixed(0);
  }

  // Show message in a snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }
}
