class Weather {
  final String cityName;
  final double temperature;
  final String maincondition;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.maincondition,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromjson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      maincondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble() * 3.6, // Convert m/s to k/h
    );
  }
}