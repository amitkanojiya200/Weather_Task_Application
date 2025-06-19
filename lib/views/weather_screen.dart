import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/weather_provider.dart';
import 'package:provider/provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load last searched city into the input field
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<WeatherProvider>(context, listen: false);
      _controller.text = provider.lastCity;

      // If a previous city exists, fetch its weather
      if (_controller.text.isNotEmpty) {
        provider.searchWeather(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.weather;

    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_controller.text.isNotEmpty) {
                      weatherProvider.searchWeather(_controller.text);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (weatherProvider.isLoading)
              const CircularProgressIndicator()
            else if (weather != null)
              Column(
                children: [
                  Text(
                    weather.cityName,
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    '${weather.temperature} °C',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    weather.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Image.network(
                    'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                  ),
                ],
              )
            else
              const Text('Search for a city to get weather data'),
          ],
        ),
      ),
    );
  }
}
