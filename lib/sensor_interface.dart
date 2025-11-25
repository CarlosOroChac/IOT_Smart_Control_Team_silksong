abstract class SensorInterface {
  /// Lee la temperatura actual (usado en tests antiguos)
  Future<double> readTemperature();

  /// Lee un valor genérico (usado en fetchGeneralReading)
  Future<double> readValue();

  /// Lee la humedad relativa
  Future<double> readHumidity();

  /// Lee el nivel de COx (Monóxido de Carbono)
  Future<double> readCOxLevel();

  /// Lee el nivel de luz en Lux
  Future<double> readLux();

  /// Activa el sistema de ventilación de emergencia
  void triggerVentilation();
}