import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskDraft {
  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;

  const TaskDraft({
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
  });
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Estado para el selector y la fecha opcional
  String _selectedPriority = 'Media';
  DateTime? _selectedDate;

  final List<String> _priorities = ['Alta', 'Media', 'Baja'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
      helpText: 'Selecciona fecha límite (opcional)',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    // Dispara las validaciones de todos los TextFormField
    if (!_formKey.currentState!.validate()) return;

    final draft = TaskDraft(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      dueDate: _selectedDate,
    );

    // Devuelve el TaskDraft a TaskListScreen para activar el SnackBar
    context.pop(draft);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Campo Título con controlador y mensajes personalizados
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Título de la tarea *',
                  hintText: 'Ej. Completar informe de auditoría',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Por favor, escribe un título para la tarea.';
                  }
                  if (text.length < 4) {
                    return 'El título debe tener al menos 4 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Campo Descripción con controlador y validación
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción *',
                  hintText: 'Detalla qué se debe realizar...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'La descripción no puede quedar vacía.';
                  }
                  if (text.length < 10) {
                    return 'Describe la tarea con al menos 10 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Selector de Prioridad (DropdownButtonFormField)
              DropdownButtonFormField<String>(
                initialValue: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Prioridad',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: _priorities.map((priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedPriority = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 4. Selector de Fecha Opcional con showDatePicker
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    _selectedDate == null
                        ? 'Fecha límite (opcional)'
                        : 'Fecha límite: ${_formatDate(_selectedDate!)}',
                  ),
                  subtitle: Text(
                    _selectedDate == null
                        ? 'Sin fecha asignada'
                        : 'Toca para cambiar la fecha',
                  ),
                  trailing: _selectedDate != null
                      ? IconButton(
                          tooltip: 'Quitar fecha',
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _selectedDate = null),
                        )
                      : TextButton(
                          onPressed: _pickDate,
                          child: const Text('Elegir'),
                        ),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(height: 24),

              // 5. Botón Guardar
              FilledButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Guardar tarea'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
