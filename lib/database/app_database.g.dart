// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NotesTable extends Notes with TableInfo<$NotesTable, NoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
      'pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        createdAt,
        updatedAt,
        deletedAt,
        pinned,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<NoteRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('pinned')) {
      context.handle(_pinnedMeta,
          pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      pinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pinned'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NoteRow extends DataClass implements Insertable<NoteRow> {
  final String id;
  final String title;
  final String content;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final bool pinned;
  final String deviceId;
  final int version;
  const NoteRow(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.pinned,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['pinned'] = Variable<bool>(pinned);
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      pinned: Value(pinned),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory NoteRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'pinned': serializer.toJson<bool>(pinned),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  NoteRow copyWith(
          {String? id,
          String? title,
          String? content,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          bool? pinned,
          String? deviceId,
          int? version}) =>
      NoteRow(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        pinned: pinned ?? this.pinned,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  NoteRow copyWithCompanion(NotesCompanion data) {
    return NoteRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('pinned: $pinned, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, createdAt, updatedAt,
      deletedAt, pinned, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.pinned == this.pinned &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class NotesCompanion extends UpdateCompanion<NoteRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<bool> pinned;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.pinned = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String title,
    required String content,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.pinned = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        content = Value(content),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<NoteRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<bool>? pinned,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (pinned != null) 'pinned': pinned,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? content,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<bool>? pinned,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      pinned: pinned ?? this.pinned,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('pinned: $pinned, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, TodoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<int> dueAt = GeneratedColumn<int>(
      'due_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        completed,
        dueAt,
        priority,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(Insertable<TodoRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_at']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class TodoRow extends DataClass implements Insertable<TodoRow> {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final int? dueAt;
  final int priority;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const TodoRow(
      {required this.id,
      required this.title,
      required this.description,
      required this.completed,
      this.dueAt,
      required this.priority,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<int>(dueAt);
    }
    map['priority'] = Variable<int>(priority);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      completed: Value(completed),
      dueAt:
          dueAt == null && nullToAbsent ? const Value.absent() : Value(dueAt),
      priority: Value(priority),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory TodoRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      completed: serializer.fromJson<bool>(json['completed']),
      dueAt: serializer.fromJson<int?>(json['dueAt']),
      priority: serializer.fromJson<int>(json['priority']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'completed': serializer.toJson<bool>(completed),
      'dueAt': serializer.toJson<int?>(dueAt),
      'priority': serializer.toJson<int>(priority),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  TodoRow copyWith(
          {String? id,
          String? title,
          String? description,
          bool? completed,
          Value<int?> dueAt = const Value.absent(),
          int? priority,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      TodoRow(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        completed: completed ?? this.completed,
        dueAt: dueAt.present ? dueAt.value : this.dueAt,
        priority: priority ?? this.priority,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  TodoRow copyWithCompanion(TodosCompanion data) {
    return TodoRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      completed: data.completed.present ? data.completed.value : this.completed,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      priority: data.priority.present ? data.priority.value : this.priority,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('completed: $completed, ')
          ..write('dueAt: $dueAt, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, completed, dueAt,
      priority, createdAt, updatedAt, deletedAt, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.completed == this.completed &&
          other.dueAt == this.dueAt &&
          other.priority == this.priority &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class TodosCompanion extends UpdateCompanion<TodoRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<bool> completed;
  final Value<int?> dueAt;
  final Value<int> priority;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.completed = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodosCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.completed = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.priority = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<TodoRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? completed,
    Expression<int>? dueAt,
    Expression<int>? priority,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (completed != null) 'completed': completed,
      if (dueAt != null) 'due_at': dueAt,
      if (priority != null) 'priority': priority,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodosCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<bool>? completed,
      Value<int?>? dueAt,
      Value<int>? priority,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return TodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      dueAt: dueAt ?? this.dueAt,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<int>(dueAt.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('completed: $completed, ')
          ..write('dueAt: $dueAt, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, TagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, color, createdAt, updatedAt, deletedAt, deviceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<TagRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class TagRow extends DataClass implements Insertable<TagRow> {
  final String id;
  final String name;
  final String? color;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  const TagRow(
      {required this.id,
      required this.name,
      this.color,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
    );
  }

  factory TagRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  TagRow copyWith(
          {String? id,
          String? name,
          Value<String?> color = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId}) =>
      TagRow(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color.present ? color.value : this.color,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
      );
  TagRow copyWithCompanion(TagsCompanion data) {
    return TagRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, color, createdAt, updatedAt, deletedAt, deviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId);
}

class TagsCompanion extends UpdateCompanion<TagRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    this.color = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<TagRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? color,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? rowid}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteTagsTable extends NoteTags
    with TableInfo<$NoteTagsTable, NoteTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
      'note_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [noteId, tagId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_tags';
  @override
  VerificationContext validateIntegrity(Insertable<NoteTagRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId, tagId};
  @override
  NoteTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteTagRow(
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $NoteTagsTable createAlias(String alias) {
    return $NoteTagsTable(attachedDatabase, alias);
  }
}

class NoteTagRow extends DataClass implements Insertable<NoteTagRow> {
  final String noteId;
  final String tagId;
  final int createdAt;
  const NoteTagRow(
      {required this.noteId, required this.tagId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['tag_id'] = Variable<String>(tagId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  NoteTagsCompanion toCompanion(bool nullToAbsent) {
    return NoteTagsCompanion(
      noteId: Value(noteId),
      tagId: Value(tagId),
      createdAt: Value(createdAt),
    );
  }

  factory NoteTagRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteTagRow(
      noteId: serializer.fromJson<String>(json['noteId']),
      tagId: serializer.fromJson<String>(json['tagId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'tagId': serializer.toJson<String>(tagId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  NoteTagRow copyWith({String? noteId, String? tagId, int? createdAt}) =>
      NoteTagRow(
        noteId: noteId ?? this.noteId,
        tagId: tagId ?? this.tagId,
        createdAt: createdAt ?? this.createdAt,
      );
  NoteTagRow copyWithCompanion(NoteTagsCompanion data) {
    return NoteTagRow(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteTagRow(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, tagId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteTagRow &&
          other.noteId == this.noteId &&
          other.tagId == this.tagId &&
          other.createdAt == this.createdAt);
}

class NoteTagsCompanion extends UpdateCompanion<NoteTagRow> {
  final Value<String> noteId;
  final Value<String> tagId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const NoteTagsCompanion({
    this.noteId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteTagsCompanion.insert({
    required String noteId,
    required String tagId,
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : noteId = Value(noteId),
        tagId = Value(tagId),
        createdAt = Value(createdAt);
  static Insertable<NoteTagRow> custom({
    Expression<String>? noteId,
    Expression<String>? tagId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (tagId != null) 'tag_id': tagId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteTagsCompanion copyWith(
      {Value<String>? noteId,
      Value<String>? tagId,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return NoteTagsCompanion(
      noteId: noteId ?? this.noteId,
      tagId: tagId ?? this.tagId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteTagsCompanion(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ThemeSchemesTable extends ThemeSchemes
    with TableInfo<$ThemeSchemesTable, ThemeSchemeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThemeSchemesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _backgroundColorMeta =
      const VerificationMeta('backgroundColor');
  @override
  late final GeneratedColumn<int> backgroundColor = GeneratedColumn<int>(
      'background_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _primaryColorMeta =
      const VerificationMeta('primaryColor');
  @override
  late final GeneratedColumn<int> primaryColor = GeneratedColumn<int>(
      'primary_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textColorMeta =
      const VerificationMeta('textColor');
  @override
  late final GeneratedColumn<int> textColor = GeneratedColumn<int>(
      'text_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _surfaceColorMeta =
      const VerificationMeta('surfaceColor');
  @override
  late final GeneratedColumn<int> surfaceColor = GeneratedColumn<int>(
      'surface_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _brightnessMeta =
      const VerificationMeta('brightness');
  @override
  late final GeneratedColumn<String> brightness = GeneratedColumn<String>(
      'brightness', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('light'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        backgroundColor,
        primaryColor,
        textColor,
        surfaceColor,
        brightness,
        createdAt,
        updatedAt,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'theme_schemes';
  @override
  VerificationContext validateIntegrity(Insertable<ThemeSchemeRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('background_color')) {
      context.handle(
          _backgroundColorMeta,
          backgroundColor.isAcceptableOrUnknown(
              data['background_color']!, _backgroundColorMeta));
    } else if (isInserting) {
      context.missing(_backgroundColorMeta);
    }
    if (data.containsKey('primary_color')) {
      context.handle(
          _primaryColorMeta,
          primaryColor.isAcceptableOrUnknown(
              data['primary_color']!, _primaryColorMeta));
    } else if (isInserting) {
      context.missing(_primaryColorMeta);
    }
    if (data.containsKey('text_color')) {
      context.handle(_textColorMeta,
          textColor.isAcceptableOrUnknown(data['text_color']!, _textColorMeta));
    } else if (isInserting) {
      context.missing(_textColorMeta);
    }
    if (data.containsKey('surface_color')) {
      context.handle(
          _surfaceColorMeta,
          surfaceColor.isAcceptableOrUnknown(
              data['surface_color']!, _surfaceColorMeta));
    } else if (isInserting) {
      context.missing(_surfaceColorMeta);
    }
    if (data.containsKey('brightness')) {
      context.handle(
          _brightnessMeta,
          brightness.isAcceptableOrUnknown(
              data['brightness']!, _brightnessMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThemeSchemeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThemeSchemeRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      backgroundColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}background_color'])!,
      primaryColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}primary_color'])!,
      textColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}text_color'])!,
      surfaceColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surface_color'])!,
      brightness: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brightness'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ThemeSchemesTable createAlias(String alias) {
    return $ThemeSchemesTable(attachedDatabase, alias);
  }
}

class ThemeSchemeRow extends DataClass implements Insertable<ThemeSchemeRow> {
  final String id;
  final String name;
  final int backgroundColor;
  final int primaryColor;
  final int textColor;
  final int surfaceColor;
  final String brightness;
  final int createdAt;
  final int updatedAt;
  final bool isActive;
  const ThemeSchemeRow(
      {required this.id,
      required this.name,
      required this.backgroundColor,
      required this.primaryColor,
      required this.textColor,
      required this.surfaceColor,
      required this.brightness,
      required this.createdAt,
      required this.updatedAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['background_color'] = Variable<int>(backgroundColor);
    map['primary_color'] = Variable<int>(primaryColor);
    map['text_color'] = Variable<int>(textColor);
    map['surface_color'] = Variable<int>(surfaceColor);
    map['brightness'] = Variable<String>(brightness);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ThemeSchemesCompanion toCompanion(bool nullToAbsent) {
    return ThemeSchemesCompanion(
      id: Value(id),
      name: Value(name),
      backgroundColor: Value(backgroundColor),
      primaryColor: Value(primaryColor),
      textColor: Value(textColor),
      surfaceColor: Value(surfaceColor),
      brightness: Value(brightness),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isActive: Value(isActive),
    );
  }

  factory ThemeSchemeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThemeSchemeRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      backgroundColor: serializer.fromJson<int>(json['backgroundColor']),
      primaryColor: serializer.fromJson<int>(json['primaryColor']),
      textColor: serializer.fromJson<int>(json['textColor']),
      surfaceColor: serializer.fromJson<int>(json['surfaceColor']),
      brightness: serializer.fromJson<String>(json['brightness']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'backgroundColor': serializer.toJson<int>(backgroundColor),
      'primaryColor': serializer.toJson<int>(primaryColor),
      'textColor': serializer.toJson<int>(textColor),
      'surfaceColor': serializer.toJson<int>(surfaceColor),
      'brightness': serializer.toJson<String>(brightness),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ThemeSchemeRow copyWith(
          {String? id,
          String? name,
          int? backgroundColor,
          int? primaryColor,
          int? textColor,
          int? surfaceColor,
          String? brightness,
          int? createdAt,
          int? updatedAt,
          bool? isActive}) =>
      ThemeSchemeRow(
        id: id ?? this.id,
        name: name ?? this.name,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        primaryColor: primaryColor ?? this.primaryColor,
        textColor: textColor ?? this.textColor,
        surfaceColor: surfaceColor ?? this.surfaceColor,
        brightness: brightness ?? this.brightness,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isActive: isActive ?? this.isActive,
      );
  ThemeSchemeRow copyWithCompanion(ThemeSchemesCompanion data) {
    return ThemeSchemeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      backgroundColor: data.backgroundColor.present
          ? data.backgroundColor.value
          : this.backgroundColor,
      primaryColor: data.primaryColor.present
          ? data.primaryColor.value
          : this.primaryColor,
      textColor: data.textColor.present ? data.textColor.value : this.textColor,
      surfaceColor: data.surfaceColor.present
          ? data.surfaceColor.value
          : this.surfaceColor,
      brightness:
          data.brightness.present ? data.brightness.value : this.brightness,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThemeSchemeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('textColor: $textColor, ')
          ..write('surfaceColor: $surfaceColor, ')
          ..write('brightness: $brightness, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, backgroundColor, primaryColor,
      textColor, surfaceColor, brightness, createdAt, updatedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThemeSchemeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.backgroundColor == this.backgroundColor &&
          other.primaryColor == this.primaryColor &&
          other.textColor == this.textColor &&
          other.surfaceColor == this.surfaceColor &&
          other.brightness == this.brightness &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isActive == this.isActive);
}

class ThemeSchemesCompanion extends UpdateCompanion<ThemeSchemeRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> backgroundColor;
  final Value<int> primaryColor;
  final Value<int> textColor;
  final Value<int> surfaceColor;
  final Value<String> brightness;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ThemeSchemesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.primaryColor = const Value.absent(),
    this.textColor = const Value.absent(),
    this.surfaceColor = const Value.absent(),
    this.brightness = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThemeSchemesCompanion.insert({
    required String id,
    required String name,
    required int backgroundColor,
    required int primaryColor,
    required int textColor,
    required int surfaceColor,
    this.brightness = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        backgroundColor = Value(backgroundColor),
        primaryColor = Value(primaryColor),
        textColor = Value(textColor),
        surfaceColor = Value(surfaceColor),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ThemeSchemeRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? backgroundColor,
    Expression<int>? primaryColor,
    Expression<int>? textColor,
    Expression<int>? surfaceColor,
    Expression<String>? brightness,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (primaryColor != null) 'primary_color': primaryColor,
      if (textColor != null) 'text_color': textColor,
      if (surfaceColor != null) 'surface_color': surfaceColor,
      if (brightness != null) 'brightness': brightness,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThemeSchemesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? backgroundColor,
      Value<int>? primaryColor,
      Value<int>? textColor,
      Value<int>? surfaceColor,
      Value<String>? brightness,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ThemeSchemesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      primaryColor: primaryColor ?? this.primaryColor,
      textColor: textColor ?? this.textColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      brightness: brightness ?? this.brightness,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<int>(backgroundColor.value);
    }
    if (primaryColor.present) {
      map['primary_color'] = Variable<int>(primaryColor.value);
    }
    if (textColor.present) {
      map['text_color'] = Variable<int>(textColor.value);
    }
    if (surfaceColor.present) {
      map['surface_color'] = Variable<int>(surfaceColor.value);
    }
    if (brightness.present) {
      map['brightness'] = Variable<String>(brightness.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThemeSchemesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('textColor: $textColor, ')
          ..write('surfaceColor: $surfaceColor, ')
          ..write('brightness: $brightness, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncLogsTable extends SyncLogs
    with TableInfo<$SyncLogsTable, SyncLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _peerDeviceIdMeta =
      const VerificationMeta('peerDeviceId');
  @override
  late final GeneratedColumn<String> peerDeviceId = GeneratedColumn<String>(
      'peer_device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _peerDeviceNameMeta =
      const VerificationMeta('peerDeviceName');
  @override
  late final GeneratedColumn<String> peerDeviceName = GeneratedColumn<String>(
      'peer_device_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
      'started_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _finishedAtMeta =
      const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<int> finishedAt = GeneratedColumn<int>(
      'finished_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesCreatedMeta =
      const VerificationMeta('notesCreated');
  @override
  late final GeneratedColumn<int> notesCreated = GeneratedColumn<int>(
      'notes_created', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesUpdatedMeta =
      const VerificationMeta('notesUpdated');
  @override
  late final GeneratedColumn<int> notesUpdated = GeneratedColumn<int>(
      'notes_updated', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesDeletedMeta =
      const VerificationMeta('notesDeleted');
  @override
  late final GeneratedColumn<int> notesDeleted = GeneratedColumn<int>(
      'notes_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _todosCreatedMeta =
      const VerificationMeta('todosCreated');
  @override
  late final GeneratedColumn<int> todosCreated = GeneratedColumn<int>(
      'todos_created', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _todosUpdatedMeta =
      const VerificationMeta('todosUpdated');
  @override
  late final GeneratedColumn<int> todosUpdated = GeneratedColumn<int>(
      'todos_updated', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _todosDeletedMeta =
      const VerificationMeta('todosDeleted');
  @override
  late final GeneratedColumn<int> todosDeleted = GeneratedColumn<int>(
      'todos_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        peerDeviceId,
        peerDeviceName,
        startedAt,
        finishedAt,
        status,
        notesCreated,
        notesUpdated,
        notesDeleted,
        todosCreated,
        todosUpdated,
        todosDeleted,
        errorMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_logs';
  @override
  VerificationContext validateIntegrity(Insertable<SyncLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('peer_device_id')) {
      context.handle(
          _peerDeviceIdMeta,
          peerDeviceId.isAcceptableOrUnknown(
              data['peer_device_id']!, _peerDeviceIdMeta));
    }
    if (data.containsKey('peer_device_name')) {
      context.handle(
          _peerDeviceNameMeta,
          peerDeviceName.isAcceptableOrUnknown(
              data['peer_device_name']!, _peerDeviceNameMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
          _finishedAtMeta,
          finishedAt.isAcceptableOrUnknown(
              data['finished_at']!, _finishedAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes_created')) {
      context.handle(
          _notesCreatedMeta,
          notesCreated.isAcceptableOrUnknown(
              data['notes_created']!, _notesCreatedMeta));
    }
    if (data.containsKey('notes_updated')) {
      context.handle(
          _notesUpdatedMeta,
          notesUpdated.isAcceptableOrUnknown(
              data['notes_updated']!, _notesUpdatedMeta));
    }
    if (data.containsKey('notes_deleted')) {
      context.handle(
          _notesDeletedMeta,
          notesDeleted.isAcceptableOrUnknown(
              data['notes_deleted']!, _notesDeletedMeta));
    }
    if (data.containsKey('todos_created')) {
      context.handle(
          _todosCreatedMeta,
          todosCreated.isAcceptableOrUnknown(
              data['todos_created']!, _todosCreatedMeta));
    }
    if (data.containsKey('todos_updated')) {
      context.handle(
          _todosUpdatedMeta,
          todosUpdated.isAcceptableOrUnknown(
              data['todos_updated']!, _todosUpdatedMeta));
    }
    if (data.containsKey('todos_deleted')) {
      context.handle(
          _todosDeletedMeta,
          todosDeleted.isAcceptableOrUnknown(
              data['todos_deleted']!, _todosDeletedMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      peerDeviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}peer_device_id']),
      peerDeviceName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}peer_device_name']),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}started_at'])!,
      finishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}finished_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notesCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notes_created'])!,
      notesUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notes_updated'])!,
      notesDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notes_deleted'])!,
      todosCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}todos_created'])!,
      todosUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}todos_updated'])!,
      todosDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}todos_deleted'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
    );
  }

  @override
  $SyncLogsTable createAlias(String alias) {
    return $SyncLogsTable(attachedDatabase, alias);
  }
}

class SyncLogRow extends DataClass implements Insertable<SyncLogRow> {
  final String id;
  final String? peerDeviceId;
  final String? peerDeviceName;
  final int startedAt;
  final int? finishedAt;
  final String status;
  final int notesCreated;
  final int notesUpdated;
  final int notesDeleted;
  final int todosCreated;
  final int todosUpdated;
  final int todosDeleted;
  final String? errorMessage;
  const SyncLogRow(
      {required this.id,
      this.peerDeviceId,
      this.peerDeviceName,
      required this.startedAt,
      this.finishedAt,
      required this.status,
      required this.notesCreated,
      required this.notesUpdated,
      required this.notesDeleted,
      required this.todosCreated,
      required this.todosUpdated,
      required this.todosDeleted,
      this.errorMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || peerDeviceId != null) {
      map['peer_device_id'] = Variable<String>(peerDeviceId);
    }
    if (!nullToAbsent || peerDeviceName != null) {
      map['peer_device_name'] = Variable<String>(peerDeviceName);
    }
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<int>(finishedAt);
    }
    map['status'] = Variable<String>(status);
    map['notes_created'] = Variable<int>(notesCreated);
    map['notes_updated'] = Variable<int>(notesUpdated);
    map['notes_deleted'] = Variable<int>(notesDeleted);
    map['todos_created'] = Variable<int>(todosCreated);
    map['todos_updated'] = Variable<int>(todosUpdated);
    map['todos_deleted'] = Variable<int>(todosDeleted);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  SyncLogsCompanion toCompanion(bool nullToAbsent) {
    return SyncLogsCompanion(
      id: Value(id),
      peerDeviceId: peerDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(peerDeviceId),
      peerDeviceName: peerDeviceName == null && nullToAbsent
          ? const Value.absent()
          : Value(peerDeviceName),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      status: Value(status),
      notesCreated: Value(notesCreated),
      notesUpdated: Value(notesUpdated),
      notesDeleted: Value(notesDeleted),
      todosCreated: Value(todosCreated),
      todosUpdated: Value(todosUpdated),
      todosDeleted: Value(todosDeleted),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory SyncLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLogRow(
      id: serializer.fromJson<String>(json['id']),
      peerDeviceId: serializer.fromJson<String?>(json['peerDeviceId']),
      peerDeviceName: serializer.fromJson<String?>(json['peerDeviceName']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      finishedAt: serializer.fromJson<int?>(json['finishedAt']),
      status: serializer.fromJson<String>(json['status']),
      notesCreated: serializer.fromJson<int>(json['notesCreated']),
      notesUpdated: serializer.fromJson<int>(json['notesUpdated']),
      notesDeleted: serializer.fromJson<int>(json['notesDeleted']),
      todosCreated: serializer.fromJson<int>(json['todosCreated']),
      todosUpdated: serializer.fromJson<int>(json['todosUpdated']),
      todosDeleted: serializer.fromJson<int>(json['todosDeleted']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'peerDeviceId': serializer.toJson<String?>(peerDeviceId),
      'peerDeviceName': serializer.toJson<String?>(peerDeviceName),
      'startedAt': serializer.toJson<int>(startedAt),
      'finishedAt': serializer.toJson<int?>(finishedAt),
      'status': serializer.toJson<String>(status),
      'notesCreated': serializer.toJson<int>(notesCreated),
      'notesUpdated': serializer.toJson<int>(notesUpdated),
      'notesDeleted': serializer.toJson<int>(notesDeleted),
      'todosCreated': serializer.toJson<int>(todosCreated),
      'todosUpdated': serializer.toJson<int>(todosUpdated),
      'todosDeleted': serializer.toJson<int>(todosDeleted),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  SyncLogRow copyWith(
          {String? id,
          Value<String?> peerDeviceId = const Value.absent(),
          Value<String?> peerDeviceName = const Value.absent(),
          int? startedAt,
          Value<int?> finishedAt = const Value.absent(),
          String? status,
          int? notesCreated,
          int? notesUpdated,
          int? notesDeleted,
          int? todosCreated,
          int? todosUpdated,
          int? todosDeleted,
          Value<String?> errorMessage = const Value.absent()}) =>
      SyncLogRow(
        id: id ?? this.id,
        peerDeviceId:
            peerDeviceId.present ? peerDeviceId.value : this.peerDeviceId,
        peerDeviceName:
            peerDeviceName.present ? peerDeviceName.value : this.peerDeviceName,
        startedAt: startedAt ?? this.startedAt,
        finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
        status: status ?? this.status,
        notesCreated: notesCreated ?? this.notesCreated,
        notesUpdated: notesUpdated ?? this.notesUpdated,
        notesDeleted: notesDeleted ?? this.notesDeleted,
        todosCreated: todosCreated ?? this.todosCreated,
        todosUpdated: todosUpdated ?? this.todosUpdated,
        todosDeleted: todosDeleted ?? this.todosDeleted,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
      );
  SyncLogRow copyWithCompanion(SyncLogsCompanion data) {
    return SyncLogRow(
      id: data.id.present ? data.id.value : this.id,
      peerDeviceId: data.peerDeviceId.present
          ? data.peerDeviceId.value
          : this.peerDeviceId,
      peerDeviceName: data.peerDeviceName.present
          ? data.peerDeviceName.value
          : this.peerDeviceName,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt:
          data.finishedAt.present ? data.finishedAt.value : this.finishedAt,
      status: data.status.present ? data.status.value : this.status,
      notesCreated: data.notesCreated.present
          ? data.notesCreated.value
          : this.notesCreated,
      notesUpdated: data.notesUpdated.present
          ? data.notesUpdated.value
          : this.notesUpdated,
      notesDeleted: data.notesDeleted.present
          ? data.notesDeleted.value
          : this.notesDeleted,
      todosCreated: data.todosCreated.present
          ? data.todosCreated.value
          : this.todosCreated,
      todosUpdated: data.todosUpdated.present
          ? data.todosUpdated.value
          : this.todosUpdated,
      todosDeleted: data.todosDeleted.present
          ? data.todosDeleted.value
          : this.todosDeleted,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogRow(')
          ..write('id: $id, ')
          ..write('peerDeviceId: $peerDeviceId, ')
          ..write('peerDeviceName: $peerDeviceName, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status, ')
          ..write('notesCreated: $notesCreated, ')
          ..write('notesUpdated: $notesUpdated, ')
          ..write('notesDeleted: $notesDeleted, ')
          ..write('todosCreated: $todosCreated, ')
          ..write('todosUpdated: $todosUpdated, ')
          ..write('todosDeleted: $todosDeleted, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      peerDeviceId,
      peerDeviceName,
      startedAt,
      finishedAt,
      status,
      notesCreated,
      notesUpdated,
      notesDeleted,
      todosCreated,
      todosUpdated,
      todosDeleted,
      errorMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLogRow &&
          other.id == this.id &&
          other.peerDeviceId == this.peerDeviceId &&
          other.peerDeviceName == this.peerDeviceName &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.status == this.status &&
          other.notesCreated == this.notesCreated &&
          other.notesUpdated == this.notesUpdated &&
          other.notesDeleted == this.notesDeleted &&
          other.todosCreated == this.todosCreated &&
          other.todosUpdated == this.todosUpdated &&
          other.todosDeleted == this.todosDeleted &&
          other.errorMessage == this.errorMessage);
}

class SyncLogsCompanion extends UpdateCompanion<SyncLogRow> {
  final Value<String> id;
  final Value<String?> peerDeviceId;
  final Value<String?> peerDeviceName;
  final Value<int> startedAt;
  final Value<int?> finishedAt;
  final Value<String> status;
  final Value<int> notesCreated;
  final Value<int> notesUpdated;
  final Value<int> notesDeleted;
  final Value<int> todosCreated;
  final Value<int> todosUpdated;
  final Value<int> todosDeleted;
  final Value<String?> errorMessage;
  final Value<int> rowid;
  const SyncLogsCompanion({
    this.id = const Value.absent(),
    this.peerDeviceId = const Value.absent(),
    this.peerDeviceName = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.notesCreated = const Value.absent(),
    this.notesUpdated = const Value.absent(),
    this.notesDeleted = const Value.absent(),
    this.todosCreated = const Value.absent(),
    this.todosUpdated = const Value.absent(),
    this.todosDeleted = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncLogsCompanion.insert({
    required String id,
    this.peerDeviceId = const Value.absent(),
    this.peerDeviceName = const Value.absent(),
    required int startedAt,
    this.finishedAt = const Value.absent(),
    required String status,
    this.notesCreated = const Value.absent(),
    this.notesUpdated = const Value.absent(),
    this.notesDeleted = const Value.absent(),
    this.todosCreated = const Value.absent(),
    this.todosUpdated = const Value.absent(),
    this.todosDeleted = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startedAt = Value(startedAt),
        status = Value(status);
  static Insertable<SyncLogRow> custom({
    Expression<String>? id,
    Expression<String>? peerDeviceId,
    Expression<String>? peerDeviceName,
    Expression<int>? startedAt,
    Expression<int>? finishedAt,
    Expression<String>? status,
    Expression<int>? notesCreated,
    Expression<int>? notesUpdated,
    Expression<int>? notesDeleted,
    Expression<int>? todosCreated,
    Expression<int>? todosUpdated,
    Expression<int>? todosDeleted,
    Expression<String>? errorMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (peerDeviceId != null) 'peer_device_id': peerDeviceId,
      if (peerDeviceName != null) 'peer_device_name': peerDeviceName,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (status != null) 'status': status,
      if (notesCreated != null) 'notes_created': notesCreated,
      if (notesUpdated != null) 'notes_updated': notesUpdated,
      if (notesDeleted != null) 'notes_deleted': notesDeleted,
      if (todosCreated != null) 'todos_created': todosCreated,
      if (todosUpdated != null) 'todos_updated': todosUpdated,
      if (todosDeleted != null) 'todos_deleted': todosDeleted,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncLogsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? peerDeviceId,
      Value<String?>? peerDeviceName,
      Value<int>? startedAt,
      Value<int?>? finishedAt,
      Value<String>? status,
      Value<int>? notesCreated,
      Value<int>? notesUpdated,
      Value<int>? notesDeleted,
      Value<int>? todosCreated,
      Value<int>? todosUpdated,
      Value<int>? todosDeleted,
      Value<String?>? errorMessage,
      Value<int>? rowid}) {
    return SyncLogsCompanion(
      id: id ?? this.id,
      peerDeviceId: peerDeviceId ?? this.peerDeviceId,
      peerDeviceName: peerDeviceName ?? this.peerDeviceName,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
      notesCreated: notesCreated ?? this.notesCreated,
      notesUpdated: notesUpdated ?? this.notesUpdated,
      notesDeleted: notesDeleted ?? this.notesDeleted,
      todosCreated: todosCreated ?? this.todosCreated,
      todosUpdated: todosUpdated ?? this.todosUpdated,
      todosDeleted: todosDeleted ?? this.todosDeleted,
      errorMessage: errorMessage ?? this.errorMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (peerDeviceId.present) {
      map['peer_device_id'] = Variable<String>(peerDeviceId.value);
    }
    if (peerDeviceName.present) {
      map['peer_device_name'] = Variable<String>(peerDeviceName.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<int>(finishedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notesCreated.present) {
      map['notes_created'] = Variable<int>(notesCreated.value);
    }
    if (notesUpdated.present) {
      map['notes_updated'] = Variable<int>(notesUpdated.value);
    }
    if (notesDeleted.present) {
      map['notes_deleted'] = Variable<int>(notesDeleted.value);
    }
    if (todosCreated.present) {
      map['todos_created'] = Variable<int>(todosCreated.value);
    }
    if (todosUpdated.present) {
      map['todos_updated'] = Variable<int>(todosUpdated.value);
    }
    if (todosDeleted.present) {
      map['todos_deleted'] = Variable<int>(todosDeleted.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogsCompanion(')
          ..write('id: $id, ')
          ..write('peerDeviceId: $peerDeviceId, ')
          ..write('peerDeviceName: $peerDeviceName, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status, ')
          ..write('notesCreated: $notesCreated, ')
          ..write('notesUpdated: $notesUpdated, ')
          ..write('notesDeleted: $notesDeleted, ')
          ..write('todosCreated: $todosCreated, ')
          ..write('todosUpdated: $todosUpdated, ')
          ..write('todosDeleted: $todosDeleted, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSettingRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String value;
  const AppSettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppSettingRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingRow copyWith({String? key, String? value}) => AppSettingRow(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskListsTable extends TaskLists
    with TableInfo<$TaskListsTable, TaskListRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _iconKeyMeta =
      const VerificationMeta('iconKey');
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
      'icon_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _archivedMeta =
      const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
      'archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        color,
        iconKey,
        sortOrder,
        archived,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_lists';
  @override
  VerificationContext validateIntegrity(Insertable<TaskListRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(_iconKeyMeta,
          iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta));
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta,
          archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskListRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskListRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      iconKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_key'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      archived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $TaskListsTable createAlias(String alias) {
    return $TaskListsTable(attachedDatabase, alias);
  }
}

class TaskListRow extends DataClass implements Insertable<TaskListRow> {
  final String id;
  final String name;
  final int color;
  final String iconKey;
  final int sortOrder;
  final bool archived;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const TaskListRow(
      {required this.id,
      required this.name,
      required this.color,
      required this.iconKey,
      required this.sortOrder,
      required this.archived,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['icon_key'] = Variable<String>(iconKey);
    map['sort_order'] = Variable<int>(sortOrder);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  TaskListsCompanion toCompanion(bool nullToAbsent) {
    return TaskListsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      iconKey: Value(iconKey),
      sortOrder: Value(sortOrder),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory TaskListRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskListRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'iconKey': serializer.toJson<String>(iconKey),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  TaskListRow copyWith(
          {String? id,
          String? name,
          int? color,
          String? iconKey,
          int? sortOrder,
          bool? archived,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      TaskListRow(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        iconKey: iconKey ?? this.iconKey,
        sortOrder: sortOrder ?? this.sortOrder,
        archived: archived ?? this.archived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  TaskListRow copyWithCompanion(TaskListsCompanion data) {
    return TaskListRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskListRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconKey: $iconKey, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, iconKey, sortOrder, archived,
      createdAt, updatedAt, deletedAt, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskListRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.iconKey == this.iconKey &&
          other.sortOrder == this.sortOrder &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class TaskListsCompanion extends UpdateCompanion<TaskListRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> color;
  final Value<String> iconKey;
  final Value<int> sortOrder;
  final Value<bool> archived;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const TaskListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskListsCompanion.insert({
    required String id,
    required String name,
    required int color,
    required String iconKey,
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        color = Value(color),
        iconKey = Value(iconKey),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<TaskListRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? iconKey,
    Expression<int>? sortOrder,
    Expression<bool>? archived,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (iconKey != null) 'icon_key': iconKey,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskListsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? color,
      Value<String>? iconKey,
      Value<int>? sortOrder,
      Value<bool>? archived,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return TaskListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      iconKey: iconKey ?? this.iconKey,
      sortOrder: sortOrder ?? this.sortOrder,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconKey: $iconKey, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksV2Table extends TasksV2 with TableInfo<$TasksV2Table, TaskV2Row> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksV2Table(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
      'list_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMarkdownMeta =
      const VerificationMeta('descriptionMarkdown');
  @override
  late final GeneratedColumn<String> descriptionMarkdown =
      GeneratedColumn<String>('description_markdown', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      check: () => ComparableExpr(priority).isBetweenValues(0, 3),
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startAtMeta =
      const VerificationMeta('startAt');
  @override
  late final GeneratedColumn<int> startAt = GeneratedColumn<int>(
      'start_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<int> dueAt = GeneratedColumn<int>(
      'due_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _allDayMeta = const VerificationMeta('allDay');
  @override
  late final GeneratedColumn<bool> allDay = GeneratedColumn<bool>(
      'all_day', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("all_day" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceEndAtMeta =
      const VerificationMeta('recurrenceEndAt');
  @override
  late final GeneratedColumn<int> recurrenceEndAt = GeneratedColumn<int>(
      'recurrence_end_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceCountMeta =
      const VerificationMeta('recurrenceCount');
  @override
  late final GeneratedColumn<int> recurrenceCount = GeneratedColumn<int>(
      'recurrence_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        parentId,
        listId,
        title,
        descriptionMarkdown,
        completed,
        priority,
        startAt,
        dueAt,
        allDay,
        sortOrder,
        recurrenceRule,
        recurrenceEndAt,
        recurrenceCount,
        completedAt,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_v2';
  @override
  VerificationContext validateIntegrity(Insertable<TaskV2Row> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('list_id')) {
      context.handle(_listIdMeta,
          listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description_markdown')) {
      context.handle(
          _descriptionMarkdownMeta,
          descriptionMarkdown.isAcceptableOrUnknown(
              data['description_markdown']!, _descriptionMarkdownMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('start_at')) {
      context.handle(_startAtMeta,
          startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    }
    if (data.containsKey('all_day')) {
      context.handle(_allDayMeta,
          allDay.isAcceptableOrUnknown(data['all_day']!, _allDayMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    }
    if (data.containsKey('recurrence_end_at')) {
      context.handle(
          _recurrenceEndAtMeta,
          recurrenceEndAt.isAcceptableOrUnknown(
              data['recurrence_end_at']!, _recurrenceEndAtMeta));
    }
    if (data.containsKey('recurrence_count')) {
      context.handle(
          _recurrenceCountMeta,
          recurrenceCount.isAcceptableOrUnknown(
              data['recurrence_count']!, _recurrenceCountMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskV2Row map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskV2Row(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      listId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}list_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      descriptionMarkdown: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}description_markdown'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      startAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_at']),
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_at']),
      allDay: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}all_day'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      recurrenceRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
      recurrenceEndAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence_end_at']),
      recurrenceCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence_count']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $TasksV2Table createAlias(String alias) {
    return $TasksV2Table(attachedDatabase, alias);
  }
}

class TaskV2Row extends DataClass implements Insertable<TaskV2Row> {
  final String id;
  final String? parentId;
  final String? listId;
  final String title;
  final String descriptionMarkdown;
  final bool completed;
  final int priority;
  final int? startAt;
  final int? dueAt;
  final bool allDay;
  final int sortOrder;
  final String? recurrenceRule;
  final int? recurrenceEndAt;
  final int? recurrenceCount;
  final int? completedAt;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const TaskV2Row(
      {required this.id,
      this.parentId,
      this.listId,
      required this.title,
      required this.descriptionMarkdown,
      required this.completed,
      required this.priority,
      this.startAt,
      this.dueAt,
      required this.allDay,
      required this.sortOrder,
      this.recurrenceRule,
      this.recurrenceEndAt,
      this.recurrenceCount,
      this.completedAt,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || listId != null) {
      map['list_id'] = Variable<String>(listId);
    }
    map['title'] = Variable<String>(title);
    map['description_markdown'] = Variable<String>(descriptionMarkdown);
    map['completed'] = Variable<bool>(completed);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || startAt != null) {
      map['start_at'] = Variable<int>(startAt);
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<int>(dueAt);
    }
    map['all_day'] = Variable<bool>(allDay);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || recurrenceEndAt != null) {
      map['recurrence_end_at'] = Variable<int>(recurrenceEndAt);
    }
    if (!nullToAbsent || recurrenceCount != null) {
      map['recurrence_count'] = Variable<int>(recurrenceCount);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  TasksV2Companion toCompanion(bool nullToAbsent) {
    return TasksV2Companion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      listId:
          listId == null && nullToAbsent ? const Value.absent() : Value(listId),
      title: Value(title),
      descriptionMarkdown: Value(descriptionMarkdown),
      completed: Value(completed),
      priority: Value(priority),
      startAt: startAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startAt),
      dueAt:
          dueAt == null && nullToAbsent ? const Value.absent() : Value(dueAt),
      allDay: Value(allDay),
      sortOrder: Value(sortOrder),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      recurrenceEndAt: recurrenceEndAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceEndAt),
      recurrenceCount: recurrenceCount == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceCount),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory TaskV2Row.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskV2Row(
      id: serializer.fromJson<String>(json['id']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      listId: serializer.fromJson<String?>(json['listId']),
      title: serializer.fromJson<String>(json['title']),
      descriptionMarkdown:
          serializer.fromJson<String>(json['descriptionMarkdown']),
      completed: serializer.fromJson<bool>(json['completed']),
      priority: serializer.fromJson<int>(json['priority']),
      startAt: serializer.fromJson<int?>(json['startAt']),
      dueAt: serializer.fromJson<int?>(json['dueAt']),
      allDay: serializer.fromJson<bool>(json['allDay']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      recurrenceEndAt: serializer.fromJson<int?>(json['recurrenceEndAt']),
      recurrenceCount: serializer.fromJson<int?>(json['recurrenceCount']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentId': serializer.toJson<String?>(parentId),
      'listId': serializer.toJson<String?>(listId),
      'title': serializer.toJson<String>(title),
      'descriptionMarkdown': serializer.toJson<String>(descriptionMarkdown),
      'completed': serializer.toJson<bool>(completed),
      'priority': serializer.toJson<int>(priority),
      'startAt': serializer.toJson<int?>(startAt),
      'dueAt': serializer.toJson<int?>(dueAt),
      'allDay': serializer.toJson<bool>(allDay),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'recurrenceEndAt': serializer.toJson<int?>(recurrenceEndAt),
      'recurrenceCount': serializer.toJson<int?>(recurrenceCount),
      'completedAt': serializer.toJson<int?>(completedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  TaskV2Row copyWith(
          {String? id,
          Value<String?> parentId = const Value.absent(),
          Value<String?> listId = const Value.absent(),
          String? title,
          String? descriptionMarkdown,
          bool? completed,
          int? priority,
          Value<int?> startAt = const Value.absent(),
          Value<int?> dueAt = const Value.absent(),
          bool? allDay,
          int? sortOrder,
          Value<String?> recurrenceRule = const Value.absent(),
          Value<int?> recurrenceEndAt = const Value.absent(),
          Value<int?> recurrenceCount = const Value.absent(),
          Value<int?> completedAt = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      TaskV2Row(
        id: id ?? this.id,
        parentId: parentId.present ? parentId.value : this.parentId,
        listId: listId.present ? listId.value : this.listId,
        title: title ?? this.title,
        descriptionMarkdown: descriptionMarkdown ?? this.descriptionMarkdown,
        completed: completed ?? this.completed,
        priority: priority ?? this.priority,
        startAt: startAt.present ? startAt.value : this.startAt,
        dueAt: dueAt.present ? dueAt.value : this.dueAt,
        allDay: allDay ?? this.allDay,
        sortOrder: sortOrder ?? this.sortOrder,
        recurrenceRule:
            recurrenceRule.present ? recurrenceRule.value : this.recurrenceRule,
        recurrenceEndAt: recurrenceEndAt.present
            ? recurrenceEndAt.value
            : this.recurrenceEndAt,
        recurrenceCount: recurrenceCount.present
            ? recurrenceCount.value
            : this.recurrenceCount,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  TaskV2Row copyWithCompanion(TasksV2Companion data) {
    return TaskV2Row(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      listId: data.listId.present ? data.listId.value : this.listId,
      title: data.title.present ? data.title.value : this.title,
      descriptionMarkdown: data.descriptionMarkdown.present
          ? data.descriptionMarkdown.value
          : this.descriptionMarkdown,
      completed: data.completed.present ? data.completed.value : this.completed,
      priority: data.priority.present ? data.priority.value : this.priority,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      allDay: data.allDay.present ? data.allDay.value : this.allDay,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      recurrenceEndAt: data.recurrenceEndAt.present
          ? data.recurrenceEndAt.value
          : this.recurrenceEndAt,
      recurrenceCount: data.recurrenceCount.present
          ? data.recurrenceCount.value
          : this.recurrenceCount,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskV2Row(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('listId: $listId, ')
          ..write('title: $title, ')
          ..write('descriptionMarkdown: $descriptionMarkdown, ')
          ..write('completed: $completed, ')
          ..write('priority: $priority, ')
          ..write('startAt: $startAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('allDay: $allDay, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurrenceEndAt: $recurrenceEndAt, ')
          ..write('recurrenceCount: $recurrenceCount, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      parentId,
      listId,
      title,
      descriptionMarkdown,
      completed,
      priority,
      startAt,
      dueAt,
      allDay,
      sortOrder,
      recurrenceRule,
      recurrenceEndAt,
      recurrenceCount,
      completedAt,
      createdAt,
      updatedAt,
      deletedAt,
      deviceId,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskV2Row &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.listId == this.listId &&
          other.title == this.title &&
          other.descriptionMarkdown == this.descriptionMarkdown &&
          other.completed == this.completed &&
          other.priority == this.priority &&
          other.startAt == this.startAt &&
          other.dueAt == this.dueAt &&
          other.allDay == this.allDay &&
          other.sortOrder == this.sortOrder &&
          other.recurrenceRule == this.recurrenceRule &&
          other.recurrenceEndAt == this.recurrenceEndAt &&
          other.recurrenceCount == this.recurrenceCount &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class TasksV2Companion extends UpdateCompanion<TaskV2Row> {
  final Value<String> id;
  final Value<String?> parentId;
  final Value<String?> listId;
  final Value<String> title;
  final Value<String> descriptionMarkdown;
  final Value<bool> completed;
  final Value<int> priority;
  final Value<int?> startAt;
  final Value<int?> dueAt;
  final Value<bool> allDay;
  final Value<int> sortOrder;
  final Value<String?> recurrenceRule;
  final Value<int?> recurrenceEndAt;
  final Value<int?> recurrenceCount;
  final Value<int?> completedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const TasksV2Companion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.listId = const Value.absent(),
    this.title = const Value.absent(),
    this.descriptionMarkdown = const Value.absent(),
    this.completed = const Value.absent(),
    this.priority = const Value.absent(),
    this.startAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.allDay = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurrenceEndAt = const Value.absent(),
    this.recurrenceCount = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksV2Companion.insert({
    required String id,
    this.parentId = const Value.absent(),
    this.listId = const Value.absent(),
    required String title,
    this.descriptionMarkdown = const Value.absent(),
    this.completed = const Value.absent(),
    this.priority = const Value.absent(),
    this.startAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.allDay = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurrenceEndAt = const Value.absent(),
    this.recurrenceCount = const Value.absent(),
    this.completedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<TaskV2Row> custom({
    Expression<String>? id,
    Expression<String>? parentId,
    Expression<String>? listId,
    Expression<String>? title,
    Expression<String>? descriptionMarkdown,
    Expression<bool>? completed,
    Expression<int>? priority,
    Expression<int>? startAt,
    Expression<int>? dueAt,
    Expression<bool>? allDay,
    Expression<int>? sortOrder,
    Expression<String>? recurrenceRule,
    Expression<int>? recurrenceEndAt,
    Expression<int>? recurrenceCount,
    Expression<int>? completedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (listId != null) 'list_id': listId,
      if (title != null) 'title': title,
      if (descriptionMarkdown != null)
        'description_markdown': descriptionMarkdown,
      if (completed != null) 'completed': completed,
      if (priority != null) 'priority': priority,
      if (startAt != null) 'start_at': startAt,
      if (dueAt != null) 'due_at': dueAt,
      if (allDay != null) 'all_day': allDay,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (recurrenceEndAt != null) 'recurrence_end_at': recurrenceEndAt,
      if (recurrenceCount != null) 'recurrence_count': recurrenceCount,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksV2Companion copyWith(
      {Value<String>? id,
      Value<String?>? parentId,
      Value<String?>? listId,
      Value<String>? title,
      Value<String>? descriptionMarkdown,
      Value<bool>? completed,
      Value<int>? priority,
      Value<int?>? startAt,
      Value<int?>? dueAt,
      Value<bool>? allDay,
      Value<int>? sortOrder,
      Value<String?>? recurrenceRule,
      Value<int?>? recurrenceEndAt,
      Value<int?>? recurrenceCount,
      Value<int?>? completedAt,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return TasksV2Companion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      descriptionMarkdown: descriptionMarkdown ?? this.descriptionMarkdown,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      startAt: startAt ?? this.startAt,
      dueAt: dueAt ?? this.dueAt,
      allDay: allDay ?? this.allDay,
      sortOrder: sortOrder ?? this.sortOrder,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      recurrenceEndAt: recurrenceEndAt ?? this.recurrenceEndAt,
      recurrenceCount: recurrenceCount ?? this.recurrenceCount,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (descriptionMarkdown.present) {
      map['description_markdown'] = Variable<String>(descriptionMarkdown.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<int>(startAt.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<int>(dueAt.value);
    }
    if (allDay.present) {
      map['all_day'] = Variable<bool>(allDay.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (recurrenceEndAt.present) {
      map['recurrence_end_at'] = Variable<int>(recurrenceEndAt.value);
    }
    if (recurrenceCount.present) {
      map['recurrence_count'] = Variable<int>(recurrenceCount.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksV2Companion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('listId: $listId, ')
          ..write('title: $title, ')
          ..write('descriptionMarkdown: $descriptionMarkdown, ')
          ..write('completed: $completed, ')
          ..write('priority: $priority, ')
          ..write('startAt: $startAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('allDay: $allDay, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurrenceEndAt: $recurrenceEndAt, ')
          ..write('recurrenceCount: $recurrenceCount, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskCompletionsTable extends TaskCompletions
    with TableInfo<$TaskCompletionsTable, TaskCompletionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<int> scheduledAt = GeneratedColumn<int>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        taskId,
        scheduledAt,
        completedAt,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_completions';
  @override
  VerificationContext validateIntegrity(Insertable<TaskCompletionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCompletionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCompletionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheduled_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $TaskCompletionsTable createAlias(String alias) {
    return $TaskCompletionsTable(attachedDatabase, alias);
  }
}

class TaskCompletionRow extends DataClass
    implements Insertable<TaskCompletionRow> {
  final String id;
  final String taskId;
  final int scheduledAt;
  final int completedAt;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const TaskCompletionRow(
      {required this.id,
      required this.taskId,
      required this.scheduledAt,
      required this.completedAt,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['scheduled_at'] = Variable<int>(scheduledAt);
    map['completed_at'] = Variable<int>(completedAt);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  TaskCompletionsCompanion toCompanion(bool nullToAbsent) {
    return TaskCompletionsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      scheduledAt: Value(scheduledAt),
      completedAt: Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory TaskCompletionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCompletionRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      scheduledAt: serializer.fromJson<int>(json['scheduledAt']),
      completedAt: serializer.fromJson<int>(json['completedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'scheduledAt': serializer.toJson<int>(scheduledAt),
      'completedAt': serializer.toJson<int>(completedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  TaskCompletionRow copyWith(
          {String? id,
          String? taskId,
          int? scheduledAt,
          int? completedAt,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      TaskCompletionRow(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        completedAt: completedAt ?? this.completedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  TaskCompletionRow copyWithCompanion(TaskCompletionsCompanion data) {
    return TaskCompletionRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletionRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, scheduledAt, completedAt,
      createdAt, updatedAt, deletedAt, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCompletionRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.scheduledAt == this.scheduledAt &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class TaskCompletionsCompanion extends UpdateCompanion<TaskCompletionRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<int> scheduledAt;
  final Value<int> completedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const TaskCompletionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskCompletionsCompanion.insert({
    required String id,
    required String taskId,
    required int scheduledAt,
    required int completedAt,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        scheduledAt = Value(scheduledAt),
        completedAt = Value(completedAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<TaskCompletionRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? scheduledAt,
    Expression<int>? completedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskCompletionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<int>? scheduledAt,
      Value<int>? completedAt,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return TaskCompletionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<int>(scheduledAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskRemindersTable extends TaskReminders
    with TableInfo<$TaskRemindersTable, TaskReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggerAtMeta =
      const VerificationMeta('triggerAt');
  @override
  late final GeneratedColumn<int> triggerAt = GeneratedColumn<int>(
      'trigger_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _offsetMinutesMeta =
      const VerificationMeta('offsetMinutes');
  @override
  late final GeneratedColumn<int> offsetMinutes = GeneratedColumn<int>(
      'offset_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _firedAtMeta =
      const VerificationMeta('firedAt');
  @override
  late final GeneratedColumn<int> firedAt = GeneratedColumn<int>(
      'fired_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        taskId,
        triggerAt,
        offsetMinutes,
        firedAt,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_reminders';
  @override
  VerificationContext validateIntegrity(Insertable<TaskReminderRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('trigger_at')) {
      context.handle(_triggerAtMeta,
          triggerAt.isAcceptableOrUnknown(data['trigger_at']!, _triggerAtMeta));
    }
    if (data.containsKey('offset_minutes')) {
      context.handle(
          _offsetMinutesMeta,
          offsetMinutes.isAcceptableOrUnknown(
              data['offset_minutes']!, _offsetMinutesMeta));
    }
    if (data.containsKey('fired_at')) {
      context.handle(_firedAtMeta,
          firedAt.isAcceptableOrUnknown(data['fired_at']!, _firedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskReminderRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      triggerAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trigger_at']),
      offsetMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}offset_minutes']),
      firedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fired_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $TaskRemindersTable createAlias(String alias) {
    return $TaskRemindersTable(attachedDatabase, alias);
  }
}

class TaskReminderRow extends DataClass implements Insertable<TaskReminderRow> {
  final String id;
  final String taskId;
  final int? triggerAt;
  final int? offsetMinutes;
  final int? firedAt;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const TaskReminderRow(
      {required this.id,
      required this.taskId,
      this.triggerAt,
      this.offsetMinutes,
      this.firedAt,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    if (!nullToAbsent || triggerAt != null) {
      map['trigger_at'] = Variable<int>(triggerAt);
    }
    if (!nullToAbsent || offsetMinutes != null) {
      map['offset_minutes'] = Variable<int>(offsetMinutes);
    }
    if (!nullToAbsent || firedAt != null) {
      map['fired_at'] = Variable<int>(firedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  TaskRemindersCompanion toCompanion(bool nullToAbsent) {
    return TaskRemindersCompanion(
      id: Value(id),
      taskId: Value(taskId),
      triggerAt: triggerAt == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerAt),
      offsetMinutes: offsetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(offsetMinutes),
      firedAt: firedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(firedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory TaskReminderRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskReminderRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      triggerAt: serializer.fromJson<int?>(json['triggerAt']),
      offsetMinutes: serializer.fromJson<int?>(json['offsetMinutes']),
      firedAt: serializer.fromJson<int?>(json['firedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'triggerAt': serializer.toJson<int?>(triggerAt),
      'offsetMinutes': serializer.toJson<int?>(offsetMinutes),
      'firedAt': serializer.toJson<int?>(firedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  TaskReminderRow copyWith(
          {String? id,
          String? taskId,
          Value<int?> triggerAt = const Value.absent(),
          Value<int?> offsetMinutes = const Value.absent(),
          Value<int?> firedAt = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      TaskReminderRow(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        triggerAt: triggerAt.present ? triggerAt.value : this.triggerAt,
        offsetMinutes:
            offsetMinutes.present ? offsetMinutes.value : this.offsetMinutes,
        firedAt: firedAt.present ? firedAt.value : this.firedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  TaskReminderRow copyWithCompanion(TaskRemindersCompanion data) {
    return TaskReminderRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      triggerAt: data.triggerAt.present ? data.triggerAt.value : this.triggerAt,
      offsetMinutes: data.offsetMinutes.present
          ? data.offsetMinutes.value
          : this.offsetMinutes,
      firedAt: data.firedAt.present ? data.firedAt.value : this.firedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskReminderRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('triggerAt: $triggerAt, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('firedAt: $firedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, triggerAt, offsetMinutes, firedAt,
      createdAt, updatedAt, deletedAt, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskReminderRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.triggerAt == this.triggerAt &&
          other.offsetMinutes == this.offsetMinutes &&
          other.firedAt == this.firedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class TaskRemindersCompanion extends UpdateCompanion<TaskReminderRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<int?> triggerAt;
  final Value<int?> offsetMinutes;
  final Value<int?> firedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const TaskRemindersCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.triggerAt = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    this.firedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskRemindersCompanion.insert({
    required String id,
    required String taskId,
    this.triggerAt = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    this.firedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<TaskReminderRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? triggerAt,
    Expression<int>? offsetMinutes,
    Expression<int>? firedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (triggerAt != null) 'trigger_at': triggerAt,
      if (offsetMinutes != null) 'offset_minutes': offsetMinutes,
      if (firedAt != null) 'fired_at': firedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskRemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<int?>? triggerAt,
      Value<int?>? offsetMinutes,
      Value<int?>? firedAt,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return TaskRemindersCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      triggerAt: triggerAt ?? this.triggerAt,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
      firedAt: firedAt ?? this.firedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (triggerAt.present) {
      map['trigger_at'] = Variable<int>(triggerAt.value);
    }
    if (offsetMinutes.present) {
      map['offset_minutes'] = Variable<int>(offsetMinutes.value);
    }
    if (firedAt.present) {
      map['fired_at'] = Variable<int>(firedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRemindersCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('triggerAt: $triggerAt, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('firedAt: $firedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskTagsTable extends TaskTags
    with TableInfo<$TaskTagsTable, TaskTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, color, createdAt, updatedAt, deletedAt, deviceId, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_tags';
  @override
  VerificationContext validateIntegrity(Insertable<TaskTagRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTagRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $TaskTagsTable createAlias(String alias) {
    return $TaskTagsTable(attachedDatabase, alias);
  }
}

class TaskTagRow extends DataClass implements Insertable<TaskTagRow> {
  final String id;
  final String name;
  final int color;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const TaskTagRow(
      {required this.id,
      required this.name,
      required this.color,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  TaskTagsCompanion toCompanion(bool nullToAbsent) {
    return TaskTagsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory TaskTagRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTagRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  TaskTagRow copyWith(
          {String? id,
          String? name,
          int? color,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      TaskTagRow(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  TaskTagRow copyWithCompanion(TaskTagsCompanion data) {
    return TaskTagRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskTagRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, color, createdAt, updatedAt, deletedAt, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTagRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class TaskTagsCompanion extends UpdateCompanion<TaskTagRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> color;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const TaskTagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskTagsCompanion.insert({
    required String id,
    required String name,
    required int color,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        color = Value(color),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<TaskTagRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskTagsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? color,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return TaskTagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskTagLinksTable extends TaskTagLinks
    with TableInfo<$TaskTagLinksTable, TaskTagLinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTagLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [taskId, tagId, createdAt, updatedAt, deletedAt, deviceId, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_tag_links';
  @override
  VerificationContext validateIntegrity(Insertable<TaskTagLinkRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, tagId};
  @override
  TaskTagLinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTagLinkRow(
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $TaskTagLinksTable createAlias(String alias) {
    return $TaskTagLinksTable(attachedDatabase, alias);
  }
}

class TaskTagLinkRow extends DataClass implements Insertable<TaskTagLinkRow> {
  final String taskId;
  final String tagId;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const TaskTagLinkRow(
      {required this.taskId,
      required this.tagId,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['tag_id'] = Variable<String>(tagId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  TaskTagLinksCompanion toCompanion(bool nullToAbsent) {
    return TaskTagLinksCompanion(
      taskId: Value(taskId),
      tagId: Value(tagId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory TaskTagLinkRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTagLinkRow(
      taskId: serializer.fromJson<String>(json['taskId']),
      tagId: serializer.fromJson<String>(json['tagId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'tagId': serializer.toJson<String>(tagId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  TaskTagLinkRow copyWith(
          {String? taskId,
          String? tagId,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      TaskTagLinkRow(
        taskId: taskId ?? this.taskId,
        tagId: tagId ?? this.tagId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  TaskTagLinkRow copyWithCompanion(TaskTagLinksCompanion data) {
    return TaskTagLinkRow(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskTagLinkRow(')
          ..write('taskId: $taskId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      taskId, tagId, createdAt, updatedAt, deletedAt, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTagLinkRow &&
          other.taskId == this.taskId &&
          other.tagId == this.tagId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class TaskTagLinksCompanion extends UpdateCompanion<TaskTagLinkRow> {
  final Value<String> taskId;
  final Value<String> tagId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const TaskTagLinksCompanion({
    this.taskId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskTagLinksCompanion.insert({
    required String taskId,
    required String tagId,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : taskId = Value(taskId),
        tagId = Value(tagId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<TaskTagLinkRow> custom({
    Expression<String>? taskId,
    Expression<String>? tagId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (tagId != null) 'tag_id': tagId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskTagLinksCompanion copyWith(
      {Value<String>? taskId,
      Value<String>? tagId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return TaskTagLinksCompanion(
      taskId: taskId ?? this.taskId,
      tagId: tagId ?? this.tagId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTagLinksCompanion(')
          ..write('taskId: $taskId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SmartFiltersTable extends SmartFilters
    with TableInfo<$SmartFiltersTable, SmartFilterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmartFiltersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rulesJsonMeta =
      const VerificationMeta('rulesJson');
  @override
  late final GeneratedColumn<String> rulesJson = GeneratedColumn<String>(
      'rules_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortModeMeta =
      const VerificationMeta('sortMode');
  @override
  late final GeneratedColumn<String> sortMode = GeneratedColumn<String>(
      'sort_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
      'pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        rulesJson,
        sortMode,
        sortOrder,
        pinned,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smart_filters';
  @override
  VerificationContext validateIntegrity(Insertable<SmartFilterRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('rules_json')) {
      context.handle(_rulesJsonMeta,
          rulesJson.isAcceptableOrUnknown(data['rules_json']!, _rulesJsonMeta));
    } else if (isInserting) {
      context.missing(_rulesJsonMeta);
    }
    if (data.containsKey('sort_mode')) {
      context.handle(_sortModeMeta,
          sortMode.isAcceptableOrUnknown(data['sort_mode']!, _sortModeMeta));
    } else if (isInserting) {
      context.missing(_sortModeMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('pinned')) {
      context.handle(_pinnedMeta,
          pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmartFilterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmartFilterRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      rulesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rules_json'])!,
      sortMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sort_mode'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      pinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pinned'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $SmartFiltersTable createAlias(String alias) {
    return $SmartFiltersTable(attachedDatabase, alias);
  }
}

class SmartFilterRow extends DataClass implements Insertable<SmartFilterRow> {
  final String id;
  final String name;
  final String rulesJson;
  final String sortMode;
  final int sortOrder;
  final bool pinned;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const SmartFilterRow(
      {required this.id,
      required this.name,
      required this.rulesJson,
      required this.sortMode,
      required this.sortOrder,
      required this.pinned,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['rules_json'] = Variable<String>(rulesJson);
    map['sort_mode'] = Variable<String>(sortMode);
    map['sort_order'] = Variable<int>(sortOrder);
    map['pinned'] = Variable<bool>(pinned);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  SmartFiltersCompanion toCompanion(bool nullToAbsent) {
    return SmartFiltersCompanion(
      id: Value(id),
      name: Value(name),
      rulesJson: Value(rulesJson),
      sortMode: Value(sortMode),
      sortOrder: Value(sortOrder),
      pinned: Value(pinned),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory SmartFilterRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmartFilterRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      rulesJson: serializer.fromJson<String>(json['rulesJson']),
      sortMode: serializer.fromJson<String>(json['sortMode']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'rulesJson': serializer.toJson<String>(rulesJson),
      'sortMode': serializer.toJson<String>(sortMode),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'pinned': serializer.toJson<bool>(pinned),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  SmartFilterRow copyWith(
          {String? id,
          String? name,
          String? rulesJson,
          String? sortMode,
          int? sortOrder,
          bool? pinned,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      SmartFilterRow(
        id: id ?? this.id,
        name: name ?? this.name,
        rulesJson: rulesJson ?? this.rulesJson,
        sortMode: sortMode ?? this.sortMode,
        sortOrder: sortOrder ?? this.sortOrder,
        pinned: pinned ?? this.pinned,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  SmartFilterRow copyWithCompanion(SmartFiltersCompanion data) {
    return SmartFilterRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      rulesJson: data.rulesJson.present ? data.rulesJson.value : this.rulesJson,
      sortMode: data.sortMode.present ? data.sortMode.value : this.sortMode,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmartFilterRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rulesJson: $rulesJson, ')
          ..write('sortMode: $sortMode, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('pinned: $pinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, rulesJson, sortMode, sortOrder,
      pinned, createdAt, updatedAt, deletedAt, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmartFilterRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.rulesJson == this.rulesJson &&
          other.sortMode == this.sortMode &&
          other.sortOrder == this.sortOrder &&
          other.pinned == this.pinned &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class SmartFiltersCompanion extends UpdateCompanion<SmartFilterRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> rulesJson;
  final Value<String> sortMode;
  final Value<int> sortOrder;
  final Value<bool> pinned;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const SmartFiltersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rulesJson = const Value.absent(),
    this.sortMode = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.pinned = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SmartFiltersCompanion.insert({
    required String id,
    required String name,
    required String rulesJson,
    required String sortMode,
    this.sortOrder = const Value.absent(),
    this.pinned = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        rulesJson = Value(rulesJson),
        sortMode = Value(sortMode),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<SmartFilterRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? rulesJson,
    Expression<String>? sortMode,
    Expression<int>? sortOrder,
    Expression<bool>? pinned,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rulesJson != null) 'rules_json': rulesJson,
      if (sortMode != null) 'sort_mode': sortMode,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (pinned != null) 'pinned': pinned,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SmartFiltersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? rulesJson,
      Value<String>? sortMode,
      Value<int>? sortOrder,
      Value<bool>? pinned,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return SmartFiltersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rulesJson: rulesJson ?? this.rulesJson,
      sortMode: sortMode ?? this.sortMode,
      sortOrder: sortOrder ?? this.sortOrder,
      pinned: pinned ?? this.pinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rulesJson.present) {
      map['rules_json'] = Variable<String>(rulesJson.value);
    }
    if (sortMode.present) {
      map['sort_mode'] = Variable<String>(sortMode.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmartFiltersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rulesJson: $rulesJson, ')
          ..write('sortMode: $sortMode, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('pinned: $pinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentAttachmentsTable extends ContentAttachments
    with TableInfo<$ContentAttachmentsTable, ContentAttachmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerTypeMeta =
      const VerificationMeta('ownerType');
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
      'owner_type', aliasedName, false,
      check: () => ownerType.isIn(const ['task', 'note']),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
      'sha256', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _byteSizeMeta =
      const VerificationMeta('byteSize');
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
      'byte_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
      'width', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
      'height', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _relativePathMeta =
      const VerificationMeta('relativePath');
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
      'relative_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thumbnailRelativePathMeta =
      const VerificationMeta('thumbnailRelativePath');
  @override
  late final GeneratedColumn<String> thumbnailRelativePath =
      GeneratedColumn<String>('thumbnail_relative_path', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerType,
        ownerId,
        sha256,
        mimeType,
        byteSize,
        width,
        height,
        relativePath,
        thumbnailRelativePath,
        sortOrder,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_attachments';
  @override
  VerificationContext validateIntegrity(
      Insertable<ContentAttachmentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_type')) {
      context.handle(_ownerTypeMeta,
          ownerType.isAcceptableOrUnknown(data['owner_type']!, _ownerTypeMeta));
    } else if (isInserting) {
      context.missing(_ownerTypeMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(_sha256Meta,
          sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta));
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(_byteSizeMeta,
          byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta));
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
          _widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
          _relativePathMeta,
          relativePath.isAcceptableOrUnknown(
              data['relative_path']!, _relativePathMeta));
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('thumbnail_relative_path')) {
      context.handle(
          _thumbnailRelativePathMeta,
          thumbnailRelativePath.isAcceptableOrUnknown(
              data['thumbnail_relative_path']!, _thumbnailRelativePathMeta));
    } else if (isInserting) {
      context.missing(_thumbnailRelativePathMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentAttachmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentAttachmentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_type'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      sha256: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sha256'])!,
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type'])!,
      byteSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}byte_size'])!,
      width: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}width'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}height'])!,
      relativePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relative_path'])!,
      thumbnailRelativePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}thumbnail_relative_path'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $ContentAttachmentsTable createAlias(String alias) {
    return $ContentAttachmentsTable(attachedDatabase, alias);
  }
}

class ContentAttachmentRow extends DataClass
    implements Insertable<ContentAttachmentRow> {
  final String id;
  final String ownerType;
  final String ownerId;
  final String sha256;
  final String mimeType;
  final int byteSize;
  final int width;
  final int height;
  final String relativePath;
  final String thumbnailRelativePath;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const ContentAttachmentRow(
      {required this.id,
      required this.ownerType,
      required this.ownerId,
      required this.sha256,
      required this.mimeType,
      required this.byteSize,
      required this.width,
      required this.height,
      required this.relativePath,
      required this.thumbnailRelativePath,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_type'] = Variable<String>(ownerType);
    map['owner_id'] = Variable<String>(ownerId);
    map['sha256'] = Variable<String>(sha256);
    map['mime_type'] = Variable<String>(mimeType);
    map['byte_size'] = Variable<int>(byteSize);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['relative_path'] = Variable<String>(relativePath);
    map['thumbnail_relative_path'] = Variable<String>(thumbnailRelativePath);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  ContentAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return ContentAttachmentsCompanion(
      id: Value(id),
      ownerType: Value(ownerType),
      ownerId: Value(ownerId),
      sha256: Value(sha256),
      mimeType: Value(mimeType),
      byteSize: Value(byteSize),
      width: Value(width),
      height: Value(height),
      relativePath: Value(relativePath),
      thumbnailRelativePath: Value(thumbnailRelativePath),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory ContentAttachmentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentAttachmentRow(
      id: serializer.fromJson<String>(json['id']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      sha256: serializer.fromJson<String>(json['sha256']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      thumbnailRelativePath:
          serializer.fromJson<String>(json['thumbnailRelativePath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerType': serializer.toJson<String>(ownerType),
      'ownerId': serializer.toJson<String>(ownerId),
      'sha256': serializer.toJson<String>(sha256),
      'mimeType': serializer.toJson<String>(mimeType),
      'byteSize': serializer.toJson<int>(byteSize),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'relativePath': serializer.toJson<String>(relativePath),
      'thumbnailRelativePath': serializer.toJson<String>(thumbnailRelativePath),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  ContentAttachmentRow copyWith(
          {String? id,
          String? ownerType,
          String? ownerId,
          String? sha256,
          String? mimeType,
          int? byteSize,
          int? width,
          int? height,
          String? relativePath,
          String? thumbnailRelativePath,
          int? sortOrder,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      ContentAttachmentRow(
        id: id ?? this.id,
        ownerType: ownerType ?? this.ownerType,
        ownerId: ownerId ?? this.ownerId,
        sha256: sha256 ?? this.sha256,
        mimeType: mimeType ?? this.mimeType,
        byteSize: byteSize ?? this.byteSize,
        width: width ?? this.width,
        height: height ?? this.height,
        relativePath: relativePath ?? this.relativePath,
        thumbnailRelativePath:
            thumbnailRelativePath ?? this.thumbnailRelativePath,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  ContentAttachmentRow copyWithCompanion(ContentAttachmentsCompanion data) {
    return ContentAttachmentRow(
      id: data.id.present ? data.id.value : this.id,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      thumbnailRelativePath: data.thumbnailRelativePath.present
          ? data.thumbnailRelativePath.value
          : this.thumbnailRelativePath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentAttachmentRow(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('sha256: $sha256, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('relativePath: $relativePath, ')
          ..write('thumbnailRelativePath: $thumbnailRelativePath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ownerType,
      ownerId,
      sha256,
      mimeType,
      byteSize,
      width,
      height,
      relativePath,
      thumbnailRelativePath,
      sortOrder,
      createdAt,
      updatedAt,
      deletedAt,
      deviceId,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentAttachmentRow &&
          other.id == this.id &&
          other.ownerType == this.ownerType &&
          other.ownerId == this.ownerId &&
          other.sha256 == this.sha256 &&
          other.mimeType == this.mimeType &&
          other.byteSize == this.byteSize &&
          other.width == this.width &&
          other.height == this.height &&
          other.relativePath == this.relativePath &&
          other.thumbnailRelativePath == this.thumbnailRelativePath &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class ContentAttachmentsCompanion
    extends UpdateCompanion<ContentAttachmentRow> {
  final Value<String> id;
  final Value<String> ownerType;
  final Value<String> ownerId;
  final Value<String> sha256;
  final Value<String> mimeType;
  final Value<int> byteSize;
  final Value<int> width;
  final Value<int> height;
  final Value<String> relativePath;
  final Value<String> thumbnailRelativePath;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const ContentAttachmentsCompanion({
    this.id = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.thumbnailRelativePath = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentAttachmentsCompanion.insert({
    required String id,
    required String ownerType,
    required String ownerId,
    required String sha256,
    required String mimeType,
    required int byteSize,
    required int width,
    required int height,
    required String relativePath,
    required String thumbnailRelativePath,
    this.sortOrder = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerType = Value(ownerType),
        ownerId = Value(ownerId),
        sha256 = Value(sha256),
        mimeType = Value(mimeType),
        byteSize = Value(byteSize),
        width = Value(width),
        height = Value(height),
        relativePath = Value(relativePath),
        thumbnailRelativePath = Value(thumbnailRelativePath),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<ContentAttachmentRow> custom({
    Expression<String>? id,
    Expression<String>? ownerType,
    Expression<String>? ownerId,
    Expression<String>? sha256,
    Expression<String>? mimeType,
    Expression<int>? byteSize,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? relativePath,
    Expression<String>? thumbnailRelativePath,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerType != null) 'owner_type': ownerType,
      if (ownerId != null) 'owner_id': ownerId,
      if (sha256 != null) 'sha256': sha256,
      if (mimeType != null) 'mime_type': mimeType,
      if (byteSize != null) 'byte_size': byteSize,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (relativePath != null) 'relative_path': relativePath,
      if (thumbnailRelativePath != null)
        'thumbnail_relative_path': thumbnailRelativePath,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentAttachmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerType,
      Value<String>? ownerId,
      Value<String>? sha256,
      Value<String>? mimeType,
      Value<int>? byteSize,
      Value<int>? width,
      Value<int>? height,
      Value<String>? relativePath,
      Value<String>? thumbnailRelativePath,
      Value<int>? sortOrder,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return ContentAttachmentsCompanion(
      id: id ?? this.id,
      ownerType: ownerType ?? this.ownerType,
      ownerId: ownerId ?? this.ownerId,
      sha256: sha256 ?? this.sha256,
      mimeType: mimeType ?? this.mimeType,
      byteSize: byteSize ?? this.byteSize,
      width: width ?? this.width,
      height: height ?? this.height,
      relativePath: relativePath ?? this.relativePath,
      thumbnailRelativePath:
          thumbnailRelativePath ?? this.thumbnailRelativePath,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (thumbnailRelativePath.present) {
      map['thumbnail_relative_path'] =
          Variable<String>(thumbnailRelativePath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('sha256: $sha256, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('relativePath: $relativePath, ')
          ..write('thumbnailRelativePath: $thumbnailRelativePath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomColorsTable extends CustomColors
    with TableInfo<$CustomColorsTable, CustomColorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomColorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rgbMeta = const VerificationMeta('rgb');
  @override
  late final GeneratedColumn<int> rgb = GeneratedColumn<int>(
      'rgb', aliasedName, false,
      check: () => ComparableExpr(rgb).isBetweenValues(0, 0xFFFFFF),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        rgb,
        sortOrder,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_colors';
  @override
  VerificationContext validateIntegrity(Insertable<CustomColorRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('rgb')) {
      context.handle(
          _rgbMeta, rgb.isAcceptableOrUnknown(data['rgb']!, _rgbMeta));
    } else if (isInserting) {
      context.missing(_rgbMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomColorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomColorRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      rgb: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rgb'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $CustomColorsTable createAlias(String alias) {
    return $CustomColorsTable(attachedDatabase, alias);
  }
}

class CustomColorRow extends DataClass implements Insertable<CustomColorRow> {
  final String id;
  final String name;
  final int rgb;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const CustomColorRow(
      {required this.id,
      required this.name,
      required this.rgb,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['rgb'] = Variable<int>(rgb);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  CustomColorsCompanion toCompanion(bool nullToAbsent) {
    return CustomColorsCompanion(
      id: Value(id),
      name: Value(name),
      rgb: Value(rgb),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory CustomColorRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomColorRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      rgb: serializer.fromJson<int>(json['rgb']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'rgb': serializer.toJson<int>(rgb),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  CustomColorRow copyWith(
          {String? id,
          String? name,
          int? rgb,
          int? sortOrder,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      CustomColorRow(
        id: id ?? this.id,
        name: name ?? this.name,
        rgb: rgb ?? this.rgb,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  CustomColorRow copyWithCompanion(CustomColorsCompanion data) {
    return CustomColorRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      rgb: data.rgb.present ? data.rgb.value : this.rgb,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomColorRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rgb: $rgb, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, rgb, sortOrder, createdAt,
      updatedAt, deletedAt, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomColorRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.rgb == this.rgb &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class CustomColorsCompanion extends UpdateCompanion<CustomColorRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rgb;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const CustomColorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rgb = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomColorsCompanion.insert({
    required String id,
    required String name,
    required int rgb,
    this.sortOrder = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        rgb = Value(rgb),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<CustomColorRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rgb,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rgb != null) 'rgb': rgb,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomColorsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? rgb,
      Value<int>? sortOrder,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return CustomColorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rgb: rgb ?? this.rgb,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rgb.present) {
      map['rgb'] = Variable<int>(rgb.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomColorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rgb: $rgb, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackgroundImagesTable extends BackgroundImages
    with TableInfo<$BackgroundImagesTable, BackgroundImageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackgroundImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
      'sha256', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _byteSizeMeta =
      const VerificationMeta('byteSize');
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
      'byte_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
      'width', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
      'height', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _relativePathMeta =
      const VerificationMeta('relativePath');
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
      'relative_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncEnabledMeta =
      const VerificationMeta('syncEnabled');
  @override
  late final GeneratedColumn<bool> syncEnabled = GeneratedColumn<bool>(
      'sync_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sync_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sha256,
        mimeType,
        byteSize,
        width,
        height,
        relativePath,
        syncEnabled,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'background_images';
  @override
  VerificationContext validateIntegrity(Insertable<BackgroundImageRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(_sha256Meta,
          sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta));
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(_byteSizeMeta,
          byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta));
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
          _widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
          _relativePathMeta,
          relativePath.isAcceptableOrUnknown(
              data['relative_path']!, _relativePathMeta));
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('sync_enabled')) {
      context.handle(
          _syncEnabledMeta,
          syncEnabled.isAcceptableOrUnknown(
              data['sync_enabled']!, _syncEnabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackgroundImageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackgroundImageRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sha256: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sha256'])!,
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type'])!,
      byteSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}byte_size'])!,
      width: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}width'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}height'])!,
      relativePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relative_path'])!,
      syncEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sync_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $BackgroundImagesTable createAlias(String alias) {
    return $BackgroundImagesTable(attachedDatabase, alias);
  }
}

class BackgroundImageRow extends DataClass
    implements Insertable<BackgroundImageRow> {
  final String id;
  final String sha256;
  final String mimeType;
  final int byteSize;
  final int width;
  final int height;
  final String relativePath;
  final bool syncEnabled;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const BackgroundImageRow(
      {required this.id,
      required this.sha256,
      required this.mimeType,
      required this.byteSize,
      required this.width,
      required this.height,
      required this.relativePath,
      required this.syncEnabled,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sha256'] = Variable<String>(sha256);
    map['mime_type'] = Variable<String>(mimeType);
    map['byte_size'] = Variable<int>(byteSize);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['relative_path'] = Variable<String>(relativePath);
    map['sync_enabled'] = Variable<bool>(syncEnabled);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  BackgroundImagesCompanion toCompanion(bool nullToAbsent) {
    return BackgroundImagesCompanion(
      id: Value(id),
      sha256: Value(sha256),
      mimeType: Value(mimeType),
      byteSize: Value(byteSize),
      width: Value(width),
      height: Value(height),
      relativePath: Value(relativePath),
      syncEnabled: Value(syncEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory BackgroundImageRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackgroundImageRow(
      id: serializer.fromJson<String>(json['id']),
      sha256: serializer.fromJson<String>(json['sha256']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      syncEnabled: serializer.fromJson<bool>(json['syncEnabled']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sha256': serializer.toJson<String>(sha256),
      'mimeType': serializer.toJson<String>(mimeType),
      'byteSize': serializer.toJson<int>(byteSize),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'relativePath': serializer.toJson<String>(relativePath),
      'syncEnabled': serializer.toJson<bool>(syncEnabled),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  BackgroundImageRow copyWith(
          {String? id,
          String? sha256,
          String? mimeType,
          int? byteSize,
          int? width,
          int? height,
          String? relativePath,
          bool? syncEnabled,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      BackgroundImageRow(
        id: id ?? this.id,
        sha256: sha256 ?? this.sha256,
        mimeType: mimeType ?? this.mimeType,
        byteSize: byteSize ?? this.byteSize,
        width: width ?? this.width,
        height: height ?? this.height,
        relativePath: relativePath ?? this.relativePath,
        syncEnabled: syncEnabled ?? this.syncEnabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  BackgroundImageRow copyWithCompanion(BackgroundImagesCompanion data) {
    return BackgroundImageRow(
      id: data.id.present ? data.id.value : this.id,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      syncEnabled:
          data.syncEnabled.present ? data.syncEnabled.value : this.syncEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundImageRow(')
          ..write('id: $id, ')
          ..write('sha256: $sha256, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('relativePath: $relativePath, ')
          ..write('syncEnabled: $syncEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sha256,
      mimeType,
      byteSize,
      width,
      height,
      relativePath,
      syncEnabled,
      createdAt,
      updatedAt,
      deletedAt,
      deviceId,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackgroundImageRow &&
          other.id == this.id &&
          other.sha256 == this.sha256 &&
          other.mimeType == this.mimeType &&
          other.byteSize == this.byteSize &&
          other.width == this.width &&
          other.height == this.height &&
          other.relativePath == this.relativePath &&
          other.syncEnabled == this.syncEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class BackgroundImagesCompanion extends UpdateCompanion<BackgroundImageRow> {
  final Value<String> id;
  final Value<String> sha256;
  final Value<String> mimeType;
  final Value<int> byteSize;
  final Value<int> width;
  final Value<int> height;
  final Value<String> relativePath;
  final Value<bool> syncEnabled;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const BackgroundImagesCompanion({
    this.id = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.syncEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackgroundImagesCompanion.insert({
    required String id,
    required String sha256,
    required String mimeType,
    required int byteSize,
    required int width,
    required int height,
    required String relativePath,
    this.syncEnabled = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sha256 = Value(sha256),
        mimeType = Value(mimeType),
        byteSize = Value(byteSize),
        width = Value(width),
        height = Value(height),
        relativePath = Value(relativePath),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<BackgroundImageRow> custom({
    Expression<String>? id,
    Expression<String>? sha256,
    Expression<String>? mimeType,
    Expression<int>? byteSize,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? relativePath,
    Expression<bool>? syncEnabled,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sha256 != null) 'sha256': sha256,
      if (mimeType != null) 'mime_type': mimeType,
      if (byteSize != null) 'byte_size': byteSize,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (relativePath != null) 'relative_path': relativePath,
      if (syncEnabled != null) 'sync_enabled': syncEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackgroundImagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? sha256,
      Value<String>? mimeType,
      Value<int>? byteSize,
      Value<int>? width,
      Value<int>? height,
      Value<String>? relativePath,
      Value<bool>? syncEnabled,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return BackgroundImagesCompanion(
      id: id ?? this.id,
      sha256: sha256 ?? this.sha256,
      mimeType: mimeType ?? this.mimeType,
      byteSize: byteSize ?? this.byteSize,
      width: width ?? this.width,
      height: height ?? this.height,
      relativePath: relativePath ?? this.relativePath,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (syncEnabled.present) {
      map['sync_enabled'] = Variable<bool>(syncEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackgroundImagesCompanion(')
          ..write('id: $id, ')
          ..write('sha256: $sha256, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('relativePath: $relativePath, ')
          ..write('syncEnabled: $syncEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceAppearanceProfilesTable extends DeviceAppearanceProfiles
    with TableInfo<$DeviceAppearanceProfilesTable, DeviceAppearanceProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceAppearanceProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _platformMeta =
      const VerificationMeta('platform');
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
      'platform', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _densityMeta =
      const VerificationMeta('density');
  @override
  late final GeneratedColumn<String> density = GeneratedColumn<String>(
      'density', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _navOrderJsonMeta =
      const VerificationMeta('navOrderJson');
  @override
  late final GeneratedColumn<String> navOrderJson = GeneratedColumn<String>(
      'nav_order_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hiddenNavJsonMeta =
      const VerificationMeta('hiddenNavJson');
  @override
  late final GeneratedColumn<String> hiddenNavJson = GeneratedColumn<String>(
      'hidden_nav_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startModuleMeta =
      const VerificationMeta('startModule');
  @override
  late final GeneratedColumn<String> startModule = GeneratedColumn<String>(
      'start_module', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localBackgroundImageIdMeta =
      const VerificationMeta('localBackgroundImageId');
  @override
  late final GeneratedColumn<String> localBackgroundImageId =
      GeneratedColumn<String>('local_background_image_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _backgroundFocusXMeta =
      const VerificationMeta('backgroundFocusX');
  @override
  late final GeneratedColumn<double> backgroundFocusX = GeneratedColumn<double>(
      'background_focus_x', aliasedName, false,
      check: () => ComparableExpr(backgroundFocusX).isBetweenValues(0, 1),
      type: DriftSqlType.double,
      requiredDuringInsert: true);
  static const VerificationMeta _backgroundFocusYMeta =
      const VerificationMeta('backgroundFocusY');
  @override
  late final GeneratedColumn<double> backgroundFocusY = GeneratedColumn<double>(
      'background_focus_y', aliasedName, false,
      check: () => ComparableExpr(backgroundFocusY).isBetweenValues(0, 1),
      type: DriftSqlType.double,
      requiredDuringInsert: true);
  static const VerificationMeta _backgroundZoomMeta =
      const VerificationMeta('backgroundZoom');
  @override
  late final GeneratedColumn<double> backgroundZoom = GeneratedColumn<double>(
      'background_zoom', aliasedName, false,
      check: () => ComparableExpr(backgroundZoom).isBiggerThanValue(0),
      type: DriftSqlType.double,
      requiredDuringInsert: true);
  static const VerificationMeta _backgroundBlurMeta =
      const VerificationMeta('backgroundBlur');
  @override
  late final GeneratedColumn<double> backgroundBlur = GeneratedColumn<double>(
      'background_blur', aliasedName, false,
      check: () => ComparableExpr(backgroundBlur).isBiggerOrEqualValue(0),
      type: DriftSqlType.double,
      requiredDuringInsert: true);
  static const VerificationMeta _backgroundOverlayMeta =
      const VerificationMeta('backgroundOverlay');
  @override
  late final GeneratedColumn<double> backgroundOverlay =
      GeneratedColumn<double>('background_overlay', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _hapticsModeMeta =
      const VerificationMeta('hapticsMode');
  @override
  late final GeneratedColumn<String> hapticsMode = GeneratedColumn<String>(
      'haptics_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        platform,
        density,
        navOrderJson,
        hiddenNavJson,
        startModule,
        localBackgroundImageId,
        backgroundFocusX,
        backgroundFocusY,
        backgroundZoom,
        backgroundBlur,
        backgroundOverlay,
        hapticsMode,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_appearance_profiles';
  @override
  VerificationContext validateIntegrity(
      Insertable<DeviceAppearanceProfileRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(_platformMeta,
          platform.isAcceptableOrUnknown(data['platform']!, _platformMeta));
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('density')) {
      context.handle(_densityMeta,
          density.isAcceptableOrUnknown(data['density']!, _densityMeta));
    } else if (isInserting) {
      context.missing(_densityMeta);
    }
    if (data.containsKey('nav_order_json')) {
      context.handle(
          _navOrderJsonMeta,
          navOrderJson.isAcceptableOrUnknown(
              data['nav_order_json']!, _navOrderJsonMeta));
    } else if (isInserting) {
      context.missing(_navOrderJsonMeta);
    }
    if (data.containsKey('hidden_nav_json')) {
      context.handle(
          _hiddenNavJsonMeta,
          hiddenNavJson.isAcceptableOrUnknown(
              data['hidden_nav_json']!, _hiddenNavJsonMeta));
    } else if (isInserting) {
      context.missing(_hiddenNavJsonMeta);
    }
    if (data.containsKey('start_module')) {
      context.handle(
          _startModuleMeta,
          startModule.isAcceptableOrUnknown(
              data['start_module']!, _startModuleMeta));
    } else if (isInserting) {
      context.missing(_startModuleMeta);
    }
    if (data.containsKey('local_background_image_id')) {
      context.handle(
          _localBackgroundImageIdMeta,
          localBackgroundImageId.isAcceptableOrUnknown(
              data['local_background_image_id']!, _localBackgroundImageIdMeta));
    }
    if (data.containsKey('background_focus_x')) {
      context.handle(
          _backgroundFocusXMeta,
          backgroundFocusX.isAcceptableOrUnknown(
              data['background_focus_x']!, _backgroundFocusXMeta));
    } else if (isInserting) {
      context.missing(_backgroundFocusXMeta);
    }
    if (data.containsKey('background_focus_y')) {
      context.handle(
          _backgroundFocusYMeta,
          backgroundFocusY.isAcceptableOrUnknown(
              data['background_focus_y']!, _backgroundFocusYMeta));
    } else if (isInserting) {
      context.missing(_backgroundFocusYMeta);
    }
    if (data.containsKey('background_zoom')) {
      context.handle(
          _backgroundZoomMeta,
          backgroundZoom.isAcceptableOrUnknown(
              data['background_zoom']!, _backgroundZoomMeta));
    } else if (isInserting) {
      context.missing(_backgroundZoomMeta);
    }
    if (data.containsKey('background_blur')) {
      context.handle(
          _backgroundBlurMeta,
          backgroundBlur.isAcceptableOrUnknown(
              data['background_blur']!, _backgroundBlurMeta));
    } else if (isInserting) {
      context.missing(_backgroundBlurMeta);
    }
    if (data.containsKey('background_overlay')) {
      context.handle(
          _backgroundOverlayMeta,
          backgroundOverlay.isAcceptableOrUnknown(
              data['background_overlay']!, _backgroundOverlayMeta));
    } else if (isInserting) {
      context.missing(_backgroundOverlayMeta);
    }
    if (data.containsKey('haptics_mode')) {
      context.handle(
          _hapticsModeMeta,
          hapticsMode.isAcceptableOrUnknown(
              data['haptics_mode']!, _hapticsModeMeta));
    } else if (isInserting) {
      context.missing(_hapticsModeMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceAppearanceProfileRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceAppearanceProfileRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      platform: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}platform'])!,
      density: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}density'])!,
      navOrderJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nav_order_json'])!,
      hiddenNavJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}hidden_nav_json'])!,
      startModule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_module'])!,
      localBackgroundImageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}local_background_image_id']),
      backgroundFocusX: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}background_focus_x'])!,
      backgroundFocusY: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}background_focus_y'])!,
      backgroundZoom: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}background_zoom'])!,
      backgroundBlur: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}background_blur'])!,
      backgroundOverlay: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}background_overlay'])!,
      hapticsMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}haptics_mode'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DeviceAppearanceProfilesTable createAlias(String alias) {
    return $DeviceAppearanceProfilesTable(attachedDatabase, alias);
  }
}

class DeviceAppearanceProfileRow extends DataClass
    implements Insertable<DeviceAppearanceProfileRow> {
  final String id;
  final String platform;
  final String density;
  final String navOrderJson;
  final String hiddenNavJson;
  final String startModule;
  final String? localBackgroundImageId;
  final double backgroundFocusX;
  final double backgroundFocusY;
  final double backgroundZoom;
  final double backgroundBlur;
  final double backgroundOverlay;
  final String hapticsMode;
  final int updatedAt;
  const DeviceAppearanceProfileRow(
      {required this.id,
      required this.platform,
      required this.density,
      required this.navOrderJson,
      required this.hiddenNavJson,
      required this.startModule,
      this.localBackgroundImageId,
      required this.backgroundFocusX,
      required this.backgroundFocusY,
      required this.backgroundZoom,
      required this.backgroundBlur,
      required this.backgroundOverlay,
      required this.hapticsMode,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['platform'] = Variable<String>(platform);
    map['density'] = Variable<String>(density);
    map['nav_order_json'] = Variable<String>(navOrderJson);
    map['hidden_nav_json'] = Variable<String>(hiddenNavJson);
    map['start_module'] = Variable<String>(startModule);
    if (!nullToAbsent || localBackgroundImageId != null) {
      map['local_background_image_id'] =
          Variable<String>(localBackgroundImageId);
    }
    map['background_focus_x'] = Variable<double>(backgroundFocusX);
    map['background_focus_y'] = Variable<double>(backgroundFocusY);
    map['background_zoom'] = Variable<double>(backgroundZoom);
    map['background_blur'] = Variable<double>(backgroundBlur);
    map['background_overlay'] = Variable<double>(backgroundOverlay);
    map['haptics_mode'] = Variable<String>(hapticsMode);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DeviceAppearanceProfilesCompanion toCompanion(bool nullToAbsent) {
    return DeviceAppearanceProfilesCompanion(
      id: Value(id),
      platform: Value(platform),
      density: Value(density),
      navOrderJson: Value(navOrderJson),
      hiddenNavJson: Value(hiddenNavJson),
      startModule: Value(startModule),
      localBackgroundImageId: localBackgroundImageId == null && nullToAbsent
          ? const Value.absent()
          : Value(localBackgroundImageId),
      backgroundFocusX: Value(backgroundFocusX),
      backgroundFocusY: Value(backgroundFocusY),
      backgroundZoom: Value(backgroundZoom),
      backgroundBlur: Value(backgroundBlur),
      backgroundOverlay: Value(backgroundOverlay),
      hapticsMode: Value(hapticsMode),
      updatedAt: Value(updatedAt),
    );
  }

  factory DeviceAppearanceProfileRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceAppearanceProfileRow(
      id: serializer.fromJson<String>(json['id']),
      platform: serializer.fromJson<String>(json['platform']),
      density: serializer.fromJson<String>(json['density']),
      navOrderJson: serializer.fromJson<String>(json['navOrderJson']),
      hiddenNavJson: serializer.fromJson<String>(json['hiddenNavJson']),
      startModule: serializer.fromJson<String>(json['startModule']),
      localBackgroundImageId:
          serializer.fromJson<String?>(json['localBackgroundImageId']),
      backgroundFocusX: serializer.fromJson<double>(json['backgroundFocusX']),
      backgroundFocusY: serializer.fromJson<double>(json['backgroundFocusY']),
      backgroundZoom: serializer.fromJson<double>(json['backgroundZoom']),
      backgroundBlur: serializer.fromJson<double>(json['backgroundBlur']),
      backgroundOverlay: serializer.fromJson<double>(json['backgroundOverlay']),
      hapticsMode: serializer.fromJson<String>(json['hapticsMode']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'platform': serializer.toJson<String>(platform),
      'density': serializer.toJson<String>(density),
      'navOrderJson': serializer.toJson<String>(navOrderJson),
      'hiddenNavJson': serializer.toJson<String>(hiddenNavJson),
      'startModule': serializer.toJson<String>(startModule),
      'localBackgroundImageId':
          serializer.toJson<String?>(localBackgroundImageId),
      'backgroundFocusX': serializer.toJson<double>(backgroundFocusX),
      'backgroundFocusY': serializer.toJson<double>(backgroundFocusY),
      'backgroundZoom': serializer.toJson<double>(backgroundZoom),
      'backgroundBlur': serializer.toJson<double>(backgroundBlur),
      'backgroundOverlay': serializer.toJson<double>(backgroundOverlay),
      'hapticsMode': serializer.toJson<String>(hapticsMode),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DeviceAppearanceProfileRow copyWith(
          {String? id,
          String? platform,
          String? density,
          String? navOrderJson,
          String? hiddenNavJson,
          String? startModule,
          Value<String?> localBackgroundImageId = const Value.absent(),
          double? backgroundFocusX,
          double? backgroundFocusY,
          double? backgroundZoom,
          double? backgroundBlur,
          double? backgroundOverlay,
          String? hapticsMode,
          int? updatedAt}) =>
      DeviceAppearanceProfileRow(
        id: id ?? this.id,
        platform: platform ?? this.platform,
        density: density ?? this.density,
        navOrderJson: navOrderJson ?? this.navOrderJson,
        hiddenNavJson: hiddenNavJson ?? this.hiddenNavJson,
        startModule: startModule ?? this.startModule,
        localBackgroundImageId: localBackgroundImageId.present
            ? localBackgroundImageId.value
            : this.localBackgroundImageId,
        backgroundFocusX: backgroundFocusX ?? this.backgroundFocusX,
        backgroundFocusY: backgroundFocusY ?? this.backgroundFocusY,
        backgroundZoom: backgroundZoom ?? this.backgroundZoom,
        backgroundBlur: backgroundBlur ?? this.backgroundBlur,
        backgroundOverlay: backgroundOverlay ?? this.backgroundOverlay,
        hapticsMode: hapticsMode ?? this.hapticsMode,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DeviceAppearanceProfileRow copyWithCompanion(
      DeviceAppearanceProfilesCompanion data) {
    return DeviceAppearanceProfileRow(
      id: data.id.present ? data.id.value : this.id,
      platform: data.platform.present ? data.platform.value : this.platform,
      density: data.density.present ? data.density.value : this.density,
      navOrderJson: data.navOrderJson.present
          ? data.navOrderJson.value
          : this.navOrderJson,
      hiddenNavJson: data.hiddenNavJson.present
          ? data.hiddenNavJson.value
          : this.hiddenNavJson,
      startModule:
          data.startModule.present ? data.startModule.value : this.startModule,
      localBackgroundImageId: data.localBackgroundImageId.present
          ? data.localBackgroundImageId.value
          : this.localBackgroundImageId,
      backgroundFocusX: data.backgroundFocusX.present
          ? data.backgroundFocusX.value
          : this.backgroundFocusX,
      backgroundFocusY: data.backgroundFocusY.present
          ? data.backgroundFocusY.value
          : this.backgroundFocusY,
      backgroundZoom: data.backgroundZoom.present
          ? data.backgroundZoom.value
          : this.backgroundZoom,
      backgroundBlur: data.backgroundBlur.present
          ? data.backgroundBlur.value
          : this.backgroundBlur,
      backgroundOverlay: data.backgroundOverlay.present
          ? data.backgroundOverlay.value
          : this.backgroundOverlay,
      hapticsMode:
          data.hapticsMode.present ? data.hapticsMode.value : this.hapticsMode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceAppearanceProfileRow(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('density: $density, ')
          ..write('navOrderJson: $navOrderJson, ')
          ..write('hiddenNavJson: $hiddenNavJson, ')
          ..write('startModule: $startModule, ')
          ..write('localBackgroundImageId: $localBackgroundImageId, ')
          ..write('backgroundFocusX: $backgroundFocusX, ')
          ..write('backgroundFocusY: $backgroundFocusY, ')
          ..write('backgroundZoom: $backgroundZoom, ')
          ..write('backgroundBlur: $backgroundBlur, ')
          ..write('backgroundOverlay: $backgroundOverlay, ')
          ..write('hapticsMode: $hapticsMode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      platform,
      density,
      navOrderJson,
      hiddenNavJson,
      startModule,
      localBackgroundImageId,
      backgroundFocusX,
      backgroundFocusY,
      backgroundZoom,
      backgroundBlur,
      backgroundOverlay,
      hapticsMode,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceAppearanceProfileRow &&
          other.id == this.id &&
          other.platform == this.platform &&
          other.density == this.density &&
          other.navOrderJson == this.navOrderJson &&
          other.hiddenNavJson == this.hiddenNavJson &&
          other.startModule == this.startModule &&
          other.localBackgroundImageId == this.localBackgroundImageId &&
          other.backgroundFocusX == this.backgroundFocusX &&
          other.backgroundFocusY == this.backgroundFocusY &&
          other.backgroundZoom == this.backgroundZoom &&
          other.backgroundBlur == this.backgroundBlur &&
          other.backgroundOverlay == this.backgroundOverlay &&
          other.hapticsMode == this.hapticsMode &&
          other.updatedAt == this.updatedAt);
}

class DeviceAppearanceProfilesCompanion
    extends UpdateCompanion<DeviceAppearanceProfileRow> {
  final Value<String> id;
  final Value<String> platform;
  final Value<String> density;
  final Value<String> navOrderJson;
  final Value<String> hiddenNavJson;
  final Value<String> startModule;
  final Value<String?> localBackgroundImageId;
  final Value<double> backgroundFocusX;
  final Value<double> backgroundFocusY;
  final Value<double> backgroundZoom;
  final Value<double> backgroundBlur;
  final Value<double> backgroundOverlay;
  final Value<String> hapticsMode;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const DeviceAppearanceProfilesCompanion({
    this.id = const Value.absent(),
    this.platform = const Value.absent(),
    this.density = const Value.absent(),
    this.navOrderJson = const Value.absent(),
    this.hiddenNavJson = const Value.absent(),
    this.startModule = const Value.absent(),
    this.localBackgroundImageId = const Value.absent(),
    this.backgroundFocusX = const Value.absent(),
    this.backgroundFocusY = const Value.absent(),
    this.backgroundZoom = const Value.absent(),
    this.backgroundBlur = const Value.absent(),
    this.backgroundOverlay = const Value.absent(),
    this.hapticsMode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceAppearanceProfilesCompanion.insert({
    required String id,
    required String platform,
    required String density,
    required String navOrderJson,
    required String hiddenNavJson,
    required String startModule,
    this.localBackgroundImageId = const Value.absent(),
    required double backgroundFocusX,
    required double backgroundFocusY,
    required double backgroundZoom,
    required double backgroundBlur,
    required double backgroundOverlay,
    required String hapticsMode,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        platform = Value(platform),
        density = Value(density),
        navOrderJson = Value(navOrderJson),
        hiddenNavJson = Value(hiddenNavJson),
        startModule = Value(startModule),
        backgroundFocusX = Value(backgroundFocusX),
        backgroundFocusY = Value(backgroundFocusY),
        backgroundZoom = Value(backgroundZoom),
        backgroundBlur = Value(backgroundBlur),
        backgroundOverlay = Value(backgroundOverlay),
        hapticsMode = Value(hapticsMode),
        updatedAt = Value(updatedAt);
  static Insertable<DeviceAppearanceProfileRow> custom({
    Expression<String>? id,
    Expression<String>? platform,
    Expression<String>? density,
    Expression<String>? navOrderJson,
    Expression<String>? hiddenNavJson,
    Expression<String>? startModule,
    Expression<String>? localBackgroundImageId,
    Expression<double>? backgroundFocusX,
    Expression<double>? backgroundFocusY,
    Expression<double>? backgroundZoom,
    Expression<double>? backgroundBlur,
    Expression<double>? backgroundOverlay,
    Expression<String>? hapticsMode,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (platform != null) 'platform': platform,
      if (density != null) 'density': density,
      if (navOrderJson != null) 'nav_order_json': navOrderJson,
      if (hiddenNavJson != null) 'hidden_nav_json': hiddenNavJson,
      if (startModule != null) 'start_module': startModule,
      if (localBackgroundImageId != null)
        'local_background_image_id': localBackgroundImageId,
      if (backgroundFocusX != null) 'background_focus_x': backgroundFocusX,
      if (backgroundFocusY != null) 'background_focus_y': backgroundFocusY,
      if (backgroundZoom != null) 'background_zoom': backgroundZoom,
      if (backgroundBlur != null) 'background_blur': backgroundBlur,
      if (backgroundOverlay != null) 'background_overlay': backgroundOverlay,
      if (hapticsMode != null) 'haptics_mode': hapticsMode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceAppearanceProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? platform,
      Value<String>? density,
      Value<String>? navOrderJson,
      Value<String>? hiddenNavJson,
      Value<String>? startModule,
      Value<String?>? localBackgroundImageId,
      Value<double>? backgroundFocusX,
      Value<double>? backgroundFocusY,
      Value<double>? backgroundZoom,
      Value<double>? backgroundBlur,
      Value<double>? backgroundOverlay,
      Value<String>? hapticsMode,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return DeviceAppearanceProfilesCompanion(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      density: density ?? this.density,
      navOrderJson: navOrderJson ?? this.navOrderJson,
      hiddenNavJson: hiddenNavJson ?? this.hiddenNavJson,
      startModule: startModule ?? this.startModule,
      localBackgroundImageId:
          localBackgroundImageId ?? this.localBackgroundImageId,
      backgroundFocusX: backgroundFocusX ?? this.backgroundFocusX,
      backgroundFocusY: backgroundFocusY ?? this.backgroundFocusY,
      backgroundZoom: backgroundZoom ?? this.backgroundZoom,
      backgroundBlur: backgroundBlur ?? this.backgroundBlur,
      backgroundOverlay: backgroundOverlay ?? this.backgroundOverlay,
      hapticsMode: hapticsMode ?? this.hapticsMode,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (density.present) {
      map['density'] = Variable<String>(density.value);
    }
    if (navOrderJson.present) {
      map['nav_order_json'] = Variable<String>(navOrderJson.value);
    }
    if (hiddenNavJson.present) {
      map['hidden_nav_json'] = Variable<String>(hiddenNavJson.value);
    }
    if (startModule.present) {
      map['start_module'] = Variable<String>(startModule.value);
    }
    if (localBackgroundImageId.present) {
      map['local_background_image_id'] =
          Variable<String>(localBackgroundImageId.value);
    }
    if (backgroundFocusX.present) {
      map['background_focus_x'] = Variable<double>(backgroundFocusX.value);
    }
    if (backgroundFocusY.present) {
      map['background_focus_y'] = Variable<double>(backgroundFocusY.value);
    }
    if (backgroundZoom.present) {
      map['background_zoom'] = Variable<double>(backgroundZoom.value);
    }
    if (backgroundBlur.present) {
      map['background_blur'] = Variable<double>(backgroundBlur.value);
    }
    if (backgroundOverlay.present) {
      map['background_overlay'] = Variable<double>(backgroundOverlay.value);
    }
    if (hapticsMode.present) {
      map['haptics_mode'] = Variable<String>(hapticsMode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceAppearanceProfilesCompanion(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('density: $density, ')
          ..write('navOrderJson: $navOrderJson, ')
          ..write('hiddenNavJson: $hiddenNavJson, ')
          ..write('startModule: $startModule, ')
          ..write('localBackgroundImageId: $localBackgroundImageId, ')
          ..write('backgroundFocusX: $backgroundFocusX, ')
          ..write('backgroundFocusY: $backgroundFocusY, ')
          ..write('backgroundZoom: $backgroundZoom, ')
          ..write('backgroundBlur: $backgroundBlur, ')
          ..write('backgroundOverlay: $backgroundOverlay, ')
          ..write('hapticsMode: $hapticsMode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, HabitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
      'prompt', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _iconKeyMeta =
      const VerificationMeta('iconKey');
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
      'icon_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      check: () => ComparableExpr(color).isBetweenValues(0, 0xFFFFFF),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _scheduleTypeMeta =
      const VerificationMeta('scheduleType');
  @override
  late final GeneratedColumn<String> scheduleType = GeneratedColumn<String>(
      'schedule_type', aliasedName, false,
      check: () =>
          scheduleType.isIn(const ['daily', 'weekdays', 'weekly', 'interval']),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _scheduleJsonMeta =
      const VerificationMeta('scheduleJson');
  @override
  late final GeneratedColumn<String> scheduleJson = GeneratedColumn<String>(
      'schedule_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _archivedMeta =
      const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
      'archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        prompt,
        iconKey,
        color,
        scheduleType,
        scheduleJson,
        sortOrder,
        archived,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(Insertable<HabitRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(_promptMeta,
          prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta));
    }
    if (data.containsKey('icon_key')) {
      context.handle(_iconKeyMeta,
          iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta));
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('schedule_type')) {
      context.handle(
          _scheduleTypeMeta,
          scheduleType.isAcceptableOrUnknown(
              data['schedule_type']!, _scheduleTypeMeta));
    } else if (isInserting) {
      context.missing(_scheduleTypeMeta);
    }
    if (data.containsKey('schedule_json')) {
      context.handle(
          _scheduleJsonMeta,
          scheduleJson.isAcceptableOrUnknown(
              data['schedule_json']!, _scheduleJsonMeta));
    } else if (isInserting) {
      context.missing(_scheduleJsonMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta,
          archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      prompt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prompt'])!,
      iconKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_key'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      scheduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_type'])!,
      scheduleJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_json'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      archived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class HabitRow extends DataClass implements Insertable<HabitRow> {
  final String id;
  final String name;
  final String prompt;
  final String iconKey;
  final int color;
  final String scheduleType;
  final String scheduleJson;
  final int sortOrder;
  final bool archived;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const HabitRow(
      {required this.id,
      required this.name,
      required this.prompt,
      required this.iconKey,
      required this.color,
      required this.scheduleType,
      required this.scheduleJson,
      required this.sortOrder,
      required this.archived,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['prompt'] = Variable<String>(prompt);
    map['icon_key'] = Variable<String>(iconKey);
    map['color'] = Variable<int>(color);
    map['schedule_type'] = Variable<String>(scheduleType);
    map['schedule_json'] = Variable<String>(scheduleJson);
    map['sort_order'] = Variable<int>(sortOrder);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      prompt: Value(prompt),
      iconKey: Value(iconKey),
      color: Value(color),
      scheduleType: Value(scheduleType),
      scheduleJson: Value(scheduleJson),
      sortOrder: Value(sortOrder),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory HabitRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      prompt: serializer.fromJson<String>(json['prompt']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      color: serializer.fromJson<int>(json['color']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      scheduleJson: serializer.fromJson<String>(json['scheduleJson']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'prompt': serializer.toJson<String>(prompt),
      'iconKey': serializer.toJson<String>(iconKey),
      'color': serializer.toJson<int>(color),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'scheduleJson': serializer.toJson<String>(scheduleJson),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  HabitRow copyWith(
          {String? id,
          String? name,
          String? prompt,
          String? iconKey,
          int? color,
          String? scheduleType,
          String? scheduleJson,
          int? sortOrder,
          bool? archived,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      HabitRow(
        id: id ?? this.id,
        name: name ?? this.name,
        prompt: prompt ?? this.prompt,
        iconKey: iconKey ?? this.iconKey,
        color: color ?? this.color,
        scheduleType: scheduleType ?? this.scheduleType,
        scheduleJson: scheduleJson ?? this.scheduleJson,
        sortOrder: sortOrder ?? this.sortOrder,
        archived: archived ?? this.archived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  HabitRow copyWithCompanion(HabitsCompanion data) {
    return HabitRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      color: data.color.present ? data.color.value : this.color,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      scheduleJson: data.scheduleJson.present
          ? data.scheduleJson.value
          : this.scheduleJson,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('prompt: $prompt, ')
          ..write('iconKey: $iconKey, ')
          ..write('color: $color, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('scheduleJson: $scheduleJson, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      prompt,
      iconKey,
      color,
      scheduleType,
      scheduleJson,
      sortOrder,
      archived,
      createdAt,
      updatedAt,
      deletedAt,
      deviceId,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.prompt == this.prompt &&
          other.iconKey == this.iconKey &&
          other.color == this.color &&
          other.scheduleType == this.scheduleType &&
          other.scheduleJson == this.scheduleJson &&
          other.sortOrder == this.sortOrder &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class HabitsCompanion extends UpdateCompanion<HabitRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> prompt;
  final Value<String> iconKey;
  final Value<int> color;
  final Value<String> scheduleType;
  final Value<String> scheduleJson;
  final Value<int> sortOrder;
  final Value<bool> archived;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.prompt = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.color = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.scheduleJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String name,
    this.prompt = const Value.absent(),
    required String iconKey,
    required int color,
    required String scheduleType,
    required String scheduleJson,
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        iconKey = Value(iconKey),
        color = Value(color),
        scheduleType = Value(scheduleType),
        scheduleJson = Value(scheduleJson),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<HabitRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? prompt,
    Expression<String>? iconKey,
    Expression<int>? color,
    Expression<String>? scheduleType,
    Expression<String>? scheduleJson,
    Expression<int>? sortOrder,
    Expression<bool>? archived,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (prompt != null) 'prompt': prompt,
      if (iconKey != null) 'icon_key': iconKey,
      if (color != null) 'color': color,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (scheduleJson != null) 'schedule_json': scheduleJson,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? prompt,
      Value<String>? iconKey,
      Value<int>? color,
      Value<String>? scheduleType,
      Value<String>? scheduleJson,
      Value<int>? sortOrder,
      Value<bool>? archived,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      prompt: prompt ?? this.prompt,
      iconKey: iconKey ?? this.iconKey,
      color: color ?? this.color,
      scheduleType: scheduleType ?? this.scheduleType,
      scheduleJson: scheduleJson ?? this.scheduleJson,
      sortOrder: sortOrder ?? this.sortOrder,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (scheduleJson.present) {
      map['schedule_json'] = Variable<String>(scheduleJson.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('prompt: $prompt, ')
          ..write('iconKey: $iconKey, ')
          ..write('color: $color, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('scheduleJson: $scheduleJson, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitCheckinsTable extends HabitCheckins
    with TableInfo<$HabitCheckinsTable, HabitCheckinRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitCheckinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _habitIdMeta =
      const VerificationMeta('habitId');
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
      'habit_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _checkinDayMeta =
      const VerificationMeta('checkinDay');
  @override
  late final GeneratedColumn<int> checkinDay = GeneratedColumn<int>(
      'checkin_day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      check: () => status.isIn(const ['done']),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        habitId,
        checkinDay,
        status,
        note,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_checkins';
  @override
  VerificationContext validateIntegrity(Insertable<HabitCheckinRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(_habitIdMeta,
          habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta));
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('checkin_day')) {
      context.handle(
          _checkinDayMeta,
          checkinDay.isAcceptableOrUnknown(
              data['checkin_day']!, _checkinDayMeta));
    } else if (isInserting) {
      context.missing(_checkinDayMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitCheckinRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitCheckinRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      habitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_id'])!,
      checkinDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}checkin_day'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $HabitCheckinsTable createAlias(String alias) {
    return $HabitCheckinsTable(attachedDatabase, alias);
  }
}

class HabitCheckinRow extends DataClass implements Insertable<HabitCheckinRow> {
  final String id;
  final String habitId;
  final int checkinDay;
  final String status;
  final String note;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;
  const HabitCheckinRow(
      {required this.id,
      required this.habitId,
      required this.checkinDay,
      required this.status,
      required this.note,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.deviceId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['checkin_day'] = Variable<int>(checkinDay);
    map['status'] = Variable<String>(status);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['version'] = Variable<int>(version);
    return map;
  }

  HabitCheckinsCompanion toCompanion(bool nullToAbsent) {
    return HabitCheckinsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      checkinDay: Value(checkinDay),
      status: Value(status),
      note: Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(version),
    );
  }

  factory HabitCheckinRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitCheckinRow(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      checkinDay: serializer.fromJson<int>(json['checkinDay']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'checkinDay': serializer.toJson<int>(checkinDay),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'version': serializer.toJson<int>(version),
    };
  }

  HabitCheckinRow copyWith(
          {String? id,
          String? habitId,
          int? checkinDay,
          String? status,
          String? note,
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent(),
          String? deviceId,
          int? version}) =>
      HabitCheckinRow(
        id: id ?? this.id,
        habitId: habitId ?? this.habitId,
        checkinDay: checkinDay ?? this.checkinDay,
        status: status ?? this.status,
        note: note ?? this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        deviceId: deviceId ?? this.deviceId,
        version: version ?? this.version,
      );
  HabitCheckinRow copyWithCompanion(HabitCheckinsCompanion data) {
    return HabitCheckinRow(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      checkinDay:
          data.checkinDay.present ? data.checkinDay.value : this.checkinDay,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitCheckinRow(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('checkinDay: $checkinDay, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, checkinDay, status, note,
      createdAt, updatedAt, deletedAt, deviceId, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitCheckinRow &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.checkinDay == this.checkinDay &&
          other.status == this.status &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.version == this.version);
}

class HabitCheckinsCompanion extends UpdateCompanion<HabitCheckinRow> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<int> checkinDay;
  final Value<String> status;
  final Value<String> note;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<int> version;
  final Value<int> rowid;
  const HabitCheckinsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.checkinDay = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitCheckinsCompanion.insert({
    required String id,
    required String habitId,
    required int checkinDay,
    required String status,
    this.note = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        habitId = Value(habitId),
        checkinDay = Value(checkinDay),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deviceId = Value(deviceId);
  static Insertable<HabitCheckinRow> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<int>? checkinDay,
    Expression<String>? status,
    Expression<String>? note,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (checkinDay != null) 'checkin_day': checkinDay,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitCheckinsCompanion copyWith(
      {Value<String>? id,
      Value<String>? habitId,
      Value<int>? checkinDay,
      Value<String>? status,
      Value<String>? note,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<String>? deviceId,
      Value<int>? version,
      Value<int>? rowid}) {
    return HabitCheckinsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      checkinDay: checkinDay ?? this.checkinDay,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (checkinDay.present) {
      map['checkin_day'] = Variable<int>(checkinDay.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitCheckinsCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('checkinDay: $checkinDay, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $NoteTagsTable noteTags = $NoteTagsTable(this);
  late final $ThemeSchemesTable themeSchemes = $ThemeSchemesTable(this);
  late final $SyncLogsTable syncLogs = $SyncLogsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $TaskListsTable taskLists = $TaskListsTable(this);
  late final $TasksV2Table tasksV2 = $TasksV2Table(this);
  late final $TaskCompletionsTable taskCompletions =
      $TaskCompletionsTable(this);
  late final $TaskRemindersTable taskReminders = $TaskRemindersTable(this);
  late final $TaskTagsTable taskTags = $TaskTagsTable(this);
  late final $TaskTagLinksTable taskTagLinks = $TaskTagLinksTable(this);
  late final $SmartFiltersTable smartFilters = $SmartFiltersTable(this);
  late final $ContentAttachmentsTable contentAttachments =
      $ContentAttachmentsTable(this);
  late final $CustomColorsTable customColors = $CustomColorsTable(this);
  late final $BackgroundImagesTable backgroundImages =
      $BackgroundImagesTable(this);
  late final $DeviceAppearanceProfilesTable deviceAppearanceProfiles =
      $DeviceAppearanceProfilesTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitCheckinsTable habitCheckins = $HabitCheckinsTable(this);
  late final NotesDao notesDao = NotesDao(this as AppDatabase);
  late final TodosDao todosDao = TodosDao(this as AppDatabase);
  late final TagsDao tagsDao = TagsDao(this as AppDatabase);
  late final NoteTagsDao noteTagsDao = NoteTagsDao(this as AppDatabase);
  late final ThemeSchemesDao themeSchemesDao =
      ThemeSchemesDao(this as AppDatabase);
  late final SyncLogsDao syncLogsDao = SyncLogsDao(this as AppDatabase);
  late final AppSettingsDao appSettingsDao =
      AppSettingsDao(this as AppDatabase);
  late final TasksV2Dao tasksV2Dao = TasksV2Dao(this as AppDatabase);
  late final TaskTaxonomyDao taskTaxonomyDao =
      TaskTaxonomyDao(this as AppDatabase);
  late final AttachmentsDao attachmentsDao =
      AttachmentsDao(this as AppDatabase);
  late final AppearanceDao appearanceDao = AppearanceDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        notes,
        todos,
        tags,
        noteTags,
        themeSchemes,
        syncLogs,
        appSettings,
        taskLists,
        tasksV2,
        taskCompletions,
        taskReminders,
        taskTags,
        taskTagLinks,
        smartFilters,
        contentAttachments,
        customColors,
        backgroundImages,
        deviceAppearanceProfiles,
        habits,
        habitCheckins
      ];
}

typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String id,
  required String title,
  required String content,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  Value<bool> pinned,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> content,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<bool> pinned,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteRow,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteRow, BaseReferences<_$AppDatabase, $NotesTable, NoteRow>),
    NoteRow,
    PrefetchHooks Function()> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            pinned: pinned,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String content,
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            pinned: pinned,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteRow,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteRow, BaseReferences<_$AppDatabase, $NotesTable, NoteRow>),
    NoteRow,
    PrefetchHooks Function()>;
typedef $$TodosTableCreateCompanionBuilder = TodosCompanion Function({
  required String id,
  required String title,
  Value<String> description,
  Value<bool> completed,
  Value<int?> dueAt,
  Value<int> priority,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$TodosTableUpdateCompanionBuilder = TodosCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<bool> completed,
  Value<int?> dueAt,
  Value<int> priority,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$TodosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodosTable,
    TodoRow,
    $$TodosTableFilterComposer,
    $$TodosTableOrderingComposer,
    $$TodosTableAnnotationComposer,
    $$TodosTableCreateCompanionBuilder,
    $$TodosTableUpdateCompanionBuilder,
    (TodoRow, BaseReferences<_$AppDatabase, $TodosTable, TodoRow>),
    TodoRow,
    PrefetchHooks Function()> {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<int?> dueAt = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodosCompanion(
            id: id,
            title: title,
            description: description,
            completed: completed,
            dueAt: dueAt,
            priority: priority,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> description = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<int?> dueAt = const Value.absent(),
            Value<int> priority = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodosCompanion.insert(
            id: id,
            title: title,
            description: description,
            completed: completed,
            dueAt: dueAt,
            priority: priority,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodosTable,
    TodoRow,
    $$TodosTableFilterComposer,
    $$TodosTableOrderingComposer,
    $$TodosTableAnnotationComposer,
    $$TodosTableCreateCompanionBuilder,
    $$TodosTableUpdateCompanionBuilder,
    (TodoRow, BaseReferences<_$AppDatabase, $TodosTable, TodoRow>),
    TodoRow,
    PrefetchHooks Function()>;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String id,
  required String name,
  Value<String?> color,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> color,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> rowid,
});

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$TagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTable,
    TagRow,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (TagRow, BaseReferences<_$AppDatabase, $TagsTable, TagRow>),
    TagRow,
    PrefetchHooks Function()> {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> color = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagsTable,
    TagRow,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (TagRow, BaseReferences<_$AppDatabase, $TagsTable, TagRow>),
    TagRow,
    PrefetchHooks Function()>;
typedef $$NoteTagsTableCreateCompanionBuilder = NoteTagsCompanion Function({
  required String noteId,
  required String tagId,
  required int createdAt,
  Value<int> rowid,
});
typedef $$NoteTagsTableUpdateCompanionBuilder = NoteTagsCompanion Function({
  Value<String> noteId,
  Value<String> tagId,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$NoteTagsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$NoteTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$NoteTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NoteTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoteTagsTable,
    NoteTagRow,
    $$NoteTagsTableFilterComposer,
    $$NoteTagsTableOrderingComposer,
    $$NoteTagsTableAnnotationComposer,
    $$NoteTagsTableCreateCompanionBuilder,
    $$NoteTagsTableUpdateCompanionBuilder,
    (NoteTagRow, BaseReferences<_$AppDatabase, $NoteTagsTable, NoteTagRow>),
    NoteTagRow,
    PrefetchHooks Function()> {
  $$NoteTagsTableTableManager(_$AppDatabase db, $NoteTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> noteId = const Value.absent(),
            Value<String> tagId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteTagsCompanion(
            noteId: noteId,
            tagId: tagId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String noteId,
            required String tagId,
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteTagsCompanion.insert(
            noteId: noteId,
            tagId: tagId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NoteTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoteTagsTable,
    NoteTagRow,
    $$NoteTagsTableFilterComposer,
    $$NoteTagsTableOrderingComposer,
    $$NoteTagsTableAnnotationComposer,
    $$NoteTagsTableCreateCompanionBuilder,
    $$NoteTagsTableUpdateCompanionBuilder,
    (NoteTagRow, BaseReferences<_$AppDatabase, $NoteTagsTable, NoteTagRow>),
    NoteTagRow,
    PrefetchHooks Function()>;
typedef $$ThemeSchemesTableCreateCompanionBuilder = ThemeSchemesCompanion
    Function({
  required String id,
  required String name,
  required int backgroundColor,
  required int primaryColor,
  required int textColor,
  required int surfaceColor,
  Value<String> brightness,
  required int createdAt,
  required int updatedAt,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ThemeSchemesTableUpdateCompanionBuilder = ThemeSchemesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<int> backgroundColor,
  Value<int> primaryColor,
  Value<int> textColor,
  Value<int> surfaceColor,
  Value<String> brightness,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$ThemeSchemesTableFilterComposer
    extends Composer<_$AppDatabase, $ThemeSchemesTable> {
  $$ThemeSchemesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get backgroundColor => $composableBuilder(
      column: $table.backgroundColor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get primaryColor => $composableBuilder(
      column: $table.primaryColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get textColor => $composableBuilder(
      column: $table.textColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surfaceColor => $composableBuilder(
      column: $table.surfaceColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brightness => $composableBuilder(
      column: $table.brightness, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$ThemeSchemesTableOrderingComposer
    extends Composer<_$AppDatabase, $ThemeSchemesTable> {
  $$ThemeSchemesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get backgroundColor => $composableBuilder(
      column: $table.backgroundColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get primaryColor => $composableBuilder(
      column: $table.primaryColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get textColor => $composableBuilder(
      column: $table.textColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surfaceColor => $composableBuilder(
      column: $table.surfaceColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brightness => $composableBuilder(
      column: $table.brightness, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$ThemeSchemesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThemeSchemesTable> {
  $$ThemeSchemesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get backgroundColor => $composableBuilder(
      column: $table.backgroundColor, builder: (column) => column);

  GeneratedColumn<int> get primaryColor => $composableBuilder(
      column: $table.primaryColor, builder: (column) => column);

  GeneratedColumn<int> get textColor =>
      $composableBuilder(column: $table.textColor, builder: (column) => column);

  GeneratedColumn<int> get surfaceColor => $composableBuilder(
      column: $table.surfaceColor, builder: (column) => column);

  GeneratedColumn<String> get brightness => $composableBuilder(
      column: $table.brightness, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ThemeSchemesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ThemeSchemesTable,
    ThemeSchemeRow,
    $$ThemeSchemesTableFilterComposer,
    $$ThemeSchemesTableOrderingComposer,
    $$ThemeSchemesTableAnnotationComposer,
    $$ThemeSchemesTableCreateCompanionBuilder,
    $$ThemeSchemesTableUpdateCompanionBuilder,
    (
      ThemeSchemeRow,
      BaseReferences<_$AppDatabase, $ThemeSchemesTable, ThemeSchemeRow>
    ),
    ThemeSchemeRow,
    PrefetchHooks Function()> {
  $$ThemeSchemesTableTableManager(_$AppDatabase db, $ThemeSchemesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThemeSchemesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThemeSchemesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThemeSchemesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> backgroundColor = const Value.absent(),
            Value<int> primaryColor = const Value.absent(),
            Value<int> textColor = const Value.absent(),
            Value<int> surfaceColor = const Value.absent(),
            Value<String> brightness = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ThemeSchemesCompanion(
            id: id,
            name: name,
            backgroundColor: backgroundColor,
            primaryColor: primaryColor,
            textColor: textColor,
            surfaceColor: surfaceColor,
            brightness: brightness,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int backgroundColor,
            required int primaryColor,
            required int textColor,
            required int surfaceColor,
            Value<String> brightness = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ThemeSchemesCompanion.insert(
            id: id,
            name: name,
            backgroundColor: backgroundColor,
            primaryColor: primaryColor,
            textColor: textColor,
            surfaceColor: surfaceColor,
            brightness: brightness,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ThemeSchemesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ThemeSchemesTable,
    ThemeSchemeRow,
    $$ThemeSchemesTableFilterComposer,
    $$ThemeSchemesTableOrderingComposer,
    $$ThemeSchemesTableAnnotationComposer,
    $$ThemeSchemesTableCreateCompanionBuilder,
    $$ThemeSchemesTableUpdateCompanionBuilder,
    (
      ThemeSchemeRow,
      BaseReferences<_$AppDatabase, $ThemeSchemesTable, ThemeSchemeRow>
    ),
    ThemeSchemeRow,
    PrefetchHooks Function()>;
typedef $$SyncLogsTableCreateCompanionBuilder = SyncLogsCompanion Function({
  required String id,
  Value<String?> peerDeviceId,
  Value<String?> peerDeviceName,
  required int startedAt,
  Value<int?> finishedAt,
  required String status,
  Value<int> notesCreated,
  Value<int> notesUpdated,
  Value<int> notesDeleted,
  Value<int> todosCreated,
  Value<int> todosUpdated,
  Value<int> todosDeleted,
  Value<String?> errorMessage,
  Value<int> rowid,
});
typedef $$SyncLogsTableUpdateCompanionBuilder = SyncLogsCompanion Function({
  Value<String> id,
  Value<String?> peerDeviceId,
  Value<String?> peerDeviceName,
  Value<int> startedAt,
  Value<int?> finishedAt,
  Value<String> status,
  Value<int> notesCreated,
  Value<int> notesUpdated,
  Value<int> notesDeleted,
  Value<int> todosCreated,
  Value<int> todosUpdated,
  Value<int> todosDeleted,
  Value<String?> errorMessage,
  Value<int> rowid,
});

class $$SyncLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get peerDeviceId => $composableBuilder(
      column: $table.peerDeviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get peerDeviceName => $composableBuilder(
      column: $table.peerDeviceName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notesCreated => $composableBuilder(
      column: $table.notesCreated, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notesUpdated => $composableBuilder(
      column: $table.notesUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notesDeleted => $composableBuilder(
      column: $table.notesDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get todosCreated => $composableBuilder(
      column: $table.todosCreated, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get todosUpdated => $composableBuilder(
      column: $table.todosUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get todosDeleted => $composableBuilder(
      column: $table.todosDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));
}

class $$SyncLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get peerDeviceId => $composableBuilder(
      column: $table.peerDeviceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get peerDeviceName => $composableBuilder(
      column: $table.peerDeviceName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notesCreated => $composableBuilder(
      column: $table.notesCreated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notesUpdated => $composableBuilder(
      column: $table.notesUpdated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notesDeleted => $composableBuilder(
      column: $table.notesDeleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get todosCreated => $composableBuilder(
      column: $table.todosCreated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get todosUpdated => $composableBuilder(
      column: $table.todosUpdated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get todosDeleted => $composableBuilder(
      column: $table.todosDeleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get peerDeviceId => $composableBuilder(
      column: $table.peerDeviceId, builder: (column) => column);

  GeneratedColumn<String> get peerDeviceName => $composableBuilder(
      column: $table.peerDeviceName, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get notesCreated => $composableBuilder(
      column: $table.notesCreated, builder: (column) => column);

  GeneratedColumn<int> get notesUpdated => $composableBuilder(
      column: $table.notesUpdated, builder: (column) => column);

  GeneratedColumn<int> get notesDeleted => $composableBuilder(
      column: $table.notesDeleted, builder: (column) => column);

  GeneratedColumn<int> get todosCreated => $composableBuilder(
      column: $table.todosCreated, builder: (column) => column);

  GeneratedColumn<int> get todosUpdated => $composableBuilder(
      column: $table.todosUpdated, builder: (column) => column);

  GeneratedColumn<int> get todosDeleted => $composableBuilder(
      column: $table.todosDeleted, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);
}

class $$SyncLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncLogsTable,
    SyncLogRow,
    $$SyncLogsTableFilterComposer,
    $$SyncLogsTableOrderingComposer,
    $$SyncLogsTableAnnotationComposer,
    $$SyncLogsTableCreateCompanionBuilder,
    $$SyncLogsTableUpdateCompanionBuilder,
    (SyncLogRow, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLogRow>),
    SyncLogRow,
    PrefetchHooks Function()> {
  $$SyncLogsTableTableManager(_$AppDatabase db, $SyncLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> peerDeviceId = const Value.absent(),
            Value<String?> peerDeviceName = const Value.absent(),
            Value<int> startedAt = const Value.absent(),
            Value<int?> finishedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> notesCreated = const Value.absent(),
            Value<int> notesUpdated = const Value.absent(),
            Value<int> notesDeleted = const Value.absent(),
            Value<int> todosCreated = const Value.absent(),
            Value<int> todosUpdated = const Value.absent(),
            Value<int> todosDeleted = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncLogsCompanion(
            id: id,
            peerDeviceId: peerDeviceId,
            peerDeviceName: peerDeviceName,
            startedAt: startedAt,
            finishedAt: finishedAt,
            status: status,
            notesCreated: notesCreated,
            notesUpdated: notesUpdated,
            notesDeleted: notesDeleted,
            todosCreated: todosCreated,
            todosUpdated: todosUpdated,
            todosDeleted: todosDeleted,
            errorMessage: errorMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> peerDeviceId = const Value.absent(),
            Value<String?> peerDeviceName = const Value.absent(),
            required int startedAt,
            Value<int?> finishedAt = const Value.absent(),
            required String status,
            Value<int> notesCreated = const Value.absent(),
            Value<int> notesUpdated = const Value.absent(),
            Value<int> notesDeleted = const Value.absent(),
            Value<int> todosCreated = const Value.absent(),
            Value<int> todosUpdated = const Value.absent(),
            Value<int> todosDeleted = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncLogsCompanion.insert(
            id: id,
            peerDeviceId: peerDeviceId,
            peerDeviceName: peerDeviceName,
            startedAt: startedAt,
            finishedAt: finishedAt,
            status: status,
            notesCreated: notesCreated,
            notesUpdated: notesUpdated,
            notesDeleted: notesDeleted,
            todosCreated: todosCreated,
            todosUpdated: todosUpdated,
            todosDeleted: todosDeleted,
            errorMessage: errorMessage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncLogsTable,
    SyncLogRow,
    $$SyncLogsTableFilterComposer,
    $$SyncLogsTableOrderingComposer,
    $$SyncLogsTableAnnotationComposer,
    $$SyncLogsTableCreateCompanionBuilder,
    $$SyncLogsTableUpdateCompanionBuilder,
    (SyncLogRow, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLogRow>),
    SyncLogRow,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingRow,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSettingRow,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>
    ),
    AppSettingRow,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSettingRow,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSettingRow,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>
    ),
    AppSettingRow,
    PrefetchHooks Function()>;
typedef $$TaskListsTableCreateCompanionBuilder = TaskListsCompanion Function({
  required String id,
  required String name,
  required int color,
  required String iconKey,
  Value<int> sortOrder,
  Value<bool> archived,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$TaskListsTableUpdateCompanionBuilder = TaskListsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> color,
  Value<String> iconKey,
  Value<int> sortOrder,
  Value<bool> archived,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$TaskListsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconKey => $composableBuilder(
      column: $table.iconKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$TaskListsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconKey => $composableBuilder(
      column: $table.iconKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$TaskListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$TaskListsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskListsTable,
    TaskListRow,
    $$TaskListsTableFilterComposer,
    $$TaskListsTableOrderingComposer,
    $$TaskListsTableAnnotationComposer,
    $$TaskListsTableCreateCompanionBuilder,
    $$TaskListsTableUpdateCompanionBuilder,
    (TaskListRow, BaseReferences<_$AppDatabase, $TaskListsTable, TaskListRow>),
    TaskListRow,
    PrefetchHooks Function()> {
  $$TaskListsTableTableManager(_$AppDatabase db, $TaskListsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> color = const Value.absent(),
            Value<String> iconKey = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> archived = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskListsCompanion(
            id: id,
            name: name,
            color: color,
            iconKey: iconKey,
            sortOrder: sortOrder,
            archived: archived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int color,
            required String iconKey,
            Value<int> sortOrder = const Value.absent(),
            Value<bool> archived = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskListsCompanion.insert(
            id: id,
            name: name,
            color: color,
            iconKey: iconKey,
            sortOrder: sortOrder,
            archived: archived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskListsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskListsTable,
    TaskListRow,
    $$TaskListsTableFilterComposer,
    $$TaskListsTableOrderingComposer,
    $$TaskListsTableAnnotationComposer,
    $$TaskListsTableCreateCompanionBuilder,
    $$TaskListsTableUpdateCompanionBuilder,
    (TaskListRow, BaseReferences<_$AppDatabase, $TaskListsTable, TaskListRow>),
    TaskListRow,
    PrefetchHooks Function()>;
typedef $$TasksV2TableCreateCompanionBuilder = TasksV2Companion Function({
  required String id,
  Value<String?> parentId,
  Value<String?> listId,
  required String title,
  Value<String> descriptionMarkdown,
  Value<bool> completed,
  Value<int> priority,
  Value<int?> startAt,
  Value<int?> dueAt,
  Value<bool> allDay,
  Value<int> sortOrder,
  Value<String?> recurrenceRule,
  Value<int?> recurrenceEndAt,
  Value<int?> recurrenceCount,
  Value<int?> completedAt,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$TasksV2TableUpdateCompanionBuilder = TasksV2Companion Function({
  Value<String> id,
  Value<String?> parentId,
  Value<String?> listId,
  Value<String> title,
  Value<String> descriptionMarkdown,
  Value<bool> completed,
  Value<int> priority,
  Value<int?> startAt,
  Value<int?> dueAt,
  Value<bool> allDay,
  Value<int> sortOrder,
  Value<String?> recurrenceRule,
  Value<int?> recurrenceEndAt,
  Value<int?> recurrenceCount,
  Value<int?> completedAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$TasksV2TableFilterComposer
    extends Composer<_$AppDatabase, $TasksV2Table> {
  $$TasksV2TableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get listId => $composableBuilder(
      column: $table.listId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descriptionMarkdown => $composableBuilder(
      column: $table.descriptionMarkdown,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startAt => $composableBuilder(
      column: $table.startAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get allDay => $composableBuilder(
      column: $table.allDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recurrenceEndAt => $composableBuilder(
      column: $table.recurrenceEndAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recurrenceCount => $composableBuilder(
      column: $table.recurrenceCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$TasksV2TableOrderingComposer
    extends Composer<_$AppDatabase, $TasksV2Table> {
  $$TasksV2TableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get listId => $composableBuilder(
      column: $table.listId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descriptionMarkdown => $composableBuilder(
      column: $table.descriptionMarkdown,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startAt => $composableBuilder(
      column: $table.startAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get allDay => $composableBuilder(
      column: $table.allDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recurrenceEndAt => $composableBuilder(
      column: $table.recurrenceEndAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recurrenceCount => $composableBuilder(
      column: $table.recurrenceCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$TasksV2TableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksV2Table> {
  $$TasksV2TableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get descriptionMarkdown => $composableBuilder(
      column: $table.descriptionMarkdown, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<int> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<bool> get allDay =>
      $composableBuilder(column: $table.allDay, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  GeneratedColumn<int> get recurrenceEndAt => $composableBuilder(
      column: $table.recurrenceEndAt, builder: (column) => column);

  GeneratedColumn<int> get recurrenceCount => $composableBuilder(
      column: $table.recurrenceCount, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$TasksV2TableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksV2Table,
    TaskV2Row,
    $$TasksV2TableFilterComposer,
    $$TasksV2TableOrderingComposer,
    $$TasksV2TableAnnotationComposer,
    $$TasksV2TableCreateCompanionBuilder,
    $$TasksV2TableUpdateCompanionBuilder,
    (TaskV2Row, BaseReferences<_$AppDatabase, $TasksV2Table, TaskV2Row>),
    TaskV2Row,
    PrefetchHooks Function()> {
  $$TasksV2TableTableManager(_$AppDatabase db, $TasksV2Table table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksV2TableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksV2TableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksV2TableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String?> listId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> descriptionMarkdown = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int?> startAt = const Value.absent(),
            Value<int?> dueAt = const Value.absent(),
            Value<bool> allDay = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<int?> recurrenceEndAt = const Value.absent(),
            Value<int?> recurrenceCount = const Value.absent(),
            Value<int?> completedAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksV2Companion(
            id: id,
            parentId: parentId,
            listId: listId,
            title: title,
            descriptionMarkdown: descriptionMarkdown,
            completed: completed,
            priority: priority,
            startAt: startAt,
            dueAt: dueAt,
            allDay: allDay,
            sortOrder: sortOrder,
            recurrenceRule: recurrenceRule,
            recurrenceEndAt: recurrenceEndAt,
            recurrenceCount: recurrenceCount,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> parentId = const Value.absent(),
            Value<String?> listId = const Value.absent(),
            required String title,
            Value<String> descriptionMarkdown = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int?> startAt = const Value.absent(),
            Value<int?> dueAt = const Value.absent(),
            Value<bool> allDay = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
            Value<int?> recurrenceEndAt = const Value.absent(),
            Value<int?> recurrenceCount = const Value.absent(),
            Value<int?> completedAt = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksV2Companion.insert(
            id: id,
            parentId: parentId,
            listId: listId,
            title: title,
            descriptionMarkdown: descriptionMarkdown,
            completed: completed,
            priority: priority,
            startAt: startAt,
            dueAt: dueAt,
            allDay: allDay,
            sortOrder: sortOrder,
            recurrenceRule: recurrenceRule,
            recurrenceEndAt: recurrenceEndAt,
            recurrenceCount: recurrenceCount,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksV2TableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksV2Table,
    TaskV2Row,
    $$TasksV2TableFilterComposer,
    $$TasksV2TableOrderingComposer,
    $$TasksV2TableAnnotationComposer,
    $$TasksV2TableCreateCompanionBuilder,
    $$TasksV2TableUpdateCompanionBuilder,
    (TaskV2Row, BaseReferences<_$AppDatabase, $TasksV2Table, TaskV2Row>),
    TaskV2Row,
    PrefetchHooks Function()>;
typedef $$TaskCompletionsTableCreateCompanionBuilder = TaskCompletionsCompanion
    Function({
  required String id,
  required String taskId,
  required int scheduledAt,
  required int completedAt,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$TaskCompletionsTableUpdateCompanionBuilder = TaskCompletionsCompanion
    Function({
  Value<String> id,
  Value<String> taskId,
  Value<int> scheduledAt,
  Value<int> completedAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$TaskCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCompletionsTable> {
  $$TaskCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$TaskCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCompletionsTable> {
  $$TaskCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$TaskCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCompletionsTable> {
  $$TaskCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$TaskCompletionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskCompletionsTable,
    TaskCompletionRow,
    $$TaskCompletionsTableFilterComposer,
    $$TaskCompletionsTableOrderingComposer,
    $$TaskCompletionsTableAnnotationComposer,
    $$TaskCompletionsTableCreateCompanionBuilder,
    $$TaskCompletionsTableUpdateCompanionBuilder,
    (
      TaskCompletionRow,
      BaseReferences<_$AppDatabase, $TaskCompletionsTable, TaskCompletionRow>
    ),
    TaskCompletionRow,
    PrefetchHooks Function()> {
  $$TaskCompletionsTableTableManager(
      _$AppDatabase db, $TaskCompletionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<int> scheduledAt = const Value.absent(),
            Value<int> completedAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskCompletionsCompanion(
            id: id,
            taskId: taskId,
            scheduledAt: scheduledAt,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required int scheduledAt,
            required int completedAt,
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskCompletionsCompanion.insert(
            id: id,
            taskId: taskId,
            scheduledAt: scheduledAt,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskCompletionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskCompletionsTable,
    TaskCompletionRow,
    $$TaskCompletionsTableFilterComposer,
    $$TaskCompletionsTableOrderingComposer,
    $$TaskCompletionsTableAnnotationComposer,
    $$TaskCompletionsTableCreateCompanionBuilder,
    $$TaskCompletionsTableUpdateCompanionBuilder,
    (
      TaskCompletionRow,
      BaseReferences<_$AppDatabase, $TaskCompletionsTable, TaskCompletionRow>
    ),
    TaskCompletionRow,
    PrefetchHooks Function()>;
typedef $$TaskRemindersTableCreateCompanionBuilder = TaskRemindersCompanion
    Function({
  required String id,
  required String taskId,
  Value<int?> triggerAt,
  Value<int?> offsetMinutes,
  Value<int?> firedAt,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$TaskRemindersTableUpdateCompanionBuilder = TaskRemindersCompanion
    Function({
  Value<String> id,
  Value<String> taskId,
  Value<int?> triggerAt,
  Value<int?> offsetMinutes,
  Value<int?> firedAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$TaskRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get triggerAt => $composableBuilder(
      column: $table.triggerAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get offsetMinutes => $composableBuilder(
      column: $table.offsetMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get firedAt => $composableBuilder(
      column: $table.firedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$TaskRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get triggerAt => $composableBuilder(
      column: $table.triggerAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get offsetMinutes => $composableBuilder(
      column: $table.offsetMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get firedAt => $composableBuilder(
      column: $table.firedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$TaskRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get triggerAt =>
      $composableBuilder(column: $table.triggerAt, builder: (column) => column);

  GeneratedColumn<int> get offsetMinutes => $composableBuilder(
      column: $table.offsetMinutes, builder: (column) => column);

  GeneratedColumn<int> get firedAt =>
      $composableBuilder(column: $table.firedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$TaskRemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskRemindersTable,
    TaskReminderRow,
    $$TaskRemindersTableFilterComposer,
    $$TaskRemindersTableOrderingComposer,
    $$TaskRemindersTableAnnotationComposer,
    $$TaskRemindersTableCreateCompanionBuilder,
    $$TaskRemindersTableUpdateCompanionBuilder,
    (
      TaskReminderRow,
      BaseReferences<_$AppDatabase, $TaskRemindersTable, TaskReminderRow>
    ),
    TaskReminderRow,
    PrefetchHooks Function()> {
  $$TaskRemindersTableTableManager(_$AppDatabase db, $TaskRemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<int?> triggerAt = const Value.absent(),
            Value<int?> offsetMinutes = const Value.absent(),
            Value<int?> firedAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskRemindersCompanion(
            id: id,
            taskId: taskId,
            triggerAt: triggerAt,
            offsetMinutes: offsetMinutes,
            firedAt: firedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            Value<int?> triggerAt = const Value.absent(),
            Value<int?> offsetMinutes = const Value.absent(),
            Value<int?> firedAt = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskRemindersCompanion.insert(
            id: id,
            taskId: taskId,
            triggerAt: triggerAt,
            offsetMinutes: offsetMinutes,
            firedAt: firedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskRemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskRemindersTable,
    TaskReminderRow,
    $$TaskRemindersTableFilterComposer,
    $$TaskRemindersTableOrderingComposer,
    $$TaskRemindersTableAnnotationComposer,
    $$TaskRemindersTableCreateCompanionBuilder,
    $$TaskRemindersTableUpdateCompanionBuilder,
    (
      TaskReminderRow,
      BaseReferences<_$AppDatabase, $TaskRemindersTable, TaskReminderRow>
    ),
    TaskReminderRow,
    PrefetchHooks Function()>;
typedef $$TaskTagsTableCreateCompanionBuilder = TaskTagsCompanion Function({
  required String id,
  required String name,
  required int color,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$TaskTagsTableUpdateCompanionBuilder = TaskTagsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> color,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$TaskTagsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTagsTable> {
  $$TaskTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$TaskTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTagsTable> {
  $$TaskTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$TaskTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTagsTable> {
  $$TaskTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$TaskTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskTagsTable,
    TaskTagRow,
    $$TaskTagsTableFilterComposer,
    $$TaskTagsTableOrderingComposer,
    $$TaskTagsTableAnnotationComposer,
    $$TaskTagsTableCreateCompanionBuilder,
    $$TaskTagsTableUpdateCompanionBuilder,
    (TaskTagRow, BaseReferences<_$AppDatabase, $TaskTagsTable, TaskTagRow>),
    TaskTagRow,
    PrefetchHooks Function()> {
  $$TaskTagsTableTableManager(_$AppDatabase db, $TaskTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> color = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskTagsCompanion(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int color,
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskTagsCompanion.insert(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskTagsTable,
    TaskTagRow,
    $$TaskTagsTableFilterComposer,
    $$TaskTagsTableOrderingComposer,
    $$TaskTagsTableAnnotationComposer,
    $$TaskTagsTableCreateCompanionBuilder,
    $$TaskTagsTableUpdateCompanionBuilder,
    (TaskTagRow, BaseReferences<_$AppDatabase, $TaskTagsTable, TaskTagRow>),
    TaskTagRow,
    PrefetchHooks Function()>;
typedef $$TaskTagLinksTableCreateCompanionBuilder = TaskTagLinksCompanion
    Function({
  required String taskId,
  required String tagId,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$TaskTagLinksTableUpdateCompanionBuilder = TaskTagLinksCompanion
    Function({
  Value<String> taskId,
  Value<String> tagId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$TaskTagLinksTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTagLinksTable> {
  $$TaskTagLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$TaskTagLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTagLinksTable> {
  $$TaskTagLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$TaskTagLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTagLinksTable> {
  $$TaskTagLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$TaskTagLinksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskTagLinksTable,
    TaskTagLinkRow,
    $$TaskTagLinksTableFilterComposer,
    $$TaskTagLinksTableOrderingComposer,
    $$TaskTagLinksTableAnnotationComposer,
    $$TaskTagLinksTableCreateCompanionBuilder,
    $$TaskTagLinksTableUpdateCompanionBuilder,
    (
      TaskTagLinkRow,
      BaseReferences<_$AppDatabase, $TaskTagLinksTable, TaskTagLinkRow>
    ),
    TaskTagLinkRow,
    PrefetchHooks Function()> {
  $$TaskTagLinksTableTableManager(_$AppDatabase db, $TaskTagLinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskTagLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskTagLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskTagLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> taskId = const Value.absent(),
            Value<String> tagId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskTagLinksCompanion(
            taskId: taskId,
            tagId: tagId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String taskId,
            required String tagId,
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskTagLinksCompanion.insert(
            taskId: taskId,
            tagId: tagId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskTagLinksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskTagLinksTable,
    TaskTagLinkRow,
    $$TaskTagLinksTableFilterComposer,
    $$TaskTagLinksTableOrderingComposer,
    $$TaskTagLinksTableAnnotationComposer,
    $$TaskTagLinksTableCreateCompanionBuilder,
    $$TaskTagLinksTableUpdateCompanionBuilder,
    (
      TaskTagLinkRow,
      BaseReferences<_$AppDatabase, $TaskTagLinksTable, TaskTagLinkRow>
    ),
    TaskTagLinkRow,
    PrefetchHooks Function()>;
typedef $$SmartFiltersTableCreateCompanionBuilder = SmartFiltersCompanion
    Function({
  required String id,
  required String name,
  required String rulesJson,
  required String sortMode,
  Value<int> sortOrder,
  Value<bool> pinned,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$SmartFiltersTableUpdateCompanionBuilder = SmartFiltersCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> rulesJson,
  Value<String> sortMode,
  Value<int> sortOrder,
  Value<bool> pinned,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$SmartFiltersTableFilterComposer
    extends Composer<_$AppDatabase, $SmartFiltersTable> {
  $$SmartFiltersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rulesJson => $composableBuilder(
      column: $table.rulesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sortMode => $composableBuilder(
      column: $table.sortMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$SmartFiltersTableOrderingComposer
    extends Composer<_$AppDatabase, $SmartFiltersTable> {
  $$SmartFiltersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rulesJson => $composableBuilder(
      column: $table.rulesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sortMode => $composableBuilder(
      column: $table.sortMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$SmartFiltersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmartFiltersTable> {
  $$SmartFiltersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get rulesJson =>
      $composableBuilder(column: $table.rulesJson, builder: (column) => column);

  GeneratedColumn<String> get sortMode =>
      $composableBuilder(column: $table.sortMode, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$SmartFiltersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SmartFiltersTable,
    SmartFilterRow,
    $$SmartFiltersTableFilterComposer,
    $$SmartFiltersTableOrderingComposer,
    $$SmartFiltersTableAnnotationComposer,
    $$SmartFiltersTableCreateCompanionBuilder,
    $$SmartFiltersTableUpdateCompanionBuilder,
    (
      SmartFilterRow,
      BaseReferences<_$AppDatabase, $SmartFiltersTable, SmartFilterRow>
    ),
    SmartFilterRow,
    PrefetchHooks Function()> {
  $$SmartFiltersTableTableManager(_$AppDatabase db, $SmartFiltersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmartFiltersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmartFiltersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmartFiltersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> rulesJson = const Value.absent(),
            Value<String> sortMode = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SmartFiltersCompanion(
            id: id,
            name: name,
            rulesJson: rulesJson,
            sortMode: sortMode,
            sortOrder: sortOrder,
            pinned: pinned,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String rulesJson,
            required String sortMode,
            Value<int> sortOrder = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SmartFiltersCompanion.insert(
            id: id,
            name: name,
            rulesJson: rulesJson,
            sortMode: sortMode,
            sortOrder: sortOrder,
            pinned: pinned,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SmartFiltersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SmartFiltersTable,
    SmartFilterRow,
    $$SmartFiltersTableFilterComposer,
    $$SmartFiltersTableOrderingComposer,
    $$SmartFiltersTableAnnotationComposer,
    $$SmartFiltersTableCreateCompanionBuilder,
    $$SmartFiltersTableUpdateCompanionBuilder,
    (
      SmartFilterRow,
      BaseReferences<_$AppDatabase, $SmartFiltersTable, SmartFilterRow>
    ),
    SmartFilterRow,
    PrefetchHooks Function()>;
typedef $$ContentAttachmentsTableCreateCompanionBuilder
    = ContentAttachmentsCompanion Function({
  required String id,
  required String ownerType,
  required String ownerId,
  required String sha256,
  required String mimeType,
  required int byteSize,
  required int width,
  required int height,
  required String relativePath,
  required String thumbnailRelativePath,
  Value<int> sortOrder,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$ContentAttachmentsTableUpdateCompanionBuilder
    = ContentAttachmentsCompanion Function({
  Value<String> id,
  Value<String> ownerType,
  Value<String> ownerId,
  Value<String> sha256,
  Value<String> mimeType,
  Value<int> byteSize,
  Value<int> width,
  Value<int> height,
  Value<String> relativePath,
  Value<String> thumbnailRelativePath,
  Value<int> sortOrder,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$ContentAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentAttachmentsTable> {
  $$ContentAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerType => $composableBuilder(
      column: $table.ownerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sha256 => $composableBuilder(
      column: $table.sha256, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get byteSize => $composableBuilder(
      column: $table.byteSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relativePath => $composableBuilder(
      column: $table.relativePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailRelativePath => $composableBuilder(
      column: $table.thumbnailRelativePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$ContentAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentAttachmentsTable> {
  $$ContentAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerType => $composableBuilder(
      column: $table.ownerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sha256 => $composableBuilder(
      column: $table.sha256, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get byteSize => $composableBuilder(
      column: $table.byteSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relativePath => $composableBuilder(
      column: $table.relativePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailRelativePath => $composableBuilder(
      column: $table.thumbnailRelativePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$ContentAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentAttachmentsTable> {
  $$ContentAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
      column: $table.relativePath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailRelativePath => $composableBuilder(
      column: $table.thumbnailRelativePath, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$ContentAttachmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContentAttachmentsTable,
    ContentAttachmentRow,
    $$ContentAttachmentsTableFilterComposer,
    $$ContentAttachmentsTableOrderingComposer,
    $$ContentAttachmentsTableAnnotationComposer,
    $$ContentAttachmentsTableCreateCompanionBuilder,
    $$ContentAttachmentsTableUpdateCompanionBuilder,
    (
      ContentAttachmentRow,
      BaseReferences<_$AppDatabase, $ContentAttachmentsTable,
          ContentAttachmentRow>
    ),
    ContentAttachmentRow,
    PrefetchHooks Function()> {
  $$ContentAttachmentsTableTableManager(
      _$AppDatabase db, $ContentAttachmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentAttachmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerType = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> sha256 = const Value.absent(),
            Value<String> mimeType = const Value.absent(),
            Value<int> byteSize = const Value.absent(),
            Value<int> width = const Value.absent(),
            Value<int> height = const Value.absent(),
            Value<String> relativePath = const Value.absent(),
            Value<String> thumbnailRelativePath = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentAttachmentsCompanion(
            id: id,
            ownerType: ownerType,
            ownerId: ownerId,
            sha256: sha256,
            mimeType: mimeType,
            byteSize: byteSize,
            width: width,
            height: height,
            relativePath: relativePath,
            thumbnailRelativePath: thumbnailRelativePath,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerType,
            required String ownerId,
            required String sha256,
            required String mimeType,
            required int byteSize,
            required int width,
            required int height,
            required String relativePath,
            required String thumbnailRelativePath,
            Value<int> sortOrder = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentAttachmentsCompanion.insert(
            id: id,
            ownerType: ownerType,
            ownerId: ownerId,
            sha256: sha256,
            mimeType: mimeType,
            byteSize: byteSize,
            width: width,
            height: height,
            relativePath: relativePath,
            thumbnailRelativePath: thumbnailRelativePath,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContentAttachmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContentAttachmentsTable,
    ContentAttachmentRow,
    $$ContentAttachmentsTableFilterComposer,
    $$ContentAttachmentsTableOrderingComposer,
    $$ContentAttachmentsTableAnnotationComposer,
    $$ContentAttachmentsTableCreateCompanionBuilder,
    $$ContentAttachmentsTableUpdateCompanionBuilder,
    (
      ContentAttachmentRow,
      BaseReferences<_$AppDatabase, $ContentAttachmentsTable,
          ContentAttachmentRow>
    ),
    ContentAttachmentRow,
    PrefetchHooks Function()>;
typedef $$CustomColorsTableCreateCompanionBuilder = CustomColorsCompanion
    Function({
  required String id,
  required String name,
  required int rgb,
  Value<int> sortOrder,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$CustomColorsTableUpdateCompanionBuilder = CustomColorsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<int> rgb,
  Value<int> sortOrder,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$CustomColorsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomColorsTable> {
  $$CustomColorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rgb => $composableBuilder(
      column: $table.rgb, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$CustomColorsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomColorsTable> {
  $$CustomColorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rgb => $composableBuilder(
      column: $table.rgb, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$CustomColorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomColorsTable> {
  $$CustomColorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get rgb =>
      $composableBuilder(column: $table.rgb, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$CustomColorsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomColorsTable,
    CustomColorRow,
    $$CustomColorsTableFilterComposer,
    $$CustomColorsTableOrderingComposer,
    $$CustomColorsTableAnnotationComposer,
    $$CustomColorsTableCreateCompanionBuilder,
    $$CustomColorsTableUpdateCompanionBuilder,
    (
      CustomColorRow,
      BaseReferences<_$AppDatabase, $CustomColorsTable, CustomColorRow>
    ),
    CustomColorRow,
    PrefetchHooks Function()> {
  $$CustomColorsTableTableManager(_$AppDatabase db, $CustomColorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomColorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomColorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomColorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rgb = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomColorsCompanion(
            id: id,
            name: name,
            rgb: rgb,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int rgb,
            Value<int> sortOrder = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomColorsCompanion.insert(
            id: id,
            name: name,
            rgb: rgb,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomColorsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomColorsTable,
    CustomColorRow,
    $$CustomColorsTableFilterComposer,
    $$CustomColorsTableOrderingComposer,
    $$CustomColorsTableAnnotationComposer,
    $$CustomColorsTableCreateCompanionBuilder,
    $$CustomColorsTableUpdateCompanionBuilder,
    (
      CustomColorRow,
      BaseReferences<_$AppDatabase, $CustomColorsTable, CustomColorRow>
    ),
    CustomColorRow,
    PrefetchHooks Function()>;
typedef $$BackgroundImagesTableCreateCompanionBuilder
    = BackgroundImagesCompanion Function({
  required String id,
  required String sha256,
  required String mimeType,
  required int byteSize,
  required int width,
  required int height,
  required String relativePath,
  Value<bool> syncEnabled,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$BackgroundImagesTableUpdateCompanionBuilder
    = BackgroundImagesCompanion Function({
  Value<String> id,
  Value<String> sha256,
  Value<String> mimeType,
  Value<int> byteSize,
  Value<int> width,
  Value<int> height,
  Value<String> relativePath,
  Value<bool> syncEnabled,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$BackgroundImagesTableFilterComposer
    extends Composer<_$AppDatabase, $BackgroundImagesTable> {
  $$BackgroundImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sha256 => $composableBuilder(
      column: $table.sha256, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get byteSize => $composableBuilder(
      column: $table.byteSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relativePath => $composableBuilder(
      column: $table.relativePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get syncEnabled => $composableBuilder(
      column: $table.syncEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$BackgroundImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $BackgroundImagesTable> {
  $$BackgroundImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sha256 => $composableBuilder(
      column: $table.sha256, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get byteSize => $composableBuilder(
      column: $table.byteSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relativePath => $composableBuilder(
      column: $table.relativePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get syncEnabled => $composableBuilder(
      column: $table.syncEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$BackgroundImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackgroundImagesTable> {
  $$BackgroundImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
      column: $table.relativePath, builder: (column) => column);

  GeneratedColumn<bool> get syncEnabled => $composableBuilder(
      column: $table.syncEnabled, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$BackgroundImagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BackgroundImagesTable,
    BackgroundImageRow,
    $$BackgroundImagesTableFilterComposer,
    $$BackgroundImagesTableOrderingComposer,
    $$BackgroundImagesTableAnnotationComposer,
    $$BackgroundImagesTableCreateCompanionBuilder,
    $$BackgroundImagesTableUpdateCompanionBuilder,
    (
      BackgroundImageRow,
      BaseReferences<_$AppDatabase, $BackgroundImagesTable, BackgroundImageRow>
    ),
    BackgroundImageRow,
    PrefetchHooks Function()> {
  $$BackgroundImagesTableTableManager(
      _$AppDatabase db, $BackgroundImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackgroundImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackgroundImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackgroundImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sha256 = const Value.absent(),
            Value<String> mimeType = const Value.absent(),
            Value<int> byteSize = const Value.absent(),
            Value<int> width = const Value.absent(),
            Value<int> height = const Value.absent(),
            Value<String> relativePath = const Value.absent(),
            Value<bool> syncEnabled = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackgroundImagesCompanion(
            id: id,
            sha256: sha256,
            mimeType: mimeType,
            byteSize: byteSize,
            width: width,
            height: height,
            relativePath: relativePath,
            syncEnabled: syncEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sha256,
            required String mimeType,
            required int byteSize,
            required int width,
            required int height,
            required String relativePath,
            Value<bool> syncEnabled = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackgroundImagesCompanion.insert(
            id: id,
            sha256: sha256,
            mimeType: mimeType,
            byteSize: byteSize,
            width: width,
            height: height,
            relativePath: relativePath,
            syncEnabled: syncEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BackgroundImagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BackgroundImagesTable,
    BackgroundImageRow,
    $$BackgroundImagesTableFilterComposer,
    $$BackgroundImagesTableOrderingComposer,
    $$BackgroundImagesTableAnnotationComposer,
    $$BackgroundImagesTableCreateCompanionBuilder,
    $$BackgroundImagesTableUpdateCompanionBuilder,
    (
      BackgroundImageRow,
      BaseReferences<_$AppDatabase, $BackgroundImagesTable, BackgroundImageRow>
    ),
    BackgroundImageRow,
    PrefetchHooks Function()>;
typedef $$DeviceAppearanceProfilesTableCreateCompanionBuilder
    = DeviceAppearanceProfilesCompanion Function({
  required String id,
  required String platform,
  required String density,
  required String navOrderJson,
  required String hiddenNavJson,
  required String startModule,
  Value<String?> localBackgroundImageId,
  required double backgroundFocusX,
  required double backgroundFocusY,
  required double backgroundZoom,
  required double backgroundBlur,
  required double backgroundOverlay,
  required String hapticsMode,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$DeviceAppearanceProfilesTableUpdateCompanionBuilder
    = DeviceAppearanceProfilesCompanion Function({
  Value<String> id,
  Value<String> platform,
  Value<String> density,
  Value<String> navOrderJson,
  Value<String> hiddenNavJson,
  Value<String> startModule,
  Value<String?> localBackgroundImageId,
  Value<double> backgroundFocusX,
  Value<double> backgroundFocusY,
  Value<double> backgroundZoom,
  Value<double> backgroundBlur,
  Value<double> backgroundOverlay,
  Value<String> hapticsMode,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$DeviceAppearanceProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceAppearanceProfilesTable> {
  $$DeviceAppearanceProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get density => $composableBuilder(
      column: $table.density, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get navOrderJson => $composableBuilder(
      column: $table.navOrderJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hiddenNavJson => $composableBuilder(
      column: $table.hiddenNavJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startModule => $composableBuilder(
      column: $table.startModule, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localBackgroundImageId => $composableBuilder(
      column: $table.localBackgroundImageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get backgroundFocusX => $composableBuilder(
      column: $table.backgroundFocusX,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get backgroundFocusY => $composableBuilder(
      column: $table.backgroundFocusY,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get backgroundZoom => $composableBuilder(
      column: $table.backgroundZoom,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get backgroundBlur => $composableBuilder(
      column: $table.backgroundBlur,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get backgroundOverlay => $composableBuilder(
      column: $table.backgroundOverlay,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hapticsMode => $composableBuilder(
      column: $table.hapticsMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DeviceAppearanceProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceAppearanceProfilesTable> {
  $$DeviceAppearanceProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get density => $composableBuilder(
      column: $table.density, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get navOrderJson => $composableBuilder(
      column: $table.navOrderJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hiddenNavJson => $composableBuilder(
      column: $table.hiddenNavJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startModule => $composableBuilder(
      column: $table.startModule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localBackgroundImageId => $composableBuilder(
      column: $table.localBackgroundImageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get backgroundFocusX => $composableBuilder(
      column: $table.backgroundFocusX,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get backgroundFocusY => $composableBuilder(
      column: $table.backgroundFocusY,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get backgroundZoom => $composableBuilder(
      column: $table.backgroundZoom,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get backgroundBlur => $composableBuilder(
      column: $table.backgroundBlur,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get backgroundOverlay => $composableBuilder(
      column: $table.backgroundOverlay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hapticsMode => $composableBuilder(
      column: $table.hapticsMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DeviceAppearanceProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceAppearanceProfilesTable> {
  $$DeviceAppearanceProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get density =>
      $composableBuilder(column: $table.density, builder: (column) => column);

  GeneratedColumn<String> get navOrderJson => $composableBuilder(
      column: $table.navOrderJson, builder: (column) => column);

  GeneratedColumn<String> get hiddenNavJson => $composableBuilder(
      column: $table.hiddenNavJson, builder: (column) => column);

  GeneratedColumn<String> get startModule => $composableBuilder(
      column: $table.startModule, builder: (column) => column);

  GeneratedColumn<String> get localBackgroundImageId => $composableBuilder(
      column: $table.localBackgroundImageId, builder: (column) => column);

  GeneratedColumn<double> get backgroundFocusX => $composableBuilder(
      column: $table.backgroundFocusX, builder: (column) => column);

  GeneratedColumn<double> get backgroundFocusY => $composableBuilder(
      column: $table.backgroundFocusY, builder: (column) => column);

  GeneratedColumn<double> get backgroundZoom => $composableBuilder(
      column: $table.backgroundZoom, builder: (column) => column);

  GeneratedColumn<double> get backgroundBlur => $composableBuilder(
      column: $table.backgroundBlur, builder: (column) => column);

  GeneratedColumn<double> get backgroundOverlay => $composableBuilder(
      column: $table.backgroundOverlay, builder: (column) => column);

  GeneratedColumn<String> get hapticsMode => $composableBuilder(
      column: $table.hapticsMode, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DeviceAppearanceProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DeviceAppearanceProfilesTable,
    DeviceAppearanceProfileRow,
    $$DeviceAppearanceProfilesTableFilterComposer,
    $$DeviceAppearanceProfilesTableOrderingComposer,
    $$DeviceAppearanceProfilesTableAnnotationComposer,
    $$DeviceAppearanceProfilesTableCreateCompanionBuilder,
    $$DeviceAppearanceProfilesTableUpdateCompanionBuilder,
    (
      DeviceAppearanceProfileRow,
      BaseReferences<_$AppDatabase, $DeviceAppearanceProfilesTable,
          DeviceAppearanceProfileRow>
    ),
    DeviceAppearanceProfileRow,
    PrefetchHooks Function()> {
  $$DeviceAppearanceProfilesTableTableManager(
      _$AppDatabase db, $DeviceAppearanceProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceAppearanceProfilesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceAppearanceProfilesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceAppearanceProfilesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> platform = const Value.absent(),
            Value<String> density = const Value.absent(),
            Value<String> navOrderJson = const Value.absent(),
            Value<String> hiddenNavJson = const Value.absent(),
            Value<String> startModule = const Value.absent(),
            Value<String?> localBackgroundImageId = const Value.absent(),
            Value<double> backgroundFocusX = const Value.absent(),
            Value<double> backgroundFocusY = const Value.absent(),
            Value<double> backgroundZoom = const Value.absent(),
            Value<double> backgroundBlur = const Value.absent(),
            Value<double> backgroundOverlay = const Value.absent(),
            Value<String> hapticsMode = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeviceAppearanceProfilesCompanion(
            id: id,
            platform: platform,
            density: density,
            navOrderJson: navOrderJson,
            hiddenNavJson: hiddenNavJson,
            startModule: startModule,
            localBackgroundImageId: localBackgroundImageId,
            backgroundFocusX: backgroundFocusX,
            backgroundFocusY: backgroundFocusY,
            backgroundZoom: backgroundZoom,
            backgroundBlur: backgroundBlur,
            backgroundOverlay: backgroundOverlay,
            hapticsMode: hapticsMode,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String platform,
            required String density,
            required String navOrderJson,
            required String hiddenNavJson,
            required String startModule,
            Value<String?> localBackgroundImageId = const Value.absent(),
            required double backgroundFocusX,
            required double backgroundFocusY,
            required double backgroundZoom,
            required double backgroundBlur,
            required double backgroundOverlay,
            required String hapticsMode,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DeviceAppearanceProfilesCompanion.insert(
            id: id,
            platform: platform,
            density: density,
            navOrderJson: navOrderJson,
            hiddenNavJson: hiddenNavJson,
            startModule: startModule,
            localBackgroundImageId: localBackgroundImageId,
            backgroundFocusX: backgroundFocusX,
            backgroundFocusY: backgroundFocusY,
            backgroundZoom: backgroundZoom,
            backgroundBlur: backgroundBlur,
            backgroundOverlay: backgroundOverlay,
            hapticsMode: hapticsMode,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DeviceAppearanceProfilesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DeviceAppearanceProfilesTable,
        DeviceAppearanceProfileRow,
        $$DeviceAppearanceProfilesTableFilterComposer,
        $$DeviceAppearanceProfilesTableOrderingComposer,
        $$DeviceAppearanceProfilesTableAnnotationComposer,
        $$DeviceAppearanceProfilesTableCreateCompanionBuilder,
        $$DeviceAppearanceProfilesTableUpdateCompanionBuilder,
        (
          DeviceAppearanceProfileRow,
          BaseReferences<_$AppDatabase, $DeviceAppearanceProfilesTable,
              DeviceAppearanceProfileRow>
        ),
        DeviceAppearanceProfileRow,
        PrefetchHooks Function()>;
typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  required String id,
  required String name,
  Value<String> prompt,
  required String iconKey,
  required int color,
  required String scheduleType,
  required String scheduleJson,
  Value<int> sortOrder,
  Value<bool> archived,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> prompt,
  Value<String> iconKey,
  Value<int> color,
  Value<String> scheduleType,
  Value<String> scheduleJson,
  Value<int> sortOrder,
  Value<bool> archived,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prompt => $composableBuilder(
      column: $table.prompt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconKey => $composableBuilder(
      column: $table.iconKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleJson => $composableBuilder(
      column: $table.scheduleJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prompt => $composableBuilder(
      column: $table.prompt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconKey => $composableBuilder(
      column: $table.iconKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleJson => $composableBuilder(
      column: $table.scheduleJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => column);

  GeneratedColumn<String> get scheduleJson => $composableBuilder(
      column: $table.scheduleJson, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$HabitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitsTable,
    HabitRow,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (HabitRow, BaseReferences<_$AppDatabase, $HabitsTable, HabitRow>),
    HabitRow,
    PrefetchHooks Function()> {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> prompt = const Value.absent(),
            Value<String> iconKey = const Value.absent(),
            Value<int> color = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<String> scheduleJson = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> archived = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitsCompanion(
            id: id,
            name: name,
            prompt: prompt,
            iconKey: iconKey,
            color: color,
            scheduleType: scheduleType,
            scheduleJson: scheduleJson,
            sortOrder: sortOrder,
            archived: archived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> prompt = const Value.absent(),
            required String iconKey,
            required int color,
            required String scheduleType,
            required String scheduleJson,
            Value<int> sortOrder = const Value.absent(),
            Value<bool> archived = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitsCompanion.insert(
            id: id,
            name: name,
            prompt: prompt,
            iconKey: iconKey,
            color: color,
            scheduleType: scheduleType,
            scheduleJson: scheduleJson,
            sortOrder: sortOrder,
            archived: archived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HabitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitsTable,
    HabitRow,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (HabitRow, BaseReferences<_$AppDatabase, $HabitsTable, HabitRow>),
    HabitRow,
    PrefetchHooks Function()>;
typedef $$HabitCheckinsTableCreateCompanionBuilder = HabitCheckinsCompanion
    Function({
  required String id,
  required String habitId,
  required int checkinDay,
  required String status,
  Value<String> note,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  required String deviceId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$HabitCheckinsTableUpdateCompanionBuilder = HabitCheckinsCompanion
    Function({
  Value<String> id,
  Value<String> habitId,
  Value<int> checkinDay,
  Value<String> status,
  Value<String> note,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<String> deviceId,
  Value<int> version,
  Value<int> rowid,
});

class $$HabitCheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitCheckinsTable> {
  $$HabitCheckinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get habitId => $composableBuilder(
      column: $table.habitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checkinDay => $composableBuilder(
      column: $table.checkinDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$HabitCheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitCheckinsTable> {
  $$HabitCheckinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get habitId => $composableBuilder(
      column: $table.habitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checkinDay => $composableBuilder(
      column: $table.checkinDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$HabitCheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitCheckinsTable> {
  $$HabitCheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<int> get checkinDay => $composableBuilder(
      column: $table.checkinDay, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$HabitCheckinsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitCheckinsTable,
    HabitCheckinRow,
    $$HabitCheckinsTableFilterComposer,
    $$HabitCheckinsTableOrderingComposer,
    $$HabitCheckinsTableAnnotationComposer,
    $$HabitCheckinsTableCreateCompanionBuilder,
    $$HabitCheckinsTableUpdateCompanionBuilder,
    (
      HabitCheckinRow,
      BaseReferences<_$AppDatabase, $HabitCheckinsTable, HabitCheckinRow>
    ),
    HabitCheckinRow,
    PrefetchHooks Function()> {
  $$HabitCheckinsTableTableManager(_$AppDatabase db, $HabitCheckinsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitCheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitCheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitCheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> habitId = const Value.absent(),
            Value<int> checkinDay = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitCheckinsCompanion(
            id: id,
            habitId: habitId,
            checkinDay: checkinDay,
            status: status,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String habitId,
            required int checkinDay,
            required String status,
            Value<String> note = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            required String deviceId,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitCheckinsCompanion.insert(
            id: id,
            habitId: habitId,
            checkinDay: checkinDay,
            status: status,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            deviceId: deviceId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HabitCheckinsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitCheckinsTable,
    HabitCheckinRow,
    $$HabitCheckinsTableFilterComposer,
    $$HabitCheckinsTableOrderingComposer,
    $$HabitCheckinsTableAnnotationComposer,
    $$HabitCheckinsTableCreateCompanionBuilder,
    $$HabitCheckinsTableUpdateCompanionBuilder,
    (
      HabitCheckinRow,
      BaseReferences<_$AppDatabase, $HabitCheckinsTable, HabitCheckinRow>
    ),
    HabitCheckinRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$NoteTagsTableTableManager get noteTags =>
      $$NoteTagsTableTableManager(_db, _db.noteTags);
  $$ThemeSchemesTableTableManager get themeSchemes =>
      $$ThemeSchemesTableTableManager(_db, _db.themeSchemes);
  $$SyncLogsTableTableManager get syncLogs =>
      $$SyncLogsTableTableManager(_db, _db.syncLogs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$TaskListsTableTableManager get taskLists =>
      $$TaskListsTableTableManager(_db, _db.taskLists);
  $$TasksV2TableTableManager get tasksV2 =>
      $$TasksV2TableTableManager(_db, _db.tasksV2);
  $$TaskCompletionsTableTableManager get taskCompletions =>
      $$TaskCompletionsTableTableManager(_db, _db.taskCompletions);
  $$TaskRemindersTableTableManager get taskReminders =>
      $$TaskRemindersTableTableManager(_db, _db.taskReminders);
  $$TaskTagsTableTableManager get taskTags =>
      $$TaskTagsTableTableManager(_db, _db.taskTags);
  $$TaskTagLinksTableTableManager get taskTagLinks =>
      $$TaskTagLinksTableTableManager(_db, _db.taskTagLinks);
  $$SmartFiltersTableTableManager get smartFilters =>
      $$SmartFiltersTableTableManager(_db, _db.smartFilters);
  $$ContentAttachmentsTableTableManager get contentAttachments =>
      $$ContentAttachmentsTableTableManager(_db, _db.contentAttachments);
  $$CustomColorsTableTableManager get customColors =>
      $$CustomColorsTableTableManager(_db, _db.customColors);
  $$BackgroundImagesTableTableManager get backgroundImages =>
      $$BackgroundImagesTableTableManager(_db, _db.backgroundImages);
  $$DeviceAppearanceProfilesTableTableManager get deviceAppearanceProfiles =>
      $$DeviceAppearanceProfilesTableTableManager(
          _db, _db.deviceAppearanceProfiles);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitCheckinsTableTableManager get habitCheckins =>
      $$HabitCheckinsTableTableManager(_db, _db.habitCheckins);
}

mixin _$NotesDaoMixin on DatabaseAccessor<AppDatabase> {
  $NotesTable get notes => attachedDatabase.notes;
  NotesDaoManager get managers => NotesDaoManager(this);
}

class NotesDaoManager {
  final _$NotesDaoMixin _db;
  NotesDaoManager(this._db);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db.attachedDatabase, _db.notes);
}

mixin _$TodosDaoMixin on DatabaseAccessor<AppDatabase> {
  $TodosTable get todos => attachedDatabase.todos;
  TodosDaoManager get managers => TodosDaoManager(this);
}

class TodosDaoManager {
  final _$TodosDaoMixin _db;
  TodosDaoManager(this._db);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db.attachedDatabase, _db.todos);
}

mixin _$TagsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TagsTable get tags => attachedDatabase.tags;
  TagsDaoManager get managers => TagsDaoManager(this);
}

class TagsDaoManager {
  final _$TagsDaoMixin _db;
  TagsDaoManager(this._db);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
}

mixin _$NoteTagsDaoMixin on DatabaseAccessor<AppDatabase> {
  $NoteTagsTable get noteTags => attachedDatabase.noteTags;
  NoteTagsDaoManager get managers => NoteTagsDaoManager(this);
}

class NoteTagsDaoManager {
  final _$NoteTagsDaoMixin _db;
  NoteTagsDaoManager(this._db);
  $$NoteTagsTableTableManager get noteTags =>
      $$NoteTagsTableTableManager(_db.attachedDatabase, _db.noteTags);
}

mixin _$ThemeSchemesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ThemeSchemesTable get themeSchemes => attachedDatabase.themeSchemes;
  ThemeSchemesDaoManager get managers => ThemeSchemesDaoManager(this);
}

class ThemeSchemesDaoManager {
  final _$ThemeSchemesDaoMixin _db;
  ThemeSchemesDaoManager(this._db);
  $$ThemeSchemesTableTableManager get themeSchemes =>
      $$ThemeSchemesTableTableManager(_db.attachedDatabase, _db.themeSchemes);
}

mixin _$SyncLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SyncLogsTable get syncLogs => attachedDatabase.syncLogs;
  SyncLogsDaoManager get managers => SyncLogsDaoManager(this);
}

class SyncLogsDaoManager {
  final _$SyncLogsDaoMixin _db;
  SyncLogsDaoManager(this._db);
  $$SyncLogsTableTableManager get syncLogs =>
      $$SyncLogsTableTableManager(_db.attachedDatabase, _db.syncLogs);
}

mixin _$AppSettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AppSettingsTable get appSettings => attachedDatabase.appSettings;
  AppSettingsDaoManager get managers => AppSettingsDaoManager(this);
}

class AppSettingsDaoManager {
  final _$AppSettingsDaoMixin _db;
  AppSettingsDaoManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db.attachedDatabase, _db.appSettings);
}

mixin _$TasksV2DaoMixin on DatabaseAccessor<AppDatabase> {
  $TasksV2Table get tasksV2 => attachedDatabase.tasksV2;
  TasksV2DaoManager get managers => TasksV2DaoManager(this);
}

class TasksV2DaoManager {
  final _$TasksV2DaoMixin _db;
  TasksV2DaoManager(this._db);
  $$TasksV2TableTableManager get tasksV2 =>
      $$TasksV2TableTableManager(_db.attachedDatabase, _db.tasksV2);
}

mixin _$TaskTaxonomyDaoMixin on DatabaseAccessor<AppDatabase> {
  $TaskListsTable get taskLists => attachedDatabase.taskLists;
  $TaskTagsTable get taskTags => attachedDatabase.taskTags;
  $TaskTagLinksTable get taskTagLinks => attachedDatabase.taskTagLinks;
  $SmartFiltersTable get smartFilters => attachedDatabase.smartFilters;
  $TasksV2Table get tasksV2 => attachedDatabase.tasksV2;
  TaskTaxonomyDaoManager get managers => TaskTaxonomyDaoManager(this);
}

class TaskTaxonomyDaoManager {
  final _$TaskTaxonomyDaoMixin _db;
  TaskTaxonomyDaoManager(this._db);
  $$TaskListsTableTableManager get taskLists =>
      $$TaskListsTableTableManager(_db.attachedDatabase, _db.taskLists);
  $$TaskTagsTableTableManager get taskTags =>
      $$TaskTagsTableTableManager(_db.attachedDatabase, _db.taskTags);
  $$TaskTagLinksTableTableManager get taskTagLinks =>
      $$TaskTagLinksTableTableManager(_db.attachedDatabase, _db.taskTagLinks);
  $$SmartFiltersTableTableManager get smartFilters =>
      $$SmartFiltersTableTableManager(_db.attachedDatabase, _db.smartFilters);
  $$TasksV2TableTableManager get tasksV2 =>
      $$TasksV2TableTableManager(_db.attachedDatabase, _db.tasksV2);
}

mixin _$AttachmentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ContentAttachmentsTable get contentAttachments =>
      attachedDatabase.contentAttachments;
  AttachmentsDaoManager get managers => AttachmentsDaoManager(this);
}

class AttachmentsDaoManager {
  final _$AttachmentsDaoMixin _db;
  AttachmentsDaoManager(this._db);
  $$ContentAttachmentsTableTableManager get contentAttachments =>
      $$ContentAttachmentsTableTableManager(
          _db.attachedDatabase, _db.contentAttachments);
}

mixin _$AppearanceDaoMixin on DatabaseAccessor<AppDatabase> {
  $CustomColorsTable get customColors => attachedDatabase.customColors;
  $BackgroundImagesTable get backgroundImages =>
      attachedDatabase.backgroundImages;
  $DeviceAppearanceProfilesTable get deviceAppearanceProfiles =>
      attachedDatabase.deviceAppearanceProfiles;
  AppearanceDaoManager get managers => AppearanceDaoManager(this);
}

class AppearanceDaoManager {
  final _$AppearanceDaoMixin _db;
  AppearanceDaoManager(this._db);
  $$CustomColorsTableTableManager get customColors =>
      $$CustomColorsTableTableManager(_db.attachedDatabase, _db.customColors);
  $$BackgroundImagesTableTableManager get backgroundImages =>
      $$BackgroundImagesTableTableManager(
          _db.attachedDatabase, _db.backgroundImages);
  $$DeviceAppearanceProfilesTableTableManager get deviceAppearanceProfiles =>
      $$DeviceAppearanceProfilesTableTableManager(
          _db.attachedDatabase, _db.deviceAppearanceProfiles);
}
