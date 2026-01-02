import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:totalx/app/injector/injector.dart';
import 'package:totalx/src/application/auth/auth_bloc.dart';
import 'package:totalx/src/domain/core/pref_key/preference_key.dart';
import 'package:totalx/src/infrastructure/core/connectivity_helper.dart';
import 'package:totalx/src/infrastructure/core/preference_helper.dart';
import 'package:totalx/app/router/router_constants.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    configureDependencies();

    ConnectivityHelper().initialize();

    if (mounted) {
      await Future.delayed(const Duration(seconds: 1), () {
        getLoginToken();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF092B58),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(),
          SizedBox(height: 8.h),
          LinearProgressIndicator(),
          SizedBox(height: 8.h),
          LinearProgressIndicator(),
        ],
      ),
    );
  }

  Future<bool> getLoginToken() async {
    final loginToken = await PreferenceHelper().getString(
      key: AppPrefKeys.token,
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (loginToken.isEmpty ||
        loginToken == 'none' ||
        loginToken == 'OTP has expired' || loginToken == 'invalid otp') {
      if (mounted) {
        context.read<AuthBloc>().add(SetAuthenticated(isAuthenticated: false));
        context.go(RouterConstants.mainLoginRoute);
      }
      return false;
    } else {
      if (mounted) {
        context.read<AuthBloc>().add(SetAuthenticated(isAuthenticated: true));
        context.go(RouterConstants.bottomNavRoute);
      }
      return true;
    }
  }
}
