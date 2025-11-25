import 'dart:async';
import 'package:smart_device_tester/sensor_interface.dart';

class IotController {
  final SensorInterface generalSensor;
  final SensorInterface humiditySensor;
  final SensorInterface coxDetector;
  final SensorInterface lightDetector;

  // Estado
  double lastReading = 0.0;
  bool isLoading = false;
  bool alarmTriggered = false;
  List<double> readingHistory = [];

  IotController({
    required this.generalSensor,
    required this.humiditySensor,
    required this.coxDetector,
    required this.lightDetector, required sensor,
  });

  // ==========================================================
  // LÓGICA PURA (Unit Tests - Requisito 1)
  // Métodos síncronos sin dependencias externas
  // ==========================================================

  /// 1. Convierte Celsius a Fahrenheit
  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  /// 2. Valida si la temperatura es segura (ej. 10°C a 40°C)
  bool isTempSafe(double temp) {
    return temp >= 10.0 && temp <= 40.0;
  }

  /// 3. Verifica si el nivel de gas es crítico (> 100)
  bool isGasCritical(double ppm) {
    return ppm > 100.0;
  }

  /// 4. Valida que la lectura no sea negativa (hardware error check)
  bool isValidReading(double value) {
    return value >= 0;
  }

  /// 5. Calcula el promedio del historial
  double calculateAverage(List<double> values) {
    if (values.isEmpty) return 0.0;
    double sum = values.reduce((a, b) => a + b);
    return sum / values.length;
  }

  /// 6. Formatea la lectura para UI
  String formatReading(double value) {
    return value.toStringAsFixed(2);
  }

  /// 7. Agrega al historial (Lógica de estado)
  void addToHistory(double value) {
    if (readingHistory.length >= 10) {
      readingHistory.removeAt(0);
    }
    readingHistory.add(value);
  }

  /// 8. Reinicia la alarma manualmente
  void resetAlarm() {
    alarmTriggered = false;
  }

  /// 9. Determina el estado del sistema basado en luz
  String getLightStatus(double lux) {
    if (lux < 50) return "Night Mode";
    if (lux > 1000) return "Bright Sunlight";
    return "Normal";
  }

  /// 10. Verifica batería baja (simulada)
  bool isBatteryLow(double voltage) {
    return voltage < 3.3;
  }

  // ==========================================================
  // MÉTODOS ASÍNCRONOS (Integration Tests - Requisito 3)
  // Comunicación con Hardware
  // ==========================================================

  Future<double> fetchGeneralReading() async {
    isLoading = true;
    try {
      final value = await generalSensor.readValue();
      lastReading = value;
      addToHistory(value);
      return value;
    } finally {
      isLoading = false;
    }
  }

  Future<double> fetchHumidityWithFallback() async {
    try {
      return await humiditySensor.readHumidity();
    } catch (e) {
      return -1.0; // Fallback seguro
    }
  }

  Future<void> monitorCriticalGas() async {
    final level = await coxDetector.readCOxLevel();
    if (isGasCritical(level)) {
      coxDetector.triggerVentilation(); // Comando al hardware
      alarmTriggered = true;
    }
  }

  Future<double> fetchGeneralReadingWithTimeout({required Duration timeout}) async {
    return await generalSensor.readValue().timeout(timeout);
  }
  
  Future<double> fetchLightLevelWithLatency() async {
    isLoading = true;
    final val = await lightDetector.readLux();
    isLoading = false;
    return val;
  }

  Future<double> getTemperature() async {
    // Return the current temperature by delegating to the general reading method.
    // This ensures a non-null Future<double> is always returned.
    return await fetchGeneralReading();
  }
}