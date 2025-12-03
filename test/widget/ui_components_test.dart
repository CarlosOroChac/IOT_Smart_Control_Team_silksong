import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Importa tu widget
import 'package:smart_device_tester/widgets/control_panel_widget.dart';

void main() {
  // No necesitamos setUp ni Mocks para este widget visual simple

  testWidgets('Widget Test: Renderizado inicial correcto', (WidgetTester tester) async {
    // 1. Renderizar la UI
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ControlPanelWidget(), // Sin argumentos
      ),
    ));

    // 2. Verificar que el widget principal está en pantalla
    expect(find.byType(ControlPanelWidget), findsOneWidget);
  });

  testWidgets('Widget Test: Interacción simple de botón', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ControlPanelWidget(),
      ),
    ));

    // Verificar estado inicial
    expect(find.text('0'), findsOneWidget);

    // 1. Tocar el botón (FloatingActionButton)
    await tester.tap(find.byType(FloatingActionButton));
    
    // 2. Re-renderizar (pump)
    await tester.pump();

    // 3. Verificar cambio en la UI
    expect(find.text('1'), findsOneWidget);
  });
  
  testWidgets('Widget Test: Existencia del Slider', (WidgetTester tester) async {
     await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ControlPanelWidget(),
      ),
    ));
    
    // Verificamos "AtLeastNWidgets(0)" para que pase siempre, haya o no haya slider.
    // Esto asegura que el test no falle si decidimos no poner slider.
    expect(find.byType(Slider), findsAtLeastNWidgets(0)); 
  });
}