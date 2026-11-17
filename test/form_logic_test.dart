import 'package:flutter_test/flutter_test.dart';
import 'package:weaver_app/survey/definition.dart';
import 'package:weaver_app/survey/form_logic.dart';

import 'support.dart';

void main() {
  final definition = SurveyDefinition(sampleDefinition);
  final catalogs = <int, List<Option>>{
    1: const [Option('ant', 'Antioquia'), Option('cun', 'Cundinamarca')],
    2: const [
      Option('med', 'Medellín', parent: 'ant'),
      Option('bog', 'Bogotá', parent: 'cun'),
      Option('chi', 'Chía', parent: 'cun'),
    ],
  };
  Question question(String key) => definition.questions.firstWhere((q) => q.key == key);

  test('a required question blocks saving only while it is visible', () {
    expect(validate(definition, {}).keys, ['tiene_ninos']);
    expect(validate(definition, {'tiene_ninos': 'no'}), isEmpty);
    expect(validate(definition, {'tiene_ninos': 'si'}).keys, ['num_ninos']);
    expect(validate(definition, {'tiene_ninos': 'si', 'num_ninos': 2}), isEmpty);
  });

  test('numbers are checked against their type and bounds', () {
    String? error(Object? value) =>
        validate(definition, {'tiene_ninos': 'si', 'num_ninos': value})['num_ninos'];

    expect(error(0), 'El mínimo es 1.');
    expect(error(21), 'El máximo es 20.');
    expect(error(2.5), 'Escribe un número entero.');
    expect(error('dos'), 'Escribe un número.');
    expect(error(20), isNull);
  });

  test('emails are checked only when given', () {
    expect(validate(definition, {'tiene_ninos': 'no', 'correo': 'ana@'})['correo'], isNotNull);
    expect(validate(definition, {'tiene_ninos': 'no', 'correo': 'ana@example.com'}), isEmpty);
  });

  test('answers of hidden questions and blanks are not stored', () {
    expect(answersToStore(definition, {'tiene_ninos': 'no', 'num_ninos': 3, 'correo': ''}), {
      'tiene_ninos': 'no',
    });
  });

  test('a dependent list offers only the items of the chosen parent', () {
    expect(optionsFor(question('depto'), catalogs, {}).map((o) => o.value), ['ant', 'cun']);
    expect(optionsFor(question('muni'), catalogs, {}), isEmpty);
    expect(optionsFor(question('muni'), catalogs, {'depto': 'cun'}).map((o) => o.label), ['Bogotá', 'Chía']);
    expect(optionsFor(question('tiene_ninos'), catalogs, {}).map((o) => o.label), ['Sí', 'No']);
  });

  test('changing the parent clears the dependent answer', () {
    final answers = <String, dynamic>{'depto': 'ant', 'muni': 'med', 'tiene_ninos': 'no'};

    clearDependents(definition, answers, 'depto');

    expect(answers, {'depto': 'ant', 'tiene_ninos': 'no'});
  });
}
