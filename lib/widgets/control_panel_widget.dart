import 'package:flutter/material.dart';
// Asegúrate de importar tu controlador correctamente
import '../IotController.dart'; 

class ControlPanelWidget extends StatefulWidget {
  // CLAVE: Permitir inyección del controlador para pruebas
  final IotController controller;

  const ControlPanelWidget({Key? key, required this.controller}) : super(key: key);

  @override
  State<ControlPanelWidget> createState() => _ControlPanelWidgetState();
}

class _ControlPanelWidgetState extends State<ControlPanelWidget> {
  late IotController _iotController;
  String _temperatureDisplay = "--.-°C";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Requiere que el controlador sea provisto por el padre (inyección).
    _iotController = widget.controller;
  }

  // Método para actualizar datos simulando petición asíncrona
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Asumimos que tu controller tiene un método getTemperature() o similar.
      // Si tu método se llama distinto (ej. readSensor), cámbialo aquí.
      final double temp = await _iotController.getTemperature(); 
      
      setState(() {
        _temperatureDisplay = "${temp.toStringAsFixed(1)}°C";
        _isLoading = false;
      });
    } catch (e) {
      // Manejo elegante del error (Requisito del test de fallo)
      setState(() {
        _temperatureDisplay = "0.0°C"; // Valor seguro por defecto
        _isLoading = false;
      });
      // Opcional: Mostrar un SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de conexión con el sensor')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Thermostat")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.thermostat, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "Temperatura Actual:",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    _temperatureDisplay,
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              // Es importante ponerle una Key para encontrarlo fácil en el test
              key: const Key('refresh_button'),
              onPressed: _isLoading ? null : _refreshData,
              icon: const Icon(Icons.refresh),
              label: const Text("Actualizar Sensor"),
            )
          ],
        ),
      ),
    );
  }
}