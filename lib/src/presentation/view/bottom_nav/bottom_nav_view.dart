import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:totalx/app/router/router_constants.dart';
import 'package:totalx/src/application/auth/auth_bloc.dart';
import 'package:totalx/src/presentation/core/constants/string.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:totalx/src/presentation/core/values/no_glow_scroll_behaviour.dart';
import 'package:totalx/src/presentation/view/main_home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:totalx/src/presentation/view/main_home/widget/add_user_bottom_sheet.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehaviour(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (mounted && context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppStrings.exit),
                  content: Text(AppStrings.exitConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(AppStrings.no),
                    ),
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Text(AppStrings.yes),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                        context.go(RouterConstants.mainLoginRoute);
                      },
                      child: Text(AppStrings.logout),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: SafeArea(
            child: SizedBox(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              child: HomeView(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
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
                  return AddUserBottomSheet(context: context);
                },
              );
            },
            backgroundColor: AppColors.primaryBlack,
            child: Icon(Icons.add, color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
