part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState({
    this.createUserStatus = const StatusInitial(),
    this.createUserResponse = const CommonResponseModel(),

    this.getUserStatus = const StatusInitial(),
    this.users = const <ListAllUserModel>[],

    this.getUserResultStatus = const StatusInitial(),
    this.userResults = const ResultsModel(),

    this.getUserInfoStatus = const StatusInitial(),
    this.userInfo = const ListAllUserModel(),

    this.updateUserStatus = const StatusInitial(),
    this.updateUserResponse = const CommonResponseModel(),

    this.deleteUserStatus = const StatusInitial(),
    this.deleteUserResponse = const CommonResponseModel(),

    this.currentPage = 1,
    this.hasReachedEnd = false,
  });
  final Status createUserStatus;
  final CommonResponseModel createUserResponse;

  final Status getUserStatus;
  final List<ListAllUserModel> users;

  final Status getUserResultStatus;
  final ResultsModel userResults;

  final Status getUserInfoStatus;
  final ListAllUserModel userInfo;

  final Status updateUserStatus;
  final CommonResponseModel updateUserResponse;

  final Status deleteUserStatus;
  final CommonResponseModel deleteUserResponse;

  final int currentPage;
  final bool hasReachedEnd;
  @override
  List<Object> get props => [
    createUserStatus,
    createUserResponse,

    getUserStatus,
    users,
    getUserResultStatus,
    userResults,

    getUserInfoStatus,
    userInfo,

    updateUserStatus,
    updateUserResponse,

    deleteUserStatus,
    deleteUserResponse,

    currentPage,
    hasReachedEnd,
  ];
  UserState copyWith({
    Status? createUserStatus,
    CommonResponseModel? createUserResponse,

    Status? getUserStatus,
    List<ListAllUserModel>? users,

    Status? getUserResultStatus,
    ResultsModel? userResults,

    Status? getUserInfoStatus,
    ListAllUserModel? userInfo,

    Status? updateUserStatus,
    CommonResponseModel? updateUserResponse,

    Status? deleteUserStatus,
    CommonResponseModel? deleteUserResponse,

    int? currentPage,
    bool? hasReachedEnd,
  }) {
    return UserState(
      createUserStatus: createUserStatus ?? this.createUserStatus,
      createUserResponse: createUserResponse ?? this.createUserResponse,

      getUserStatus: getUserStatus ?? this.getUserStatus,
      users: users ?? this.users,

      getUserResultStatus: getUserResultStatus ?? this.getUserResultStatus,
      userResults: userResults ?? this.userResults,

      getUserInfoStatus: getUserInfoStatus ?? this.getUserInfoStatus,
      userInfo: userInfo ?? this.userInfo,

      updateUserStatus: updateUserStatus ?? this.updateUserStatus,
      updateUserResponse: updateUserResponse ?? this.updateUserResponse,

      deleteUserStatus: deleteUserStatus ?? this.deleteUserStatus,
      deleteUserResponse: deleteUserResponse ?? this.deleteUserResponse,

      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}
