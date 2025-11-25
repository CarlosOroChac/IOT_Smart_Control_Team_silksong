import 'dart:async';
import 'sensor_interface.dart'; // Asegúrate de que este import sea correcto

class IotController {
  // Hacemos que los sensores sean "nullable" (?) para que sean opcionales
  final SensorInterface? generalSensor;
  final SensorInterface? humiditySensor;
  final SensorInterface? coxDetector;
  final SensorInterface? lightDetector;
  final SensorInterface? sensor; // El sensor principal para tus tests

  // Constructor con parámetros nombrados opcionales
  IotController({
    this.generalSensor,
    this.humiditySensor,
    this.coxDetector,
    this.lightDetector,
    this.sensor,
  });

  get lastReading => null;

  /// Método para obtener temperatura.
  /// Prioriza el 'sensor' inyectado (para tests), luego 'generalSensor', 
  /// o retorna un valor por defecto si no hay ninguno.
  Future<double> getTemperature() async {
    // Simular un pequeño retardo de red/hardware real si no es un test
    if (sensor == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      if (sensor != null) {
        return await sensor!.readTemperature();
      } else if (generalSensor != null) {
        return await generalSensor!.readTemperature();
      }
      
      // Lógica por defecto si no hay sensores conectados (Modo Demo)
      return 20.0; 
    } catch (e) {
      rethrow; // Permitir que la UI maneje la excepción
    }
  }

  Future fetchGeneralReading() async {}

  // Aquí puedes agregar el resto de métodos para los otros sensores
  // usando la misma lógica de verificar si son != null
}