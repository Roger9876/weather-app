import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/views/favourites_page.dart';
import 'package:mp5/views/forcast_page.dart';
import 'package:mp5/views/search_page.dart';

Widget createSearchPage() => (const MaterialApp(
      home: SearchPage(),
    ));

Widget createFavouritesPage() => (const MaterialApp(
      home: FavouritesPage(),
    ));

Widget createForcastPage() => (const MaterialApp(
      home: ForcastPage(cityName: 'Chicago'),
    ));

Widget createMainApp() => (const MaterialApp(
      title: 'Weather App',
      home: SearchPage(),
      debugShowCheckedModeBanner: false,
    ));

void main() {
  testWidgets('Main app has a SearchPage', (WidgetTester tester) async {
    await tester.pumpWidget(createSearchPage());
    expect(find.byType(SearchPage), findsOneWidget);
  });

  testWidgets('SearchPage has a title and a star icon', (tester) async {
    await tester.pumpWidget(createSearchPage());
    expect(find.text('WeatherWise 🌦️'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('SearchPage has a search bar', (widgetTester) async {
    await widgetTester.pumpWidget(createSearchPage());
    expect(find.byType(SearchBar), findsOneWidget);
  });

  testWidgets('FavouritesPage has a title and a back icon', (tester) async {
    await tester.pumpWidget(createFavouritesPage());
    expect(find.text('Favourites'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('FavouritesPage has a list of cities', (widgetTester) async {
    await widgetTester.pumpWidget(createFavouritesPage());
    expect(find.byType(ListView), findsOneWidget);
  });
}
