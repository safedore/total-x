import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'common_response_model.g.dart';

@JsonSerializable()
class CommonResponseModel extends Equatable {
  final String? message;

  const CommonResponseModel({this.message});

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) {
    return _$CommonResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CommonResponseModelToJson(this);

  @override
  List<Object?> get props => [message];
}
