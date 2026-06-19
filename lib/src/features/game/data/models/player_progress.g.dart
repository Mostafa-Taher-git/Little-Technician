// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlayerProgressCollection on Isar {
  IsarCollection<PlayerProgress> get playerProgress => this.collection();
}

const PlayerProgressSchema = CollectionSchema(
  name: r'PlayerProgress',
  id: -69375815682459782,
  properties: {
    r'activeFrameId': PropertySchema(
      id: 0,
      name: r'activeFrameId',
      type: IsarType.string,
    ),
    r'activeSkinId': PropertySchema(
      id: 1,
      name: r'activeSkinId',
      type: IsarType.string,
    ),
    r'bossesDefeated': PropertySchema(
      id: 2,
      name: r'bossesDefeated',
      type: IsarType.long,
    ),
    r'completedCategoryIds': PropertySchema(
      id: 3,
      name: r'completedCategoryIds',
      type: IsarType.stringList,
    ),
    r'completedLevelIds': PropertySchema(
      id: 4,
      name: r'completedLevelIds',
      type: IsarType.stringList,
    ),
    r'completedWorldIds': PropertySchema(
      id: 5,
      name: r'completedWorldIds',
      type: IsarType.longList,
    ),
    r'correctAnswers': PropertySchema(
      id: 6,
      name: r'correctAnswers',
      type: IsarType.long,
    ),
    r'currentCategoryId': PropertySchema(
      id: 7,
      name: r'currentCategoryId',
      type: IsarType.string,
    ),
    r'currentLevelId': PropertySchema(
      id: 8,
      name: r'currentLevelId',
      type: IsarType.string,
    ),
    r'currentWorldId': PropertySchema(
      id: 9,
      name: r'currentWorldId',
      type: IsarType.long,
    ),
    r'earnedRewardIds': PropertySchema(
      id: 10,
      name: r'earnedRewardIds',
      type: IsarType.stringList,
    ),
    r'extraSupTechUses': PropertySchema(
      id: 11,
      name: r'extraSupTechUses',
      type: IsarType.long,
    ),
    r'lastActiveDate': PropertySchema(
      id: 12,
      name: r'lastActiveDate',
      type: IsarType.dateTime,
    ),
    r'levelsCleared': PropertySchema(
      id: 13,
      name: r'levelsCleared',
      type: IsarType.long,
    ),
    r'playDates': PropertySchema(
      id: 14,
      name: r'playDates',
      type: IsarType.dateTimeList,
    ),
    r'points': PropertySchema(
      id: 15,
      name: r'points',
      type: IsarType.long,
    ),
    r'prepResults': PropertySchema(
      id: 16,
      name: r'prepResults',
      type: IsarType.stringList,
    ),
    r'supTechUsesThisLevel': PropertySchema(
      id: 17,
      name: r'supTechUsesThisLevel',
      type: IsarType.long,
    ),
    r'themeId': PropertySchema(
      id: 18,
      name: r'themeId',
      type: IsarType.string,
    ),
    r'totalAnswers': PropertySchema(
      id: 19,
      name: r'totalAnswers',
      type: IsarType.long,
    ),
    r'totalPlayTimeSeconds': PropertySchema(
      id: 20,
      name: r'totalPlayTimeSeconds',
      type: IsarType.long,
    ),
    r'unlockedSkinIds': PropertySchema(
      id: 21,
      name: r'unlockedSkinIds',
      type: IsarType.stringList,
    ),
    r'userId': PropertySchema(
      id: 22,
      name: r'userId',
      type: IsarType.long,
    )
  },
  estimateSize: _playerProgressEstimateSize,
  serialize: _playerProgressSerialize,
  deserialize: _playerProgressDeserialize,
  deserializeProp: _playerProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _playerProgressGetId,
  getLinks: _playerProgressGetLinks,
  attach: _playerProgressAttach,
  version: '3.1.0+1',
);

int _playerProgressEstimateSize(
  PlayerProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activeFrameId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.activeSkinId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.completedCategoryIds.length * 3;
  {
    for (var i = 0; i < object.completedCategoryIds.length; i++) {
      final value = object.completedCategoryIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.completedLevelIds.length * 3;
  {
    for (var i = 0; i < object.completedLevelIds.length; i++) {
      final value = object.completedLevelIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.completedWorldIds.length * 8;
  {
    final value = object.currentCategoryId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.currentLevelId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.earnedRewardIds.length * 3;
  {
    for (var i = 0; i < object.earnedRewardIds.length; i++) {
      final value = object.earnedRewardIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.playDates.length * 8;
  bytesCount += 3 + object.prepResults.length * 3;
  {
    for (var i = 0; i < object.prepResults.length; i++) {
      final value = object.prepResults[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.themeId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.unlockedSkinIds.length * 3;
  {
    for (var i = 0; i < object.unlockedSkinIds.length; i++) {
      final value = object.unlockedSkinIds[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _playerProgressSerialize(
  PlayerProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activeFrameId);
  writer.writeString(offsets[1], object.activeSkinId);
  writer.writeLong(offsets[2], object.bossesDefeated);
  writer.writeStringList(offsets[3], object.completedCategoryIds);
  writer.writeStringList(offsets[4], object.completedLevelIds);
  writer.writeLongList(offsets[5], object.completedWorldIds);
  writer.writeLong(offsets[6], object.correctAnswers);
  writer.writeString(offsets[7], object.currentCategoryId);
  writer.writeString(offsets[8], object.currentLevelId);
  writer.writeLong(offsets[9], object.currentWorldId);
  writer.writeStringList(offsets[10], object.earnedRewardIds);
  writer.writeLong(offsets[11], object.extraSupTechUses);
  writer.writeDateTime(offsets[12], object.lastActiveDate);
  writer.writeLong(offsets[13], object.levelsCleared);
  writer.writeDateTimeList(offsets[14], object.playDates);
  writer.writeLong(offsets[15], object.points);
  writer.writeStringList(offsets[16], object.prepResults);
  writer.writeLong(offsets[17], object.supTechUsesThisLevel);
  writer.writeString(offsets[18], object.themeId);
  writer.writeLong(offsets[19], object.totalAnswers);
  writer.writeLong(offsets[20], object.totalPlayTimeSeconds);
  writer.writeStringList(offsets[21], object.unlockedSkinIds);
  writer.writeLong(offsets[22], object.userId);
}

PlayerProgress _playerProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlayerProgress();
  object.activeFrameId = reader.readStringOrNull(offsets[0]);
  object.activeSkinId = reader.readStringOrNull(offsets[1]);
  object.bossesDefeated = reader.readLong(offsets[2]);
  object.completedCategoryIds = reader.readStringList(offsets[3]) ?? [];
  object.completedLevelIds = reader.readStringList(offsets[4]) ?? [];
  object.completedWorldIds = reader.readLongList(offsets[5]) ?? [];
  object.correctAnswers = reader.readLong(offsets[6]);
  object.currentCategoryId = reader.readStringOrNull(offsets[7]);
  object.currentLevelId = reader.readStringOrNull(offsets[8]);
  object.currentWorldId = reader.readLong(offsets[9]);
  object.earnedRewardIds = reader.readStringList(offsets[10]) ?? [];
  object.extraSupTechUses = reader.readLong(offsets[11]);
  object.id = id;
  object.lastActiveDate = reader.readDateTimeOrNull(offsets[12]);
  object.levelsCleared = reader.readLong(offsets[13]);
  object.playDates = reader.readDateTimeList(offsets[14]) ?? [];
  object.points = reader.readLong(offsets[15]);
  object.prepResults = reader.readStringList(offsets[16]) ?? [];
  object.supTechUsesThisLevel = reader.readLong(offsets[17]);
  object.themeId = reader.readStringOrNull(offsets[18]);
  object.totalAnswers = reader.readLong(offsets[19]);
  object.totalPlayTimeSeconds = reader.readLong(offsets[20]);
  object.unlockedSkinIds = reader.readStringList(offsets[21]) ?? [];
  object.userId = reader.readLong(offsets[22]);
  return object;
}

P _playerProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readLongList(offset) ?? []) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringList(offset) ?? []) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDateTimeList(offset) ?? []) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readStringList(offset) ?? []) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readStringList(offset) ?? []) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playerProgressGetId(PlayerProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playerProgressGetLinks(PlayerProgress object) {
  return [];
}

void _playerProgressAttach(
    IsarCollection<dynamic> col, Id id, PlayerProgress object) {
  object.id = id;
}

extension PlayerProgressQueryWhereSort
    on QueryBuilder<PlayerProgress, PlayerProgress, QWhere> {
  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhere> anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }
}

extension PlayerProgressQueryWhere
    on QueryBuilder<PlayerProgress, PlayerProgress, QWhereClause> {
  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause> userIdEqualTo(
      int userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause>
      userIdNotEqualTo(int userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause>
      userIdGreaterThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [userId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause>
      userIdLessThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [],
        upper: [userId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterWhereClause> userIdBetween(
    int lowerUserId,
    int upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [lowerUserId],
        includeLower: includeLower,
        upper: [upperUserId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlayerProgressQueryFilter
    on QueryBuilder<PlayerProgress, PlayerProgress, QFilterCondition> {
  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeFrameId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeFrameId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeFrameId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeFrameId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeFrameId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeFrameId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activeFrameId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activeFrameId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activeFrameId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activeFrameId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeFrameId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeFrameIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activeFrameId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeSkinId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeSkinId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeSkinId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeSkinId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeSkinId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeSkinId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activeSkinId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activeSkinId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activeSkinId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activeSkinId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeSkinId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      activeSkinIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activeSkinId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      bossesDefeatedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bossesDefeated',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      bossesDefeatedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bossesDefeated',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      bossesDefeatedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bossesDefeated',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      bossesDefeatedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bossesDefeated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedCategoryIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedCategoryIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedCategoryIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedCategoryIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'completedCategoryIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'completedCategoryIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'completedCategoryIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'completedCategoryIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedCategoryIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'completedCategoryIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedCategoryIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedCategoryIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedCategoryIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedCategoryIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedCategoryIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedCategoryIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedCategoryIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedLevelIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedLevelIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedLevelIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedLevelIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'completedLevelIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'completedLevelIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'completedLevelIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'completedLevelIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedLevelIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'completedLevelIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedLevelIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedLevelIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedLevelIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedLevelIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedLevelIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedLevelIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedLevelIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedWorldIds',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedWorldIds',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedWorldIds',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedWorldIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedWorldIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedWorldIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedWorldIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedWorldIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedWorldIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      completedWorldIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedWorldIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      correctAnswersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correctAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      correctAnswersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'correctAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      correctAnswersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'correctAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      correctAnswersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'correctAnswers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentCategoryId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentCategoryId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentCategoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentCategoryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentCategoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentCategoryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentCategoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentLevelId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentLevelId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentLevelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentLevelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentLevelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentLevelId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentLevelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentLevelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentLevelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentLevelId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentLevelId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentLevelIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentLevelId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentWorldIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentWorldId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentWorldIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentWorldId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentWorldIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentWorldId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      currentWorldIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentWorldId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'earnedRewardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'earnedRewardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'earnedRewardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'earnedRewardIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'earnedRewardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'earnedRewardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'earnedRewardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'earnedRewardIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'earnedRewardIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'earnedRewardIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'earnedRewardIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'earnedRewardIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'earnedRewardIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'earnedRewardIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'earnedRewardIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      earnedRewardIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'earnedRewardIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      extraSupTechUsesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraSupTechUses',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      extraSupTechUsesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'extraSupTechUses',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      extraSupTechUsesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'extraSupTechUses',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      extraSupTechUsesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'extraSupTechUses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      lastActiveDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastActiveDate',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      lastActiveDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastActiveDate',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      lastActiveDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastActiveDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      lastActiveDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastActiveDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      lastActiveDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastActiveDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      lastActiveDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastActiveDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      levelsClearedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'levelsCleared',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      levelsClearedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'levelsCleared',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      levelsClearedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'levelsCleared',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      levelsClearedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'levelsCleared',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playDates',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playDates',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playDates',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playDates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playDates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playDates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playDates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playDates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      playDatesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'playDates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      pointsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'points',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      pointsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'points',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      pointsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'points',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      pointsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'points',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prepResults',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prepResults',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prepResults',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prepResults',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prepResults',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prepResults',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prepResults',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prepResults',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prepResults',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prepResults',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prepResults',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prepResults',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prepResults',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prepResults',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prepResults',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      prepResultsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prepResults',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      supTechUsesThisLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supTechUsesThisLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      supTechUsesThisLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supTechUsesThisLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      supTechUsesThisLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supTechUsesThisLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      supTechUsesThisLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supTechUsesThisLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'themeId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'themeId',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'themeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      themeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'themeId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      totalAnswersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      totalAnswersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      totalAnswersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      totalAnswersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAnswers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      totalPlayTimeSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPlayTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      totalPlayTimeSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPlayTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      totalPlayTimeSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPlayTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      totalPlayTimeSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPlayTimeSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unlockedSkinIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unlockedSkinIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unlockedSkinIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unlockedSkinIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unlockedSkinIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unlockedSkinIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unlockedSkinIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unlockedSkinIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unlockedSkinIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unlockedSkinIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedSkinIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedSkinIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedSkinIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedSkinIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedSkinIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      unlockedSkinIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedSkinIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      userIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterFilterCondition>
      userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlayerProgressQueryObject
    on QueryBuilder<PlayerProgress, PlayerProgress, QFilterCondition> {}

extension PlayerProgressQueryLinks
    on QueryBuilder<PlayerProgress, PlayerProgress, QFilterCondition> {}

extension PlayerProgressQuerySortBy
    on QueryBuilder<PlayerProgress, PlayerProgress, QSortBy> {
  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByActiveFrameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeFrameId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByActiveFrameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeFrameId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByActiveSkinId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeSkinId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByActiveSkinIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeSkinId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByBossesDefeated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossesDefeated', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByBossesDefeatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossesDefeated', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctAnswers', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByCorrectAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctAnswers', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByCurrentCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCategoryId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByCurrentCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCategoryId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByCurrentLevelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevelId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByCurrentLevelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevelId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByCurrentWorldId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWorldId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByCurrentWorldIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWorldId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByExtraSupTechUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraSupTechUses', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByExtraSupTechUsesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraSupTechUses', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByLastActiveDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveDate', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByLastActiveDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveDate', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByLevelsCleared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelsCleared', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByLevelsClearedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelsCleared', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy> sortByPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'points', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'points', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortBySupTechUsesThisLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supTechUsesThisLevel', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortBySupTechUsesThisLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supTechUsesThisLevel', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy> sortByThemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByThemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByTotalAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnswers', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByTotalAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnswers', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByTotalPlayTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPlayTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByTotalPlayTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPlayTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PlayerProgressQuerySortThenBy
    on QueryBuilder<PlayerProgress, PlayerProgress, QSortThenBy> {
  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByActiveFrameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeFrameId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByActiveFrameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeFrameId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByActiveSkinId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeSkinId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByActiveSkinIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeSkinId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByBossesDefeated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossesDefeated', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByBossesDefeatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bossesDefeated', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctAnswers', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByCorrectAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctAnswers', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByCurrentCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCategoryId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByCurrentCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCategoryId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByCurrentLevelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevelId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByCurrentLevelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevelId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByCurrentWorldId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWorldId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByCurrentWorldIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWorldId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByExtraSupTechUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraSupTechUses', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByExtraSupTechUsesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraSupTechUses', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByLastActiveDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveDate', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByLastActiveDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveDate', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByLevelsCleared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelsCleared', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByLevelsClearedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelsCleared', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy> thenByPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'points', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'points', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenBySupTechUsesThisLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supTechUsesThisLevel', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenBySupTechUsesThisLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supTechUsesThisLevel', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy> thenByThemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByThemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeId', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByTotalAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnswers', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByTotalAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnswers', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByTotalPlayTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPlayTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByTotalPlayTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPlayTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PlayerProgressQueryWhereDistinct
    on QueryBuilder<PlayerProgress, PlayerProgress, QDistinct> {
  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByActiveFrameId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeFrameId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByActiveSkinId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeSkinId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByBossesDefeated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bossesDefeated');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByCompletedCategoryIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedCategoryIds');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByCompletedLevelIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedLevelIds');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByCompletedWorldIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedWorldIds');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correctAnswers');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByCurrentCategoryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentCategoryId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByCurrentLevelId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentLevelId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByCurrentWorldId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentWorldId');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByEarnedRewardIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'earnedRewardIds');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByExtraSupTechUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraSupTechUses');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByLastActiveDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastActiveDate');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByLevelsCleared() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'levelsCleared');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByPlayDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playDates');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct> distinctByPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'points');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByPrepResults() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prepResults');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctBySupTechUsesThisLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supTechUsesThisLevel');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct> distinctByThemeId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByTotalAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAnswers');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByTotalPlayTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPlayTimeSeconds');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct>
      distinctByUnlockedSkinIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedSkinIds');
    });
  }

  QueryBuilder<PlayerProgress, PlayerProgress, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension PlayerProgressQueryProperty
    on QueryBuilder<PlayerProgress, PlayerProgress, QQueryProperty> {
  QueryBuilder<PlayerProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlayerProgress, String?, QQueryOperations>
      activeFrameIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeFrameId');
    });
  }

  QueryBuilder<PlayerProgress, String?, QQueryOperations>
      activeSkinIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeSkinId');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations> bossesDefeatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bossesDefeated');
    });
  }

  QueryBuilder<PlayerProgress, List<String>, QQueryOperations>
      completedCategoryIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedCategoryIds');
    });
  }

  QueryBuilder<PlayerProgress, List<String>, QQueryOperations>
      completedLevelIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedLevelIds');
    });
  }

  QueryBuilder<PlayerProgress, List<int>, QQueryOperations>
      completedWorldIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedWorldIds');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations> correctAnswersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correctAnswers');
    });
  }

  QueryBuilder<PlayerProgress, String?, QQueryOperations>
      currentCategoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentCategoryId');
    });
  }

  QueryBuilder<PlayerProgress, String?, QQueryOperations>
      currentLevelIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentLevelId');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations> currentWorldIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentWorldId');
    });
  }

  QueryBuilder<PlayerProgress, List<String>, QQueryOperations>
      earnedRewardIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'earnedRewardIds');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations>
      extraSupTechUsesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraSupTechUses');
    });
  }

  QueryBuilder<PlayerProgress, DateTime?, QQueryOperations>
      lastActiveDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastActiveDate');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations> levelsClearedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'levelsCleared');
    });
  }

  QueryBuilder<PlayerProgress, List<DateTime>, QQueryOperations>
      playDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playDates');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations> pointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'points');
    });
  }

  QueryBuilder<PlayerProgress, List<String>, QQueryOperations>
      prepResultsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prepResults');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations>
      supTechUsesThisLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supTechUsesThisLevel');
    });
  }

  QueryBuilder<PlayerProgress, String?, QQueryOperations> themeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeId');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations> totalAnswersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAnswers');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations>
      totalPlayTimeSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPlayTimeSeconds');
    });
  }

  QueryBuilder<PlayerProgress, List<String>, QQueryOperations>
      unlockedSkinIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedSkinIds');
    });
  }

  QueryBuilder<PlayerProgress, int, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
