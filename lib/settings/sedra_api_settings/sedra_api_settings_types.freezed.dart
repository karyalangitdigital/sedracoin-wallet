// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sedra_api_settings_types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SedraApiSettings {

 Map<String, String> get apiUrlByNetworkId;
/// Create a copy of SedraApiSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SedraApiSettingsCopyWith<SedraApiSettings> get copyWith => _$SedraApiSettingsCopyWithImpl<SedraApiSettings>(this as SedraApiSettings, _$identity);

  /// Serializes this SedraApiSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SedraApiSettings&&const DeepCollectionEquality().equals(other.apiUrlByNetworkId, apiUrlByNetworkId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(apiUrlByNetworkId));

@override
String toString() {
  return 'SedraApiSettings(apiUrlByNetworkId: $apiUrlByNetworkId)';
}


}

/// @nodoc
abstract mixin class $SedraApiSettingsCopyWith<$Res>  {
  factory $SedraApiSettingsCopyWith(SedraApiSettings value, $Res Function(SedraApiSettings) _then) = _$SedraApiSettingsCopyWithImpl;
@useResult
$Res call({
 Map<String, String> apiUrlByNetworkId
});




}
/// @nodoc
class _$SedraApiSettingsCopyWithImpl<$Res>
    implements $SedraApiSettingsCopyWith<$Res> {
  _$SedraApiSettingsCopyWithImpl(this._self, this._then);

  final SedraApiSettings _self;
  final $Res Function(SedraApiSettings) _then;

/// Create a copy of SedraApiSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiUrlByNetworkId = null,}) {
  return _then(_self.copyWith(
apiUrlByNetworkId: null == apiUrlByNetworkId ? _self.apiUrlByNetworkId : apiUrlByNetworkId // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SedraApiSettings].
extension SedraApiSettingsPatterns on SedraApiSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SedraApiSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SedraApiSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SedraApiSettings value)  $default,){
final _that = this;
switch (_that) {
case _SedraApiSettings():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SedraApiSettings value)?  $default,){
final _that = this;
switch (_that) {
case _SedraApiSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> apiUrlByNetworkId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SedraApiSettings() when $default != null:
return $default(_that.apiUrlByNetworkId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> apiUrlByNetworkId)  $default,) {final _that = this;
switch (_that) {
case _SedraApiSettings():
return $default(_that.apiUrlByNetworkId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> apiUrlByNetworkId)?  $default,) {final _that = this;
switch (_that) {
case _SedraApiSettings() when $default != null:
return $default(_that.apiUrlByNetworkId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SedraApiSettings extends SedraApiSettings {
  const _SedraApiSettings({final  Map<String, String> apiUrlByNetworkId = const {}}): _apiUrlByNetworkId = apiUrlByNetworkId,super._();
  factory _SedraApiSettings.fromJson(Map<String, dynamic> json) => _$SedraApiSettingsFromJson(json);

 final  Map<String, String> _apiUrlByNetworkId;
@override@JsonKey() Map<String, String> get apiUrlByNetworkId {
  if (_apiUrlByNetworkId is EqualUnmodifiableMapView) return _apiUrlByNetworkId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_apiUrlByNetworkId);
}


/// Create a copy of SedraApiSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SedraApiSettingsCopyWith<_SedraApiSettings> get copyWith => __$SedraApiSettingsCopyWithImpl<_SedraApiSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SedraApiSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SedraApiSettings&&const DeepCollectionEquality().equals(other._apiUrlByNetworkId, _apiUrlByNetworkId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_apiUrlByNetworkId));

@override
String toString() {
  return 'SedraApiSettings(apiUrlByNetworkId: $apiUrlByNetworkId)';
}


}

/// @nodoc
abstract mixin class _$SedraApiSettingsCopyWith<$Res> implements $SedraApiSettingsCopyWith<$Res> {
  factory _$SedraApiSettingsCopyWith(_SedraApiSettings value, $Res Function(_SedraApiSettings) _then) = __$SedraApiSettingsCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> apiUrlByNetworkId
});




}
/// @nodoc
class __$SedraApiSettingsCopyWithImpl<$Res>
    implements _$SedraApiSettingsCopyWith<$Res> {
  __$SedraApiSettingsCopyWithImpl(this._self, this._then);

  final _SedraApiSettings _self;
  final $Res Function(_SedraApiSettings) _then;

/// Create a copy of SedraApiSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiUrlByNetworkId = null,}) {
  return _then(_SedraApiSettings(
apiUrlByNetworkId: null == apiUrlByNetworkId ? _self._apiUrlByNetworkId : apiUrlByNetworkId // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
