part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends UserEvent {
  const CreateUserEvent({required this.userModel});
  final PmUserModel userModel;

  @override
  List<Object> get props => [userModel];
}

class GetUserEvent extends UserEvent {
  const GetUserEvent({
    this.search = '',
    this.orderBy = 'id',
    this.direction = 'asc',
  });
  final String search;
  final String orderBy;
  final String direction;

  @override
  List<Object> get props => [search];
}

class GetUserResultEvent extends UserEvent {
  const GetUserResultEvent({
    this.search = '',
    this.orderBy = 'id',
    this.direction = 'asc',
    this.ageMin,
    this.ageMax,
    this.isRefresh = false,
    this.page = AppNumber.page,
    this.limit = AppNumber.limit,
  });
  final String search;
  final String orderBy;
  final String direction;
  final int? ageMin;
  final int? ageMax;
  final int page;
  final int limit;
  final bool isRefresh;
  @override
  List<Object> get props => [
    search,
    orderBy,
    direction,
    page,
    limit,
    isRefresh,
  ];
}

class GetUserInfoEvent extends UserEvent {
  const GetUserInfoEvent({required this.id});
  final int id;

  @override
  List<Object> get props => [id];
}

class UpdateUserEvent extends UserEvent {
  const UpdateUserEvent({required this.id, required this.userModel});
  final int id;
  final PmUserModel userModel;

  @override
  List<Object> get props => [id, userModel];
}

class DeleteUserEvent extends UserEvent {
  const DeleteUserEvent({required this.id});
  final int id;

  @override
  List<Object> get props => [id];
}

class ResetUserEvent extends UserEvent {}
