import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather.dart';

void main() {
  group('Weather.fromJson', () {
    test('should parse realistic Manila OpenWeatherMap JSON correctly', () {
      // 1. Arrange: Data structured exactly like the real API response
      // Based on the OpenWeatherMap JSON format for Manila
      final Map<String, dynamic> manilaJson = {
        "coord": {"lon": 120.9822, "lat": 14.6042},
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 31.02,
          "feels_like": 35.88,
          "temp_min": 30.06,
          "temp_max": 32.15,
          "pressure": 1010,
          "humidity": 66
        },
        "visibility": 10000,
        "wind": {"speed": 4.12, "deg": 80},
        "clouds": {"all": 75},
        "dt": 1705123200,
        "sys": {
          "type": 1,
          "id": 7905,
          "country": "PH",
          "sunrise": 1705098312,
          "sunset": 1705138845
        },
        "timezone": 28800,
        "id": 1701668,
        "name": "Manila",
        "cod": 200
      };

      // 2. Act: Call the fromJson factory
      final weather = Weather.fromJson(manilaJson);

      // 3. Assert: Verify the data matches the JSON input
      expect(weather.city, 'Manila');
      expect(weather.temperature, 31.02);
      expect(weather.description, 'Clouds');
      expect(weather.humidity, 66);
      expect(weather.windSpeed, 4.12);
    });

    test('should handle integer values for double fields safely', () {

      final Map<String, dynamic> integerJson = {
        "weather": [
          {"main": "Clear"}
        ],
        "main": {
          "temp": 30,
          "humidity": 50
        },
        "wind": {
          "speed": 5
        },
        "name": "Manila"
      };

      final weather = Weather.fromJson(integerJson);

      expect(weather.temperature, 30.0);
      expect(weather.windSpeed, 5.0);
    });

    test('should provide default values for missing data', () {
      final Map<String, dynamic> incompleteJson = {
        "weather": [{}],
        "main": {},
        "wind": {},
      };

      final weather = Weather.fromJson(incompleteJson);

      expect(weather.city, 'Unknown');
      expect(weather.temperature, 0.0);
      expect(weather.description, 'Unknown');
      expect(weather.humidity, 0);
      expect(weather.windSpeed, 0.0);
    });
  });
}