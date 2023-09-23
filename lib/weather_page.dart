import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class WeatherData {
  final String cityName;
  final double temperature;
  final double maxTemperature;
  final double minTemperature;
  final String description;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.description,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    return WeatherData(
      cityName: json['name'],
      temperature: main['temp'].toDouble(),
      maxTemperature: main['temp_max'].toDouble(),
      minTemperature: main['temp_min'].toDouble(),
      description: weather['description'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherData? weatherData;

  final TextEditingController cityNameController = TextEditingController();

  Future<void> fetchWeatherData(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://weather.contrateumdev.com.br/api/weather/city/?city=$cityName'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        weatherData = WeatherData.fromJson(data);
      });
    } else {
      throw Exception('Erro ao carregar os dados meteorológicos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previsão do Tempo'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              controller: cityNameController,
              decoration: InputDecoration(labelText: 'Nome da Cidade'),
              onEditingComplete: () {
                fetchWeatherData(cityNameController.text);
              },
            ),
          ),
          if (weatherData != null)
            Column(
              children: <Widget>[
                _buildInfoContainer('Cidade: ${weatherData!.cityName}'),
                _buildInfoContainer(
                    'Temperatura: ${weatherData!.temperature.toStringAsFixed(1)}°C'),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoContainer(
                          'Temperatura Máxima: ${weatherData!.maxTemperature.toStringAsFixed(1)}°C'),
                    ),
                    SizedBox(width: 16), // Espaço entre os retângulos
                    Expanded(
                      child: _buildInfoContainer(
                          'Temperatura  Mínima: ${weatherData!.minTemperature.toStringAsFixed(1)}°C'),
                    ),
                  ],
                ),
                _buildInfoContainer('Descrição: ${weatherData!.description}'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String info) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        info,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
