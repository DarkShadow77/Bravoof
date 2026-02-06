import 'dart:ui';

import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_icon_changer/flutter_app_icon_changer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/custom_icons/custom_icons.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../utility/ui_tool_mix.dart';

Future changeAppIconModal() {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    ChangeAppIconModal(),
  );
}

class ChangeAppIconModal extends StatefulWidget {
  const ChangeAppIconModal({super.key});

  @override
  State<ChangeAppIconModal> createState() => _ChangeAppIconModalState();
}

class _ChangeAppIconModalState extends State<ChangeAppIconModal>
    with UIToolMixin {
  final _flutterAppIconChangerPlugin = FlutterAppIconChangerPlugin(
    iconsSet: CustomIcons.list,
  );

  CustomIcon _currentIcon = CustomIcons.defaultIcon;
  CustomIcon? _selectedIcon;
  var _isSupported = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _isSupported = await _flutterAppIconChangerPlugin.isSupported();
    if (_isSupported) {
      final currentIcon = await _flutterAppIconChangerPlugin.getCurrentIcon();

      if (!mounted) return;

      setState(() {
        _currentIcon = CustomIcon.fromString(currentIcon);
        _selectedIcon = _currentIcon;
      });
    }
  }

  Future<void> _changeIcon(CustomIcon icon) async {
    final bool confirmed = await _showConfirmationDialog() ?? false;
    if (!confirmed) return;

    final currentIcon = icon.currentIcon;

    try {
      context.read<ProfileBloc>().add(
        LogUserLogoActivityEvent(logoString: icon.logoName),
      );
      await _flutterAppIconChangerPlugin.changeIcon(currentIcon);
      setState(() {
        _currentIcon = icon;
      });
    } on PlatformException catch (e) {
      showMessage(
        "Failed to change icon: '${e.message}'.",
        context,
        color: Colors.green,
        styleColor: Colors.black,
        status: true,
      );
      debugPrint("Failed to change icon: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext ctx) {
    bool canProceed =
        _isSupported && _selectedIcon != null && _selectedIcon != _currentIcon;
    return ShowModalSheet(
      maxHeight: 600.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Row(
              spacing: 20.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 6.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              spacing: 20.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Change App Icon",
                      style: TextStyles.titleBold20(context),
                    ),
                  ),
                ),
                Container(
                  height: 36.r,
                  width: 36.r,
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.black03,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: AppColors.black05),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (!_isSupported) ...[
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Changing the icon is not supported on this device",
                  style: TextStyles.smallRegular12(context),
                ),
              ),
              SizedBox(height: 8.h),
            ],
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80.w,
                  crossAxisSpacing: 10.w,
                ),
                itemCount: CustomIcons.list.length,
                itemBuilder: (context, index) {
                  final icon = CustomIcons.list[index];
                  final isSelected = icon == _selectedIcon;
                  return GestureDetector(
                    onTap: () {
                      if (_isSupported) {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      }
                    },
                    child: Opacity(
                      opacity: _isSupported ? 1 : .5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: isSelected
                                  ? Border.all(
                                      color: AppColors.primary,
                                      width: 2.w,
                                    )
                                  : null,
                            ),
                            child: Container(
                              width: 60.w,
                              height: 60.h,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                image: DecorationImage(
                                  image: AssetImage(icon.previewPath),
                                  fit: BoxFit.cover,
                                ),
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
            IconTextButton(
              height: 56,
              color: canProceed ? AppColors.black : AppColors.grey400,
              textColor: AppColors.white,
              onPressed: () {
                if (canProceed) {
                  _changeIcon(_selectedIcon!);
                }
              },
              text: "Change Icon",
            ),
            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

Future<bool?> _showConfirmationDialog() async {
  return Get.dialog<bool>(
    name: "change_app_icon_confirmation_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    ChangeAppIconConfirmationDialog(),
  );
}

class ChangeAppIconConfirmationDialog extends StatelessWidget {
  const ChangeAppIconConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(color: AppColors.black.withValues(alpha: 0.2)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.white85,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15.h),
                    // Icon
                    Center(
                      child: Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          color: AppColors.redBrown11,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedLayersLogo,
                            color: AppColors.redBrown50,
                            size: 24.r,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Title
                    RichText(
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Change App Icon?",
                        style: TextStyles.bigTitleBold24(
                          context,
                        ).copyWith(fontFamily: AppFonts.baloo2),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            "The app may briefly restart to apply the new icon.",
                        style: TextStyles.smallMedium12(context),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      spacing: 8.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: IconTextButton(
                            height: 48,
                            color: AppColors.grey300,
                            textColor: AppColors.black,
                            onPressed: () => Navigator.pop(context, false),
                            text: "Cancel",
                          ),
                        ),
                        Expanded(
                          child: IconTextButton(
                            height: 48,
                            color: AppColors.black,
                            textColor: AppColors.white,
                            onPressed: () => Navigator.pop(context, true),
                            text: "Confirm",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
