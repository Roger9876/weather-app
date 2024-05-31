# Weather App

Welcome to the "WeatherWise" - a Weather App, a Flutter-based application providing real-time weather updates and forecasts.

## Getting Started

### Prerequisites

Ensure you have the following prerequisites installed on your machine:

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)
- An IDE with Flutter support (e.g., Android Studio, VS Code)
- An active internet connection

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Roger9876/weather-app.git
   cd weather-app
   ```

2. **Get the dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the app:**

   ```bash
   flutter run
   ```

## How to Use

The Weather App consists of three main screens:

### Main Screen (Search Screen)

- **Search for a City:** Enter the name of the city in the search bar to get current weather details.
- **Current Weather Display:** Shows the current temperature, weather condition, and other relevant information for the searched city.
![Main Screen](mainpage.png)

### Favourites Screen

- **View Favourites:** Displays a list of your favourite cities with their current weather details.
- **Remove from Favourites:** Option to remove cities from your favourites list.
![Favourites Screen](favouritespage.png)

### 5-Day Forecast Screen

- **Daily Forecasts:** Shows the weather forecast for the next five days for a selected city.
- **Detailed Information:** Each day's forecast includes temperature highs and lows, weather conditions, and other relevant data.
![fivedayforcastpage](fivedayforcastpage.png)

## Features

- **Real-time Weather Updates:** Get up-to-date weather information for any city.
- **Favourite Cities:** Save and manage your favourite cities for easy access.
- **5-Day Forecast:** View weather predictions for the next five days.
- **Intuitive UI:** User-friendly interface for seamless navigation and usage.

## Implementation Requirements

- **API Integration:** Utilizes a weather API (e.g., OpenWeatherMap) to fetch real-time weather data. You need to obtain an API key and add it to the project.
- **State Management:** Implemented using Flutter's state management solutions like Provider or Riverpod.
- **Responsive Design:** Ensures compatibility across various device sizes and orientations.

## Widget and Integration Testing

### Widget Testing

Widget tests are implemented to ensure the UI components work as expected.

1. **Run Widget Tests:**

   ```bash
   flutter test test/widget_test.dart
   ```

### Integration Testing

Integration tests are implemented for end-to-end testing of the app's functionality.

1. **Run Integration Tests:**

   ```bash
      flutter drive --target=integration_test/weather_app_test.dart
   ```

## Contact

For any queries, issues, or suggestions, please contact:

- Name: Raviraj Khopade
- Email: <rmkhopade21@gmail.com>

Thank you for using the WeatherWise!
