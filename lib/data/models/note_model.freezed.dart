// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) {
  return _NoteModel.fromJson(json);
}

/// @nodoc
mixin _$NoteModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get folderId => throw _privateConstructorUsedError;
  IconModel? get icon => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get contentText => throw _privateConstructorUsedError;
  Map<String, dynamic> get contentJson => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NoteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteModelCopyWith<NoteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteModelCopyWith<$Res> {
  factory $NoteModelCopyWith(NoteModel value, $Res Function(NoteModel) then) =
      _$NoteModelCopyWithImpl<$Res, NoteModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? folderId,
    IconModel? icon,
    String title,
    String contentText,
    Map<String, dynamic> contentJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $IconModelCopyWith<$Res>? get icon;
}

/// @nodoc
class _$NoteModelCopyWithImpl<$Res, $Val extends NoteModel>
    implements $NoteModelCopyWith<$Res> {
  _$NoteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? folderId = freezed,
    Object? icon = freezed,
    Object? title = null,
    Object? contentText = null,
    Object? contentJson = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            folderId: freezed == folderId
                ? _value.folderId
                : folderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as IconModel?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            contentText: null == contentText
                ? _value.contentText
                : contentText // ignore: cast_nullable_to_non_nullable
                      as String,
            contentJson: null == contentJson
                ? _value.contentJson
                : contentJson // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IconModelCopyWith<$Res>? get icon {
    if (_value.icon == null) {
      return null;
    }

    return $IconModelCopyWith<$Res>(_value.icon!, (value) {
      return _then(_value.copyWith(icon: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NoteModelImplCopyWith<$Res>
    implements $NoteModelCopyWith<$Res> {
  factory _$$NoteModelImplCopyWith(
    _$NoteModelImpl value,
    $Res Function(_$NoteModelImpl) then,
  ) = __$$NoteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? folderId,
    IconModel? icon,
    String title,
    String contentText,
    Map<String, dynamic> contentJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $IconModelCopyWith<$Res>? get icon;
}

/// @nodoc
class __$$NoteModelImplCopyWithImpl<$Res>
    extends _$NoteModelCopyWithImpl<$Res, _$NoteModelImpl>
    implements _$$NoteModelImplCopyWith<$Res> {
  __$$NoteModelImplCopyWithImpl(
    _$NoteModelImpl _value,
    $Res Function(_$NoteModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? folderId = freezed,
    Object? icon = freezed,
    Object? title = null,
    Object? contentText = null,
    Object? contentJson = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$NoteModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        folderId: freezed == folderId
            ? _value.folderId
            : folderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as IconModel?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        contentText: null == contentText
            ? _value.contentText
            : contentText // ignore: cast_nullable_to_non_nullable
                  as String,
        contentJson: null == contentJson
            ? _value._contentJson
            : contentJson // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteModelImpl extends _NoteModel {
  const _$NoteModelImpl({
    required this.id,
    required this.userId,
    this.folderId,
    this.icon,
    required this.title,
    required this.contentText,
    required final Map<String, dynamic> contentJson,
    this.createdAt,
    this.updatedAt,
  }) : _contentJson = contentJson,
       super._();

  factory _$NoteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? folderId;
  @override
  final IconModel? icon;
  @override
  final String title;
  @override
  final String contentText;
  final Map<String, dynamic> _contentJson;
  @override
  Map<String, dynamic> get contentJson {
    if (_contentJson is EqualUnmodifiableMapView) return _contentJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contentJson);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NoteModel(id: $id, userId: $userId, folderId: $folderId, icon: $icon, title: $title, contentText: $contentText, contentJson: $contentJson, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.contentText, contentText) ||
                other.contentText == contentText) &&
            const DeepCollectionEquality().equals(
              other._contentJson,
              _contentJson,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    folderId,
    icon,
    title,
    contentText,
    const DeepCollectionEquality().hash(_contentJson),
    createdAt,
    updatedAt,
  );

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteModelImplCopyWith<_$NoteModelImpl> get copyWith =>
      __$$NoteModelImplCopyWithImpl<_$NoteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteModelImplToJson(this);
  }
}

abstract class _NoteModel extends NoteModel {
  const factory _NoteModel({
    required final String id,
    required final String userId,
    final String? folderId,
    final IconModel? icon,
    required final String title,
    required final String contentText,
    required final Map<String, dynamic> contentJson,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$NoteModelImpl;
  const _NoteModel._() : super._();

  factory _NoteModel.fromJson(Map<String, dynamic> json) =
      _$NoteModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get folderId;
  @override
  IconModel? get icon;
  @override
  String get title;
  @override
  String get contentText;
  @override
  Map<String, dynamic> get contentJson;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteModelImplCopyWith<_$NoteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
