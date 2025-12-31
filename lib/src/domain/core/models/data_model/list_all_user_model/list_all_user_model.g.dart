// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_all_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListAllUserModel _$ListAllUserModelFromJson(Map<String, dynamic> json) =>
    ListAllUserModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      age: (json['age'] as num?)?.toInt(),
      phoneNumber: BoolStringListConverter.fromJson(json['phone_number']),
      userImage: BoolStringListConverter.fromJson(json['user_image']),
    );

Map<String, dynamic> _$ListAllUserModelToJson(ListAllUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'phone_number': instance.phoneNumber,
      'user_image': instance.userImage,
    };
