// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IconModel _$IconModelFromJson(Map<String, dynamic> json) {
  return _IconModel.fromJson(json);
}

/// @nodoc
mixin _$IconModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;

  /// Serializes this IconModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IconModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IconModelCopyWith<IconModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IconModelCopyWith<$Res> {
  factory $IconModelCopyWith(IconModel value, $Res Function(IconModel) then) =
      _$IconModelCopyWithImpl<$Res, IconModel>;
  @useResult
  $Res call({String id, String name, String fileUrl});
}

/// @nodoc
class _$IconModelCopyWithImpl<$Res, $Val extends IconModel>
    implements $IconModelCopyWith<$Res> {
  _$IconModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IconModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? fileUrl = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            fileUrl: null == fileUrl
                ? _value.fileUrl
                : fileUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IconModelImplCopyWith<$Res>
    implements $IconModelCopyWith<$Res> {
  factory _$$IconModelImplCopyWith(
    _$IconModelImpl value,
    $Res Function(_$IconModelImpl) then,
  ) = __$$IconModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String fileUrl});
}

/// @nodoc
class __$$IconModelImplCopyWithImpl<$Res>
    extends _$IconModelCopyWithImpl<$Res, _$IconModelImpl>
    implements _$$IconModelImplCopyWith<$Res> {
  __$$IconModelImplCopyWithImpl(
    _$IconModelImpl _value,
    $Res Function(_$IconModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IconModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? fileUrl = null}) {
    return _then(
      _$IconModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        fileUrl: null == fileUrl
            ? _value.fileUrl
            : fileUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IconModelImpl extends _IconModel {
  const _$IconModelImpl({
    required this.id,
    required this.name,
    required this.fileUrl,
  }) : super._();

  factory _$IconModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$IconModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String fileUrl;

  @override
  String toString() {
    return 'IconModel(id: $id, name: $name, fileUrl: $fileUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IconModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, fileUrl);

  /// Create a copy of IconModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IconModelImplCopyWith<_$IconModelImpl> get copyWith =>
      __$$IconModelImplCopyWithImpl<_$IconModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IconModelImplToJson(this);
  }
}

abstract class _IconModel extends IconModel {
  const factory _IconModel({
    required final String id,
    required final String name,
    required final String fileUrl,
  }) = _$IconModelImpl;
  const _IconModel._() : super._();

  factory _IconModel.fromJson(Map<String, dynamic> json) =
      _$IconModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get fileUrl;

  /// Create a copy of IconModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IconModelImplCopyWith<_$IconModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
