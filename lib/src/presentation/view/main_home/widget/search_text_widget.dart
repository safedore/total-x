import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:totalx/src/application/user/user_bloc.dart';
import 'package:totalx/src/presentation/core/constants/app_images.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:totalx/src/presentation/core/theme/typography.dart';
import 'package:totalx/src/presentation/core/values/enumerators.dart';
import 'package:totalx/src/presentation/view/main_home/widget/sort_bottom_sheet.dart';

class SearchTextWidget extends StatefulWidget {
  const SearchTextWidget({
    super.key,
    required this.controller,
    required this.selectedSort,
    required this.filterType,
    required this.handleSort,
  });
  final TextEditingController controller;
  final SortType selectedSort;
  final FilterType filterType;
  final Function(SortType sortType, FilterType filterType) handleSort;

  @override
  State<SearchTextWidget> createState() => _SearchTextWidgetState();
}

class _SearchTextWidgetState extends State<SearchTextWidget> {
  SortType get _selectedSort => widget.selectedSort;
  FilterType get _filterType => widget.filterType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, top: 11.h, right: 13.w),
      child: Row(
        children: [
          SizedBox(
            height: 44.h,
            width: 297.w,
            child: TextField(
              controller: widget.controller,
              onSubmitted: (value) {
                String sort = _selectedSort.name;
                if (_selectedSort == SortType.all) {
                  sort = 'asc';
                }

                context.read<UserBloc>().add(
                  GetUserResultEvent(
                    search: value,
                    orderBy: _selectedSort == SortType.all ? 'id' : 'age',
                    direction: sort,
                    ageMin: _filterType == FilterType.above60 ? 60 : null,
                    ageMax: _filterType == FilterType.below60 ? 60 : null,
                  ),
                );
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.black.withValues(alpha: 0.9),
                ),
                hintText: 'search by name',
                hintStyle: AppTypography.montserratRegular.copyWith(
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide: BorderSide(color: AppColors.blackColor),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                showDragHandle: false,
                backgroundColor: AppColors.transparent,
                builder: (_) {
                  return SortBottomSheet(
                    sortType: _selectedSort,
                    filterType: _filterType,
                    handleSort: (sortType, filterType) {
                      widget.handleSort(
                        sortType ?? SortType.all,
                        filterType ?? FilterType.all,
                      );
                    },
                  );
                },
              );
            },
            child: SvgPicture.asset(
              AppImages.filterIcon,
              width: 32.w,
              height: 32.h,
            ),
          ),
        ],
      ),
    );
  }
}
