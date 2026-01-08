import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inner_shadow_container/inner_shadow_container.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../styles/text_styles.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.fontFamily,
    this.iconWidget,
    this.color,
    this.textColor,
    this.borderColor,
    this.shadowColor = AppColors.black,
    this.height,
    this.textSize,
  });

  final VoidCallback onPressed;
  final String text;
  final String? icon;
  final String? fontFamily;
  final Widget? iconWidget;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Color shadowColor;
  final double? height;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    Color nullColor = color ?? AppColors.white;

    final buttonHeight = (height ?? 45).h;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 2.5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            width: 1.w,
            color: borderColor ?? AppColors.primary.withValues(alpha: .15),
          ),
        ),
        child: InnerShadowContainer(
          offset: Offset(-4, 10),
          blur: 9.r,
          borderRadius: 100.r,
          backgroundColor: nullColor,
          shadowColor: AppColors.white.withValues(alpha: .35),
          isShadowTopLeft: true,
          isShadowTopRight: true,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: nullColor,
              borderRadius: BorderRadius.circular(100.r),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withValues(alpha: .1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
                BoxShadow(
                  color: shadowColor.withValues(alpha: .09),
                  blurRadius: 6,
                  offset: Offset(0, 6),
                ),
                BoxShadow(
                  color: shadowColor.withValues(alpha: .05),
                  blurRadius: 9,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Row(
              spacing: 8.w,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ?iconWidget,
                if (icon != null) ...[
                  SvgPicture.asset(
                    icon!,
                    width: 16.w,
                    height: 16.h,
                    fit: BoxFit.contain,
                    colorFilter: textColor != null
                        ? ColorFilter.mode(textColor!, BlendMode.srcIn)
                        : null,
                  ),
                ],
                Flexible(
                  child: RichText(
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: text,
                      style: TextStyles.normalBold14(context).copyWith(
                        color: textColor,
                        fontSize: textSize?.sp,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
