import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = 'London';
  String _temperature = '';
  String _weatherDescription = '';
  String _feelsLike = '';
  bool _loading = false;

  final String apiKey = 'bd5e378503939ddaee76f12ad7a97608';


  Future<void> _getWeather() async {
    setState(() {
      _loading = true;
    });

    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = '${data['main']['temp']} °C';
          _weatherDescription = data['weather'][0]['description'];
          _feelsLike = 'Feels like: ${data['main']['feels_like']} °C';
        });
      } else {
        setState(() {
          _temperature = 'Error fetching data';
          _weatherDescription = '';
          _feelsLike = '';
        });
      }
    } catch (e) {
      setState(() {
        _temperature = 'Error fetching data';
        _weatherDescription = '';
        _feelsLike = '';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => _city = value,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('City: $_city', style: TextStyle(fontSize: 18)),
                      Text('Temperature: $_temperature', style: TextStyle(fontSize: 18)),
                      Text('Weather: $_weatherDescription', style: TextStyle(fontSize: 18)),
                      Text(_feelsLike, style: TextStyle(fontSize: 18)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
