import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:totalx/src/presentation/core/constants/app_images.dart';
import 'package:totalx/src/presentation/core/constants/string.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:totalx/src/presentation/core/theme/typography.dart';

class OtpWidget extends StatefulWidget {
  const OtpWidget({
    super.key,
    required this.otpController,
    required this.handleVerifyOtp,
    required this.handleRetryOtp,
    required this.phoneNumber,
    required this.loadingNotifier,
  });
  final TextEditingController otpController;
  final Function() handleVerifyOtp;
  final Function() handleRetryOtp;
  final String phoneNumber;
  final ValueNotifier<bool> loadingNotifier;

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  Timer? _timer;
  final ValueNotifier<int> _remainingSeconds = ValueNotifier(59);
  bool _canResend = false;
  void _startTimer() {
    _remainingSeconds.value = 59;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        if (mounted) {
          _remainingSeconds.value--;
        }
      } else {
        if (mounted) {
          setState(() {
            _canResend = true;
          });
        }
        _timer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regex = RegExp(r'^[0-9]\d{5}$');
    return Column(
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

        Text(AppStrings.otpVerify, style: AppTypography.montserratSemiBold),
        SizedBox(height: 24.h),
        Text(
          'Enter the verification code we just sent to your number +91 ${'*******${widget.phoneNumber.substring(widget.phoneNumber.length - 3)}'}',
          style: AppTypography.montserratRegular,
        ),
        SizedBox(height: 23.h),
        PinFieldAutoFill(
          codeLength: 6,
          decoration: BoxLooseDecoration(
            strokeColorBuilder: PinListenColorBuilder(
              AppColors.primaryBlack,
              AppColors.primaryBlack.withValues(alpha: 0.3),
            ),
            radius: Radius.circular(8),
            textStyle: AppTypography.rethinkSansBold.copyWith(
              fontSize: 18,
              color: AppColors.redColor,
            ),
          ),
          onCodeChanged: (code) {
            if (code != null) {
              widget.otpController.text = code;
              if (widget.otpController.text.trim().isNotEmpty &&
                  regex.hasMatch(widget.otpController.text.trim())) {
                widget.handleVerifyOtp();
              }
            }
          },
          onCodeSubmitted: (code) {
            widget.otpController.text = code;
            if (widget.otpController.text.trim().isNotEmpty &&
                regex.hasMatch(widget.otpController.text.trim())) {
              widget.handleVerifyOtp();
            }
          },
        ),

        SizedBox(height: 15.h),

        Align(
          child: Column(
            children: [
              if (_canResend) ...[
                Text(
                  AppStrings.noCodeReceived,
                  style: AppTypography.montserratMedium.copyWith(fontSize: 12),
                ),
                TextButton(
                  onPressed: () {
                    widget.handleRetryOtp();
                    _startTimer();
                  },
                  child: Text(
                    AppStrings.resend,
                    style: AppTypography.montserratSemiBold.copyWith(
                      color: Color(0xFF1782FF),
                    ),
                  ),
                ),
              ] else ...[
                ValueListenableBuilder(
                  valueListenable: _remainingSeconds,
                  builder: (context, value, child) {
                    return Text(
                      '$value Sec',
                      style: AppTypography.montserratSemiBold.copyWith(
                        fontSize: 11,
                        color: AppColors.redColor,
                      ),
                    );
                  }
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 20),

        // // OTP Button
        // CustomButton(
        //   onPressed: () {
        //     if (otpController.text.trim().isNotEmpty &&
        //         regex.hasMatch(otpController.text.trim())) {
        //       handleVerifyOtp();
        //     }
        //   },
        //   isLoading: loadingNotifier,
        //   textColor: Colors.white,
        // ),
        SizedBox(height: 20),
      ],
    );
  }
}
