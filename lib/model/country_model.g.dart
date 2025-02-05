// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CountryModelImpl _$$CountryModelImplFromJson(Map<String, dynamic> json) =>
    _$CountryModelImpl(
      name: json['name'] as String,
      code: json['code'] as String,
      flag: json['flag'] as String,
      shortName: json['shortName'] as String,
      phoneNumberLength: (json['phoneNumberLength'] as num).toInt(),
      states: (json['states'] as List<dynamic>)
          .map((e) => StateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CountryModelImplToJson(_$CountryModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'flag': instance.flag,
      'shortName': instance.shortName,
      'phoneNumberLength': instance.phoneNumberLength,
      'states': instance.states,
    };

_$StateModelImpl _$$StateModelImplFromJson(Map<String, dynamic> json) =>
    _$StateModelImpl(
      name: json['name'] as String,
    );

Map<String, dynamic> _$$StateModelImplToJson(_$StateModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
