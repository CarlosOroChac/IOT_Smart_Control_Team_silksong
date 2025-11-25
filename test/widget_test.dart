import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// --- Widget Simulado para Pruebas (Si tienes uno real, impórtalo) ---
class SmartDisplayCard extends StatefulWidget {
  final String title;
  final String initialValue;

  const SmartDisplayCard({super.key, required this.title, required this.initialValue});

  @override
  State<SmartDisplayCard> createState() => _SmartDisplayCardState();
}

class _SmartDisplayCardState extends State<SmartDisplayCard> {
  late String currentValue;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.title),
          Text(currentValue, style: TextStyle(color: isActive ? Colors.green : Colors.grey)),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                currentValue = "Updated";
                isActive = !isActive;
              });
            },
          ),
        ],
      ),
    );
  }
}
// -------------------------------------------------------------------

void main() {
  group('2. Widget Tests - UI Rendering & Interaction', () {
    
    testWidgets('Should render Title and Initial Value correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SmartDisplayCard(title: 'Temperatura', initialValue: '20°C'),
        ),
      ));

      // Assert (Verificar que se muestran los textos)
      expect(find.text('Temperatura'), findsOneWidget);
      expect(find.text('20°C'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('Should find the Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SmartDisplayCard(title: 'Humedad', initialValue: '50%'),
        ),
      ));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Interaction: Tapping refresh should update text and color (State Change)', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SmartDisplayCard(title: 'Sensor', initialValue: 'Waiting'),
        ),
      ));

      // Act: Tocar el botón
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump(); // Forzar re-renderizado

      // Assert: El texto debió cambiar
      expect(find.text('Updated'), findsOneWidget);
      expect(find.text('Waiting'), findsNothing);
      
      // Verificar cambio de estilo (Verificamos que el widget Text ahora tenga color verde implícitamente por lógica)
      final textWidget = tester.widget<Text>(find.text('Updated'));
      expect(textWidget.style?.color, Colors.green);
    });
  });
}