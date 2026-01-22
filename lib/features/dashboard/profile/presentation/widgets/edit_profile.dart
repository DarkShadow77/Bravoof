import 'dart:io';

import 'package:Bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:Bravoo/features/dashboard/profile/presentation/widgets/edit_avatar.dart';
import 'package:Bravoo/features/onbaording/data/model/user_profile.dart';
import 'package:Bravoo/features/onboarding2/data/convert_asset_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../bloc/profile_bloc.dart';
import 'edit_name.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with UIToolMixin {
  UserProfile userProfile = UserProfile.empty();
  late ProfileBloc profileBloc;

  int? selectedAvatar;

  String? pickedImage;

  final ImagePicker _picker = ImagePicker();
  ValueNotifier<bool> isSending = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    profileBloc = context.read<ProfileBloc>();
    userProfile = profileBloc.state.profile;
    profileBloc.add(GetProfileEvent());
  }

  pickImage(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        setState(() {
          pickedImage = pickedFile.path;
          selectedAvatar = null;
        });

        context.read<ProfileBloc>().add(
          UpdateProfileEvent(
            profile: userProfile,
            imageFile: File(pickedFile.path),
          ),
        );
      }
    } catch (e) {
      print(e);
      setState(() {
        // _pickImageError = e;
      });
    }
  }

  void _loadingProfileState(BuildContext context, ProfileLoadingState state) {
    if (state.type == ProfileType.updateProfile) {
      isSending.value = true;
    }
  }

  void _successProfileState(BuildContext context, ProfileSuccessState state) {
    if (state.type == ProfileType.updateProfile) {
      isSending.value = false;
      showMessage(
        "Profile Updated Successfully",
        context,
        color: Colors.green,
        styleColor: Colors.white,
      );
      setState(() {
        selectedAvatar = null;
        pickedImage = null;
      });
    }
  }

  void _failedProfileState(BuildContext context, ProfileFailureState state) {
    if (state.type == ProfileType.updateProfile) {
      isSending.value = false;
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
        status: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadingState) {
          _loadingProfileState(context, state);
        } else if (state is ProfileSuccessState) {
          _successProfileState(context, state);
        } else if (state is ProfileFailureState) {
          _failedProfileState(context, state);
        }
      },
      builder: (context, state) {
        userProfile = state.profile;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context, true),
            ),
            title: Text(
              "Edit Profile",
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                // Profile Avatar
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 120.r,
                        width: 120.r,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: selectedAvatar != null
                            ? Image.asset(
                                "assets/avatar/${selectedAvatar}.png",
                                fit: BoxFit.cover,
                              )
                            : pickedImage != null
                            ? Image.file(File(pickedImage!), fit: BoxFit.cover)
                            : CachedImageRadius(
                                imageUrl: userProfile.profilePic,
                                circle: true,
                                size: 120,
                                fit: BoxFit.cover,
                                color: AppColors.grey.withValues(alpha: .5),
                              ),
                      ),

                      Positioned(
                        right: 0,
                        top: 0,
                        child: Visibility(
                          visible:
                              selectedAvatar != null || pickedImage != null,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              selectedAvatar = null;
                              pickedImage = null;
                            }),
                            child: Container(
                              width: 28.r,
                              height: 28.r,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildOption(
                      context,
                      SvgPicture.asset("assets/images/camera-01.svg"),
                      "Camera",
                      apply: () async {
                        pickImage(ImageSource.camera);
                      },
                    ),
                    buildOption(
                      context,
                      SvgPicture.asset("assets/images/gallery.svg"),
                      "Gallery",
                      apply: () async {
                        await pickImage(ImageSource.gallery);
                      },
                    ),
                    buildOption(
                      context,
                      HugeIcon(icon: HugeIcons.strokeRoundedNerd),
                      "Avatar",
                      name: 'avatar',
                      apply: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        barrierColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        // important for blur
                        builder: (_) => EditAvatarWidget(
                          apply: (val) async {
                            setState(() {
                              selectedAvatar = val['selectedAvatar'] + 1;
                            });
                            context.read<ProfileBloc>().add(
                              UpdateProfileEvent(
                                profile: userProfile,
                                imageFile: File(
                                  await assetToFile(val['avatarString']),
                                ),
                              ),
                            );
                          },
                          selectedAvatar: selectedAvatar,
                          isSending: isSending,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: Text(
                    "Update your name and bio",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF767676),
                    ),
                  ),
                ),
                buildDetailTile(
                  context,
                  apply: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    // important for blur
                    builder: (_) => EditNameWidget(
                      apply: (val) async {
                        final profile = UserProfile.empty();
                        context.read<ProfileBloc>().add(
                          UpdateProfileEvent(
                            profile: profile.copyWith(
                              name: val['name'],
                              bio: val['bio'],
                            ),
                          ),
                        );
                      },
                      isSending: isSending,
                    ),
                  ),
                  "Name",
                  userProfile.name ?? 'N/A',
                  true,
                ),
                buildDetailTile(
                  context,
                  apply: () {},
                  "Bio",
                  userProfile.bio ?? 'Say something about yourself..',
                  false,
                ),
                buildDetailTile(
                  context,
                  apply: () {},
                  "Email Address",
                  userProfile.email ?? 'N/A',
                  false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildOption(
    BuildContext context,
    Widget icon,
    String label, {
    String? name,
    required Function() apply,
  }) {
    return GestureDetector(
      onTap: apply,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDFE2EB)),
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailTile(
    BuildContext context,
    String label,
    String value,
    bool active, {
    required Function() apply,
  }) {
    return GestureDetector(
      onTap: apply,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF767676),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: active ? Color(0xFF191919) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              size: 18,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
