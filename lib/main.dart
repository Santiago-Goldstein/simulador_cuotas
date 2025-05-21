import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador de Cuotas',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto', // Usar una tipografía moderna
      ),
      home: const HomeScreen(), // Pantalla principal
    );
  }
}

// Pantalla principal con menú
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Map<int, double>> _cargarCoeficientesSimple() async {
    final prefs = await SharedPreferences.getInstance();
    final simpleEntries = prefs.getStringList('coeficientesSimple');
    if (simpleEntries != null) {
      final newCoeficientesSimple = <int, double>{};
      for (var entry in simpleEntries) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          newCoeficientesSimple[int.parse(parts[0])] = double.parse(parts[1]);
        }
      }
      return newCoeficientesSimple;
    }
    return SimuladorCuotas.coeficientesSimple; // Valores por defecto
  }

  Future<Map<String, List<double>>> _cargarCoeficientesEmisor() async {
    final prefs = await SharedPreferences.getInstance();
    final emisorEntries = prefs.getStringList('coeficientesEmisor');
    if (emisorEntries != null) {
      final newCoeficientesEmisor = <String, List<double>>{};
      for (var entry in emisorEntries) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          final valores = parts[1].split(',').map((v) => double.parse(v)).toList();
          newCoeficientesEmisor[parts[0]] = valores;
        }
      }
      return newCoeficientesEmisor;
    }
    return SimuladorCuotas.coeficientesEmisor; // Valores por defecto
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.indigo], // Fondo degradado
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Simulador de Cuotas',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // Navegar al simulador de cuotas
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimuladorCuotas(),
                    ),
                  );
                },
                icon: const Icon(Icons.calculate, size: 30),
                label: const Text(
                  'Simulador de Cuotas',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bordes redondeados
                  ),
                  shadowColor: Colors.black,
                  elevation: 10, // Sombra
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  // Cargar los coeficientes antes de navegar
                  final coeficientesSimple = await _cargarCoeficientesSimple();
                  final coeficientesEmisor = await _cargarCoeficientesEmisor();

                  // Navegar a la pantalla de edición de coeficientes
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarCoeficientes(
                        coeficientesSimple: coeficientesSimple,
                        coeficientesEmisor: coeficientesEmisor,
                        onCoeficientesUpdated: (newSimple, newEmisor) {
                          // Actualizar los coeficientes en SimuladorCuotas
                          SimuladorCuotas.of(context)?.actualizarCoeficientes(newSimple, newEmisor);
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, size: 30),
                label: const Text(
                  'Editar Coeficientes',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bordes redondeados
                  ),
                  shadowColor: Colors.black,
                  elevation: 10, // Sombra
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Simulador de cuotas
class SimuladorCuotas extends StatefulWidget {
  const SimuladorCuotas({super.key});

  // Coeficientes para cuotas simples (3, 6, 9, 12)
  static Map<int, double> coeficientesSimple = {
    3: 1.1000,
    6: 1.1425,
    9: 1.1955,
    12: 1.2673,
  };

  // Coeficientes para el plan emisor
  static Map<String, List<double>> coeficientesEmisor = {
    "Naranja": [
      1.1062, 1.1449, 1.1844, 1.2248, 1.266, 1.3229, 1.368, 1.4141, 1.461, 1.5088,
      1.5575, 1.6071, 1.6575, 1.7088, 1.7609, 1.8138, 1.8675, 1.9221, 1.9773, 2.0334,
      2.0902, 2.1477, 2.2059, 2.2648, 2.3244, 2.3847, 2.4456, 2.5071, 2.5692, 2.6319,
      2.6952, 2.759, 2.8234, 2.8883, 2.9536
    ],
    "Cencosud": [
      1.1197, 1.1634, 1.2082, 1.2541, 1.3011, 1.3491, 1.3982, 1.4483, 1.4995, 1.5517,
      1.6048, 1.659, 1.7141, 1.7702, 1.8273, 1.8853, 1.9441, 2.0039, 2.0645, 2.126,
      2.1883, 2.2515, 2.3154, 2.38, 2.4454, 2.5116, 2.5784, 2.6459, 2.7141, 2.7829,
      2.8523, 2.9223, 2.9928, 3.0639, 3.1356
    ]
  };

  static _SimuladorCuotasState? of(BuildContext context) {
    return context.findAncestorStateOfType<_SimuladorCuotasState>();
  }

  @override
  _SimuladorCuotasState createState() => _SimuladorCuotasState();
}

class _SimuladorCuotasState extends State<SimuladorCuotas> {
  String? _tipoCuotas;
  String? _tarjetaSeleccionada;
  int? _cuotasSeleccionadas;
  List<TextEditingController> _montoControllers = [TextEditingController()];
  String _resultado = '';

  @override
  void initState() {
    super.initState();
    _cargarCoeficientes();
  }

  void _cargarCoeficientes() async {
    final prefs = await SharedPreferences.getInstance();

    // Cargar coeficientes simples
    final simpleEntries = prefs.getStringList('coeficientesSimple');
    if (simpleEntries != null) {
      final newCoeficientesSimple = <int, double>{};
      for (var entry in simpleEntries) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          newCoeficientesSimple[int.parse(parts[0])] = double.parse(parts[1]);
        }
      }
      setState(() {
        SimuladorCuotas.coeficientesSimple = newCoeficientesSimple;
      });
    }

    // Cargar coeficientes del plan emisor
    final emisorEntries = prefs.getStringList('coeficientesEmisor');
    if (emisorEntries != null) {
      final newCoeficientesEmisor = <String, List<double>>{};
      for (var entry in emisorEntries) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          final valores = parts[1].split(',').map((v) => double.parse(v)).toList();
          newCoeficientesEmisor[parts[0]] = valores;
        }
      }
      setState(() {
        SimuladorCuotas.coeficientesEmisor = newCoeficientesEmisor;
      });
    }
  }

  void actualizarCoeficientes(Map<int, double> newSimple, Map<String, List<double>> newEmisor) async {
    final prefs = await SharedPreferences.getInstance();

    // Guardar coeficientes simples
    final simpleEntries = newSimple.entries.map((entry) => "${entry.key}:${entry.value}").toList();
    await prefs.setStringList('coeficientesSimple', simpleEntries);

    // Guardar coeficientes del plan emisor
    final emisorEntries = newEmisor.entries.map((entry) {
      final valores = entry.value.join(',');
      return "${entry.key}:$valores";
    }).toList();
    await prefs.setStringList('coeficientesEmisor', emisorEntries);

    setState(() {
      SimuladorCuotas.coeficientesSimple = newSimple;
      SimuladorCuotas.coeficientesEmisor = newEmisor;
    });
  }

  void _actualizarOpcionesCuotas(String? newValue) {
    setState(() {
      _tipoCuotas = newValue;
      _cuotasSeleccionadas = null;
      _actualizarOpcionesTarjetas();
    });
  }

  void _actualizarOpcionesTarjetas() {
    setState(() {
      _tarjetaSeleccionada = null;
      if (_tipoCuotas == 'simple') {
        _tarjetaSeleccionada = 'Visa';
      } else if (_tipoCuotas == 'emisor') {
        _tarjetaSeleccionada = 'Naranja';
      }
    });
  }

  void _agregarProducto() {
    setState(() {
      _montoControllers.add(TextEditingController());
    });
  }

  void _eliminarProducto(int index) {
    setState(() {
      if (_montoControllers.length > 1) {
        _montoControllers.removeAt(index);
      }
    });
  }

  void _calcularInteres() {
    if (_tipoCuotas == null) {
      setState(() {
        _resultado = "Por favor, selecciona un tipo de cuotas.";
      });
      return;
    }
    if (_tarjetaSeleccionada == null) {
      setState(() {
        _resultado = "Por favor, selecciona una tarjeta.";
      });
      return;
    }
    if (_cuotasSeleccionadas == null) {
      setState(() {
        _resultado = "Por favor, selecciona la cantidad de cuotas.";
      });
      return;
    }

    int montoTotal = 0;
    for (var controller in _montoControllers) {
      if (controller.text.isEmpty) {
        setState(() {
          _resultado = "Por favor, ingresa un monto válido para todos los productos.";
        });
        return;
      }
      montoTotal += int.parse(controller.text);
    }

    final int cuotas = _cuotasSeleccionadas!;
    final String tarjeta = _tarjetaSeleccionada!;

    double tasaInteres;
    if (_tipoCuotas == 'simple') {
      tasaInteres = SimuladorCuotas.coeficientesSimple[cuotas]!;
    } else {
      if (cuotas - 2 >= 0 && cuotas - 2 < SimuladorCuotas.coeficientesEmisor[tarjeta]!.length) {
        tasaInteres = SimuladorCuotas.coeficientesEmisor[tarjeta]![cuotas - 2];
      } else {
        setState(() {
          _resultado = "Número de cuota no válido para el plan emisor.";
        });
        return;
      }
    }

    final double interesTotal = montoTotal * (tasaInteres - 1);
    // final double montoTotalConInteres = montoTotal + interesTotal;
    final double porcentajeInteres = (interesTotal / montoTotal) * 100;
    // final int montoTotalRedondeado = _redondearMonto(montoTotalConInteres.toInt());

    // Calcular el interés y el monto total con interés para cada producto
    List<double> montosConInteres = [];
    List<double> interesesPorProducto = [];
    for (var controller in _montoControllers) {
      int monto = int.parse(controller.text);
      double interesProducto = monto * (tasaInteres - 1);
      double montoConInteres = monto + interesProducto;
      montosConInteres.add(montoConInteres);
      interesesPorProducto.add(interesProducto);
    }

    // Calcular el monto total redondeado (suma de los productos con intereses aplicados y redondeados)
    int montoTotalFinal = montosConInteres.map((monto) => _redondearMonto(monto.toInt())).reduce((a, b) => a + b);

    // Construir la cadena de resultado con el detalle de cada producto
    StringBuffer resultadoBuffer = StringBuffer();
    resultadoBuffer.writeln("Tarjeta seleccionada: $tarjeta");
    resultadoBuffer.writeln("Tipo de cuotas: ${_tipoCuotas!.toUpperCase()}");
    resultadoBuffer.writeln("Cantidad de cuotas: $cuotas");
    resultadoBuffer.writeln("Interés total: \$${interesTotal.toStringAsFixed(2)} - (${porcentajeInteres.toStringAsFixed(2)}%)");

    // Calcular el valor por cuota
    double valorPorCuota = montoTotalFinal / cuotas;
    resultadoBuffer.writeln("Por cuota: \$${valorPorCuota.toStringAsFixed(2)}");

    resultadoBuffer.writeln("\nSuma de productos: \$$montoTotal");
    for (int i = 0; i < _montoControllers.length; i++) {
      int montoRedondeado = _redondearMonto(montosConInteres[i].toInt());
      resultadoBuffer.writeln("Producto ${i + 1}: \$${montoRedondeado}");
    }

    resultadoBuffer.writeln("\nMonto total: \$$montoTotalFinal");

    setState(() {
      _resultado = resultadoBuffer.toString();
    });
  }

  int _redondearMonto(int montoTotal) {
    final int ultimaCifra = montoTotal % 100;
    if (ultimaCifra == 50) {
      return montoTotal;
    } else if (ultimaCifra > 50) {
      return ((montoTotal ~/ 100) + 1) * 100;
    } else {
      return (montoTotal ~/ 100) * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador de Cuotas'),
      ),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              const Text('Selecciona el tipo de cuotas:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Radio<String>(
                    value: 'simple',
                    groupValue: _tipoCuotas,
                    onChanged: _actualizarOpcionesCuotas,
                  ),
                  const Text('Cuota Simple'),
                  Radio<String>(
                    value: 'emisor',
                    groupValue: _tipoCuotas,
                    onChanged: _actualizarOpcionesCuotas,
                  ),
                  const Text('Plan Emisor'),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Selecciona una tarjeta:'),
              DropdownButton<String>(
                value: _tarjetaSeleccionada,
                onChanged: (String? newValue) {
                  setState(() {
                    _tarjetaSeleccionada = newValue!;
                  });
                },
                items: (_tipoCuotas == 'simple')
                    ? [
                        const DropdownMenuItem(
                          value: 'Visa',
                          child: Text('Visa'),
                        ),
                        const DropdownMenuItem(
                          value: 'Master',
                          child: Text('Master'),
                        ),
                        const DropdownMenuItem(
                          value: 'Cabal',
                          child: Text('Cabal'),
                        ),
                      ]
                    : (_tipoCuotas == 'emisor')
                        ? [
                            const DropdownMenuItem(
                              value: 'Naranja',
                              child: Text('Naranja'),
                            ),
                            const DropdownMenuItem(
                              value: 'Cencosud',
                              child: Text('Cencosud'),
                            ),
                          ]
                        : null,
              ),
              const SizedBox(height: 20),
              const Text('Selecciona la cantidad de cuotas:'),
              DropdownButton<int>(
                value: _cuotasSeleccionadas,
                onChanged: (int? newValue) {
                  setState(() {
                    _cuotasSeleccionadas = newValue!;
                  });
                },
                items: (_tipoCuotas == 'simple')
                    ? [
                        const DropdownMenuItem(
                          value: 3,
                          child: Text('3 cuotas'),
                        ),
                        const DropdownMenuItem(
                          value: 6,
                          child: Text('6 cuotas'),
                        ),
                        const DropdownMenuItem(
                          value: 9,
                          child: Text('9 cuotas'),
                        ),
                        const DropdownMenuItem(
                          value: 12,
                          child: Text('12 cuotas'),
                        ),
                      ]
                    : (_tipoCuotas == 'emisor')
                        ? List.generate(35, (index) => index + 2)
                            .map((cuota) => DropdownMenuItem(
                                  value: cuota,
                                  child: Text('$cuota cuotas'),
                                ))
                            .toList()
                        : null,
              ),
              const SizedBox(height: 20),
              const Text('Ingresa el monto de los productos:'),
              ..._montoControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Ejemplo: 1000'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _eliminarProducto(index),
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: _agregarProducto,
                child: const Text('Agregar producto'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularInteres,
                child: const Text('Calcular Interés'),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(_resultado),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla para editar coeficientes
class EditarCoeficientes extends StatefulWidget {
  final Map<int, double> coeficientesSimple;
  final Map<String, List<double>> coeficientesEmisor;
  final Function(Map<int, double>, Map<String, List<double>>) onCoeficientesUpdated;

  const EditarCoeficientes({
    super.key,
    required this.coeficientesSimple,
    required this.coeficientesEmisor,
    required this.onCoeficientesUpdated,
  });

  @override
  _EditarCoeficientesState createState() => _EditarCoeficientesState();
}

class _EditarCoeficientesState extends State<EditarCoeficientes> {
  // Controladores para los coeficientes de cuotas simples
  late Map<int, TextEditingController> _simpleControllers;

  // Controladores para los coeficientes del plan emisor
  late Map<String, List<TextEditingController>> _emisorControllers;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores actuales
    _simpleControllers = {};
    for (var entry in widget.coeficientesSimple.entries) {
      _simpleControllers[entry.key] = TextEditingController(text: entry.value.toString());
    }

    _emisorControllers = {};
    for (var entry in widget.coeficientesEmisor.entries) {
      _emisorControllers[entry.key] = entry.value
          .map((value) => TextEditingController(text: value.toString()))
          .toList();
    }
  }

  void _guardarCoeficientes() async {
    // Guardar coeficientes de cuotas simples
    final newCoeficientesSimple = <int, double>{};
    for (var entry in _simpleControllers.entries) {
      newCoeficientesSimple[entry.key] = double.parse(entry.value.text);
    }

    // Guardar coeficientes del plan emisor
    final newCoeficientesEmisor = <String, List<double>>{};
    for (var entry in _emisorControllers.entries) {
      newCoeficientesEmisor[entry.key] =
          entry.value.map((controller) => double.parse(controller.text)).toList();
    }

    // Notificar la actualización de coeficientes
    widget.onCoeficientesUpdated(newCoeficientesSimple, newCoeficientesEmisor);

    // Guardar en SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Guardar coeficientes simples
    final simpleEntries = newCoeficientesSimple.entries.map((entry) => "${entry.key}:${entry.value}").toList();
    await prefs.setStringList('coeficientesSimple', simpleEntries);

    // Guardar coeficientes del plan emisor
    final emisorEntries = newCoeficientesEmisor.entries.map((entry) {
      final valores = entry.value.join(',');
      return "${entry.key}:$valores";
    }).toList();
    await prefs.setStringList('coeficientesEmisor', emisorEntries);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coeficientes actualizados correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Coeficientes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Coeficientes de Cuotas Simples',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._simpleControllers.entries.map((entry) {
              return TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: '${entry.key} cuotas',
                ),
                keyboardType: TextInputType.number,
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              'Coeficientes del Plan Emisor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._emisorControllers.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...entry.value.asMap().entries.map((controllerEntry) {
                    return TextField(
                      controller: controllerEntry.value,
                      decoration: InputDecoration(
                        labelText: 'Cuota ${controllerEntry.key + 2}',
                      ),
                      keyboardType: TextInputType.number,
                    );
                  }).toList(),
                ],
              );
            }).toList(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _guardarCoeficientes,
                child: const Text('Guardar Cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}