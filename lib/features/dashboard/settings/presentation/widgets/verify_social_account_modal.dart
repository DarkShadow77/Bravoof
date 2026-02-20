import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pinput/pinput.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';

Future<String?> verifySocialAccountModal({
  required String provider,
  required String providerEmail,
  required String currentEmail,
  required bool emailMatch,
}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    VerifySocialAccountModal(
      provider: provider,
      providerEmail: providerEmail,
      currentEmail: currentEmail,
      emailMatch: emailMatch,
    ),
  );
}

class VerifySocialAccountModal extends StatefulWidget {
  const VerifySocialAccountModal({
    super.key,
    required this.provider,
    required this.providerEmail,
    required this.currentEmail,
    required this.emailMatch,
  });

  final String provider;
  final String providerEmail;
  final String currentEmail;
  final bool emailMatch;

  @override
  State<VerifySocialAccountModal> createState() =>
      _VerifySocialAccountModalState();
}

class _VerifySocialAccountModalState extends State<VerifySocialAccountModal> {
  TextEditingController _verificationController = TextEditingController();

  bool _isCodeValid = false;
  bool _isFormValid = true;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    _verificationController.dispose();
    super.dispose();
  }

  _validateForm() {
    String code = _verificationController.text.trim();

    setState(() {
      _isCodeValid = code.length == 6;
    });
  }

  bool _formValidation() {
    return _isCodeValid;
  }

  _submit() {
    _validateForm();
    _isFormValid = _formValidation();
    if (_isFormValid) {
      Navigator.pop(context, _verificationController.text.trim());
    }
  }

  @override
  Widget build(BuildContext ctx) {
    final defaultPinTheme = PinTheme(
      width: 75.w,
      height: 50.h,
      textStyle: TextStyles.h2Medium32(
        context,
      ).copyWith(color: AppColors.grey500, fontFamily: AppFonts.baloo),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
    return ShowModalSheet(
      maxHeight: 600.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            SizedBox(height: 4.h),
            Row(
              spacing: 20.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text:
                          "Verify ${widget.provider.capitalize ?? ""} Account",
                      style: TextStyles.titleSemiBold20(context),
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
            if (!widget.emailMatch) ...[
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: AppColors.orange11,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Different email detected",
                        style: TextStyles.normalBold14(
                          context,
                        ).copyWith(color: AppColors.redBrown),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    RichText(
                      text: TextSpan(
                        text: 'Current: ${widget.currentEmail}',
                        style: TextStyles.smallMedium12(context),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Linking: ${widget.providerEmail}',
                        style: TextStyles.smallSemibold12(context),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],
            RichText(
              text: TextSpan(
                text: "A verification code has been sent to: ",
                children: [
                  TextSpan(
                    text: widget.providerEmail,
                    style: TextStyle(
                      color: AppColors.primary50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                style: TextStyles.normalRegular14(context),
              ),
            ),
            SizedBox(height: 16.h),
            Pinput(
              length: 6,
              controller: _verificationController,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                  color: AppColors.white50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary, width: 1.w),
                ),
              ),
              onChanged: (val) => _validateForm(),
              obscureText: false,
              showCursor: true,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(height: 24.h),
            IconTextButton(
              height: 54,
              onPressed: _submit,
              text: "Verify",
              color: _formValidation() ? AppColors.black : AppColors.grey300,
              textColor: AppColors.white,
            ),

            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
