import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app2/weather_model/weather_model.dart';

import '../weather_model/forecast_model.dart';
import '../weather_service/notification_service.dart';
import '../weather_service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherServices =
      WeatherServices(
    apikey: 'e008df2889aafcb78470c1dba624ff6d'.trim(),
  );

  final NotificationService _notificationService =
      NotificationService();

  Weather? _weather;
  List<ForecastItem>? _forecast;

Future<void> _fetchWeather() async {
  try {
    print("=== FETCH WEATHER STARTED ===");

    String cityName =
        await _weatherServices.getCurrentCity();

    print("City: $cityName");

    final weather =
        await _weatherServices.getWeather(cityName);

    print("Temperature: ${weather.temperature}");
    print("Condition: ${weather.maincondition}");

    final forecast =
        await _weatherServices.getForecast(cityName);

    setState(() {
      _weather = weather;
      _forecast = forecast;
    });

    // SEND WEATHER NOTIFICATION
    await _notificationService.showWeatherNotification(
      temperature: weather.temperature,
      description: weather.maincondition,
    );

    print("=== WEATHER NOTIFICATION SENT ===");
  } catch (e) {
    print("=== WEATHER ERROR ===");
    print(e);
  }
}

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/animation/windy.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'assets/animation/sunny.json';

      case 'clouds':
        return 'assets/animation/cloudy.json';

      case 'rain':
        return 'assets/animation/rainy.json';

      case 'snow':
        return 'assets/animation/snowy.json';

      default:
        return 'assets/animation/sunny.json';
    }
  }

  IconData _iconForCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;

      case 'rain':
        return Icons.grain;

      case 'snow':
        return Icons.ac_unit;

      default:
        return Icons.wb_sunny;
    }
  }

  Widget buildHourlyForecast() {
    final next24hrs = _forecast!.take(8).toList();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: next24hrs.length,
        itemBuilder: (context, index) {
          final item = next24hrs[index];

          final hour =
              "${item.dateTime.hour}:00";

          return Container(
            width: 70,
            margin:
                const EdgeInsets.only(right: 12),
            padding:
                const EdgeInsets.symmetric(
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.15),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  hour,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Icon(
                  _iconForCondition(
                    item.mainCondition,
                  ),
                  color: Colors.white,
                  size: 22,
                ),
                Text(
                  "${item.temperature.round()}°",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildFiveDayForecast() {
    Map<String, ForecastItem> dailyMap = {};

    for (var item in _forecast!) {
      String dateKey =
          "${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}";

      if (item.dateTime.hour == 12 ||
          !dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = item;
      }
    }

    final dailyList =
        dailyMap.values.take(5).toList();

    return Column(
      children: dailyList.map((item) {
        final weekday =
            _weekdayName(item.dateTime.weekday);

        return Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weekday,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Icon(
                _iconForCondition(
                  item.mainCondition,
                ),
                color: Colors.white,
              ),
              Text(
                "${item.temperature.round()}°",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _weekdayName(int weekday) {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return days[weekday - 1];
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff55C1F8),
              Color(0xff4A90E2),
            ],
          ),
        ),
        child: SafeArea(
          child: _weather == null
              ? const Center(
                  child:
                      CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Top Row
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons
                                      .location_on_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _weather!.cityName,
                                  style:
                                      const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: _fetchWeather,
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Weather Animation
                        Lottie.asset(
                          getWeatherAnimation(
                            _weather!.maincondition,
                          ),
                          width: 180,
                          height: 180,
                        ),

                        const SizedBox(height: 20),

                        // Weather Card
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(20),
                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(
                              25,
                            ),
                            border: Border.all(
                              color: Colors.white24,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Today",
                                style: TextStyle(
                                  color:
                                      Colors.white70,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                "${_weather!.temperature.round()}°",
                                style:
                                    const TextStyle(
                                  fontSize: 60,
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.w300,
                                ),
                              ),

                              Text(
                                _weather!.maincondition,
                                style:
                                    const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.air,
                                        color:
                                            Colors.white,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "Wind",
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white70,
                                        ),
                                      ),
                                      Text(
                                        "${_weather!.windSpeed.toStringAsFixed(1)} k/h",
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      const Icon(
                                        Icons
                                            .water_drop,
                                        color:
                                            Colors.white,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "Humidity",
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white70,
                                        ),
                                      ),
                                      Text(
                                        "${_weather!.humidity}%",
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Next 24 Hours
                        const Align(
                          alignment:
                              Alignment.centerLeft,
                          child: Text(
                            "Next 24 Hours",
                            style: TextStyle(
                              color:
                                  Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        buildHourlyForecast(),

                        const SizedBox(height: 20),

                        // 5 Day Forecast
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(
                            15,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),
                          child:
                              buildFiveDayForecast(),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}