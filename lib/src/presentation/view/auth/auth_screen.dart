import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:totalx/app/router/router_constants.dart';
import 'package:totalx/src/domain/core/pref_key/preference_key.dart';
import 'package:totalx/src/infrastructure/core/preference_helper.dart';
import 'package:totalx/src/presentation/core/widget/custom_button.dart';
import 'package:totalx/src/presentation/view/auth/widget/otp_widget.dart';
import 'package:totalx/src/presentation/view/auth/widget/phone_number.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loadingNotifier = ValueNotifier<bool>(false);
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final String widgetId = '356c436f654e333231363038';
  final String authToken = '485295T0AdJ41wH69534acfP1';

  String? reqId;

  @override
  void initState() {
    super.initState();
    OTPWidget.initializeWidget(widgetId, authToken);
    _initOtp();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _otpController.dispose();
  }

  // Method to send OTP
  Future<void> handleSendOtp() async {
    _loadingNotifier.value = true;
    final data = {'identifier': '91${_phoneController.text.trim()}'};
    final response = await OTPWidget.sendOTP(data);
    // Handle response {message: 356c44635649373034303738, type: success}
    _loadingNotifier.value = false;
    if (response != null) {
      setState(() {
        // reqId = '356c44635649373034303738';
        reqId = response['message'];
      });
    }
  }

  Future<void> handleRetryOtp() async {
    _loadingNotifier.value = true;
    final data = {
      'reqId': reqId, // Request ID
      'retryChannel': 11, // Retry via SMS
    };
    final response = await OTPWidget.retryOTP(data);
    // Handle response
    _loadingNotifier.value = false;
    if (response != null) {
      setState(() {
        // reqId = '356c44635649373034303738';
        reqId = response['message'];
      });
    }
  }

  Future<void> handleVerifyOtp() async {
    _loadingNotifier.value = true;
    final data = {
      'reqId': reqId, // Request ID
      'otp': _otpController.text.trim(), // OTP entered by the user
    };
    final response = await OTPWidget.verifyOTP(data);
    // Handle response {message: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyZXF1ZXN0SWQiOiIzNTZjNDQ2YTdhNjczODMyMzQzOTM3MzEiLCJjb21wYW55SWQiOjQ4NTI5NX0.IfpeP2_8TTS8YQTrhPswOdMJMNqL3yCJukLax9RaFy4, type: success}
    _loadingNotifier.value = false;
    if (response?['message'] != null) {
      PreferenceHelper().setString(
        key: AppPrefKeys.token,
        value: response!['message'],
      );
      if (mounted) {
        context.go(RouterConstants.bottomNavRoute);
      }
    }
  }

  void _initOtp() async {
    SmsAutoFill().listenForCode();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: reqId == null || reqId!.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (mounted && (reqId != null || reqId!.isNotEmpty)) {
            setState(() {
              reqId = null;
            });
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: reqId != null && reqId!.isNotEmpty
                  ? OtpWidget(
                      key: ValueKey('otp'),
                      otpController: _otpController,
                      handleVerifyOtp: handleVerifyOtp,
                      handleRetryOtp: handleRetryOtp,
                      phoneNumber: _phoneController.text.trim(),
                      loadingNotifier: _loadingNotifier,
                    )
                  : PhoneNumberWidget(
                      key: ValueKey('phone'),
                      phoneController: _phoneController,
                      handleSendOtp: handleSendOtp,
                      loadingNotifier: _loadingNotifier,
                    ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CustomButton(
          label: reqId != null && reqId!.isNotEmpty ? 'Verify' : 'Get OTP',
          onPressed: () {
            if (reqId != null && reqId!.isNotEmpty) {
              final regex = RegExp(r'^[0-9]\d{5}$');
              if (_otpController.text.trim().isNotEmpty &&
                  regex.hasMatch(_otpController.text.trim())) {
                handleVerifyOtp();
              }
            } else {
              final regex = RegExp(r'^[6-9]\d{9}$');
              if (_phoneController.text.trim().isNotEmpty &&
                  regex.hasMatch(_phoneController.text.trim())) {
                handleSendOtp();
              }
            }
          },
          isLoading: _loadingNotifier,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
