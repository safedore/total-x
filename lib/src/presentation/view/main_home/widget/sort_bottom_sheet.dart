import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:totalx/src/presentation/core/theme/typography.dart';
import 'package:totalx/src/presentation/core/values/enumerators.dart';

import '../../../core/theme/color.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({
    super.key,
    required this.sortType,
    required this.filterType,
    required this.handleSort,
  });
  final SortType sortType;
  final FilterType filterType;
  final Function(SortType? sortType, FilterType? filterType) handleSort;

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  SortType? _sortType;
  FilterType? _filterType;

  @override
  void initState() {
    super.initState();
    _sortType = widget.sortType;
    _filterType = widget.filterType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(30),
          left: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          RadioGroup<SortType>(
            groupValue: _sortType,
            onChanged: (SortType? value) {
              widget.handleSort(value, _filterType);
              if (mounted) {
                setState(() {
                  _sortType = value;
                });
              }
              // context.pop();
            },
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sort', style: AppTypography.montserratSemiBold),

                  RadioListTile<SortType>(
                    value: SortType.all,
                    contentPadding: EdgeInsets.zero,
                    radioScaleFactor: 1.1,
                    title: Text(
                      'All',
                      style: AppTypography.montserratMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.greyColor2,
                      ),
                    ),
                  ),

                  RadioListTile<SortType>(
                    value: SortType.desc,
                    contentPadding: EdgeInsets.zero,
                    radioScaleFactor: 1.1,
                    title: Text(
                      'Age: Elder',
                      style: AppTypography.montserratMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.greyColor2,
                      ),
                    ),
                  ),

                  RadioListTile<SortType>(
                    value: SortType.asc,
                    contentPadding: EdgeInsets.zero,
                    radioScaleFactor: 1.1,
                    title: Text(
                      'Age: Younger',
                      style: AppTypography.montserratMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.greyColor2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          RadioGroup<FilterType>(
            groupValue: _filterType,
            onChanged: (FilterType? value) {
              if (value != null) {
                widget.handleSort(_sortType, value);
                if (mounted) {
                  setState(() {
                    _filterType = value;
                  });
                }
              }
              // context.pop();
            },
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter', style: AppTypography.montserratSemiBold),

                  RadioListTile<FilterType>(
                    value: FilterType.all,
                    contentPadding: EdgeInsets.zero,
                    radioScaleFactor: 1.1,
                    title: Text(
                      'All',
                      style: AppTypography.montserratMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.greyColor2,
                      ),
                    ),
                  ),

                  RadioListTile<FilterType>(
                    value: FilterType.above60,
                    contentPadding: EdgeInsets.zero,
                    radioScaleFactor: 1.1,
                    title: Text(
                      'Age: Above 60',
                      style: AppTypography.montserratMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.greyColor2,
                      ),
                    ),
                  ),

                  RadioListTile<FilterType>(
                    value: FilterType.below60,
                    contentPadding: EdgeInsets.zero,
                    radioScaleFactor: 1.1,
                    title: Text(
                      'Age: Below 60',
                      style: AppTypography.montserratMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.greyColor2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
