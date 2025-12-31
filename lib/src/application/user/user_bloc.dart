import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:totalx/src/application/core/status.dart';
import 'package:totalx/src/domain/core/models/data_model/common_response_model/common_response_model.dart';
import 'package:totalx/src/domain/core/models/pm_model/pm_user_model/pm_user_model.dart';
import 'package:totalx/src/domain/user/i_user_repository.dart';
import 'package:totalx/src/domain/core/extensions/results_model_mapper.dart';
import 'package:totalx/src/domain/core/models/data_model/list_all_user_model/list_all_user_model.dart';
import 'package:totalx/src/domain/core/models/data_model/results_model/results_model.dart';

import '../../presentation/core/constants/app_number.dart' show AppNumber;

part 'user_event.dart';
part 'user_state.dart';

@injectable
/// User BLoC for listing available user used across the e-store browsing.
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._userRepository) : super(UserState()) {
    on<CreateUserEvent>(_createUser);
    on<GetUserEvent>(_getUser);
    on<GetUserResultEvent>(_getUserResult);
    on<GetUserInfoEvent>(_getUserInfo);
    on<UpdateUserEvent>(_updateUser);
    on<DeleteUserEvent>(_deleteUser);
    on<ResetUserEvent>(_resetUser);
  }

  FutureOr<void> _createUser(
    CreateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(createUserStatus: StatusLoading()));

      final res = await _userRepository.createUser(userModel: event.userModel);
      if (res.message == 'User created successfully!') {
        emit(state.copyWith(createUserStatus: StatusSuccess()));
      } else {
        emit(
          state.copyWith(
            createUserStatus: StatusFailure(res.message ?? 'Failed to create'),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(createUserStatus: StatusFailure('Something went wrong')),
      );
    }
  }

  FutureOr<void> _getUser(GetUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(getUserStatus: StatusLoading()));

      final res = await _userRepository.getUser(
        search: event.search,
        orderBy: event.orderBy,
        direction: event.direction,
      );
      if (res.isNotEmpty) {
        emit(state.copyWith(getUserStatus: StatusSuccess(), users: res));
      } else {
        emit(
          state.copyWith(getUserStatus: const StatusFailure('No Data Found')),
        );
      }
    } catch (e) {
      emit(state.copyWith(getUserStatus: StatusFailure(e.toString())));
    }
  }

  FutureOr<void> _getUserResult(
    GetUserResultEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      if (event.isRefresh || event.page == 1) {
        emit(
          state.copyWith(
            getUserResultStatus: StatusLoading(),
            currentPage: 1,
            hasReachedEnd: false,
          ),
        );
      } else {
        emit(state.copyWith(getUserResultStatus: StatusPageLoading()));
      }

      final res = await _userRepository.getUserResults(
        search: event.search,
        orderBy: event.orderBy,
        direction: event.direction,
        ageMin: event.ageMin,
        ageMax: event.ageMax,
        page: event.page,
        limit: event.limit,
      );

      final newItems = res.mapResult(ListAllUserModel.fromJson);
      final existingItems = state.userResults.typedList<ListAllUserModel>(
        ListAllUserModel.fromJson,
      );

      final combinedList = event.isRefresh || event.page == 1
          ? newItems
          : [...existingItems, ...newItems];

      final updatedModel = ResultsModel(
        totalCount: res.totalCount,
        result: combinedList,
      );

      final hasReachedEnd =
          res.totalCount != null && combinedList.length >= res.totalCount!;

      emit(
        state.copyWith(
          getUserResultStatus: StatusSuccess(),
          userResults: updatedModel,
          currentPage: event.page,
          hasReachedEnd: hasReachedEnd,
        ),
      );
    } catch (e) {
      emit(state.copyWith(getUserResultStatus: StatusFailure(e.toString())));
    }
  }

  FutureOr<void> _getUserInfo(
    GetUserInfoEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(getUserInfoStatus: StatusLoading()));

      final res = await _userRepository.getUserInfo(id: event.id);
      emit(state.copyWith(getUserInfoStatus: StatusSuccess(), userInfo: res));
    } catch (e) {
      emit(state.copyWith(getUserInfoStatus: StatusFailure(e.toString())));
    }
  }

  FutureOr<void> _updateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(updateUserStatus: StatusLoading()));

      final res = await _userRepository.updateUser(
        id: event.id,
        userModel: event.userModel,
      );
      if (res.message == 'User updated successfully!') {
        emit(state.copyWith(updateUserStatus: StatusSuccess()));
      } else {
        emit(
          state.copyWith(
            updateUserStatus: StatusFailure(res.message ?? 'Failed to update'),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(updateUserStatus: StatusFailure('Something went wrong')),
      );
    }
  }

  FutureOr<void> _deleteUser(
    DeleteUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(deleteUserStatus: StatusLoading()));

      final res = await _userRepository.deleteUser(id: event.id);
      if (res.message == 'User deleted successfully!') {
        emit(state.copyWith(deleteUserStatus: StatusSuccess()));
      } else {
        emit(
          state.copyWith(
            deleteUserStatus: StatusFailure(res.message ?? 'Failed to remove'),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(deleteUserStatus: StatusFailure('Something went wrong')),
      );
    }
  }

  FutureOr<void> _resetUser(
    ResetUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserState());
  }

  final IUserRepository _userRepository;
}
