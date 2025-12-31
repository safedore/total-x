import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:totalx/app/injector/injector.dart';
import 'package:totalx/app/router/router.dart';
import 'package:totalx/src/application/auth/auth_bloc.dart';
import 'package:totalx/src/application/user/user_bloc.dart';
import 'package:totalx/src/presentation/core/constants/string.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:totalx/src/presentation/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:totalx/src/presentation/core/widget/connection_widget.dart';


/// Root application widget.
///
/// Provides application-wide BLoC instances, configures orientation and system
/// UI overlays, initializes screen utilities, and sets up routing and theming.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock orientation to portrait; the app is designed for portrait layouts.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<UserBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp.router(
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(.99)),
                child: ConnectionListener(child: child!),
              );
            },
            title: AppStrings.appName,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
