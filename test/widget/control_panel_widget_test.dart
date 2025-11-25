import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_device_tester/IotController.dart';
import 'package:smart_device_tester/sensor_interface.dart';
// Asegúrate de que la ruta a tu widget sea correcta
import 'package:smart_device_tester/widgets/control_panel_widget.dart'; 

// 1. Definimos el Mock para satisfacer las dependencias del IotController
class MockSensor extends Mock implements SensorInterface {}

void main() {
  late MockSensor mockSensor;
  late IotController controller;

  // 2. Configuración previa a cada test
  setUp(() {
    mockSensor = MockSensor();
    
    // Inicializamos el controlador con los mocks (ya no puede estar vacío)
    controller = IotController(
      sensor: mockSensor,
      generalSensor: mockSensor,
      humiditySensor: mockSensor,
      coxDetector: mockSensor,
      lightDetector: mockSensor,
    );
  });

  testWidgets('should show zero when ControlPanelWidget initializes', (tester) async {
    // 3. Inyectamos el controlador creado en el setUp
    await tester.pumpWidget(
      MaterialApp(
        home: ControlPanelWidget(controller: controller),
      ),
    );

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('should increment to one when button is tapped once', (tester) async {
    await tester.pumpWidget(
      MaterialApp( // Quitamos 'const' porque el controller no es constante
        home: ControlPanelWidget(controller: controller),
      ),
    );

    // Asumiendo que tu FloatingActionButton incrementa un contador visual
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(); // Espera a que termine la animación

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('should increment to five when button is tapped five times', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ControlPanelWidget(controller: controller),
      ),
    );

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byType(FloatingActionButton));
      // Usamos pump simple dentro del bucle para velocidad, pumpAndSettle al final
      await tester.pump(); 
    }
    await tester.pumpAndSettle();

    expect(find.text('5'), findsOneWidget);
  });
}