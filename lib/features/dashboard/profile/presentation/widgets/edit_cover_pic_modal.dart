import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/helpers/image_picker_helper.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../bloc/profile_bloc.dart';

Future editCoverPicModal() {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    EditCoverPicModal(),
  );
}

class EditCoverPicModal extends StatefulWidget {
  const EditCoverPicModal({super.key});

  @override
  State<EditCoverPicModal> createState() => _EditCoverPicModalState();
}

class _EditCoverPicModalState extends State<EditCoverPicModal>
    with UIToolMixin {
  void _uploadCamera() {
    ImageHelper.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        context.read<ProfileBloc>().add(
          UpdateCoverPicEvent(imageFile: File(value.path)),
        );
      }
    });
  }

  void _uploadGallery() {
    ImageHelper.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        context.read<ProfileBloc>().add(
          UpdateCoverPicEvent(imageFile: File(value.path)),
        );
      }
    });
  }

  void _loadingProfileState(BuildContext context, ProfileLoadingState state) {
    if (state.type == ProfileType.updateCoverPic) {
      outerLoadingDialog(text: 'Updating Cover Pic…');
    }
  }

  void _successProfileState(BuildContext context, ProfileSuccessState state) {
    if (state.type == ProfileType.updateCoverPic) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (Get.isBottomSheetOpen ?? false) Get.back();
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
      );
    }
  }

  void _failedProfileState(BuildContext context, ProfileFailureState state) {
    if (state.type == ProfileType.updateCoverPic) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
        iconColor: Colors.red,
        status: true,
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) =>
          curr is ProfileLoadingState &&
              (curr.type == ProfileType.updateCoverPic) ||
          curr is ProfileSuccessState &&
              (curr.type == ProfileType.updateCoverPic) ||
          curr is ProfileFailureState &&
              (curr.type == ProfileType.updateCoverPic),
      listener: (context, state) {
        if (state is ProfileLoadingState) {
          _loadingProfileState(context, state);
        } else if (state is ProfileSuccessState) {
          _successProfileState(context, state);
        } else if (state is ProfileFailureState) {
          _failedProfileState(context, state);
        }
      },
      child: ShowModalSheet(
        maxHeight: 700.h,
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
              SizedBox(height: 12.h),
              Row(
                spacing: 20.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Edit Cover Photo",
                        style: TextStyles.titleRegular20(
                          context,
                        ).copyWith(fontFamily: AppFonts.baloo, height: 1.sp),
                      ),
                    ),
                  ),
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
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Select an Image Option",
                  style: TextStyles.normalSemibold14(context, opacity: .65),
                ),
              ),
              SizedBox(height: 23.h),
              Row(
                spacing: 10.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildImageSelector(
                      context,
                      text: "Take a Picture",
                      image: AssetsSvgIcons.camera,
                      onTap: _uploadCamera,
                    ),
                  ),
                  Expanded(
                    child: _buildImageSelector(
                      context,
                      text: "Upload an Image",
                      image: AssetsSvgIcons.upload,
                      onTap: _uploadGallery,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildImageSelector(
    BuildContext context, {
    required VoidCallback onTap,
    required String text,
    required String image,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              color: AppColors.grey200.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                image,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            text: TextSpan(
              text: text,
              style: TextStyles.normalMedium14(context, opacity: .5),
            ),
          ),
        ],
      ),
    );
  }
}
