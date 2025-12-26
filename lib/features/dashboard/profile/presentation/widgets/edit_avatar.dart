import 'dart:ui';

import 'package:flowva/features/common/app_enum.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../bloc/profile_bloc.dart';

class EditAvatarWidget extends StatefulWidget {
  EditAvatarWidget({
    super.key,
    required this.apply,
    required this.selectedAvatar,
    required this.isSending,
  });

  int? selectedAvatar;
  final Function(Map<String, dynamic> data) apply;
  final ValueNotifier<bool> isSending;
  @override
  State<EditAvatarWidget> createState() => _EditAvatarWidgetState();
}

class _EditAvatarWidgetState extends State<EditAvatarWidget> {
  final avatars = [
    "assets/avatar/1.png",
    "assets/avatar/2.png",
    "assets/avatar/3.png",
    "assets/avatar/4.png",
    "assets/avatar/5.png",
    "assets/avatar/6.png",
    "assets/avatar/7.png",
    "assets/avatar/8.png",
    "assets/avatar/9.png",
    "assets/avatar/10.png",
    "assets/avatar/11.png",
    "assets/avatar/12.png",
    "assets/avatar/13.png",
    "assets/avatar/14.png",
    "assets/avatar/15.png",
  ];
  void _successProfileState(BuildContext context, ProfileSuccessState state) {
    if (state.type == ProfileType.updateProfile) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.black.withValues(alpha: 0.5), // Optional dark overlay
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.56,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) {
            return BlocListener<ProfileBloc, ProfileState>(
  listener: (context, state) {if (state is ProfileSuccessState) {
    _successProfileState(context, state);
  }
  },
  child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // translucent
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // drag handle
                    Container(
                      width: 60.w,
                      height: 6.h,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    // Header with close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Avatar',
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          height: 36.r,
                          width: 36.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(120),
                            border: Border.all(
                              width: 0.2,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedCancel01,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: avatars.length,
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 1,
                                    ),
                                itemBuilder: (context, index) {
                                  final isSelected =
                                      widget.selectedAvatar == index;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(
                                        () => widget.selectedAvatar = index,
                                      );
                                    },
                                    child: Container(
                                      width: 52.r,
                                      height: 52.r,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: isSelected
                                            ? Border.all(
                                                color: const Color(0xFF7C4DFF),
                                                width: 2,
                                              )
                                            : null,
                                        boxShadow: [
                                          if (isSelected)
                                            BoxShadow(
                                              color: const Color(
                                                0xFF7C4DFF,
                                              ).withValues(alpha: 0.3),
                                              blurRadius: 8,
                                            ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          avatars[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ValueListenableBuilder(
                        valueListenable: widget.isSending,

                        builder: (context, val, _) {
                          print(val);
                          return FlowvaButton.blueButton(
                            buttonState: val
                                ? AppButtonState.loading
                                : AppButtonState.idle,
                            name: "Save",
                            apply: () => widget.selectedAvatar != null
                                ? widget.apply({
                                    "selectedAvatar": widget.selectedAvatar,
                                    "avatarString":
                                        avatars[widget.selectedAvatar!],
                                  })
                                : null,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 12.h + MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            ),
);
          },
        ),
      ],
    );
  }
}
