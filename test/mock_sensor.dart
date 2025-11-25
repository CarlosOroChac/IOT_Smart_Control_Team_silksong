import 'package:mocktail/mocktail.dart';
// Asegúrate de que este import apunte a tu proyecto real
import 'package:smart_device_tester/sensor_interface.dart'; 

// Clase Mock que implementa la interfaz completa
class MockSensor extends Mock implements SensorInterface {}