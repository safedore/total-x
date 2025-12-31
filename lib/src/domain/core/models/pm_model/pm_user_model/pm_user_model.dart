import 'dart:io' show File;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pm_user_model.g.dart';

String? _fileToPath(File? file) => file?.path;
File? _pathToFile(String? path) => path != null ? File(path) : null;

@JsonSerializable()
class PmUserModel extends Equatable {
  final String? name;
  final int? age;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'user_image', fromJson: _pathToFile, toJson: _fileToPath)
  final File? userImage;

  const PmUserModel({this.name, this.age, this.phoneNumber, this.userImage});

  factory PmUserModel.fromJson(Map<String, dynamic> json) {
    return _$PmUserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PmUserModelToJson(this);

  @override
  List<Object?> get props => [name, age, phoneNumber, userImage];
}
