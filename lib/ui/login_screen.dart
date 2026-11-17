import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../api/api.dart';
import '../app/session.dart';

/// Server to use by default: `flutter run --dart-define=API_URL=https://…`.
const defaultServer = String.fromEnvironment('API_URL');

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _server = TextEditingController(text: defaultServer);
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();

  Map<String, String> _errors = const {};
  String? _message;
  bool _askCode = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _restoreServer();
  }

  Future<void> _restoreServer() async {
    final saved = await ref.read(storeProvider).read('base_url');
    if (saved != null && mounted && _server.text.isEmpty) {
      _server.text = saved;
    }
  }

  @override
  void dispose() {
    _server.dispose();
    _email.dispose();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final server = _server.text.trim();
    if (!server.startsWith('http://') && !server.startsWith('https://')) {
      setState(() => _errors = {'server': 'Escribe la dirección completa, con https://'});
      return;
    }

    setState(() {
      _busy = true;
      _errors = const {};
      _message = null;
    });

    try {
      await ref
          .read(sessionProvider.notifier)
          .login(
            baseUrl: server,
            email: _email.text,
            password: _password.text,
            code: _askCode ? _code.text.trim() : null,
          );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errors = error.fields;
        // The account has two-step verification: show the code field.
        _askCode = _askCode || error.fields.containsKey('code');
        _message = error.fields.isEmpty ? error.message : null;
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Weaver', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    const Text('Entra con la cuenta que te dio tu organización.'),
                    const SizedBox(height: 24),
                    TextField(
                      key: const Key('server'),
                      controller: _server,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Servidor',
                        hintText: 'https://encuestas.ejemplo.co',
                        errorText: _errors['server'],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const Key('email'),
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.username],
                      decoration: InputDecoration(labelText: 'Correo', errorText: _errors['email']),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const Key('password'),
                      controller: _password,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(labelText: 'Contraseña', errorText: _errors['password']),
                      onSubmitted: (_) => _submit(),
                    ),
                    if (_askCode) ...[
                      const SizedBox(height: 12),
                      TextField(
                        key: const Key('code'),
                        controller: _code,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Código de verificación',
                          helperText: 'El de tu app de autenticación, o un código de recuperación.',
                          errorText: _errors['code'],
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                    ],
                    if (_message != null) ...[
                      const SizedBox(height: 12),
                      Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('login'),
                      onPressed: _busy ? null : _submit,
                      child: Text(_busy ? 'Entrando…' : 'Entrar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
