/// Evaluates the visibility rules of a survey definition (schema v2).
///
/// The same logic lives in the backend (PHP) and in the web builder
/// (TypeScript). test/fixtures/survey-rules.json is the contract all three
/// must pass; it is a copy of tests/fixtures/survey-rules.json in the backend.
library;

typedef Answers = Map<String, dynamic>;

final _numeric = RegExp(r'^-?\d+(\.\d+)?$');

bool isEmptyAnswer(Object? value) => value == null || value == '' || (value is List && value.isEmpty);

bool _isNumeric(Object? value) => value is num || (value is String && _numeric.hasMatch(value));

double _number(Object value) => value is num ? value.toDouble() : double.parse(value as String);

bool _isScalar(Object? value) => value is String || value is num || value is bool;

bool _equals(Object? answer, Object? value) {
  if (isEmptyAnswer(answer) || answer is List || value is List || value == null) {
    return false;
  }

  if (_isNumeric(answer) && _isNumeric(value)) {
    return _number(answer!) == _number(value);
  }

  return _isScalar(answer) && _isScalar(value) && '$answer' == '$value';
}

bool _compare(Object? answer, Object? value, bool Function(int order) test) {
  if (isEmptyAnswer(answer) || answer is List || isEmptyAnswer(value) || value is List) {
    return false;
  }

  if (_isNumeric(answer) && _isNumeric(value)) {
    return test(_number(answer!).compareTo(_number(value!)));
  }

  if (answer is String && value is String) {
    return test(answer.compareTo(value));
  }

  return false;
}

bool _isIn(Object? answer, Object? value) => value is List && value.any((item) => _equals(answer, item));

/// Whether [rule] holds for [answers]. A missing or malformed rule passes.
bool passes(Object? rule, Answers answers) {
  if (rule is! Map) {
    return true;
  }

  final all = rule['all'];
  if (all is List) {
    return all.every((child) => passes(child, answers));
  }

  final any = rule['any'];
  if (any is List) {
    return any.isEmpty || any.any((child) => passes(child, answers));
  }

  final q = rule['q'];
  final op = rule['op'];
  if (q is! String || op is! String) {
    return true;
  }

  final answer = answers[q];
  final value = rule['value'];

  switch (op) {
    case 'empty':
      return isEmptyAnswer(answer);
    case 'not_empty':
      return !isEmptyAnswer(answer);
    case 'eq':
      return _equals(answer, value);
    case 'neq':
      return !_equals(answer, value);
    case 'gt':
      return _compare(answer, value, (order) => order > 0);
    case 'gte':
      return _compare(answer, value, (order) => order >= 0);
    case 'lt':
      return _compare(answer, value, (order) => order < 0);
    case 'lte':
      return _compare(answer, value, (order) => order <= 0);
    case 'in':
      return _isIn(answer, value);
    case 'not_in':
      return !_isIn(answer, value);
    case 'contains':
      return answer is List && answer.any((item) => _equals(item, value));
    default:
      return false;
  }
}

/// Keys of the questions shown for [answers], in order. Answers to hidden
/// questions do not count when evaluating later rules.
///
/// Each question is a map with a `key` and an optional `visibleIf`.
List<String> visibleKeys(Iterable<Map<String, dynamic>> questions, Answers answers) {
  final visible = <String>[];
  final effective = <String, dynamic>{};

  for (final question in questions) {
    if (passes(question['visibleIf'], effective)) {
      final key = question['key'] as String;
      visible.add(key);
      effective[key] = answers[key];
    }
  }

  return visible;
}
