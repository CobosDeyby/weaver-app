# Weaver App

App móvil (Flutter) para encuestadores de [Weaver](https://github.com/CobosDeyby/weaver): descarga las encuestas asignadas, las aplica sin conexión y envía las respuestas cuando hay señal.

## Qué hace

- **Entrar** con el servidor, correo y contraseña de la organización. Soporta verificación en dos pasos.
- **Encuestas asignadas**: se descargan al abrir la app y solo se vuelven a bajar las que cambiaron.
- **Formulario**: 12 tipos de pregunta, preguntas condicionales, obligatorias, mínimos y máximos, y listas dependientes (departamento → municipio) con buscador.
- **Sin conexión**: cada respuesta se guarda primero en el teléfono (SQLite). El envío es aparte, por lotes de 50, y reintentar nunca duplica.
- **Ubicación**: toma el GPS al abrir el formulario. Si no hay señal de GPS se puede guardar igual; el servidor la marca para revisión.
- **Mis respuestas**: por enviar, enviadas y rechazadas, con el motivo del rechazo.

La app sincroniza al abrirse, al volver al frente, al guardar una respuesta, cada 5 minutos mientras está abierta y con el botón "Sincronizar". Todavía no sincroniza con la app cerrada.

## Desarrollo

Requisitos: Flutter 3.50 (Dart 3.14) y, para correrla, Android Studio o Xcode.

```bash
flutter pub get
flutter run --dart-define=API_URL=http://192.168.1.10:8000
```

`API_URL` solo rellena el campo "Servidor" de la pantalla de entrada; se puede cambiar ahí. En un emulador de Android, el `localhost` de tu computador es `http://10.0.2.2:8000`. Las compilaciones de depuración aceptan `http`; las de publicación exigen `https`.

Para probar contra el backend local: `php artisan migrate:fresh --seed` y entra con `encuestador1@example.com` / `password`.

```bash
flutter analyze
flutter test
dart format lib test
dart run build_runner build   # después de cambiar lib/data/database.dart
```

## Estructura

| Carpeta | Contenido |
| --- | --- |
| `lib/survey` | Definición de la encuesta, evaluador de reglas y lógica del formulario. Sin Flutter ni base de datos. |
| `lib/data` | Base local (Drift): encuestas, listas y respuestas. |
| `lib/api` | Cliente de la API v2 del backend. |
| `lib/sync` | Subida de respuestas y descarga de encuestas y listas. |
| `lib/app` | Sesión, almacenamiento seguro del token y ubicación. |
| `lib/ui` | Pantallas. |

`test/fixtures/survey-rules.json` es una copia de `tests/fixtures/survey-rules.json` del backend: el contrato que deben pasar los tres evaluadores de reglas (PHP, TypeScript y Dart). Si cambia allá, se copia aquí.
