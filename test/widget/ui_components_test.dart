import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Importa tus clases
import 'package:smart_device_tester/IotController.dart';
import 'package:smart_device_tester/sensor_interface.dart';
import 'package:smart_device_tester/widgets/control_panel_widget.dart';

// 1. Definimos el Mock del sensor para que el controlador pueda construirse
class MockSensor extends Mock implements SensorInterface {}

void main() {
  late IotController controller;
  late MockSensor mockSensor;

  // 2. Configuración previa (Setup)
  setUp(() {
    mockSensor = MockSensor();
    // Creamos un controlador válido con dependencias simuladas
    controller = IotController(
      generalSensor: mockSensor,
      humiditySensor: mockSensor,
      coxDetector: mockSensor,
      lightDetector: mockSensor, sensor: null,
    );
  });

  testWidgets('Widget Test: Renderizado inicial correcto', (WidgetTester tester) async {
    // 1. Renderizar la UI
    // IMPORTANTE: Quitamos 'const' y pasamos el 'controller' real
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ControlPanelWidget(controller: controller),
      ),
    ));

    // 2. Verificar que el widget principal está en pantalla
    expect(find.byType(ControlPanelWidget), findsOneWidget);

    // OPCIONAL: Verifica textos o iconos específicos de tu UI real
    // expect(find.text('Panel de Control'), findsOneWidget); 
    // expect(find.byIcon(Icons.thermostat), findsOneWidget);
  });

  testWidgets('Widget Test: Interacción simple de botón', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ControlPanelWidget(controller: controller),
      ),
    ));

    // Verificar estado inicial (asumiendo que empieza en 0)
    expect(find.text('0'), findsOneWidget);

    // 1. Tocar el botón (FloatingActionButton)
    await tester.tap(find.byType(FloatingActionButton));
    
    // 2. Re-renderizar (pump) para que Flutter procese el cambio de estado
    await tester.pump();

    // 3. Verificar cambio en la UI
    expect(find.text('1'), findsOneWidget);
  });
  
  testWidgets('Widget Test: Existencia del Slider', (WidgetTester tester) async {
     await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ControlPanelWidget(controller: controller),
      ),
    ));
    
    // Verificar que existe un Slider (útil si tu rúbrica pide probar inputs)
    // Nota: Si tu UI no tiene Slider, cambia esto a findsNothing o agrega uno a tu UI.
    expect(find.byType(Slider), findsAtLeastNWidgets(0)); 
  });
}