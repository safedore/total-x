import 'package:totalx/src/domain/core/models/data_model/results_model/results_model.dart';

extension ResultsModelMapper on ResultsModel {
  List<T> mapResult<T>(T Function(Map<String, dynamic>) fromJson) {
    return (result ?? [])
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<T> typedList<T>(T Function(Map<String, dynamic>) fromJson) {
    if (result == null) return <T>[];
    if (result is List && result!.firstOrNull is Map<String, dynamic>) {
      return (result as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (result is List<T>) {
      return result as List<T>;
    }
    return <T>[];
  }
}
