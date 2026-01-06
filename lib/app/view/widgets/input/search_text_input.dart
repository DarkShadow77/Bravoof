import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../styles/text_styles.dart';

class SearchTextInput extends StatefulWidget {
  const SearchTextInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.autofocus = false,
    this.errorBool = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.words,
    this.onChanged,
    this.length = 999,
    this.color,
    this.inverse = false,
    this.radius = 16,
  });

  final bool errorBool;
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final int length;
  final Color? color;
  final bool inverse;
  final double radius;

  @override
  State<SearchTextInput> createState() => _SearchTextInputState();
}

class _SearchTextInputState extends State<SearchTextInput> {
  late FocusNode _focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.h,
      decoration: BoxDecoration(
        color: widget.color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(widget.radius.r),
        border: Border.all(
          width: 1.w,
          color: widget.errorBool
              ? AppColors.error
              : isFocused
              ? AppColors.primary50
              : AppColors.black10,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!widget.inverse) ...[SizedBox(width: 8.w)],
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              autofocus: widget.autofocus,
              keyboardType: widget.textInputType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.length),
              ],
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyles.normalRegular14(
                  context,
                ).copyWith(fontSize: 15.sp, color: AppColors.black40),
                border: InputBorder.none,
              ),
              style: TextStyles.normalRegular14(
                context,
              ).copyWith(fontSize: 15.sp, color: AppColors.black),
              onChanged: widget.onChanged,
            ),
          ),
          if (widget.inverse) ...[SizedBox(width: 8.w)],
        ],
      ),
    );
  }
}
