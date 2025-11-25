import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Para TimeoutException

// Importaciones de tu proyecto
import 'package:smart_device_tester/IotController.dart';
import 'package:smart_device_tester/sensor_interface.dart';
import 'package:smart_device_tester/widgets/control_panel_widget.dart'; // O tu widget principal

// 1. Crear el Mock
class MockSensor extends Mock implements SensorInterface {
  @override
  Future<double> readTemperature() async {
    return 0.0;
  }
}

void main() {
  late MockSensor mockSensor;
  late IotController controller;

  setUp(() {
      mockSensor = MockSensor();
      // Inyectamos el mock al controlador
      controller = IotController(
        sensor: mockSensor,
        generalSensor: mockSensor,
        humiditySensor: mockSensor,
        coxDetector: mockSensor,
        lightDetector: mockSensor,
      );
    });

  testWidgets('E2E: UI actualiza valor cuando el sensor responde EXITOSAMENTE', (WidgetTester tester) async {
    // ARRANGE: Configurar el mock para retornar 25.5 grados
    when(() => mockSensor.readTemperature()).thenAnswer((_) async => 25.5);

    // Inyectar el controlador en la UI
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        // Asumiendo que tu widget acepta el controller
        body: ControlPanelWidget(controller: controller), 
      ),
    ));

    // ACT: Simular interacción (botón de refrescar)
    // Busca el botón por icono o key. Ajusta esto a tu UI real.
    final refreshBtn = find.byIcon(Icons.refresh);
    await tester.tap(refreshBtn);

    // Re-renderizar para iniciar el Future
    await tester.pump(); 
    // Esperar a que el "Future" simulado termine (crucial en E2E)
    await tester.pump(const Duration(milliseconds: 500));

    // ASSERT: Verificar que el texto 25.5 aparece en pantalla
    expect(find.textContaining('25.5'), findsOneWidget);
    // Verificar que se llamó al hardware
    verify(() => mockSensor.readTemperature()).called(1);
  });

  testWidgets('E2E: UI maneja ERROR del sensor elegantemente', (WidgetTester tester) async {
    // ARRANGE: Configurar el mock para lanzar excepción
    when(() => mockSensor.readTemperature()).thenThrow(Exception('Fallo de hardware'));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ControlPanelWidget(controller: controller),
      ),
    ));

    // ACT
    await tester.tap(find.byIcon(Icons.refresh));
    
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // ASSERT: Verificar que la app NO crasheó y muestra un valor seguro o error
    // Opción A: Muestra 0.0
    // Opción B: Muestra "Error"
    // Ajusta según tu lógica de manejo de errores
    expect(find.textContaining('0.0'), findsOneWidget); 
  });
}