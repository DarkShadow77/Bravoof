import 'dart:ui';

import 'package:Bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:Bravoo/core/constants/app_assets.dart';
import 'package:Bravoo/core/constants/fonts.dart';
import 'package:Bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as ss;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';

Future<dynamic> priceDetailsDialog({
  required CampaignResponseModel campaign,
}) async {
  return Get.dialog(
    name: "price_details_dialog",
    barrierDismissible: true,
    PriceDetailsDialog(campaign: campaign),
  );
}

class PriceDetailsDialog extends StatefulWidget {
  const PriceDetailsDialog({super.key, required this.campaign});

  final CampaignResponseModel campaign;

  @override
  State<PriceDetailsDialog> createState() => _PriceDetailsDialogState();
}

class _PriceDetailsDialogState extends State<PriceDetailsDialog> {
  String formatDate(String isoString) {
    final dateTime = DateTime.parse(isoString);

    return DateFormat('MMMM dd, yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(color: AppColors.black15),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: 20.sp,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 159.w,
                height: 189.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 100.r,
                        width: 100.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              color: AppColors.white.withValues(alpha: .35),
                              blurRadius: 40.r,
                              spreadRadius: 40.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 159.w,
                      height: 189.h,
                      child: Transform.scale(
                        scale: 1.5,
                        child: CachedImageSize(
                          imageUrl: widget.campaign.url,
                          width: 159.w,
                          height: 189.h,
                          color: Colors.transparent,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: .56),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30.h,
                      child: SvgPicture.asset(
                        AssetsSvgImages.prizeDetailTitle,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: widget.campaign.prizeDetails,
                        style: TextStyles.normalBold14(
                          context,
                        ).copyWith(color: AppColors.white85),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            "Draw Date: ${formatDate(widget.campaign.campaignEndDate.toString())}",
                        style: TextStyles.normalBold14(
                          context,
                        ).copyWith(color: AppColors.white85),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 58.h),
              Container(
                height: 68.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ss.Svg(AssetsSvgImages.prizeDetailBottom),
                  ),
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '“Winner will be announced here.\n Stay tuned!”',
                      style: TextStyles.normalRegular14(context).copyWith(
                        color: AppColors.white85,
                        fontFamily: AppFonts.baloo,
                      ),
                    ),
                  ),
                ),
              ),

              /*Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                decoration: BoxDecoration(
                  color: surfaceColor(),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: widget.title,
                        style: TextStyles.titleRegular20(context),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: widget.subtitle,
                        style: TextStyles.normalRegular14(context, opacity: .65),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      spacing: 8.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // "No" Button
                        Flexible(
                          flex: 1,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: _loading ? 0 : 150.w,
                            child: _ConfirmationButton(
                              key: ValueKey<bool>(false),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              mainButton: false,
                              loading: false,
                              text: "No",
                            ),
                          ),
                        ),

                        // "Yes" Button
                        Flexible(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: _loading ? 1000.w : 150.w,
                            child: _ConfirmationButton(
                              key: ValueKey<bool>(true),
                              onPressed: () {
                                widget.onPressed();
                              },
                              mainButton: true,
                              loading: _loading,
                              text: "Yes",
                            ),
                          ),
                        ),
                        */
              /*if (loading) ...[
                        Expanded(
                          child: Opacity(
                            opacity: loading ? 1 : 0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1000),
                              child: Container(
                                height: 32.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(32.r),
                                ),
                                child: Row(
                                  spacing: 14.w,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LoadingAnimationWidget.inkDrop(
                                      color: AppColors.white,
                                      size: 12.sp,
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: "Loading....",
                                        style: TextStyles.normalRegular14(
                                          context,
                                        ).copyWith(color: AppColors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Opacity(
                            opacity: loading ? 0 : 1,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1000),
                              child: Row(
                                spacing: 8.w,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: _ConfirmationButton(
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      },
                                      mainButton: false,
                                      loading: false,
                                      text: "No",
                                    ),
                                  ),
                                  Expanded(
                                    child: _ConfirmationButton(
                                      onPressed: () {
                                        setState(() {
                                          loading = true;
                                        });
                                        widget.onPressed();
                                      },
                                      mainButton: true,
                                      loading: loading,
                                      text: "Yes",
                                    ),
                                  ),
                                  */
              /*
                        */
              /*Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context, rootNavigator: true).pop();
                                          },
                                          child: Ink(
                                            height: 32.h,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1.w,
                                                color: AppColors.dynamic,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                32.r,
                                              ),
                                            ),
                                            child: Center(
                                              child: RichText(
                                                text: TextSpan(
                                                  text: "Yes",
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              loading = true;
                                            });
                                            widget.onPressed();
                                          },
                                          child: Ink(
                                            height: 32.h,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1.w,
                                                color: AppColors.dynamic,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                32.r,
                                              ),
                                            ),
                                            child: Center(
                                              child: RichText(
                                                text: TextSpan(
                                                  text: "No",
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),*/
              /*
                        */
              /*
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],*/
              /*
                      ],
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
