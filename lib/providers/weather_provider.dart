import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();
  WeatherModel? _weather;
  bool _isLoading = false;
  String _lastCity = '';

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String get lastCity => _lastCity;

  WeatherProvider() {
    _loadLastCity();
  }

  Future<void> _loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    _lastCity = prefs.getString('last_city') ?? '';

    if (_lastCity.isNotEmpty) {
      await searchWeather(_lastCity);
    }
  }

  Future<void> searchWeather(String city) async {
    _isLoading = true;
    notifyListeners();

    _weather = await _service.fetchWeather(city);
    _lastCity = city;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('last_city', city);

    _isLoading = false;
    notifyListeners();
  }
}
