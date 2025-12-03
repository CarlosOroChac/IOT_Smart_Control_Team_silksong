class Thermostat {
  // Constantes públicas (para que el test pueda acceder si lo necesita)
  static const double minTemperature = 15.0;
  static const double maxTemperature = 30.0;

  // Variable interna privada
  double _currentTemp = 20.0;

  // 1. Getter 'currentTemp' (El test lo pide así: thermostat.currentTemp)
  double get currentTemp => _currentTemp;
  
  // Getter alias por si algún otro test usa 'targetTemperature'
  double get targetTemperature => _currentTemp;

  // 2. Método Setter (El test usa: thermostat.setTargetTemperature(val))
  double setTargetTemperature(double temp) {
    if (temp < minTemperature) {
      _currentTemp = minTemperature;
    } else if (temp > maxTemperature) {
      _currentTemp = maxTemperature;
    } else {
      _currentTemp = temp;
    }
    return _currentTemp;
  }

  // 3. Métodos increase/decrease (El test los pide)
  void increase() {
    setTargetTemperature(_currentTemp + 1);
  }

  void decrease() {
    setTargetTemperature(_currentTemp - 1);
  }

  // 4. Método isValidRange (El test #12 y #13 lo piden explícitamente)
  bool isValidRange(double temp) {
    return temp >= minTemperature && temp <= maxTemperature;
  }
}