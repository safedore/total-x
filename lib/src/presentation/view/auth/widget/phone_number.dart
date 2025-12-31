import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:totalx/src/presentation/core/constants/app_images.dart';
import 'package:totalx/src/presentation/core/constants/string.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:totalx/src/presentation/core/theme/typography.dart';

class PhoneNumberWidget extends StatelessWidget {
  const PhoneNumberWidget({
    super.key,
    required this.phoneController,
    required this.handleSendOtp,
    required this.loadingNotifier,
  });
  final TextEditingController phoneController;
  final Function() handleSendOtp;
  final ValueNotifier<bool> loadingNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          child: SvgPicture.asset(
            AppImages.loginLogo,
            height: 102.74.h,
            width: 130.w,
          ),
        ),

        SizedBox(height: 20.h),

        Text(AppStrings.enterPhone, style: AppTypography.montserratSemiBold),
        SizedBox(height: 16.h),
        SizedBox(
          height: 44.h,
          child: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              label: RichText(
                text: TextSpan(
                  text: AppStrings.enterPhone,
                  style: AppTypography.montserratRegular.copyWith(fontSize: 12),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: AppTypography.montserratRegular.copyWith(
                        color: AppColors.redColor,
                      ),
                    ),
                  ],
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF000000)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF000000)),
              ),
              prefixText: '+91 ',
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // TnC
        RichText(
          text: TextSpan(
            text: AppStrings.agreement,
            style: AppTypography.montserratRegular.copyWith(fontSize: 12),
            children: [
              TextSpan(
                text: AppStrings.tnc,
                style: AppTypography.montserratSemiBold.copyWith(
                  color: AppColors.blueColor,
                  fontSize: 11,
                ),
              ),
              TextSpan(
                text: ' & ',
                style: AppTypography.montserratSemiBold.copyWith(fontSize: 11),
              ),
              TextSpan(
                text: AppStrings.privacy,
                style: AppTypography.montserratSemiBold.copyWith(
                  color: AppColors.blueColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),

        // // OTP Button
        // CustomButton(
        //   onPressed: () {
        //     final regex = RegExp(r'^[6-9]\d{9}$');
        //     if (phoneController.text.trim().isNotEmpty &&
        //         regex.hasMatch(phoneController.text.trim())) {
        //       handleSendOtp();
        //     }
        //   },
        //   textColor: Colors.white,
        //   isLoading: loadingNotifier,
        // ),

        SizedBox(height: 20),
      ],
    );
  }
}
