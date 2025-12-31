import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:totalx/src/application/core/status.dart';
import 'package:totalx/src/application/user/user_bloc.dart';
import 'package:totalx/src/domain/core/models/data_model/list_all_user_model/list_all_user_model.dart';
import 'package:totalx/src/domain/core/models/pm_model/pm_user_model/pm_user_model.dart';
import 'package:totalx/src/presentation/core/constants/app_images.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:totalx/src/presentation/core/theme/typography.dart';
import 'package:totalx/src/presentation/core/values/data_formatters.dart';
import 'package:totalx/src/presentation/core/values/no_glow_scroll_behaviour.dart';
import 'package:totalx/src/presentation/core/widget/custom_button.dart';
import 'package:totalx/src/presentation/core/widget/custom_loading.dart';

class UpdateUserBottomSheet extends StatefulWidget {
  const UpdateUserBottomSheet({
    super.key,
    required this.context,
    required this.userData,
    required this.handleRefresh,
  });
  final BuildContext context;
  final ListAllUserModel userData;
  final Function() handleRefresh;

  @override
  State<UpdateUserBottomSheet> createState() => _UpdateUserBottomSheetState();
}

class _UpdateUserBottomSheetState extends State<UpdateUserBottomSheet> {
  ListAllUserModel get _userData => widget.userData;

  final _showSizeError = ValueNotifier<bool>(false);

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  final _ageFocus = FocusNode();
  final _phoneFocus = FocusNode();

  File? _image;

  Map<String, dynamic> _userImage = {};

  @override
  void initState() {
    super.initState();

    _nameController.text = _userData.name ?? '';
    _ageController.text = _userData.age.toString();
    _phoneController.text = _userData.phoneNumber ?? '';

    _userImage = DataFormatters.decodeBase64ToUint8Lists(
      _userData.userImage ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _ageFocus.dispose();
    _phoneFocus.dispose();
    _showSizeError.dispose();
    _image = null;
    super.dispose();
  }

  void _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();
    if (bytes.length > 512 * 1024) {
      _showSizeError.value = true;
      return;
    }
    _showSizeError.value = false;
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext _) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehaviour(),
      child: BlocListener<UserBloc, UserState>(
        listenWhen: (previous, current) =>
            previous.updateUserStatus != current.updateUserStatus,
        listener: (context, state) {
          if (state.updateUserStatus is StatusInitial) {
          } else if (state.updateUserStatus is StatusLoading) {
            CustomLoading(context: context).show();
          } else if (state.updateUserStatus is StatusSuccess) {
            CustomLoading.dismiss(context);
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User updated')),
            );
            widget.handleRefresh();
          } else {
            CustomLoading.dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User updated failed')),
            );
          }
        },
        child: Container(
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(30),
              left: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.h),
              Text(
                'Update User',
                style: AppTypography.montserratSemiBold.copyWith(
                  fontSize: 13,
                  color: AppColors.black,
                  height: 23 / 13,
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          final imageKeys = _userImage.keys;
                          final isSvg = imageKeys.firstOrNull == 'svg';
                          final isMemory = imageKeys.firstOrNull == 'memory';
                          if (_image?.path != null) {
                            return Image.file(_image!, height: 85.h);
                          } else {
                            if (isSvg) {
                              return SvgPicture.string(
                                _userImage['svg'],
                                height: 85.h,
                              );
                            } else if (isMemory) {
                              return Image.memory(
                                _userImage['memory'],
                                height: 85.h,
                              );
                            }
                            return Image.asset(AppImages.pickImage);
                          }
                        },
                      ),
                      ValueListenableBuilder(
                        valueListenable: _showSizeError,
                        builder: (context, value, child) => value
                            ? Text(
                                'Image must be under 512 KB',
                                style: AppTypography.montserratSemiBold.copyWith(
                                  fontSize: 12,
                                  color: AppColors.redColor,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _textField(
                label: 'Name',
                controller: _nameController,
                keyboardType: TextInputType.name,
                focusNode: _nameFocus,
              ),
              SizedBox(height: 16.h),
              _textField(
                label: 'Age',
                controller: _ageController,
                keyboardType: TextInputType.number,
                focusNode: _ageFocus,
              ),
              SizedBox(height: 16.h),
              _textField(
                label: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.number,
                focusNode: _phoneFocus,
                prefixText: '+91 ',
                maxLength: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    label: 'Cancel',
                    width: 95.w,
                    height: 28.h,
                    marginRight: 8.w,
                    radius: 8,
                    onPressed: () {
                      context.pop();
                    },
                    textStyle: AppTypography.montserratMedium.copyWith(
                      color: AppColors.blackColor,
                      fontSize: 12,
                    ),
                    backgroundColor: Color(0xFFCCCCCC),
                  ),
                  Opacity(
                    opacity: _image != null || _userImage.isNotEmpty ? 1 : 0.5,
                    child: CustomButton(
                      label: 'Save',
                      width: 95.w,
                      height: 28.h,
                      marginLeft: 0,
                      radius: 8,
                      onPressed: () {
                        if (_image == null && _userImage.isEmpty) {
                          return;
                        }
                        final name = _nameController.text.trim();
                        final age = _ageController.text.trim();
                        final phoneNumber = _phoneController.text.trim();
                        if (name.isEmpty) {
                          _nameFocus.requestFocus();
                          return;
                        }
                        final ageRegex = RegExp(r'^[1-9]\d{0,1}$');
                        if (age.isEmpty || !ageRegex.hasMatch(age)) {
                          _ageFocus.requestFocus();
                          return;
                        }
                        final phoneRegex = RegExp(r'^[6-9]\d{9}$');
                        if (phoneNumber.isEmpty ||
                            !phoneRegex.hasMatch(phoneNumber)) {
                          _phoneFocus.requestFocus();
                          return;
                        }

                        final userModel = PmUserModel(
                          name: _nameController.text.trim(),
                          age: int.parse(_ageController.text.trim()),
                          phoneNumber: _phoneController.text.trim(),
                          userImage: _image,
                        );
                        context.read<UserBloc>().add(
                          UpdateUserEvent(
                            id: _userData.id!,
                            userModel: userModel,
                          ),
                        );
                      },
                      textStyle: AppTypography.montserratMedium.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 12,
                      ),
                      backgroundColor: Color(0xFF1782FF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? prefixText,
    FocusNode? focusNode,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.montserratRegular.copyWith(
            fontSize: 12,
            color: AppColors.greyColor2,
            height: 23 / 12,
          ),
        ),
        SizedBox(height: 11.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.words,
          focusNode: focusNode,
          maxLength: maxLength,
          decoration: InputDecoration(
            prefixText: prefixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.black.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
