/// Typed, read-only view of a published survey definition (schema v2).
library;

import 'dart:convert';

import 'rules.dart';

class Option {
  const Option(this.value, this.label, {this.parent});

  final String value;
  final String label;

  /// For items of a dependent list: the value of the item they belong to.
  final String? parent;
}

class Question {
  Question(this.raw);

  final Map<String, dynamic> raw;

  String get key => raw['key'] as String;
  String get type => raw['type'] as String? ?? 'text';
  String get label => raw['label'] as String? ?? '';
  String? get help => raw['help'] as String?;
  bool get required => raw['required'] == true;
  num? get min => (raw['validation'] as Map?)?['min'] as num?;
  num? get max => (raw['validation'] as Map?)?['max'] as num?;

  /// Id of the shared list the options come from, when not written inline.
  int? get catalogId => (raw['source'] as Map?)?['catalog'] as int?;

  /// Key of the earlier question whose answer narrows the list.
  String? get filterBy => (raw['source'] as Map?)?['filterBy'] as String?;

  bool get collectsAnswer => type != 'header' && type != 'note';
  bool get isChoice => type == 'single_choice' || type == 'multiple_choice';
  bool get isNumber => type == 'integer' || type == 'decimal';

  List<Option> get inlineOptions => [
    for (final option in (raw['options'] as List? ?? const []))
      Option('${option['value']}', '${option['label']}'),
  ];
}

class Section {
  Section(this.title, this.questions);

  final String title;
  final List<Question> questions;
}

class SurveyDefinition {
  SurveyDefinition(this.raw)
    : sections = [
        for (final section in (raw['sections'] as List? ?? const []))
          Section(section['title'] as String? ?? '', [
            for (final question in (section['questions'] as List? ?? const []))
              Question(Map<String, dynamic>.from(question as Map)),
          ]),
      ];

  factory SurveyDefinition.fromJson(String json) =>
      SurveyDefinition(Map<String, dynamic>.from(jsonDecode(json) as Map));

  final Map<String, dynamic> raw;
  final List<Section> sections;

  late final List<Question> questions = [for (final section in sections) ...section.questions];

  bool get requireLocation => (raw['settings'] as Map?)?['requireLocation'] == true;

  Set<int> get catalogIds => {
    for (final question in questions)
      if (question.catalogId != null) question.catalogId!,
  };

  Set<String> visible(Answers answers) =>
      visibleKeys(questions.map((question) => question.raw), answers).toSet();
}
