import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:totalx/src/infrastructure/core/connectivity_helper.dart';
import 'package:totalx/src/presentation/core/constants/string.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:totalx/src/presentation/core/theme/typography.dart';

class ConnectionListener extends StatefulWidget {
  final Widget child;

  const ConnectionListener({super.key, required this.child});

  @override
  State<ConnectionListener> createState() => _ConnectionListenerState();
}

class _ConnectionListenerState extends State<ConnectionListener> {
  late StreamSubscription<bool> _subscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();

    ConnectivityHelper().checkConnection().then((connected) {
      setState(() => _isConnected = connected);
      if (!connected) _showSnackBar();
    });

    _subscription = ConnectivityHelper().connectivityStream.listen((connected) {
      setState(() => _isConnected = connected);
      if (!connected) {
        _showSnackBar();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      }
    });
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.noInternet),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        duration: Duration(days: 1),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_isConnected)
          Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.signal_cellular_connected_no_internet_0_bar,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Check your internet\nconnection',
                  style: AppTypography.montserratRegular.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.blackColor,
                    letterSpacing: -0.02 * 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
