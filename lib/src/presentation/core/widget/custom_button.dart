import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:totalx/src/presentation/core/theme/typography.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height,
    this.width,
    this.radius,
    this.backgroundColor,
    this.color,
    this.textColor,
    this.fontSize,
    this.textStyle,
    this.marginTop,
    this.marginBottom,
    this.marginRight,
    this.marginLeft,
    this.isLoading,
  });
  final String label;
  final Function() onPressed;
  final double? height;
  final double? width;
  final double? radius;
  final Color? backgroundColor;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final TextStyle? textStyle;
  final double? marginTop;
  final double? marginBottom;
  final double? marginRight;
  final double? marginLeft;
  final ValueNotifier? isLoading;

  @override
  Widget build(BuildContext context) {
    if ((textColor != null && textStyle != null) ||
        (fontSize != null && textStyle != null)) {
      throw ErrorDescription(
        'If textStyle is not Null, textColor must be Null\nIf textStyle is not Null, fontSize must be Null',
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        top: marginTop ?? 16.h,
        bottom: marginBottom ?? 16.h,
        right: marginRight ?? 16.w,
        left: marginLeft ?? 16.w,
      ),
      child: ValueListenableBuilder(
        valueListenable: isLoading ?? ValueNotifier(false),
        builder: (context, value, child) {
          if (value) {
            return ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? AppColors.primaryBlack,
                minimumSize: Size(width ?? double.infinity, height ?? 44.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 60),
                ),
              ),
              child: CircularProgressIndicator(),
            );
          }
          return ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.primaryBlack,
              minimumSize: Size(width ?? double.infinity, height ?? 44.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 60),
              ),
            ),
            child: Text(
              label,
              style:
                  textStyle ??
                  AppTypography.montserratSemiBold.copyWith(
                    color: textColor,
                    fontSize: fontSize ?? 14,
                  ),
            ),
          );
        },
      ),
    );
  }
}
