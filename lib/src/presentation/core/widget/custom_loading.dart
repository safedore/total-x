import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';

class CustomLoading {
  const CustomLoading({required this.context});
  final BuildContext context;

  Future<void> show() {
    return showDialog(
      barrierColor: AppColors.blackColor.withValues(alpha: 0.5),
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              width: 200.w,
              height: 80.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: const BoxDecoration(
                // shape: BoxShape.circle,
                color: AppColors.transparent,
              ),
              child: Column(
                children: [
                  LinearProgressIndicator(),
                  SizedBox(height: 8.h,),
                  LinearProgressIndicator(),
                  SizedBox(height: 8.h,),
                  LinearProgressIndicator(),
                ],
              )
            ),
          ),
        );
      },
    );
  }

  static void dismiss(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
