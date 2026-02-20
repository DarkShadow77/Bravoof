import 'dart:ui';

import 'package:bravoo/features/common/app_enum.dart';
import 'package:bravoo/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../data/model/user_profile.dart';
import '../bloc/profile_bloc.dart';

class EditNameWidget extends StatefulWidget {
  EditNameWidget({super.key, required this.apply, required this.isSending});

  Function(Map<String, dynamic> data) apply;
  ValueNotifier<bool> isSending = ValueNotifier(false);

  @override
  State<EditNameWidget> createState() => _EditNameWidgetState();
}

class _EditNameWidgetState extends State<EditNameWidget> {
  final name = TextEditingController();
  final bio = TextEditingController();

  UserProfile userProfile = UserProfile.empty();
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();

    profileBloc = context.read<ProfileBloc>();
    userProfile = profileBloc.state.profile;
    profileBloc.add(GetProfileEvent());

    name.text = userProfile.name ?? "";
    bio.text = userProfile.bio ?? "";
  }

  void _successProfileState(BuildContext context, ProfileSuccessState state) {
    if (state.type == ProfileType.updateProfile) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black.withValues(
                alpha: 0.5,
              ), // Optional dark overlay
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (ctx, scrollController) {
              return BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileSuccessState) {
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
                    child: SingleChildScrollView(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          // drag handle
                          Container(
                            width: 60,
                            height: 6,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          // Header with close button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Name',
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                height: 36,
                                width: 36,
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
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: name,

                                    decoration: InputDecoration(
                                      hintText: 'James martins',
                                      hintStyle: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF767676),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          width: 0.2,
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          width: 0.2,
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 18,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Bio',
                                    style: GoogleFonts.manrope(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    controller: bio,
                                    decoration: InputDecoration(
                                      hintText: 'Say something about yourself',
                                      hintStyle: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF767676),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          width: 0.2,
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          width: 0.2,
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 18,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
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
                                  apply: () {
                                    if (name.text.isNotEmpty) {
                                      widget.apply({
                                        "name": name.text,
                                        "bio": bio.text,
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
