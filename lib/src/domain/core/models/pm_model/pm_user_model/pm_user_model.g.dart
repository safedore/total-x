// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pm_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PmUserModel _$PmUserModelFromJson(Map<String, dynamic> json) => PmUserModel(
  name: json['name'] as String?,
  age: (json['age'] as num?)?.toInt(),
  phoneNumber: json['phone_number'] as String?,
  userImage: _pathToFile(json['user_image'] as String?),
);

Map<String, dynamic> _$PmUserModelToJson(PmUserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'phone_number': instance.phoneNumber,
      'user_image': _fileToPath(instance.userImage),
    };
