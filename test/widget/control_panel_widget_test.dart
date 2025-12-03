import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:smart_device_tester/widgets/control_panel_widget.dart'; 

void main() {
  testWidgets('should show zero when ControlPanelWidget initializes', (tester) async {
    // 1. Renderizamos el widget (sin controller)
    await tester.pumpWidget(
      const MaterialApp(
        home: ControlPanelWidget(), 
      ),
    );

    // 2. Verificamos que arranque en 0
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('should increment to one when button is tapped once', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ControlPanelWidget(),
      ),
    );

    // 1. Buscamos el botón flotante y le damos tap
    await tester.tap(find.byType(FloatingActionButton));
    
    // 2. Esperamos la animación
    await tester.pumpAndSettle();

    // 3. Verificamos que cambió a 1
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('should increment to five when button is tapped five times', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ControlPanelWidget(),
      ),
    );

    // 1. Damos 5 taps
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(); // Pump rápido entre taps
    }
    
    // 2. Esperamos asentamiento final
    await tester.pumpAndSettle();

    // 3. Verificamos que llegó a 5
    expect(find.text('5'), findsOneWidget);
  });
}