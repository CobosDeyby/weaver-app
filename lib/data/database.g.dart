// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SurveysTable extends Surveys with TableInfo<$SurveysTable, Survey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurveysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organizationMeta = const VerificationMeta('organization');
  @override
  late final GeneratedColumn<String> organization = GeneratedColumn<String>(
    'organization',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _definitionMeta = const VerificationMeta('definition');
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
    'definition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, description, organization, version, hash, definition];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surveys';
  @override
  VerificationContext validateIntegrity(Insertable<Survey> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(data['description']!, _descriptionMeta),
      );
    }
    if (data.containsKey('organization')) {
      context.handle(
        _organizationMeta,
        organization.isAcceptableOrUnknown(data['organization']!, _organizationMeta),
      );
    } else if (isInserting) {
      context.missing(_organizationMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta, version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(_hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('definition')) {
      context.handle(_definitionMeta, definition.isAcceptableOrUnknown(data['definition']!, _definitionMeta));
    } else if (isInserting) {
      context.missing(_definitionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Survey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Survey(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      organization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization'],
      )!,
      version: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      hash: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}hash'])!,
      definition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition'],
      )!,
    );
  }

  @override
  $SurveysTable createAlias(String alias) {
    return $SurveysTable(attachedDatabase, alias);
  }
}

class Survey extends DataClass implements Insertable<Survey> {
  final int id;
  final String title;
  final String? description;
  final String organization;
  final int version;
  final String hash;

  /// The definition exactly as the server sent it (JSON).
  final String definition;
  const Survey({
    required this.id,
    required this.title,
    this.description,
    required this.organization,
    required this.version,
    required this.hash,
    required this.definition,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['organization'] = Variable<String>(organization);
    map['version'] = Variable<int>(version);
    map['hash'] = Variable<String>(hash);
    map['definition'] = Variable<String>(definition);
    return map;
  }

  SurveysCompanion toCompanion(bool nullToAbsent) {
    return SurveysCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent ? const Value.absent() : Value(description),
      organization: Value(organization),
      version: Value(version),
      hash: Value(hash),
      definition: Value(definition),
    );
  }

  factory Survey.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Survey(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      organization: serializer.fromJson<String>(json['organization']),
      version: serializer.fromJson<int>(json['version']),
      hash: serializer.fromJson<String>(json['hash']),
      definition: serializer.fromJson<String>(json['definition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'organization': serializer.toJson<String>(organization),
      'version': serializer.toJson<int>(version),
      'hash': serializer.toJson<String>(hash),
      'definition': serializer.toJson<String>(definition),
    };
  }

  Survey copyWith({
    int? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? organization,
    int? version,
    String? hash,
    String? definition,
  }) => Survey(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    organization: organization ?? this.organization,
    version: version ?? this.version,
    hash: hash ?? this.hash,
    definition: definition ?? this.definition,
  );
  Survey copyWithCompanion(SurveysCompanion data) {
    return Survey(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present ? data.description.value : this.description,
      organization: data.organization.present ? data.organization.value : this.organization,
      version: data.version.present ? data.version.value : this.version,
      hash: data.hash.present ? data.hash.value : this.hash,
      definition: data.definition.present ? data.definition.value : this.definition,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Survey(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('organization: $organization, ')
          ..write('version: $version, ')
          ..write('hash: $hash, ')
          ..write('definition: $definition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, organization, version, hash, definition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Survey &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.organization == this.organization &&
          other.version == this.version &&
          other.hash == this.hash &&
          other.definition == this.definition);
}

class SurveysCompanion extends UpdateCompanion<Survey> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> organization;
  final Value<int> version;
  final Value<String> hash;
  final Value<String> definition;
  const SurveysCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.organization = const Value.absent(),
    this.version = const Value.absent(),
    this.hash = const Value.absent(),
    this.definition = const Value.absent(),
  });
  SurveysCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String organization,
    required int version,
    required String hash,
    required String definition,
  }) : title = Value(title),
       organization = Value(organization),
       version = Value(version),
       hash = Value(hash),
       definition = Value(definition);
  static Insertable<Survey> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? organization,
    Expression<int>? version,
    Expression<String>? hash,
    Expression<String>? definition,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (organization != null) 'organization': organization,
      if (version != null) 'version': version,
      if (hash != null) 'hash': hash,
      if (definition != null) 'definition': definition,
    });
  }

  SurveysCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? organization,
    Value<int>? version,
    Value<String>? hash,
    Value<String>? definition,
  }) {
    return SurveysCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      organization: organization ?? this.organization,
      version: version ?? this.version,
      hash: hash ?? this.hash,
      definition: definition ?? this.definition,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (organization.present) {
      map['organization'] = Variable<String>(organization.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurveysCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('organization: $organization, ')
          ..write('version: $version, ')
          ..write('hash: $hash, ')
          ..write('definition: $definition')
          ..write(')'))
        .toString();
  }
}

class $CatalogsTable extends Catalogs with TableInfo<$CatalogsTable, Catalog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, parentId, hash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogs';
  @override
  VerificationContext validateIntegrity(Insertable<Catalog> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta, parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('hash')) {
      context.handle(_hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Catalog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Catalog(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      hash: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}hash'])!,
    );
  }

  @override
  $CatalogsTable createAlias(String alias) {
    return $CatalogsTable(attachedDatabase, alias);
  }
}

class Catalog extends DataClass implements Insertable<Catalog> {
  final int id;
  final String name;
  final int? parentId;
  final String hash;
  const Catalog({required this.id, required this.name, this.parentId, required this.hash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['hash'] = Variable<String>(hash);
    return map;
  }

  CatalogsCompanion toCompanion(bool nullToAbsent) {
    return CatalogsCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent ? const Value.absent() : Value(parentId),
      hash: Value(hash),
    );
  }

  factory Catalog.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Catalog(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      hash: serializer.fromJson<String>(json['hash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
      'hash': serializer.toJson<String>(hash),
    };
  }

  Catalog copyWith({int? id, String? name, Value<int?> parentId = const Value.absent(), String? hash}) =>
      Catalog(
        id: id ?? this.id,
        name: name ?? this.name,
        parentId: parentId.present ? parentId.value : this.parentId,
        hash: hash ?? this.hash,
      );
  Catalog copyWithCompanion(CatalogsCompanion data) {
    return Catalog(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      hash: data.hash.present ? data.hash.value : this.hash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Catalog(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId, hash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catalog &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.hash == this.hash);
}

class CatalogsCompanion extends UpdateCompanion<Catalog> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<String> hash;
  const CatalogsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.hash = const Value.absent(),
  });
  CatalogsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    required String hash,
  }) : name = Value(name),
       hash = Value(hash);
  static Insertable<Catalog> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? parentId,
    Expression<String>? hash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (hash != null) 'hash': hash,
    });
  }

  CatalogsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? parentId,
    Value<String>? hash,
  }) {
    return CatalogsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      hash: hash ?? this.hash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }
}

class $CatalogItemsTable extends CatalogItems with TableInfo<$CatalogItemsTable, CatalogItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _catalogIdMeta = const VerificationMeta('catalogId');
  @override
  late final GeneratedColumn<int> catalogId = GeneratedColumn<int>(
    'catalog_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<String> parent = GeneratedColumn<String>(
    'parent',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, catalogId, value, label, parent, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_items';
  @override
  VerificationContext validateIntegrity(Insertable<CatalogItem> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('catalog_id')) {
      context.handle(_catalogIdMeta, catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta));
    } else if (isInserting) {
      context.missing(_catalogIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('label')) {
      context.handle(_labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('parent')) {
      context.handle(_parentMeta, parent.isAcceptableOrUnknown(data['parent']!, _parentMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogItem(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      catalogId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}catalog_id'])!,
      value: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      label: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      parent: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}parent']),
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $CatalogItemsTable createAlias(String alias) {
    return $CatalogItemsTable(attachedDatabase, alias);
  }
}

class CatalogItem extends DataClass implements Insertable<CatalogItem> {
  final int id;
  final int catalogId;
  final String value;
  final String label;
  final String? parent;
  final int position;
  const CatalogItem({
    required this.id,
    required this.catalogId,
    required this.value,
    required this.label,
    this.parent,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['catalog_id'] = Variable<int>(catalogId);
    map['value'] = Variable<String>(value);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || parent != null) {
      map['parent'] = Variable<String>(parent);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  CatalogItemsCompanion toCompanion(bool nullToAbsent) {
    return CatalogItemsCompanion(
      id: Value(id),
      catalogId: Value(catalogId),
      value: Value(value),
      label: Value(label),
      parent: parent == null && nullToAbsent ? const Value.absent() : Value(parent),
      position: Value(position),
    );
  }

  factory CatalogItem.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogItem(
      id: serializer.fromJson<int>(json['id']),
      catalogId: serializer.fromJson<int>(json['catalogId']),
      value: serializer.fromJson<String>(json['value']),
      label: serializer.fromJson<String>(json['label']),
      parent: serializer.fromJson<String?>(json['parent']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'catalogId': serializer.toJson<int>(catalogId),
      'value': serializer.toJson<String>(value),
      'label': serializer.toJson<String>(label),
      'parent': serializer.toJson<String?>(parent),
      'position': serializer.toJson<int>(position),
    };
  }

  CatalogItem copyWith({
    int? id,
    int? catalogId,
    String? value,
    String? label,
    Value<String?> parent = const Value.absent(),
    int? position,
  }) => CatalogItem(
    id: id ?? this.id,
    catalogId: catalogId ?? this.catalogId,
    value: value ?? this.value,
    label: label ?? this.label,
    parent: parent.present ? parent.value : this.parent,
    position: position ?? this.position,
  );
  CatalogItem copyWithCompanion(CatalogItemsCompanion data) {
    return CatalogItem(
      id: data.id.present ? data.id.value : this.id,
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      value: data.value.present ? data.value.value : this.value,
      label: data.label.present ? data.label.value : this.label,
      parent: data.parent.present ? data.parent.value : this.parent,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogItem(')
          ..write('id: $id, ')
          ..write('catalogId: $catalogId, ')
          ..write('value: $value, ')
          ..write('label: $label, ')
          ..write('parent: $parent, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, catalogId, value, label, parent, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogItem &&
          other.id == this.id &&
          other.catalogId == this.catalogId &&
          other.value == this.value &&
          other.label == this.label &&
          other.parent == this.parent &&
          other.position == this.position);
}

class CatalogItemsCompanion extends UpdateCompanion<CatalogItem> {
  final Value<int> id;
  final Value<int> catalogId;
  final Value<String> value;
  final Value<String> label;
  final Value<String?> parent;
  final Value<int> position;
  const CatalogItemsCompanion({
    this.id = const Value.absent(),
    this.catalogId = const Value.absent(),
    this.value = const Value.absent(),
    this.label = const Value.absent(),
    this.parent = const Value.absent(),
    this.position = const Value.absent(),
  });
  CatalogItemsCompanion.insert({
    this.id = const Value.absent(),
    required int catalogId,
    required String value,
    required String label,
    this.parent = const Value.absent(),
    required int position,
  }) : catalogId = Value(catalogId),
       value = Value(value),
       label = Value(label),
       position = Value(position);
  static Insertable<CatalogItem> custom({
    Expression<int>? id,
    Expression<int>? catalogId,
    Expression<String>? value,
    Expression<String>? label,
    Expression<String>? parent,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catalogId != null) 'catalog_id': catalogId,
      if (value != null) 'value': value,
      if (label != null) 'label': label,
      if (parent != null) 'parent': parent,
      if (position != null) 'position': position,
    });
  }

  CatalogItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? catalogId,
    Value<String>? value,
    Value<String>? label,
    Value<String?>? parent,
    Value<int>? position,
  }) {
    return CatalogItemsCompanion(
      id: id ?? this.id,
      catalogId: catalogId ?? this.catalogId,
      value: value ?? this.value,
      label: label ?? this.label,
      parent: parent ?? this.parent,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (catalogId.present) {
      map['catalog_id'] = Variable<int>(catalogId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (parent.present) {
      map['parent'] = Variable<String>(parent.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogItemsCompanion(')
          ..write('id: $id, ')
          ..write('catalogId: $catalogId, ')
          ..write('value: $value, ')
          ..write('label: $label, ')
          ..write('parent: $parent, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $ResponsesTable extends Responses with TableInfo<$ResponsesTable, Response> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surveyIdMeta = const VerificationMeta('surveyId');
  @override
  late final GeneratedColumn<int> surveyId = GeneratedColumn<int>(
    'survey_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surveyTitleMeta = const VerificationMeta('surveyTitle');
  @override
  late final GeneratedColumn<String> surveyTitle = GeneratedColumn<String>(
    'survey_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answersMeta = const VerificationMeta('answers');
  @override
  late final GeneratedColumn<String> answers = GeneratedColumn<String>(
    'answers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    surveyId,
    surveyTitle,
    version,
    answers,
    startedAt,
    finishedAt,
    latitude,
    longitude,
    accuracy,
    status,
    reason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'responses';
  @override
  VerificationContext validateIntegrity(Insertable<Response> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('survey_id')) {
      context.handle(_surveyIdMeta, surveyId.isAcceptableOrUnknown(data['survey_id']!, _surveyIdMeta));
    } else if (isInserting) {
      context.missing(_surveyIdMeta);
    }
    if (data.containsKey('survey_title')) {
      context.handle(
        _surveyTitleMeta,
        surveyTitle.isAcceptableOrUnknown(data['survey_title']!, _surveyTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_surveyTitleMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta, version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('answers')) {
      context.handle(_answersMeta, answers.isAcceptableOrUnknown(data['answers']!, _answersMeta));
    } else if (isInserting) {
      context.missing(_answersMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta, startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_finishedAtMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta, latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta, longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta, accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta, reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Response map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Response(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      surveyId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}survey_id'])!,
      surveyTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}survey_title'],
      )!,
      version: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      answers: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}answers'])!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      )!,
      latitude: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      accuracy: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}accuracy']),
      status: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      reason: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}reason']),
    );
  }

  @override
  $ResponsesTable createAlias(String alias) {
    return $ResponsesTable(attachedDatabase, alias);
  }
}

class Response extends DataClass implements Insertable<Response> {
  final String id;
  final int userId;
  final int surveyId;
  final String surveyTitle;
  final int version;
  final String answers;
  final DateTime startedAt;
  final DateTime finishedAt;
  final double? latitude;
  final double? longitude;
  final double? accuracy;

  /// pending | synced | rejected
  final String status;
  final String? reason;
  const Response({
    required this.id,
    required this.userId,
    required this.surveyId,
    required this.surveyTitle,
    required this.version,
    required this.answers,
    required this.startedAt,
    required this.finishedAt,
    this.latitude,
    this.longitude,
    this.accuracy,
    required this.status,
    this.reason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<int>(userId);
    map['survey_id'] = Variable<int>(surveyId);
    map['survey_title'] = Variable<String>(surveyTitle);
    map['version'] = Variable<int>(version);
    map['answers'] = Variable<String>(answers);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['finished_at'] = Variable<DateTime>(finishedAt);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    return map;
  }

  ResponsesCompanion toCompanion(bool nullToAbsent) {
    return ResponsesCompanion(
      id: Value(id),
      userId: Value(userId),
      surveyId: Value(surveyId),
      surveyTitle: Value(surveyTitle),
      version: Value(version),
      answers: Value(answers),
      startedAt: Value(startedAt),
      finishedAt: Value(finishedAt),
      latitude: latitude == null && nullToAbsent ? const Value.absent() : Value(latitude),
      longitude: longitude == null && nullToAbsent ? const Value.absent() : Value(longitude),
      accuracy: accuracy == null && nullToAbsent ? const Value.absent() : Value(accuracy),
      status: Value(status),
      reason: reason == null && nullToAbsent ? const Value.absent() : Value(reason),
    );
  }

  factory Response.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Response(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      surveyId: serializer.fromJson<int>(json['surveyId']),
      surveyTitle: serializer.fromJson<String>(json['surveyTitle']),
      version: serializer.fromJson<int>(json['version']),
      answers: serializer.fromJson<String>(json['answers']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime>(json['finishedAt']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      status: serializer.fromJson<String>(json['status']),
      reason: serializer.fromJson<String?>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<int>(userId),
      'surveyId': serializer.toJson<int>(surveyId),
      'surveyTitle': serializer.toJson<String>(surveyTitle),
      'version': serializer.toJson<int>(version),
      'answers': serializer.toJson<String>(answers),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime>(finishedAt),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'accuracy': serializer.toJson<double?>(accuracy),
      'status': serializer.toJson<String>(status),
      'reason': serializer.toJson<String?>(reason),
    };
  }

  Response copyWith({
    String? id,
    int? userId,
    int? surveyId,
    String? surveyTitle,
    int? version,
    String? answers,
    DateTime? startedAt,
    DateTime? finishedAt,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<double?> accuracy = const Value.absent(),
    String? status,
    Value<String?> reason = const Value.absent(),
  }) => Response(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    surveyId: surveyId ?? this.surveyId,
    surveyTitle: surveyTitle ?? this.surveyTitle,
    version: version ?? this.version,
    answers: answers ?? this.answers,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt ?? this.finishedAt,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    accuracy: accuracy.present ? accuracy.value : this.accuracy,
    status: status ?? this.status,
    reason: reason.present ? reason.value : this.reason,
  );
  Response copyWithCompanion(ResponsesCompanion data) {
    return Response(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      surveyId: data.surveyId.present ? data.surveyId.value : this.surveyId,
      surveyTitle: data.surveyTitle.present ? data.surveyTitle.value : this.surveyTitle,
      version: data.version.present ? data.version.value : this.version,
      answers: data.answers.present ? data.answers.value : this.answers,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present ? data.finishedAt.value : this.finishedAt,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      status: data.status.present ? data.status.value : this.status,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Response(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('surveyId: $surveyId, ')
          ..write('surveyTitle: $surveyTitle, ')
          ..write('version: $version, ')
          ..write('answers: $answers, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('status: $status, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    surveyId,
    surveyTitle,
    version,
    answers,
    startedAt,
    finishedAt,
    latitude,
    longitude,
    accuracy,
    status,
    reason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Response &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.surveyId == this.surveyId &&
          other.surveyTitle == this.surveyTitle &&
          other.version == this.version &&
          other.answers == this.answers &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracy == this.accuracy &&
          other.status == this.status &&
          other.reason == this.reason);
}

class ResponsesCompanion extends UpdateCompanion<Response> {
  final Value<String> id;
  final Value<int> userId;
  final Value<int> surveyId;
  final Value<String> surveyTitle;
  final Value<int> version;
  final Value<String> answers;
  final Value<DateTime> startedAt;
  final Value<DateTime> finishedAt;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> accuracy;
  final Value<String> status;
  final Value<String?> reason;
  final Value<int> rowid;
  const ResponsesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.surveyId = const Value.absent(),
    this.surveyTitle = const Value.absent(),
    this.version = const Value.absent(),
    this.answers = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResponsesCompanion.insert({
    required String id,
    required int userId,
    required int surveyId,
    required String surveyTitle,
    required int version,
    required String answers,
    required DateTime startedAt,
    required DateTime finishedAt,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       surveyId = Value(surveyId),
       surveyTitle = Value(surveyTitle),
       version = Value(version),
       answers = Value(answers),
       startedAt = Value(startedAt),
       finishedAt = Value(finishedAt);
  static Insertable<Response> custom({
    Expression<String>? id,
    Expression<int>? userId,
    Expression<int>? surveyId,
    Expression<String>? surveyTitle,
    Expression<int>? version,
    Expression<String>? answers,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracy,
    Expression<String>? status,
    Expression<String>? reason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (surveyId != null) 'survey_id': surveyId,
      if (surveyTitle != null) 'survey_title': surveyTitle,
      if (version != null) 'version': version,
      if (answers != null) 'answers': answers,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResponsesCompanion copyWith({
    Value<String>? id,
    Value<int>? userId,
    Value<int>? surveyId,
    Value<String>? surveyTitle,
    Value<int>? version,
    Value<String>? answers,
    Value<DateTime>? startedAt,
    Value<DateTime>? finishedAt,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<double?>? accuracy,
    Value<String>? status,
    Value<String?>? reason,
    Value<int>? rowid,
  }) {
    return ResponsesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      surveyId: surveyId ?? this.surveyId,
      surveyTitle: surveyTitle ?? this.surveyTitle,
      version: version ?? this.version,
      answers: answers ?? this.answers,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (surveyId.present) {
      map['survey_id'] = Variable<int>(surveyId.value);
    }
    if (surveyTitle.present) {
      map['survey_title'] = Variable<String>(surveyTitle.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (answers.present) {
      map['answers'] = Variable<String>(answers.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResponsesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('surveyId: $surveyId, ')
          ..write('surveyTitle: $surveyTitle, ')
          ..write('version: $version, ')
          ..write('answers: $answers, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurveysTable surveys = $SurveysTable(this);
  late final $CatalogsTable catalogs = $CatalogsTable(this);
  late final $CatalogItemsTable catalogItems = $CatalogItemsTable(this);
  late final $ResponsesTable responses = $ResponsesTable(this);
  late final Index catalogItemsCatalog = Index(
    'catalog_items_catalog',
    'CREATE INDEX catalog_items_catalog ON catalog_items (catalog_id, parent)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    surveys,
    catalogs,
    catalogItems,
    responses,
    catalogItemsCatalog,
  ];
}

typedef $$SurveysTableCreateCompanionBuilder = SurveysCompanion Function({
  Value<int> id,
  required String title,
  Value<String?> description,
  required String organization,
  required int version,
  required String hash,
  required String definition,
});
typedef $$SurveysTableUpdateCompanionBuilder = SurveysCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> description,
  Value<String> organization,
  Value<int> version,
  Value<String> hash,
  Value<String> definition,
});

class $$SurveysTableFilterComposer extends Composer<_$AppDatabase, $SurveysTable> {
  $$SurveysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organization =>
      $composableBuilder(column: $table.organization, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definition =>
      $composableBuilder(column: $table.definition, builder: (column) => ColumnFilters(column));
}

class $$SurveysTableOrderingComposer extends Composer<_$AppDatabase, $SurveysTable> {
  $$SurveysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organization =>
      $composableBuilder(column: $table.organization, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definition =>
      $composableBuilder(column: $table.definition, builder: (column) => ColumnOrderings(column));
}

class $$SurveysTableAnnotationComposer extends Composer<_$AppDatabase, $SurveysTable> {
  $$SurveysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title => $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get organization =>
      $composableBuilder(column: $table.organization, builder: (column) => column);

  GeneratedColumn<int> get version => $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get hash => $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<String> get definition =>
      $composableBuilder(column: $table.definition, builder: (column) => column);
}

class $$SurveysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurveysTable,
          Survey,
          $$SurveysTableFilterComposer,
          $$SurveysTableOrderingComposer,
          $$SurveysTableAnnotationComposer,
          $$SurveysTableCreateCompanionBuilder,
          $$SurveysTableUpdateCompanionBuilder,
          (Survey, BaseReferences<_$AppDatabase, $SurveysTable, Survey>),
          Survey,
          PrefetchHooks Function()
        > {
  $$SurveysTableTableManager(_$AppDatabase db, $SurveysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SurveysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SurveysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SurveysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> organization = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> hash = const Value.absent(),
                Value<String> definition = const Value.absent(),
              }) => SurveysCompanion(
                id: id,
                title: title,
                description: description,
                organization: organization,
                version: version,
                hash: hash,
                definition: definition,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required String organization,
                required int version,
                required String hash,
                required String definition,
              }) => SurveysCompanion.insert(
                id: id,
                title: title,
                description: description,
                organization: organization,
                version: version,
                hash: hash,
                definition: definition,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SurveysTable, Survey>(table),
                  BaseReferences<_$AppDatabase, $SurveysTable, Survey>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SurveysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurveysTable,
      Survey,
      $$SurveysTableFilterComposer,
      $$SurveysTableOrderingComposer,
      $$SurveysTableAnnotationComposer,
      $$SurveysTableCreateCompanionBuilder,
      $$SurveysTableUpdateCompanionBuilder,
      (Survey, BaseReferences<_$AppDatabase, $SurveysTable, Survey>),
      Survey,
      PrefetchHooks Function()
    >;
typedef $$CatalogsTableCreateCompanionBuilder = CatalogsCompanion Function({
  Value<int> id,
  required String name,
  Value<int?> parentId,
  required String hash,
});
typedef $$CatalogsTableUpdateCompanionBuilder = CatalogsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int?> parentId,
  Value<String> hash,
});

class $$CatalogsTableFilterComposer extends Composer<_$AppDatabase, $CatalogsTable> {
  $$CatalogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => ColumnFilters(column));
}

class $$CatalogsTableOrderingComposer extends Composer<_$AppDatabase, $CatalogsTable> {
  $$CatalogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => ColumnOrderings(column));
}

class $$CatalogsTableAnnotationComposer extends Composer<_$AppDatabase, $CatalogsTable> {
  $$CatalogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get hash => $composableBuilder(column: $table.hash, builder: (column) => column);
}

class $$CatalogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogsTable,
          Catalog,
          $$CatalogsTableFilterComposer,
          $$CatalogsTableOrderingComposer,
          $$CatalogsTableAnnotationComposer,
          $$CatalogsTableCreateCompanionBuilder,
          $$CatalogsTableUpdateCompanionBuilder,
          (Catalog, BaseReferences<_$AppDatabase, $CatalogsTable, Catalog>),
          Catalog,
          PrefetchHooks Function()
        > {
  $$CatalogsTableTableManager(_$AppDatabase db, $CatalogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$CatalogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$CatalogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$CatalogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<String> hash = const Value.absent(),
          }) => CatalogsCompanion(id: id, name: name, parentId: parentId, hash: hash),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int?> parentId = const Value.absent(),
            required String hash,
          }) => CatalogsCompanion.insert(id: id, name: name, parentId: parentId, hash: hash),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CatalogsTable, Catalog>(table),
                  BaseReferences<_$AppDatabase, $CatalogsTable, Catalog>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogsTable,
      Catalog,
      $$CatalogsTableFilterComposer,
      $$CatalogsTableOrderingComposer,
      $$CatalogsTableAnnotationComposer,
      $$CatalogsTableCreateCompanionBuilder,
      $$CatalogsTableUpdateCompanionBuilder,
      (Catalog, BaseReferences<_$AppDatabase, $CatalogsTable, Catalog>),
      Catalog,
      PrefetchHooks Function()
    >;
typedef $$CatalogItemsTableCreateCompanionBuilder = CatalogItemsCompanion Function({
  Value<int> id,
  required int catalogId,
  required String value,
  required String label,
  Value<String?> parent,
  required int position,
});
typedef $$CatalogItemsTableUpdateCompanionBuilder = CatalogItemsCompanion Function({
  Value<int> id,
  Value<int> catalogId,
  Value<String> value,
  Value<String> label,
  Value<String?> parent,
  Value<int> position,
});

class $$CatalogItemsTableFilterComposer extends Composer<_$AppDatabase, $CatalogItemsTable> {
  $$CatalogItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parent =>
      $composableBuilder(column: $table.parent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));
}

class $$CatalogItemsTableOrderingComposer extends Composer<_$AppDatabase, $CatalogItemsTable> {
  $$CatalogItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parent =>
      $composableBuilder(column: $table.parent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));
}

class $$CatalogItemsTableAnnotationComposer extends Composer<_$AppDatabase, $CatalogItemsTable> {
  $$CatalogItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<String> get value => $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get label => $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get parent =>
      $composableBuilder(column: $table.parent, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$CatalogItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogItemsTable,
          CatalogItem,
          $$CatalogItemsTableFilterComposer,
          $$CatalogItemsTableOrderingComposer,
          $$CatalogItemsTableAnnotationComposer,
          $$CatalogItemsTableCreateCompanionBuilder,
          $$CatalogItemsTableUpdateCompanionBuilder,
          (CatalogItem, BaseReferences<_$AppDatabase, $CatalogItemsTable, CatalogItem>),
          CatalogItem,
          PrefetchHooks Function()
        > {
  $$CatalogItemsTableTableManager(_$AppDatabase db, $CatalogItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$CatalogItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$CatalogItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$CatalogItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> catalogId = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> parent = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => CatalogItemsCompanion(
                id: id,
                catalogId: catalogId,
                value: value,
                label: label,
                parent: parent,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int catalogId,
                required String value,
                required String label,
                Value<String?> parent = const Value.absent(),
                required int position,
              }) => CatalogItemsCompanion.insert(
                id: id,
                catalogId: catalogId,
                value: value,
                label: label,
                parent: parent,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CatalogItemsTable, CatalogItem>(table),
                  BaseReferences<_$AppDatabase, $CatalogItemsTable, CatalogItem>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogItemsTable,
      CatalogItem,
      $$CatalogItemsTableFilterComposer,
      $$CatalogItemsTableOrderingComposer,
      $$CatalogItemsTableAnnotationComposer,
      $$CatalogItemsTableCreateCompanionBuilder,
      $$CatalogItemsTableUpdateCompanionBuilder,
      (CatalogItem, BaseReferences<_$AppDatabase, $CatalogItemsTable, CatalogItem>),
      CatalogItem,
      PrefetchHooks Function()
    >;
typedef $$ResponsesTableCreateCompanionBuilder = ResponsesCompanion Function({
  required String id,
  required int userId,
  required int surveyId,
  required String surveyTitle,
  required int version,
  required String answers,
  required DateTime startedAt,
  required DateTime finishedAt,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> accuracy,
  Value<String> status,
  Value<String?> reason,
  Value<int> rowid,
});
typedef $$ResponsesTableUpdateCompanionBuilder = ResponsesCompanion Function({
  Value<String> id,
  Value<int> userId,
  Value<int> surveyId,
  Value<String> surveyTitle,
  Value<int> version,
  Value<String> answers,
  Value<DateTime> startedAt,
  Value<DateTime> finishedAt,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> accuracy,
  Value<String> status,
  Value<String?> reason,
  Value<int> rowid,
});

class $$ResponsesTableFilterComposer extends Composer<_$AppDatabase, $ResponsesTable> {
  $$ResponsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surveyId =>
      $composableBuilder(column: $table.surveyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get surveyTitle =>
      $composableBuilder(column: $table.surveyTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answers =>
      $composableBuilder(column: $table.answers, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get finishedAt =>
      $composableBuilder(column: $table.finishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => ColumnFilters(column));
}

class $$ResponsesTableOrderingComposer extends Composer<_$AppDatabase, $ResponsesTable> {
  $$ResponsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surveyId =>
      $composableBuilder(column: $table.surveyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get surveyTitle =>
      $composableBuilder(column: $table.surveyTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answers =>
      $composableBuilder(column: $table.answers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get finishedAt =>
      $composableBuilder(column: $table.finishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => ColumnOrderings(column));
}

class $$ResponsesTableAnnotationComposer extends Composer<_$AppDatabase, $ResponsesTable> {
  $$ResponsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get surveyId =>
      $composableBuilder(column: $table.surveyId, builder: (column) => column);

  GeneratedColumn<String> get surveyTitle =>
      $composableBuilder(column: $table.surveyTitle, builder: (column) => column);

  GeneratedColumn<int> get version => $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get answers =>
      $composableBuilder(column: $table.answers, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt =>
      $composableBuilder(column: $table.finishedAt, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);
}

class $$ResponsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResponsesTable,
          Response,
          $$ResponsesTableFilterComposer,
          $$ResponsesTableOrderingComposer,
          $$ResponsesTableAnnotationComposer,
          $$ResponsesTableCreateCompanionBuilder,
          $$ResponsesTableUpdateCompanionBuilder,
          (Response, BaseReferences<_$AppDatabase, $ResponsesTable, Response>),
          Response,
          PrefetchHooks Function()
        > {
  $$ResponsesTableTableManager(_$AppDatabase db, $ResponsesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ResponsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ResponsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ResponsesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> surveyId = const Value.absent(),
                Value<String> surveyTitle = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> answers = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> finishedAt = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResponsesCompanion(
                id: id,
                userId: userId,
                surveyId: surveyId,
                surveyTitle: surveyTitle,
                version: version,
                answers: answers,
                startedAt: startedAt,
                finishedAt: finishedAt,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                status: status,
                reason: reason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int userId,
                required int surveyId,
                required String surveyTitle,
                required int version,
                required String answers,
                required DateTime startedAt,
                required DateTime finishedAt,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResponsesCompanion.insert(
                id: id,
                userId: userId,
                surveyId: surveyId,
                surveyTitle: surveyTitle,
                version: version,
                answers: answers,
                startedAt: startedAt,
                finishedAt: finishedAt,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                status: status,
                reason: reason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ResponsesTable, Response>(table),
                  BaseReferences<_$AppDatabase, $ResponsesTable, Response>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ResponsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResponsesTable,
      Response,
      $$ResponsesTableFilterComposer,
      $$ResponsesTableOrderingComposer,
      $$ResponsesTableAnnotationComposer,
      $$ResponsesTableCreateCompanionBuilder,
      $$ResponsesTableUpdateCompanionBuilder,
      (Response, BaseReferences<_$AppDatabase, $ResponsesTable, Response>),
      Response,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurveysTableTableManager get surveys => $$SurveysTableTableManager(_db, _db.surveys);
  $$CatalogsTableTableManager get catalogs => $$CatalogsTableTableManager(_db, _db.catalogs);
  $$CatalogItemsTableTableManager get catalogItems => $$CatalogItemsTableTableManager(_db, _db.catalogItems);
  $$ResponsesTableTableManager get responses => $$ResponsesTableTableManager(_db, _db.responses);
}
