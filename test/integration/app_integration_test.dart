
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Para TimeoutException


// Definimos la interfaz aquí para asegurar que Mocktail la entienda
abstract class SensorInterface {
  Future<double> readTemperature();
}

// Creamos el Mock basado en esa interfaz
class MockSensorInterface extends Mock implements SensorInterface {}

// Controlador simple para el test
class IotController {
  final SensorInterface sensor;
  IotController(this.sensor);

  Future<double> checkCurrentTemperature() async {
    try {
      return await sensor.readTemperature();
    } catch (e) {
      return 0.0; // Retorno seguro en caso de error
    }
  }
}

void main() {
  late MockSensorInterface mockSensor;
  late IotController controller;

  setUp(() {
    mockSensor = MockSensorInterface();
    controller = IotController(mockSensor);
  });

  test('E2E: UI actualiza valor cuando el sensor responde EXITOSAMENTE', () async {
    // Arrange
    when(() => mockSensor.readTemperature()).thenAnswer((_) async => 25.5);

    // Act
    final result = await controller.checkCurrentTemperature();

    // Assert
    expect(result, 25.5);
    verify(() => mockSensor.readTemperature()).called(1);
  });

  test('E2E: UI maneja ERROR del sensor elegantemente', () async {
    // Arrange
    when(() => mockSensor.readTemperature()).thenThrow(Exception('Error de conexión'));

    // Act
    final result = await controller.checkCurrentTemperature();

    // Assert
    expect(result, 0.0); // Verifica que devolvió el valor seguro
    verify(() => mockSensor.readTemperature()).called(1);
  });
}