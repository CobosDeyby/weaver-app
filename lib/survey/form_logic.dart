/// Pure rules of the survey form: which options a question offers, what is
/// still wrong before saving, and what gets stored.
library;

import 'definition.dart';
import 'rules.dart';

/// Items of the shared lists a survey uses, by list id.
typedef CatalogOptions = Map<int, List<Option>>;

final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// The options [question] offers right now. A dependent list is narrowed to
/// the items of the parent chosen in [answers]; with no parent chosen it is empty.
List<Option> optionsFor(Question question, CatalogOptions catalogs, Answers answers) {
  final catalogId = question.catalogId;
  if (catalogId == null) {
    return question.inlineOptions;
  }

  final items = catalogs[catalogId] ?? const <Option>[];
  final filterBy = question.filterBy;
  if (filterBy == null) {
    return items;
  }

  final parent = answers[filterBy];
  return parent is String ? items.where((item) => item.parent == parent).toList() : const <Option>[];
}

/// Problems that block saving, by question key. Hidden questions never block.
Map<String, String> validate(SurveyDefinition definition, Answers answers) {
  final errors = <String, String>{};
  final visible = definition.visible(answers);

  for (final question in definition.questions) {
    if (!question.collectsAnswer || !visible.contains(question.key)) {
      continue;
    }

    final value = answers[question.key];

    if (isEmptyAnswer(value)) {
      if (question.required) {
        errors[question.key] = 'Esta respuesta es obligatoria.';
      }
      continue;
    }

    if (question.isNumber) {
      if (value is! num) {
        errors[question.key] = 'Escribe un número.';
      } else if (question.type == 'integer' && value != value.roundToDouble()) {
        errors[question.key] = 'Escribe un número entero.';
      } else if (question.min != null && value < question.min!) {
        errors[question.key] = 'El mínimo es ${question.min}.';
      } else if (question.max != null && value > question.max!) {
        errors[question.key] = 'El máximo es ${question.max}.';
      }
    } else if (question.type == 'email' && !_email.hasMatch('$value')) {
      errors[question.key] = 'Escribe un correo válido.';
    }
  }

  return errors;
}

/// What is stored: only the answers of visible questions, without blanks.
Answers answersToStore(SurveyDefinition definition, Answers answers) {
  final visible = definition.visible(answers);

  return {
    for (final question in definition.questions)
      if (question.collectsAnswer && visible.contains(question.key) && !isEmptyAnswer(answers[question.key]))
        question.key: answers[question.key],
  };
}

/// After [changedKey] changes, drop the answers of the dependent lists it
/// narrows (a municipality no longer belongs to the new department).
void clearDependents(SurveyDefinition definition, Answers answers, String changedKey) {
  for (final question in definition.questions) {
    if (question.filterBy == changedKey && answers.containsKey(question.key)) {
      answers.remove(question.key);
      clearDependents(definition, answers, question.key);
    }
  }
}
