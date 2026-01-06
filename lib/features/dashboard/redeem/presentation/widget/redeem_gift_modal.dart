import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:flowva/app/view/widgets/button/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/country_state_modal.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../common/flowva_text_field.dart';

Future redeemGiftModal({
  required Function(String?) onPressed,
  required bool showPhone,
}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    RedeemGiftModal(onPressed: onPressed, showPhone: showPhone),
  );
}

class RedeemGiftModal extends StatefulWidget {
  const RedeemGiftModal({
    super.key,
    required this.onPressed,
    required this.showPhone,
  });

  final Function(String?) onPressed;
  final bool showPhone;

  @override
  State<RedeemGiftModal> createState() => _RedeemGiftModalState();
}

class _RedeemGiftModalState extends State<RedeemGiftModal> {
  TextEditingController _phoneController = TextEditingController();

  bool _isPhoneValid = false;

  List<Country> countriesList = [];
  Country country = Country(
    name: "United States",
    flag: "🇺🇸",
    isoCode: "US",
    currency: "USD",
    phoneCode: "+1",
    longitude: "-97.00000000",
    latitude: "38.00000000",
  );

  @override
  void initState() {
    super.initState();

    getCountries();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> getCountries() async {
    countriesList = await getAllCountries();
    setState(() {});
  }

  Future<void> _validateForm() async {
    String phone = _phoneController.text.trim();

    setState(() {
      _isPhoneValid = GetUtils.isPhoneNumber(phone);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return ShowModalSheet(
      maxHeight: 400.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 52.w),
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
            SizedBox(height: 23.h),
            Row(
              spacing: 20.w,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 21.r,
                  width: 21.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(120),
                    border: Border.all(width: 0.2, color: AppColors.black60),
                  ),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    behavior: HitTestBehavior.opaque,
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      size: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 23.h),
            RichText(
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "You earned this!",
                style: TextStyles.titleRegular20(
                  context,
                ).copyWith(fontFamily: AppFonts.baloo, height: 1.sp),
              ),
            ),
            SizedBox(height: 23.h),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: "Thank you. Your reward will be processed within 7 days.",
                style: TextStyles.normalSemibold14(context),
              ),
            ),
            SizedBox(height: 36.h),
            if (widget.showPhone) ...[
              AppTextFeild(
                controller: _phoneController,
                hintText: "Enter your phone number",
                textInputType: TextInputType.number,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Phone Number is required"),
                ]).call,
                onChanged: (val) {
                  _validateForm();
                },
                prefixIcon: GestureDetector(
                  onTap: () {
                    getCountries();
                    countryStateModal(
                      title: "Country",
                      isPhone: true,
                      onPressed: (value) {
                        setState(() => country = value);
                        _validateForm();
                      },
                      list: countriesList,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    spacing: 5.w,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: country.flag,
                          style: TextStyles.titleSemiBold20(context),
                        ),
                      ),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text:
                              "${country.phoneCode.toString().startsWith("+") ? "" : "+"} ${country.phoneCode}",
                          style: TextStyles.normalSemibold14(context),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        width: 1.w,
                        color: AppColors.black50,
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 36.h),
            ],
            (!widget.showPhone || _isPhoneValid)
                ? IconTextButton(
                    color: AppColors.black,
                    textColor: AppColors.white,
                    onPressed: () =>
                        widget.onPressed(_phoneController.text.trim()),
                    text: "Confirm redemption ✅",
                  )
                : IconTextButton(
                    color: AppColors.grey300,
                    textColor: AppColors.white,
                    onPressed: () {},
                    text: "Confirm redemption ✅",
                  ),
            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
