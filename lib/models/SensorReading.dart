import 'package:flutter/material.dart';
import 'package:smart_plants_app/utils/BackendConnection.dart';

/// Defines a sensor reading.
///
/// A sensor reading is defined as a combination of air temperature and humidity, soil moisture and light intensity.
class SensorReading {
  /// The air temperature around the plant.
  final double airTemperature;

  /// The air humidity around the plant.
  final double airHumidity;

  /// The moisture of the soil the plant is in.
  final double soilMoisture;

  /// The light intensity around the plant.
  final double lightIntensity;

  /// Constructs a new sensor reading.
  SensorReading._internal(this.airTemperature, this.airHumidity,
      this.soilMoisture, this.lightIntensity);

  /// Retrieves the latest reading from the database for [plantName] owned by [username] and creates a new [SensorReading].
  static Future<SensorReading> latestReading(
      String username, String plantName) {
    return BackendConnection.latestReading(username, plantName).then((reading) {
      return SensorReading._internal(
          reading.getField("airTemperature") * 1.0,
          reading.getField("airHumidity") * 1.0,
          reading.getField("soilMoisture") * 1.0,
          reading.getField("lightIntensity") * 1.0);
    });
  }

  Widget _displayMeasurement(
      double measurement, String measurementName, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Icon(
              icon,
              size: 48,
            ),
          ),
          Text(
            measurement.toStringAsFixed(0),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
            ),
          ),
          Text(measurementName),
        ],
      ),
    );
  }

  Widget get measurements => GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(20),
        mainAxisSpacing: 10,
        children: [
          _displayMeasurement(
              airTemperature, "Temperature", Icons.whatshot_outlined),
          _displayMeasurement(airHumidity, "Humidity", Icons.percent_outlined),
          _displayMeasurement(
              soilMoisture, "Moisture", Icons.water_drop_outlined),
          _displayMeasurement(lightIntensity, "Light", Icons.wb_sunny_outlined),
        ],
      );
}
