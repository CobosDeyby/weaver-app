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

  group('answers carried to the next survey', () {
    test('only visible answers the survey asked to remember are repeated', () {
      final answers = {
        'tiene_ninos': 'si',
        'num_ninos': 2,
        'depto': 'ant',
        'muni': 'med',
        'correo': 'a@b.co',
      };

      expect(rememberedAnswers(definition, answers), {'depto': 'ant', 'muni': 'med'});
      expect(rememberedAnswers(definition, {'depto': ''}), isEmpty);
      expect(rememberedAnswers(definition, {}), isEmpty);
    });

    test('a repeated answer the list no longer offers is dropped, with what depends on it', () {
      expect(usableAnswers(definition, catalogs, {'depto': 'ant', 'muni': 'med'}), {
        'depto': 'ant',
        'muni': 'med',
      });
      expect(usableAnswers(definition, catalogs, {'depto': 'ant', 'muni': 'bog'}), {'depto': 'ant'});
      expect(usableAnswers(definition, catalogs, {'depto': 'zzz', 'muni': 'med'}), isEmpty);
      expect(usableAnswers(definition, catalogs, {'muni': 'med'}), isEmpty);
    });
  });

  group('signature', () {
    final withRequiredSignature = SurveyDefinition({
      'sections': [
        {
          'questions': [
            {'key': 'autoriza', 'type': 'single_choice', 'label': '¿Autoriza?', 'options': <Object>[]},
            {
              'key': 'firma',
              'type': 'signature',
              'label': 'Firma',
              'required': true,
              'visibleIf': {'q': 'autoriza', 'op': 'eq', 'value': 'si'},
            },
          ],
        },
      ],
    });
    final signed = {
      'w': 300,
      'h': 160,
      'strokes': [
        [
          [10, 20],
          [30, 40],
        ],
      ],
    };

    test('is required only when it is visible', () {
      expect(validate(withRequiredSignature, {'autoriza': 'no'}), isEmpty);
      expect(validate(withRequiredSignature, {'autoriza': 'si'}).keys, ['firma']);
      expect(validate(withRequiredSignature, {'autoriza': 'si', 'firma': signed}), isEmpty);
    });

    test('is stored as the strokes the surveyor drew', () {
      expect(answersToStore(withRequiredSignature, {'autoriza': 'si', 'firma': signed}), {
        'autoriza': 'si',
        'firma': signed,
      });
      expect(answersToStore(withRequiredSignature, {'autoriza': 'no', 'firma': signed}), {'autoriza': 'no'});
    });
  });
}
