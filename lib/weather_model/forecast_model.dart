class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final String mainCondition;

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.mainCondition,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: (json['main']['temp'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}