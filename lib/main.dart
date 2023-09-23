import 'package:flutter/material.dart';
import 'home_page.dart'; 
import 'weather_page.dart'; 

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Previsão do Tempo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/weather': (context) =>
            WeatherPage(), 
      },
    );
  }
}
