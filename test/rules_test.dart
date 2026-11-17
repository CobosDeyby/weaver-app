import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:weaver_app/survey/rules.dart';

/// The shared contract. The backend (PHP) and the web builder (TypeScript)
/// run the same file.
void main() {
  final fixture =
      jsonDecode(File('test/fixtures/survey-rules.json').readAsStringSync()) as Map<String, dynamic>;

  group('rules', () {
    for (final item in fixture['rules'] as List) {
      test(item['name'] as String, () {
        expect(passes(item['rule'], Map<String, dynamic>.from(item['answers'] as Map)), item['expected']);
      });
    }
  });

  group('visibility', () {
    for (final item in fixture['visibility'] as List) {
      test(item['name'] as String, () {
        expect(
          visibleKeys([
            for (final q in item['questions'] as List) Map<String, dynamic>.from(q as Map),
          ], Map<String, dynamic>.from(item['answers'] as Map)),
          item['visible'],
        );
      });
    }
  });
}
