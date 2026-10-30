
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

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const studentName = 'Melanie Anchundia';
    const pendingTasks = 5;
    const courseName = 'Desarrollo de aplicaciones móviles';

    // Mensaje motivacional
    const motivationalMessage =
        '¡Organiza tus tareas y alcanza tus metas!';

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono de la aplicación
            const Icon(
              Icons.task_alt,
              size: 56,
              color: Colors.indigo,
            ),

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

            const SizedBox(height: 32),

            // Tarjeta de tareas pendientes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.pending_actions),
                    const SizedBox(width: 12),
                    Text('Tareas pendientes: $pendingTasks'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
