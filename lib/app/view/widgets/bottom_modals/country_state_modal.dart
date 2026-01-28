import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../app/view/widgets/input/search_text_input.dart';
import '../../../../core/constants/app_colors.dart';

Future countryStateModal({
  required String title,
  required List list,
  bool isPhone = false,
  required Function(dynamic) onPressed,
}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    CountryStateModal(
      title: title,
      list: list,
      isPhone: isPhone,
      onPressed: onPressed,
    ),
  );
}

class CountryStateModal extends StatefulWidget {
  const CountryStateModal({
    super.key,
    required this.title,
    required this.list,
    required this.isPhone,
    required this.onPressed,
  });

  final String title;
  final List list;
  final bool isPhone;
  final Function(dynamic) onPressed;

  @override
  State<CountryStateModal> createState() => _CountryStateModalState();
}

class _CountryStateModalState extends State<CountryStateModal> {
  final TextEditingController _inputController = TextEditingController();

  String searchText = "";

  List searchData = [];

  @override
  void initState() {
    super.initState();
    search();
  }

  void search() {
    searchData.clear();

    if (searchText.isEmpty) {
      searchData.addAll(widget.list);
    } else {
      searchData.addAll(
        widget.list
            .where(
              (element) =>
                  element.name.toLowerCase().contains(searchText.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowModalSheet(
      maxHeight: 600.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            Row(
              spacing: 20.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Select ${widget.title}",
                      style: TextStyles.bodySemiBold16(
                        context,
                      ).copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.close_rounded,
                    size: 20.sp,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SearchTextInput(
              hintText: "Search ${widget.title}",
              controller: _inputController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
                search();
              },
            ),
            Flexible(
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([SizedBox(height: 24.h)]),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: searchData.length * 2,
                      (ctx, idx) {
                        if (idx.isOdd) {
                          return SizedBox(height: 12.h);
                        }
                        final itemIndex = idx ~/ 2;

                        if (itemIndex > searchData.length) {
                          return null;
                        }

                        final data = searchData[itemIndex];
                        return GestureDetector(
                          onTap: () {
                            widget.onPressed(data);
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.black05,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              spacing: 8.w,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (widget.title == "Country")
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: data.flag,
                                      style: TextStyles.titleSemiBold20(
                                        context,
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: data.name,
                                      style: TextStyles.normalSemibold14(
                                        context,
                                      ),
                                    ),
                                  ),
                                ),
                                if (widget.isPhone)
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text:
                                          "${data.phoneCode.toString().startsWith("+") ? "" : "+"}"
                                          "${data.phoneCode}",
                                      style: TextStyles.normalSemibold14(
                                        context,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(
                        height: 20.h + MediaQuery.of(context).padding.bottom,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
