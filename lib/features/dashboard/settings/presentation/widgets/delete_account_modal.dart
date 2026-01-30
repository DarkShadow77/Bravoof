import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../common/flowva_text_field.dart';
import '../pages/delete_account_page.dart';

Future deactivateAccountModal() {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    DeactivateAccountModal(),
  );
}

class DeactivateAccountModal extends StatefulWidget {
  const DeactivateAccountModal({super.key});

  @override
  State<DeactivateAccountModal> createState() => _DeactivateAccountModalState();
}

class _DeactivateAccountModalState extends State<DeactivateAccountModal> {
  final TextEditingController reasonController = TextEditingController();

  String? selectedOption;

  final items = [
    {"label": "I have safety or privacy concerns"},
    {"label": "I don’t need it anymore "},
    {"label": "I cant comply to Bravoo’s term of rule"},
    {"label": "Other"},
  ];

  @override
  Widget build(BuildContext ctx) {
    bool canProceed =
        selectedOption != null &&
        (selectedOption != "Other" || reasonController.text.trim().isNotEmpty);

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
                      text: "What prompted you to Delete you Account?",
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

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = items[i]["label"];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey100.withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        spacing: 16.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: items[i]["label"] ?? "",
                                style: TextStyles.normalMedium14(context),
                              ),
                            ),
                          ),
                          Container(
                            width: 16.r,
                            height: 16.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedOption == items[i]["label"]
                                    ? AppColors.black
                                    : AppColors.grey500,
                                width: 2.w,
                              ),
                              color: selectedOption == items[i]["label"]
                                  ? AppColors.black
                                  : Colors.transparent,
                            ),
                            child: selectedOption == items[i]["label"]
                                ? Center(
                                    child: Container(
                                      width: 5.3.r,
                                      height: 5.3.r,
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (selectedOption == "Other") ...[
              AppTextFeild(
                controller: reasonController,
                hintText: "Type your reason here",
                validator: MultiValidator([
                  RequiredValidator(errorText: "Reason is required"),
                ]).call,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 10.h),
            ],
            IconTextButton(
              height: 56,
              color: canProceed ? AppColors.error : AppColors.grey400,
              textColor: AppColors.white,
              onPressed: () {
                if (canProceed) {
                  final reason = selectedOption == "Other"
                      ? reasonController.text.trim()
                      : (selectedOption ?? "");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => DeleteAccountPage(reason: reason),
                    ),
                  );
                }
              },
              text: "Delete Account",
            ),
            SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
