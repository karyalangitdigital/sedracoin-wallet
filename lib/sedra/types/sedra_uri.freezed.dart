// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sedra_uri.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SedraUriParam {

 String get key; String get value;
/// Create a copy of SedraUriParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SedraUriParamCopyWith<SedraUriParam> get copyWith => _$SedraUriParamCopyWithImpl<SedraUriParam>(this as SedraUriParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SedraUriParam&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'SedraUriParam(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class $SedraUriParamCopyWith<$Res>  {
  factory $SedraUriParamCopyWith(SedraUriParam value, $Res Function(SedraUriParam) _then) = _$SedraUriParamCopyWithImpl;
@useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class _$SedraUriParamCopyWithImpl<$Res>
    implements $SedraUriParamCopyWith<$Res> {
  _$SedraUriParamCopyWithImpl(this._self, this._then);

  final SedraUriParam _self;
  final $Res Function(SedraUriParam) _then;

/// Create a copy of SedraUriParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SedraUriParam].
extension SedraUriParamPatterns on SedraUriParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SedraUriParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SedraUriParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SedraUriParam value)  $default,){
final _that = this;
switch (_that) {
case _SedraUriParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SedraUriParam value)?  $default,){
final _that = this;
switch (_that) {
case _SedraUriParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SedraUriParam() when $default != null:
return $default(_that.key,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String value)  $default,) {final _that = this;
switch (_that) {
case _SedraUriParam():
return $default(_that.key,_that.value);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String value)?  $default,) {final _that = this;
switch (_that) {
case _SedraUriParam() when $default != null:
return $default(_that.key,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _SedraUriParam extends SedraUriParam {
  const _SedraUriParam({required this.key, required this.value}): super._();
  

@override final  String key;
@override final  String value;

/// Create a copy of SedraUriParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SedraUriParamCopyWith<_SedraUriParam> get copyWith => __$SedraUriParamCopyWithImpl<_SedraUriParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SedraUriParam&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'SedraUriParam(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class _$SedraUriParamCopyWith<$Res> implements $SedraUriParamCopyWith<$Res> {
  factory _$SedraUriParamCopyWith(_SedraUriParam value, $Res Function(_SedraUriParam) _then) = __$SedraUriParamCopyWithImpl;
@override @useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class __$SedraUriParamCopyWithImpl<$Res>
    implements _$SedraUriParamCopyWith<$Res> {
  __$SedraUriParamCopyWithImpl(this._self, this._then);

  final _SedraUriParam _self;
  final $Res Function(_SedraUriParam) _then;

/// Create a copy of SedraUriParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,}) {
  return _then(_SedraUriParam(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SedraUri {

 Address get address; Amount? get amount; String? get label; String? get message; IList<SedraUriParam> get others;
/// Create a copy of SedraUri
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SedraUriCopyWith<SedraUri> get copyWith => _$SedraUriCopyWithImpl<SedraUri>(this as SedraUri, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SedraUri&&(identical(other.address, address) || other.address == address)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.label, label) || other.label == label)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.others, others));
}


@override
int get hashCode => Object.hash(runtimeType,address,amount,label,message,const DeepCollectionEquality().hash(others));



}

/// @nodoc
abstract mixin class $SedraUriCopyWith<$Res>  {
  factory $SedraUriCopyWith(SedraUri value, $Res Function(SedraUri) _then) = _$SedraUriCopyWithImpl;
@useResult
$Res call({
 Address address, Amount? amount, String? label, String? message, IList<SedraUriParam> others
});


$AddressCopyWith<$Res> get address;$AmountCopyWith<$Res>? get amount;

}
/// @nodoc
class _$SedraUriCopyWithImpl<$Res>
    implements $SedraUriCopyWith<$Res> {
  _$SedraUriCopyWithImpl(this._self, this._then);

  final SedraUri _self;
  final $Res Function(SedraUri) _then;

/// Create a copy of SedraUri
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? amount = freezed,Object? label = freezed,Object? message = freezed,Object? others = null,}) {
  return _then(_self.copyWith(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Amount?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,others: null == others ? _self.others : others // ignore: cast_nullable_to_non_nullable
as IList<SedraUriParam>,
  ));
}
/// Create a copy of SedraUri
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of SedraUri
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AmountCopyWith<$Res>? get amount {
    if (_self.amount == null) {
    return null;
  }

  return $AmountCopyWith<$Res>(_self.amount!, (value) {
    return _then(_self.copyWith(amount: value));
  });
}
}


/// Adds pattern-matching-related methods to [SedraUri].
extension SedraUriPatterns on SedraUri {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SedraUri value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SedraUri() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SedraUri value)  $default,){
final _that = this;
switch (_that) {
case _SedraUri():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SedraUri value)?  $default,){
final _that = this;
switch (_that) {
case _SedraUri() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Address address,  Amount? amount,  String? label,  String? message,  IList<SedraUriParam> others)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SedraUri() when $default != null:
return $default(_that.address,_that.amount,_that.label,_that.message,_that.others);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Address address,  Amount? amount,  String? label,  String? message,  IList<SedraUriParam> others)  $default,) {final _that = this;
switch (_that) {
case _SedraUri():
return $default(_that.address,_that.amount,_that.label,_that.message,_that.others);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Address address,  Amount? amount,  String? label,  String? message,  IList<SedraUriParam> others)?  $default,) {final _that = this;
switch (_that) {
case _SedraUri() when $default != null:
return $default(_that.address,_that.amount,_that.label,_that.message,_that.others);case _:
  return null;

}
}

}

/// @nodoc


class _SedraUri extends SedraUri {
  const _SedraUri({required this.address, this.amount, this.label, this.message, this.others = const IListConst([])}): super._();
  

@override final  Address address;
@override final  Amount? amount;
@override final  String? label;
@override final  String? message;
@override@JsonKey() final  IList<SedraUriParam> others;

/// Create a copy of SedraUri
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SedraUriCopyWith<_SedraUri> get copyWith => __$SedraUriCopyWithImpl<_SedraUri>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SedraUri&&(identical(other.address, address) || other.address == address)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.label, label) || other.label == label)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.others, others));
}


@override
int get hashCode => Object.hash(runtimeType,address,amount,label,message,const DeepCollectionEquality().hash(others));



}

/// @nodoc
abstract mixin class _$SedraUriCopyWith<$Res> implements $SedraUriCopyWith<$Res> {
  factory _$SedraUriCopyWith(_SedraUri value, $Res Function(_SedraUri) _then) = __$SedraUriCopyWithImpl;
@override @useResult
$Res call({
 Address address, Amount? amount, String? label, String? message, IList<SedraUriParam> others
});


@override $AddressCopyWith<$Res> get address;@override $AmountCopyWith<$Res>? get amount;

}
/// @nodoc
class __$SedraUriCopyWithImpl<$Res>
    implements _$SedraUriCopyWith<$Res> {
  __$SedraUriCopyWithImpl(this._self, this._then);

  final _SedraUri _self;
  final $Res Function(_SedraUri) _then;

/// Create a copy of SedraUri
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = null,Object? amount = freezed,Object? label = freezed,Object? message = freezed,Object? others = null,}) {
  return _then(_SedraUri(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Amount?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,others: null == others ? _self.others : others // ignore: cast_nullable_to_non_nullable
as IList<SedraUriParam>,
  ));
}

/// Create a copy of SedraUri
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of SedraUri
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AmountCopyWith<$Res>? get amount {
    if (_self.amount == null) {
    return null;
  }

  return $AmountCopyWith<$Res>(_self.amount!, (value) {
    return _then(_self.copyWith(amount: value));
  });
}
}

// dart format on
