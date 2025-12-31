import 'package:totalx/src/domain/core/models/data_model/common_response_model/common_response_model.dart';
import 'package:totalx/src/domain/core/models/data_model/list_all_user_model/list_all_user_model.dart';
import 'package:totalx/src/domain/core/models/data_model/results_model/results_model.dart';
import 'package:totalx/src/domain/core/models/pm_model/pm_user_model/pm_user_model.dart';

import '../../presentation/core/constants/app_number.dart' show AppNumber;

abstract class IUserRepository {
  Future<CommonResponseModel> createUser({required PmUserModel userModel});

  Future<List<ListAllUserModel>> getUser({
    String search = '',
    String orderBy = '',
    String direction = '',
  });

  Future<ResultsModel> getUserResults({
    String search = '',
    String orderBy = '',
    String direction = '',
    int? ageMin,
    int? ageMax,
    int page = AppNumber.page,
    int limit = AppNumber.limit,
  });

  Future<ListAllUserModel> getUserInfo({required int id});

  Future<CommonResponseModel> updateUser({
    required int id,
    required PmUserModel userModel,
  });

  Future<CommonResponseModel> deleteUser({required int id});
}
