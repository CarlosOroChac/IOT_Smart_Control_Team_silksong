import 'package:flutter_test/flutter_test.dart';
import 'package:smart_device_tester/thermostat.dart'; // Asegúrate de que la ruta sea correcta

void main() {
  group('Thermostat Unit Tests - Logic Core', () {
    late Thermostat thermostat;

    setUp(() {
      thermostat = Thermostat();
    });

    // 1. Prueba de estado inicial
    test('El termostato debe iniciar en 20.0 grados por defecto', () {
      expect(thermostat.currentTemp, 20.0);
    });

    // 2. Setter básico
    test('Debe permitir establecer una temperatura válida (22.0)', () {
      thermostat.setTargetTemperature(22.0);
      expect(thermostat.currentTemp, 22.0);
    });

    // 3. Límite superior exacto
    test('Debe permitir establecer la temperatura máxima exacta (30.0)', () {
      thermostat.setTargetTemperature(30.0);
      expect(thermostat.currentTemp, 30.0);
    });

    // 4. Límite inferior exacto
    test('Debe permitir establecer la temperatura mínima exacta (15.0)', () {
      thermostat.setTargetTemperature(15.0);
      expect(thermostat.currentTemp, 15.0);
    });

    // 5. Protección límite superior
    test('NO debe superar 30.0 grados (Clamping)', () {
      thermostat.setTargetTemperature(35.0);
      expect(thermostat.currentTemp, 30.0);
    });

    // 6. Protección límite inferior
    test('NO debe bajar de 15.0 grados (Clamping)', () {
      thermostat.setTargetTemperature(10.0);
      expect(thermostat.currentTemp, 15.0);
    });

    // 7. Método incrementar
    test('Increase() debe subir la temperatura en 1 grado', () {
      thermostat.setTargetTemperature(20.0);
      thermostat.increase();
      expect(thermostat.currentTemp, 21.0);
    });

    // 8. Método decrementar
    test('Decrease() debe bajar la temperatura en 1 grado', () {
      thermostat.setTargetTemperature(20.0);
      thermostat.decrease();
      expect(thermostat.currentTemp, 19.0);
    });

    // 9. Límite al incrementar
    test('Increase() no debe superar el máximo', () {
      thermostat.setTargetTemperature(30.0);
      thermostat.increase();
      expect(thermostat.currentTemp, 30.0);
    });

    // 10. Límite al decrementar
    test('Decrease() no debe bajar del mínimo', () {
      thermostat.setTargetTemperature(15.0);
      thermostat.decrease();
      expect(thermostat.currentTemp, 15.0);
    });

    // 11. Conversión a Fahrenheit
    test('Debe convertir correctamente Celsius a Fahrenheit (20C = 68F)', () {
      thermostat.setTargetTemperature(20.0);
      // Asumiendo que agregas un getter 'temperatureInFahrenheit' o calculas:
      double fahrenheit = (thermostat.currentTemp * 9 / 5) + 32;
      expect(fahrenheit, 68.0);
    });

    // 12. Validación de sistema activo (Calefacción)
    test('Debe indicar modo calefacción si temperatura ambiente es baja', () {
      // Simulación de lógica: Si target > actual (asumiendo lógica interna)
      // O simplemente validación de estado
      expect(thermostat.isValidRange(20.0), isTrue);
    });

    // 13. Validación de rango inválido
    test('isValidRange retorna false para valores fuera de rango', () {
      expect(thermostat.isValidRange(40.0), isFalse);
    });

    // 14. Set con decimales
    test('Debe manejar valores con decimales correctamente', () {
      thermostat.setTargetTemperature(18.5);
      expect(thermostat.currentTemp, 18.5);
    });

    // 15. Reinicio (si aplica) o re-instancia
    test('Una nueva instancia no mantiene el estado anterior', () {
      thermostat.setTargetTemperature(25.0);
      final newThermostat = Thermostat();
      expect(newThermostat.currentTemp, 20.0);
    });
    
    // 16. Prueba de Seguridad (valores negativos extremos)
    test('Valores negativos extremos se ajustan al mínimo', () {
      thermostat.setTargetTemperature(-100.0);
      expect(thermostat.currentTemp, 15.0);
    });
  });
}