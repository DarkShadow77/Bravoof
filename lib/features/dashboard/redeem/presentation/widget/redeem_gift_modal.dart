import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
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
  required Function(String?, String?) onPressed,
  required bool showPhone,
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
    RedeemGiftModal(onPressed: onPressed, showPhone: showPhone),
  );
}

class RedeemGiftModal extends StatefulWidget {
  const RedeemGiftModal({
    super.key,
    required this.onPressed,
    required this.showPhone,
  });

  final Function(String?, String?) onPressed;
  final bool showPhone;

  @override
  State<RedeemGiftModal> createState() => _RedeemGiftModalState();
}

class _RedeemGiftModalState extends State<RedeemGiftModal> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _networkController = TextEditingController();

  bool _isPhoneValid = false;
  bool _isNetworkValid = false;

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
    String network = _networkController.text.trim();

    setState(() {
      _isPhoneValid = GetUtils.isPhoneNumber(phone);
      _isNetworkValid = network.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    final canProceed = widget.showPhone
        ? _isPhoneValid && _isNetworkValid
        : true;

    return ShowModalSheet(
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
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
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
                controller: _networkController,
                hintText: "Enter your Network Provider",
                textInputType: TextInputType.text,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Network Provider is required"),
                ]).call,
                onChanged: (val) {
                  _validateForm();
                },
              ),
              SizedBox(height: 10.h),
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
                prefixIcon: IntrinsicHeight(
                  child: GestureDetector(
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
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        spacing: 5.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: country.flag,
                              style: TextStyles.normalMedium14(context),
                            ),
                          ),
                          Flexible(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text:
                                    "${country.phoneCode.toString().startsWith("+") ? "" : "+"} ${country.phoneCode}",
                                style: TextStyles.normalMedium14(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
            IconTextButton(
              color: canProceed ? AppColors.black : AppColors.grey300,
              textColor: AppColors.white,
              onPressed: () {
                if (canProceed) {
                  final phone =
                      "${country.phoneCode.toString().startsWith("+") ? "" : "+"}"
                      "${country.phoneCode}"
                      "${_phoneController.text.trim()}";
                  widget.onPressed(phone, _networkController.text.trim());
                }
              },
              text: "Confirm redemption ✅",
            ),
            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
