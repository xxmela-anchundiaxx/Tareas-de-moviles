# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas y acción para crear.
Detalle: información completa y futuras acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos
GET /tasks        listar tareas
GET /tasks/:id    consultar detalle
POST /tasks       crear tarea
PATCH /tasks/:id  actualizar tarea
DELETE /tasks/:id eliminar tarea

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.
## API de tareas

- **URL base y endpoint:** `https://jsonplaceholder.typicode.com/todos`
- **Filtro aplicado:** `userId=2` (consulta completa: `GET https://jsonplaceholder.typicode.com/todos?userId=2`).
- **Campos recibidos desde la API:** `id` (entero), `userId` (entero), `title` (texto) y `completed` (booleano, mapeado a `isCompleted` en el modelo).
- **Valores completados por defecto en TaskFlow:** Como el endpoint `/todos` de JSONPlaceholder no incluye descripción ni prioridad, `Task.fromJson()` asigna los valores por defecto `'Sin descripción (API)'` y `'Sin prioridad (API)'`.
- **Persistencia temporal:** Marcar o desmarcar una tarea como completada actualiza únicamente la copia en memoria dentro de `RemoteTaskRepository`. Al reiniciar la aplicación o volver a consultar la API, los estados regresan a su valor original del servidor.
## Evidencia de Estados Asíncronos (MVVM + Provider)

La aplicación gestiona los cuatro estados de red mediante `ChangeNotifier`, `context.watch` y `context.read`, diferenciando explícitamente los fallos de conexión de las respuestas válidas sin datos:

1. **Estado de Carga (`loading`):** Se muestra un `CircularProgressIndicator` mientras `Dio` resuelve la petición HTTP. Para verificarlo visualmente sin alterar el código fuente, se limitó la velocidad de red del emulador Android a **EDGE/GSM** desde *Extended Controls > Cellular*.
2. **Estado de Éxito (`success`):** Con conexión activa (`userId = 1`), se renderiza la lista remota de tareas. Al seleccionar un elemento, `GoRouter` navega a la pantalla de detalle mostrando el `id` y `title` correspondientes al ítem tocado.
3. **Estado de Error y Reintento (`error`):** Se provocó activando el **Modo Avión** (desactivando Wi-Fi y datos móviles) en el emulador y pulsando **Actualizar** en la barra superior. La vista muestra el mensaje de fallo de red y habilita exclusivamente el botón **Reintentar**. Al restablecer la conexión y pulsar **Reintentar**, la lista se recupera sin reiniciar la aplicación.
4. **Estado Vacío (`empty`):** Se provocó cambiando temporalmente la constante `userId` a `9999` en `TaskApiService` y ejecutando un *Hot Restart*. Como el servidor devuelve `200 OK` con un arreglo vacío `[]`, la interfaz muestra el mensaje **"Todavía no hay tareas"** y el botón **Actualizar** (sin mostrar el botón *Reintentar*, reservado únicamente para errores). Finalmente, se restauró `userId = 1`.

## Avance Incremental: Formulario de Creación de Tareas (`/new`)

Se implementó la pantalla `TaskFormScreen` junto con su ruta en `GoRouter` y el botón de acceso rápido desde `TaskListScreen` para gestionar la creación de tareas con validación de datos.

### Características implementadas
* **Enrutamiento (`GoRouter`):** Se registró la ruta estática `/new` en `appRouter` y se conectó mediante `context.push<TaskDraft>('/new')` desde un `FloatingActionButton.extended` en la pantalla principal.
* **Controladores y ciclo de vida:** Uso de `TextEditingController` para los campos de título y descripción, liberando memoria correctamente en el método `dispose()`.
* **Validación personalizada (`Form`):** Validaciones en tiempo real (`AutovalidateMode.onUserInteraction`) con mensajes específicos:
  * **Título:** Obligatorio y mínimo 4 caracteres.
  * **Descripción:** Obligatoria y mínimo 10 caracteres.
* **Selector de prioridad:** Implementación de `DropdownButtonFormField<String>` con opciones predefinidas (`Alta`, `Media`, `Baja`).
* **Fecha límite opcional (`showDatePicker`):** Selector de fecha integrado que permite asignar o limpiar una fecha límite sin bloquear el guardado si se deja vacía.
* **Retorno de datos:** Al validar el formulario, se construye un objeto `TaskDraft` y se devuelve a `TaskListScreen` mediante `context.pop(draft)`, mostrando un `SnackBar` de confirmación.

### Evidencias de pruebas realizadas
1. **Validación de errores:** Intento de envío con campos vacíos o incompletos mostrando los mensajes de error personalizados en rojo.
2. **Formulario válido:** Llenado correcto de título, descripción, selección de prioridad y elección de fecha opcional mediante el calendario (`showDatePicker`).
3. **Mensaje de retorno:** Redirección automática a `Mis tareas` con visualización del `SnackBar` confirmando el título de la tarea creada.