import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:totalx/src/domain/core/bool_string_converter/bool_string_converter.dart';

part 'results_model.g.dart';

@JsonSerializable()
class ResultsModel extends Equatable {
  @JsonKey(name: 'total_count', fromJson: BoolStringListConverter.fromJson)
  final int? totalCount;
  final List<dynamic>? result;

  const ResultsModel({this.totalCount, this.result});

  factory ResultsModel.fromJson(Map<String, dynamic> json) {
    return _$ResultsModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResultsModelToJson(this);

  @override
  List<Object?> get props {
    return [totalCount, result];
  }
}
