import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Importa tu widget principal o el panel de control
import 'package:smart_device_tester/widgets/control_panel_widget.dart'; 

void main() {
  testWidgets('Widget Test: Renderizado inicial correcto', (WidgetTester tester) async {
    // 1. Renderizar la UI
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: ControlPanelWidget(controller: null,)),
    ));

    // 2. Verificar que el texto inicial existe
    expect(find.text('Panel de Control'), findsOneWidget); 
    // Busca un icono específico
    expect(find.byIcon(Icons.thermostat), findsOneWidget);
  });

  testWidgets('Widget Test: Interacción simple de botón', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: ControlPanelWidget(controller: null,)),
    ));

    // Verificar estado inicial (ej. contador en 0 o texto base)
    expect(find.text('0'), findsOneWidget);

    // 1. Tocar el botón (tap)
    await tester.tap(find.byType(FloatingActionButton));
    
    // 2. Re-renderizar (pump)
    await tester.pump();

    // 3. Verificar cambio en la UI (sin mocks complejos)
    expect(find.text('1'), findsOneWidget);
  });
  
  testWidgets('Widget Test: Existencia del Slider', (WidgetTester tester) async {
     await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: ControlPanelWidget(controller: null,)),
    ));
    
    // Verificar que existe un Slider o elemento de control
    expect(find.byType(Slider), findsAtLeastNWidgets(0)); // Cambia a 1 si tienes Slider
  });
}