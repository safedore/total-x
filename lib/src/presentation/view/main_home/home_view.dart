import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:totalx/src/application/core/status.dart';
import 'package:totalx/src/application/user/user_bloc.dart';
import 'package:totalx/src/presentation/core/theme/typography.dart';
import 'package:totalx/src/presentation/core/values/enumerators.dart';
import 'package:totalx/src/presentation/core/values/no_glow_scroll_behaviour.dart';
import 'package:totalx/src/presentation/view/main_home/widget/search_text_widget.dart';
import 'package:totalx/src/presentation/view/main_home/widget/user_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();

  late final ScrollController _scrollController;

  SortType _selectedSort = SortType.all;
  FilterType _selectedFilter = FilterType.all;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final state = context.read<UserBloc>().state;
      if (!state.hasReachedEnd &&
          state.getUserResultStatus is! StatusPageLoading) {
        _fetchData(page: state.currentPage + 1);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchData({
    int page = 1,
    bool isRefresh = false,
    String direction = 'asc',
    String orderBy = 'id',
    int? ageMin,
    int? ageMax,
  }) {
    orderBy = _selectedSort == SortType.all ? 'id' : 'age';
    direction = _selectedSort == SortType.all ? 'asc' : _selectedSort.name;

    if (_selectedFilter == FilterType.above60) ageMin = 60;
    if (_selectedFilter == FilterType.below60) ageMax = 60;

    context.read<UserBloc>().add(
      GetUserResultEvent(
        page: page,
        isRefresh: isRefresh,
        direction: direction,
        orderBy: orderBy,
        ageMin: ageMin,
        ageMax: ageMax,
        search: _searchController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehaviour(),
      child: RefreshIndicator(
        onRefresh: () async => _fetchData(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchTextWidget(
              controller: _searchController,
              selectedSort: _selectedSort,
              filterType: _selectedFilter,
              handleSort: (sortType, filterType) {
                String sort = sortType.name;
                if (sortType == SortType.all) {
                  sort = 'asc';
                }
                setState(() {
                  _selectedSort = sortType;
                  _selectedFilter = filterType;
                });
                _fetchData(
                  direction: sort,
                  orderBy: _selectedSort == SortType.all ? 'id' : 'age',
                  ageMin: _selectedFilter == FilterType.above60 ? 60 : null,
                  ageMax: _selectedFilter == FilterType.below60 ? 60 : null,
                );
              },
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10.w),
              child: Text(
                'Users Lists',
                style: AppTypography.montserratSemiBold,
              ),
            ),
            SizedBox(height: 15.h),
            UserList(
              scrollController: _scrollController,
              handleRefresh: _fetchData,
            ),
          ],
        ),
      ),
    );
  }
}
