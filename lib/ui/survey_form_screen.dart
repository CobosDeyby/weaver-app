import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:uuid/uuid.dart';

import '../app/location.dart';
import '../app/session.dart';
import '../data/database.dart';
import '../survey/definition.dart';
import '../survey/form_logic.dart';
import '../survey/rules.dart';
import '../sync/sync_controller.dart';

/// Fill one survey. The response is written to the phone first; sending it
/// is the sync's job, so saving never depends on the network.
class SurveyFormScreen extends ConsumerStatefulWidget {
  const SurveyFormScreen({super.key, required this.survey});

  final Survey survey;

  @override
  ConsumerState<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends ConsumerState<SurveyFormScreen> {
  late final SurveyDefinition _definition = SurveyDefinition.fromJson(widget.survey.definition);
  final DateTime _startedAt = DateTime.now();
  final Answers _answers = {};
  final _fieldKeys = <String, GlobalKey>{};

  CatalogOptions _catalogs = const {};
  Map<String, String> _errors = const {};
  Fix? _fix;
  bool _locating = false;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCatalogs();
    _locate();
  }

  Future<void> _loadCatalogs() async {
    final db = ref.read(databaseProvider);
    final catalogs = <int, List<Option>>{};

    for (final id in _definition.catalogIds) {
      catalogs[id] = [
        for (final item in await db.itemsOf(id)) Option(item.value, item.label, parent: item.parent),
      ];
    }

    if (mounted) {
      setState(() {
        _catalogs = catalogs;
        _loading = false;
      });
    }
  }

  Future<void> _locate() async {
    setState(() => _locating = true);
    final fix = await ref.read(locationProvider).current();

    if (mounted) {
      setState(() {
        _fix = fix ?? _fix;
        _locating = false;
      });
    }
  }

  void _set(String key, Object? value) {
    setState(() {
      if (isEmptyAnswer(value)) {
        _answers.remove(key);
      } else {
        _answers[key] = value;
      }

      clearDependents(_definition, _answers, key);
      _errors = {..._errors}..remove(key);
    });
  }

  Future<void> _save() async {
    final errors = validate(_definition, _answers);

    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errors.length == 1
                ? 'Falta corregir 1 respuesta.'
                : 'Falta corregir ${errors.length} respuestas.',
          ),
        ),
      );

      final first = _fieldKeys[errors.keys.first]?.currentContext;
      if (first != null) {
        unawaited(
          Scrollable.ensureVisible(first, duration: const Duration(milliseconds: 300), alignment: 0.1),
        );
      }
      return;
    }

    final session = ref.read(sessionProvider);
    if (session == null) {
      return;
    }

    setState(() => _saving = true);

    await ref
        .read(databaseProvider)
        .into(ref.read(databaseProvider).responses)
        .insert(
          ResponsesCompanion.insert(
            id: const Uuid().v4(),
            userId: session.userId,
            surveyId: widget.survey.id,
            surveyTitle: widget.survey.title,
            version: widget.survey.version,
            answers: jsonEncode(answersToStore(_definition, _answers)),
            startedAt: _startedAt,
            finishedAt: DateTime.now(),
            latitude: Value(_fix?.latitude),
            longitude: Value(_fix?.longitude),
            accuracy: Value(_fix?.accuracy),
          ),
        );

    unawaited(ref.read(syncProvider.notifier).sync());

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Respuesta guardada en el teléfono.')));
      Navigator.pop(context);
    }
  }

  Future<bool> _confirmDiscard() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Salir sin guardar?'),
        content: const Text('Se pierde lo que llevas respondido en esta encuesta.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Seguir respondiendo'),
          ),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Salir')),
        ],
      ),
    );

    return discard == true;
  }

  @override
  Widget build(BuildContext context) {
    final visible = _definition.visible(_answers);
    final theme = Theme.of(context);

    return PopScope(
      canPop: _answers.isEmpty || _saving,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && await _confirmDiscard() && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.survey.title)),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  for (final section in _definition.sections)
                    if (section.questions.any((question) => visible.contains(question.key))) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 4),
                        child: Text(section.title, style: theme.textTheme.titleLarge),
                      ),
                      for (final question in section.questions)
                        if (visible.contains(question.key))
                          Padding(
                            key: _fieldKeys.putIfAbsent(question.key, GlobalKey.new),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _QuestionField(
                              question: question,
                              value: _answers[question.key],
                              options: question.isChoice
                                  ? optionsFor(question, _catalogs, _answers)
                                  : const [],
                              error: _errors[question.key],
                              onChanged: (value) => _set(question.key, value),
                            ),
                          ),
                    ],
                ],
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_definition.requireLocation)
                  Row(
                    children: [
                      Icon(
                        _fix == null ? Icons.location_off : Icons.location_on,
                        size: 18,
                        color: _fix == null ? theme.colorScheme.error : Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _locating
                              ? 'Buscando ubicación…'
                              : _fix == null
                              ? 'Sin ubicación. Puedes guardar, pero quedará marcada para revisión.'
                              : 'Ubicación obtenida (±${_fix!.accuracy.round()} m)',
                          key: const Key('location-status'),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      if (!_locating && _fix == null)
                        TextButton(onPressed: _locate, child: const Text('Reintentar')),
                    ],
                  ),
                const SizedBox(height: 4),
                FilledButton(
                  key: const Key('save'),
                  onPressed: _saving || _loading ? null : _save,
                  child: const Text('Guardar respuesta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionField extends StatelessWidget {
  const _QuestionField({
    required this.question,
    required this.value,
    required this.options,
    required this.error,
    required this.onChanged,
  });

  final Question question;
  final Object? value;
  final List<Option> options;
  final String? error;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (question.type == 'header') {
      return Text(question.label, style: theme.textTheme.titleMedium);
    }
    if (question.type == 'note') {
      return Text(question.label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: question.label,
            children: [
              if (question.required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
            ],
          ),
          style: theme.textTheme.titleSmall,
        ),
        if (question.help != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(question.help!, style: theme.textTheme.bodySmall),
          ),
        const SizedBox(height: 6),
        _input(context),
        if (error != null && _showsOwnError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(error!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
          ),
      ],
    );
  }

  /// Text fields show the error inside their decoration; the rest below.
  bool get _showsOwnError => question.isChoice || question.type == 'date' || question.type == 'time';

  Widget _input(BuildContext context) {
    switch (question.type) {
      case 'single_choice':
        return question.catalogId != null ? _listPicker(context) : _radios();
      case 'multiple_choice':
        return _checkboxes();
      case 'date':
        return _dateButton(context);
      case 'time':
        return _timeButton(context);
      default:
        return _textField();
    }
  }

  Widget _radios() {
    return RadioGroup<String>(
      groupValue: value is String ? value as String : null,
      onChanged: onChanged,
      child: Column(
        children: [
          for (final option in options)
            RadioListTile<String>(
              value: option.value,
              title: Text(option.label),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
        ],
      ),
    );
  }

  Widget _checkboxes() {
    final selected = value is List ? [...value as List] : <Object?>[];

    if (options.isEmpty) {
      return const Text('Sin opciones disponibles.');
    }

    return Column(
      children: [
        for (final option in options)
          CheckboxListTile(
            value: selected.contains(option.value),
            title: Text(option.label),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            onChanged: (checked) => onChanged(
              checked == true
                  ? [...selected, option.value]
                  : selected.where((item) => item != option.value).toList(),
            ),
          ),
      ],
    );
  }

  /// Long lists (municipalities…) open in a searchable sheet.
  Widget _listPicker(BuildContext context) {
    final current = options.where((option) => option.value == value).firstOrNull;
    final waitsForParent = options.isEmpty && question.filterBy != null;

    return OutlinedButton(
      key: Key('pick-${question.key}'),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        minimumSize: const Size.fromHeight(48),
      ),
      onPressed: options.isEmpty
          ? null
          : () async {
              final picked = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => _OptionSheet(title: question.label, options: options),
              );
              if (picked != null) {
                onChanged(picked);
              }
            },
      child: Text(
        current?.label ??
            (waitsForParent
                ? 'Responde primero la pregunta anterior'
                : options.isEmpty
                ? 'Sin opciones disponibles'
                : 'Elegir'),
      ),
    );
  }

  Widget _dateButton(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.calendar_today, size: 18),
      label: Text(value is String ? value as String : 'Elegir fecha'),
      onPressed: () async {
        final initial = DateTime.tryParse('$value') ?? DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onChanged(picked.toIso8601String().substring(0, 10));
        }
      },
    );
  }

  Widget _timeButton(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.schedule, size: 18),
      label: Text(value is String ? value as String : 'Elegir hora'),
      onPressed: () async {
        final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        if (picked != null) {
          onChanged('${'${picked.hour}'.padLeft(2, '0')}:${'${picked.minute}'.padLeft(2, '0')}');
        }
      },
    );
  }

  Widget _textField() {
    final integer = question.type == 'integer';

    return TextFormField(
      key: Key('field-${question.key}'),
      initialValue: value == null ? '' : '$value',
      maxLines: question.type == 'long_text' ? 4 : 1,
      keyboardType: switch (question.type) {
        'integer' => const TextInputType.numberWithOptions(signed: true),
        'decimal' => const TextInputType.numberWithOptions(signed: true, decimal: true),
        'email' => TextInputType.emailAddress,
        'phone' => TextInputType.phone,
        'long_text' => TextInputType.multiline,
        _ => TextInputType.text,
      },
      inputFormatters: [
        if (integer) FilteringTextInputFormatter.allow(RegExp(r'[-\d]')),
        if (question.type == 'decimal') FilteringTextInputFormatter.allow(RegExp(r'[-\d.,]')),
      ],
      decoration: InputDecoration(border: const OutlineInputBorder(), errorText: error),
      onChanged: (text) {
        if (!question.isNumber) {
          onChanged(text);
          return;
        }

        // Keep what was typed when it is not a number yet, so validation can say so.
        final number = num.tryParse(text.replaceAll(',', '.'));
        onChanged(text.isEmpty ? null : number ?? text);
      },
    );
  }
}

class _OptionSheet extends StatefulWidget {
  const _OptionSheet({required this.title, required this.options});

  final String title;
  final List<Option> options;

  @override
  State<_OptionSheet> createState() => _OptionSheetState();
}

class _OptionSheetState extends State<_OptionSheet> {
  String _term = '';

  /// Lowercase and without accents, so "bogota" finds "Bogotá".
  static String _fold(String text) {
    const from = 'áéíóúüñ';
    const to = 'aeiouun';
    var folded = text.toLowerCase();

    for (var i = 0; i < from.length; i++) {
      folded = folded.replaceAll(from[i], to[i]);
    }

    return folded;
  }

  @override
  Widget build(BuildContext context) {
    final term = _fold(_term.trim());
    final matches = term.isEmpty
        ? widget.options
        : widget.options.where((option) => _fold(option.label).contains(term)).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              key: const Key('option-search'),
              autofocus: widget.options.length > 12,
              decoration: InputDecoration(
                labelText: widget.title,
                hintText: 'Buscar',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (text) => setState(() => _term = text),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(matches[index].label),
                onTap: () => Navigator.pop(context, matches[index].value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
