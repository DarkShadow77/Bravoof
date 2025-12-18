import 'dart:io';

import 'package:flowva/features/dashboard/profile/presentation/widgets/edit_avatar.dart';
import 'package:flowva/features/onbaording/data/bloc/user_cubit.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flowva/features/onboarding2/data/convert_asset_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'edit_name.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key, this.userProfile});

  UserProfile? userProfile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  ValueNotifier<bool> isSending = ValueNotifier(false);
  int? selectedAvatar;
  late UserCubit userCubit;

  final supabase = Supabase.instance.client;

  final ImagePicker _picker = ImagePicker();
  String? pickedImage;

  pickImage(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: imageSource);
      final imageBytes = await pickedFile!.readAsBytes();
      // final userid = supabase.auth.currentUser!.id;
      // supabase.storage
      //     .from('profile')
      //     .updateBinary('$userid/profile', imageBytes);

      setState(() {
        pickedImage = pickedFile.path;
      });

      userCubit.uploadProfileImage(File(await assetToFile(pickedFile.path)));
    } catch (e) {
      print(e);
      setState(() {
        // _pickImageError = e;
      });
    }
  }

  @override
  void initState() {
    userCubit = UserCubit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocListener<UserCubit, UserState>(
        bloc: userCubit,
        listener: (context, state) {
          if (state is UploadLoading) {
            isSending.value = true;
          }
          if (state is Updating) {
            isSending.value = true;
          }
          if (state is UploadSuccess) {
            userCubit.updateProfile(UserProfile(profilePic: state.imageUrl));
          }
          if (state is UserProfileSuccess) {
            isSending.value = false;
            setState(() {
              widget.userProfile!.profilePic = state.userProfile.profilePic;
              widget.userProfile!.name = state.userProfile.name;
              widget.userProfile!.bio = state.userProfile.bio;
            });
            Navigator.pop(context);
          }
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            const SizedBox(height: 10),

            // Profile Avatar
            Center(
              child: Stack(
                children: [
                  widget.userProfile != null
                      ? Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            widget.userProfile!.profilePic!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : selectedAvatar != null
                      ? Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          // clipBehavior: Clip.hardEdge,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              "assets/avatar/${selectedAvatar}.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : pickedImage != null
                      ? Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(pickedImage!, fit: BoxFit.cover),
                        )
                      : Container(
                          height: 120,
                          width: 120,
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedUser03,
                            strokeWidth: 1.2,
                            size: 18,
                          ),
                        ),

                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => setState(() {
                        selectedAvatar = null;
                        pickedImage = null;
                      }),
                      child: Container(
                        width: 28,
                        height: 28,
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
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Camera / Gallery / Avatar options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildOption(
                  context,
                  SvgPicture.asset("assets/images/camera-01.svg"),
                  "Camera",
                  apply: () {
                    pickImage(ImageSource.camera);
                  },
                ),
                buildOption(
                  context,
                  SvgPicture.asset("assets/images/gallery.svg"),
                  "Gallery",
                  apply: () {
                    pickImage(ImageSource.gallery);
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
                        userCubit.uploadProfileImage(
                          File(await assetToFile(val['avatarString'])),
                        );
                      },
                      selectedAvatar: selectedAvatar,
                      isSending: isSending,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Text(
                "Basic Details",
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
                    userCubit.updateProfile(
                      UserProfile(name: val['name'], bio: val['bio']),
                    );
                  },

                  isSending: isSending,
                ),
              ),
              "Name",
              widget.userProfile != null ? widget.userProfile!.name! : 'N/A',
              true,
            ),
            buildDetailTile(
              context,
              apply: () {},
              "Bio",
              widget.userProfile != null
                  ? widget.userProfile!.bio ?? 'Say something about yourself..'
                  : "Say something about yourself..",
              false,
            ),
            buildDetailTile(
              context,
              apply: () {},
              "Email Address",
              widget.userProfile != null ? widget.userProfile!.email! : 'N/A',
              false,
            ),
          ],
        ),
      ),
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
