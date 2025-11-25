import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_device_tester/IotController.dart';
import 'package:smart_device_tester/sensor_interface.dart'; // Asegúrate que esta ruta sea correcta

// Mocking de la interfaz de hardware
class MockSensor extends Mock implements SensorInterface {}

void main() {
  late MockSensor generalSensor;
  late MockSensor humiditySensor;
  late MockSensor coxDetector;
  late MockSensor lightDetector;
  late IotController controller;

  setUp(() {
    generalSensor = MockSensor();
    humiditySensor = MockSensor();
    coxDetector = MockSensor();
    lightDetector = MockSensor();

    controller = IotController(
      generalSensor: generalSensor,
      humiditySensor: humiditySensor,
      coxDetector: coxDetector,
      lightDetector: lightDetector, sensor: null,
    );
  });

  // =================================================================
  // REQUISITO 1: PRUEBAS UNITARIAS (+15 Tests de Lógica Pura)
  // No tocan mocks, solo lógica interna.
  // =================================================================
  group('1. Unit Tests - Pure Logic & Calculations', () {
    test('should convert 0 Celsius to 32 Fahrenheit', () {
      expect(controller.celsiusToFahrenheit(0), 32.0);
    });

    test('should convert 100 Celsius to 212 Fahrenheit', () {
      expect(controller.celsiusToFahrenheit(100), 212.0);
    });

    test('should return true for safe temperature (25C)', () {
      expect(controller.isTempSafe(25.0), isTrue);
    });

    test('should return false for unsafe low temperature (5C)', () {
      expect(controller.isTempSafe(5.0), isFalse);
    });

    test('should return false for unsafe high temperature (45C)', () {
      expect(controller.isTempSafe(45.0), isFalse);
    });

    test('should identify critical gas levels (>100)', () {
      expect(controller.isGasCritical(101.0), isTrue);
    });

    test('should identify safe gas levels (<100)', () {
      expect(controller.isGasCritical(99.0), isFalse);
    });

    test('should validate positive sensor reading', () {
      expect(controller.isValidReading(10.0), isTrue);
    });

    test('should invalidate negative sensor reading', () {
      expect(controller.isValidReading(-1.0), isFalse);
    });

    test('should calculate average of reading list correctly', () {
      expect(controller.calculateAverage([10, 20, 30]), 20.0);
    });

    test('should return 0 average for empty list', () {
      expect(controller.calculateAverage([]), 0.0);
    });

    test('should format reading with 2 decimals', () {
      expect(controller.formatReading(25.1234), "25.12");
    });

    test('should correctly identify Night Mode based on Lux', () {
      expect(controller.getLightStatus(30), "Night Mode");
    });

    test('should correctly identify Bright Sunlight based on Lux', () {
      expect(controller.getLightStatus(1200), "Bright Sunlight");
    });

    test('should reset alarm trigger manually', () {
      controller.alarmTriggered = true; // Arrange
      controller.resetAlarm();          // Act
      expect(controller.alarmTriggered, isFalse); // Assert
    });

    test('should detect low battery voltage', () {
      expect(controller.isBatteryLow(3.0), isTrue);
    });
  });

  // =================================================================
  // REQUISITO 3: INTEGRATION / E2E TESTS
  // Simulan flujo asíncrono UI <-> Hardware
  // =================================================================
  group('3. Integration Tests - Controller <-> Mock Hardware', () {
    
    // Caso de Éxito (Happy Path)
    test('Fetch General Reading: Should update state and return value', () async {
      // Arrange
      when(() => generalSensor.readValue()).thenAnswer((_) async => 25.0);
      
      // Act
      final result = await controller.fetchGeneralReading();
      
      // Assert
      expect(result, 25.0);
      expect(controller.lastReading, 25.0);
      expect(controller.readingHistory, contains(25.0));
      verify(() => generalSensor.readValue()).called(1);
    });

    // Caso de Fallo Controlado (Error Path)
    test('Fetch Humidity: Should handle exception gracefully (Fallback)', () async {
      // Arrange: Hardware falla
      when(() => humiditySensor.readHumidity()).thenThrow(Exception('Sensor disconnected'));

      // Act
      final result = await controller.fetchHumidityWithFallback();

      // Assert: La app no crashea, devuelve valor seguro
      expect(result, -1.0); 
    });

    // Caso de Lógica de Negocio Compleja (Trigger Hardware)
    test('Gas Monitor: Should trigger ventilation hardware if critical', () async {
      // Arrange
      when(() => coxDetector.readCOxLevel()).thenAnswer((_) async => 150.0); // Crítico
      when(() => coxDetector.triggerVentilation()).thenReturn(null);

      // Act
      await controller.monitorCriticalGas();

      // Assert
      verify(() => coxDetector.triggerVentilation()).called(1); // Comando enviado
      expect(controller.alarmTriggered, isTrue);
    });

    test('Light Sensor: Should manage loading state correctly', () async {
      when(() => lightDetector.readLux()).thenAnswer((_) async => 300.0);

      final future = controller.fetchLightLevelWithLatency();
      expect(controller.isLoading, isTrue); // Loading activo

      await future;
      expect(controller.isLoading, isFalse); // Loading termina
    });

    test('Timeout: Should throw exception if hardware is too slow', () async {
      when(() => generalSensor.readValue()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return 10.0;
      });

      expect(
        () => controller.fetchGeneralReadingWithTimeout(timeout: const Duration(milliseconds: 100)),
        throwsA(isA<TimeoutException>()),
      );
    });
  });
}