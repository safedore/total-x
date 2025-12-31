// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultsModel _$ResultsModelFromJson(Map<String, dynamic> json) => ResultsModel(
  totalCount: BoolStringListConverter.fromJson(json['total_count']),
  result: json['result'] as List<dynamic>?,
);

Map<String, dynamic> _$ResultsModelToJson(ResultsModel instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'result': instance.result,
    };
