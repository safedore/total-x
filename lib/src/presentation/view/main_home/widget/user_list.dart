import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:totalx/src/application/core/status.dart';
import 'package:totalx/src/application/user/user_bloc.dart';
import 'package:totalx/src/domain/core/models/data_model/list_all_user_model/list_all_user_model.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:totalx/src/presentation/core/theme/typography.dart';
import 'package:totalx/src/presentation/core/values/data_formatters.dart';
import 'package:totalx/src/presentation/core/widget/custom_loading.dart';
import 'package:totalx/src/presentation/view/main_home/widget/update_user_bottom_sheet.dart';

class UserList extends StatelessWidget {
  const UserList({
    super.key,
    required this.scrollController,
    required this.handleRefresh,
  });
  final ScrollController scrollController;
  final Function() handleRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listenWhen: (previous, current) =>
          previous.deleteUserStatus != current.deleteUserStatus,
      listener: (context, state) {
        if (state.deleteUserStatus is StatusInitial) {
        } else if (state.deleteUserStatus is StatusLoading) {
          CustomLoading(context: context).show();
        } else if (state.deleteUserStatus is StatusSuccess) {
          CustomLoading.dismiss(context);
          context.pop();
          handleRefresh();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('User Removed')));
        } else {
          CustomLoading.dismiss(context);
          context.pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to remove user!')));
        }
      },
      buildWhen: (previous, current) =>
          previous.getUserResultStatus != current.getUserResultStatus,
      builder: (context, state) {
        List<ListAllUserModel> items =
            state.userResults.result is List<ListAllUserModel>
            ? state.userResults.result as List<ListAllUserModel>
            : <ListAllUserModel>[];
        if (state.getUserResultStatus is StatusLoading) {
          return LinearProgressIndicator();
        }
        if (state.getUserResultStatus is StatusLoading && items.isEmpty) {
          return LinearProgressIndicator();
        }
        if (items.isEmpty) {
          return SizedBox.shrink();
        }
        final itemCount = items.length;
        return Expanded(
          child: ListView.separated(
            controller: scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: itemCount + (state.hasReachedEnd ? 0 : 1),
            padding: EdgeInsetsGeometry.symmetric(horizontal: 10.w),
            itemBuilder: (context, index) {
              if (index == itemCount &&
                  state.userResults.totalCount == itemCount) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: LinearProgressIndicator()),
                );
              } else if (index == itemCount && !state.hasReachedEnd) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: LinearProgressIndicator()),
                );
              } else if (index > itemCount) {
                return SizedBox.shrink();
              }
              final item = items[index];
              final name = item.name ?? 'Unknown';
              final age = item.age ?? 'Unknown';

              /// i did this because i am using my beginner account for hosting this. and i stored them in base64encoded format for convenience purpose
              final image = DataFormatters.decodeBase64ToUint8Lists(
                item.userImage,
              );

              final imageKeys = image.keys;
              return GestureDetector(
                onTap: () {
                  if (item.id == null) {
                    return;
                  }
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    showDragHandle: false,
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                      maxHeight: ScreenUtil().screenHeight / 1.2,
                    ),
                    backgroundColor: AppColors.transparent,
                    builder: (_) {
                      return UpdateUserBottomSheet(
                        context: context,
                        userData: item,
                        handleRefresh: handleRefresh,
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withValues(alpha: 0.25),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8.h),
                  child: Row(
                    children: [
                      _imageWidget(imageKeys, image),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTypography.montserratSemiBold.copyWith(
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Age: $age',
                              style: AppTypography.montserratMedium.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Confirm Delete',
                                style: AppTypography.montserratSemiBold
                                    .copyWith(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                              ),
                              content: Text(
                                'Are you sure you want to delete this item? This action cannot be undone.',
                                style: AppTypography.montserratRegular.copyWith(
                                  color: Colors.black54,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: AppTypography.montserratRegular
                                        .copyWith(color: Colors.grey[600]),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (item.id != null) {
                                      context.read<UserBloc>().add(
                                        DeleteUserEvent(id: item.id!),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Delete',
                                    style: AppTypography.montserratSemiBold
                                        .copyWith(color: Colors.red[700]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
          ),
        );
      },
    );
  }

  Widget _imageWidget(Iterable<String> imageKeys, dynamic image) {
    if (imageKeys.firstOrNull == 'svg') {
      return ClipOval(
        child: SizedBox(
          width: 60.w,
          height: 60.h,
          child: SvgPicture.string(
            image['svg'],
            fit: BoxFit.cover,
            width: 60.w,
            height: 60.h,
          ),
        ),
      );
    }
    return ClipOval(
      child: SizedBox(
        width: 60.w,
        height: 60.h,
        child: Image.memory(
          image['memory'],
          fit: BoxFit.cover,
          width: 60.w,
          height: 60.h,
        ),
      ),
    );
  }
}
