import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mp5/views/search_page.dart';
import 'package:mp5/widget/weather_card.dart';
import 'package:mp5/views/favourites_page.dart';
import 'package:mp5/views/forcast_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Testing weather app', () {
    testWidgets('Find weather of a city by searching its name', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SearchPage()));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SearchBar));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(find.byType(TextField), 'London');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(WeatherCard), findsOneWidget);
      expect(find.text('London, GB'), findsOneWidget);
    });

    testWidgets('Click favourite icon to add city in favourite list and delete it from list', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SearchPage()));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SearchBar));
      await tester.enterText(find.byType(TextField), 'Chicago');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(WeatherCard), findsOneWidget);
      expect(find.byIcon(Icons.star_border_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.star_border_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byIcon(Icons.star).at(1));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(FavouritesPage), findsOneWidget);
      expect(find.text('Chicago, US'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Chicago, US'), findsNothing);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(WeatherCard), findsOneWidget);
      expect(find.byIcon(Icons.star_border_outlined), findsOneWidget);
    });

    testWidgets('Test 5 day Forcast screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SearchPage()));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SearchBar));
      await tester.enterText(find.byType(TextField), 'Chicago');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(WeatherCard), findsOneWidget);
      expect(find.text('5 Day Forecast -→'), findsOneWidget);

      await tester.fling(find.byType(WeatherCard), const Offset(0, -300), 3000);
      await tester.tap(find.text('5 Day Forecast -→'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(ForcastPage), findsOneWidget);
      expect(find.text('5 Day Forecast for Chicago'), findsOneWidget);
      expect(find.byType(ExpansionPanelList), findsOneWidget);
    });
  });
}