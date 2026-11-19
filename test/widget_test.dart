
import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// Pantalla principal con estado
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  // Nombre del estudiante
  final String studentName = 'Melanie Anchundia';

  // Cantidad inicial de tareas pendientes
  int pendingTasks = 3;

  // Función para completar una tarea
  void _completeTask() {
    if (pendingTasks == 0) {
      return;
    }

    setState(() {
      pendingTasks--;
    });
  }

  // Función para agregar una tarea
  void _addTask() {
    setState(() {
      pendingTasks++;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Mensaje según la cantidad de tareas
    final statusMessage = pendingTasks == 0
        ? '¡Excelente! No tienes tareas pendientes.'
        : 'Aún tienes tareas por organizar.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Saludo al estudiante
            Text(
              '¡Hola, $studentName!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 12),

            // Mensaje de estado
            Text(
              statusMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.indigo,
              ),
            ),

            const SizedBox(height: 28),

            // Tarjeta de tareas pendientes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.pending_actions,
                      color: Colors.indigo,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      'Tareas pendientes: $pendingTasks',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botones para administrar tareas
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [

                // Botón para agregar tarea
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar tarea'),
                ),

                // Botón para completar tarea
                OutlinedButton.icon(
                  onPressed: pendingTasks == 0
                      ? null
                      : _completeTask,
                  icon: const Icon(Icons.done),
                  label: const Text('Completar una tarea'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
