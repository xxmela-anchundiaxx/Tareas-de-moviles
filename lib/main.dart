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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
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

  // Nombre de la asignatura
  final String courseName = 'Desarrollo de aplicaciones móviles';

  // Mensaje motivacional
  final String motivationalMessage =
      '¡Organiza tus tareas y alcanza tus metas!';

  // Variables de las tareas
  int pendingTasks = 3;
  int completedTasks = 0;
  int dailyGoal = 5;

  // Función para agregar una tarea
  void _addTask() {
    setState(() {
      pendingTasks++;
    });
  }

  // Función para completar una tarea
  void _completeTask() {
    if (pendingTasks == 0) {
      return;
    }

    setState(() {
      pendingTasks--;

      if (completedTasks < dailyGoal) {
        completedTasks++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mensaje según las tareas pendientes
    final statusMessage = pendingTasks == 0
        ? '¡Excelente! No tienes tareas pendientes.'
        : 'Aún tienes tareas por organizar.';

    // Progreso de la meta diaria
    final double progress = completedTasks / dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono de la aplicación
            const Icon(Icons.task_alt, size: 56, color: Colors.indigo),

            const SizedBox(height: 24),

            // Saludo
            Text(
              '¡Hola, $studentName!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 12),

            // Nombre de la asignatura
            Text('Bienvenido/a a $courseName.'),

            const SizedBox(height: 12),

            // Mensaje motivacional
            Text(
              motivationalMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.indigo,
              ),
            ),

            const SizedBox(height: 24),

            // Mensaje de estado
            Text(statusMessage, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 24),

            // Tarjeta de tareas pendientes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.pending_actions, color: Colors.indigo),

                    const SizedBox(width: 12),

                    Text('Tareas pendientes: $pendingTasks'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tarjeta de tareas completadas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),

                    const SizedBox(width: 12),

                    Text('Tareas completadas: $completedTasks'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Título de la meta diaria
            Text(
              'Mi meta diaria',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            // Cantidad de tareas completadas
            Text('$completedTasks de $dailyGoal tareas completadas'),

            const SizedBox(height: 12),

            // Barra de progreso
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(10),
              color: Colors.indigo,
              backgroundColor: Colors.indigo.shade100,
            ),

            const SizedBox(height: 12),

            // Porcentaje de progreso
            Text(
              'Progreso: ${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),

            const SizedBox(height: 28),

            // Botones de tareas
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Botón agregar tarea
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar tarea'),
                ),

                // Botón completar tarea
                OutlinedButton.icon(
                  onPressed: pendingTasks == 0 ? null : _completeTask,
                  icon: const Icon(Icons.done),
                  label: const Text('Completar una tarea'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Mensaje al alcanzar la meta
            if (completedTasks >= dailyGoal)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '¡Felicidades! Has alcanzado tu meta diaria.',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
