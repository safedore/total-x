import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:totalx/src/domain/core/models/data_model/common_response_model/common_response_model.dart';
import 'package:totalx/src/domain/core/models/pm_model/pm_user_model/pm_user_model.dart';
import 'package:totalx/src/domain/user/i_user_repository.dart';
import 'package:totalx/src/domain/core/app_url/app_urls.dart';
import 'package:totalx/src/domain/core/internet_service/i_base_client.dart';
import 'package:totalx/src/domain/core/models/data_model/list_all_user_model/list_all_user_model.dart';
import 'package:totalx/src/domain/core/models/data_model/results_model/results_model.dart';
import 'package:totalx/src/domain/core/pref_key/preference_key.dart';
import 'package:totalx/src/infrastructure/core/preference_helper.dart';

import '../../presentation/core/constants/app_number.dart' show AppNumber;

@LazySingleton(as: IUserRepository)
class UserRepository extends IUserRepository {
  UserRepository(this.client);
  final IBaseClient client;

  @override
  Future<CommonResponseModel> createUser({
    required PmUserModel userModel,
  }) async {
    final loginToken = await PreferenceHelper().getString(
      key: AppPrefKeys.token,
    );
    try {
      final response = await client.post(
        url: "${UserUrls.createUser}?token=$loginToken",
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': userModel.name,
          'age': userModel.age,
          'phone_number': userModel.phoneNumber,
          if (userModel.userImage != null)
            'user_image': base64Encode(
              userModel.userImage!.readAsBytesSync(),
            ), // i did this because i had to do something about the image in server and i cant just store it in as is
        }),
      );
      final decode = jsonDecode(response.body) as Map<String, dynamic>;
      return CommonResponseModel.fromJson(decode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ListAllUserModel>> getUser({
    String search = '',
    String orderBy = 'id',
    String direction = 'asc',
  }) async {
    final loginToken = await PreferenceHelper().getString(
      key: AppPrefKeys.token,
    );
    try {
      final response = await client.get(
        url:
            "${UserUrls.readUsersAll}?token=$loginToken&search=$search&order_by=$orderBy&direction=$direction",
      );
      final decode = jsonDecode(response.body) as List<dynamic>;
      final List<ListAllUserModel> data = decode
          .map((json) => ListAllUserModel.fromJson(json))
          .toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ResultsModel> getUserResults({
    String search = '',
    String orderBy = 'id',
    String direction = 'asc',
    int? ageMin,
    int? ageMax,
    int page = AppNumber.page,
    int limit = AppNumber.limit,
  }) async {
    final loginToken = await PreferenceHelper().getString(
      key: AppPrefKeys.token,
    );
    try {
      final offset = (page - 1) * limit;
      final response = await client.get(
        url:
            "${UserUrls.readUsers}"
            "?token=$loginToken"
                "&search=$search"
                "&offset=$offset"
                "&limit=$limit"
                "&order_by=$orderBy"
                "&direction=$direction"
                "&age_min=$ageMin"
                "&age_max=$ageMax",
      );
      final decode = jsonDecode(response.body) as Map<String, dynamic>;
      final data = ResultsModel.fromJson(decode);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ListAllUserModel> getUserInfo({required int id}) async {
    final loginToken = await PreferenceHelper().getString(
      key: AppPrefKeys.token,
    );
    try {
      final response = await client.get(
        url:
            "${UserUrls.readUserDetails}/$id"
            "?token=$loginToken",
      );
      final decode = jsonDecode(response.body) as Map<String, dynamic>;
      final data = ListAllUserModel.fromJson(decode);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommonResponseModel> updateUser({
    required int id,
    required PmUserModel userModel,
  }) async {
    final loginToken = await PreferenceHelper().getString(
      key: AppPrefKeys.token,
    );
    try {
      final response = await client.put(
        url: "${UserUrls.updateUser}/$id?token=$loginToken",
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': userModel.name,
          'age': userModel.age,
          'phone_number': userModel.phoneNumber,
          if (userModel.userImage != null)
            'user_image': base64Encode(
              userModel.userImage!.readAsBytesSync(),
            ), // i did this because i had to do something about the image in server and i cant just store it in as is
        }),
      );
      final decode = jsonDecode(response.body) as Map<String, dynamic>;
      return CommonResponseModel.fromJson(decode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommonResponseModel> deleteUser({required int id}) async {
    final loginToken = await PreferenceHelper().getString(
      key: AppPrefKeys.token,
    );
    try {
      final response = await client.delete(
        url: "${UserUrls.deleteUser}/$id?token=$loginToken",
      );
      final decode = jsonDecode(response.body) as Map<String, dynamic>;
      return CommonResponseModel.fromJson(decode);
    } catch (e) {
      rethrow;
    }
  }
}
