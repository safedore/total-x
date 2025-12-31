import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:totalx/src/domain/core/bool_string_converter/bool_string_converter.dart';

part 'list_all_user_model.g.dart';

@JsonSerializable()
class ListAllUserModel extends Equatable {
  final int? id;
  final String? name;
  final int? age;
  @JsonKey(name: 'phone_number', fromJson: BoolStringListConverter.fromJson)
  final String? phoneNumber;

  @JsonKey(name: 'user_image', fromJson: BoolStringListConverter.fromJson)
  final String? userImage;
  const ListAllUserModel({
    this.id,
    this.name,
    this.age,
    this.phoneNumber,
    this.userImage,
  });

  factory ListAllUserModel.fromJson(Map<String, dynamic> json) {
    return _$ListAllUserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ListAllUserModelToJson(this);

  @override
  List<Object?> get props => [id, name, age, userImage, phoneNumber];
}
