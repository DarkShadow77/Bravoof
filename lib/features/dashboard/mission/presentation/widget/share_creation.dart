import 'dart:ui';

import 'package:bravoo/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

class ShareCreation extends StatefulWidget {
  Function(dynamic val) apply;
  ShareCreation({super.key, required this.apply});

  @override
  State<ShareCreation> createState() => _ShareCreationState();
}

class _ShareCreationState extends State<ShareCreation> {
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

      // userCubit.uploadProfileImage(
      //     await assetToFile(pickedFile.path));
    } catch (e) {
      print(e);
      setState(() {
        // _pickImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.black.withValues(alpha:0.5), // Optional dark overlay
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.46,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) {
            return ClipRRect(
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 26,
                          width: 26,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(120),
                            border: Border.all(
                              width: 0.2,
                              color: Colors.black.withValues(alpha:0.6),
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
                    const SizedBox(height: 16),
                    Text(
                      "Submit Your Work",
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Upload your story to complete the \nmission.",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    pickedImage == null
                        ? GestureDetector(
                            onTap: () => pickImage(ImageSource.gallery),
                            child: Container(
                              height: 40,
                              width: 243,
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F1F1),
                                border: Border.all(color: Color(0xFFE9E9E9)),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha:0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Click to upload your image",
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFA5A5A5),
                                    ),
                                  ),
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedImageCrop,
                                    strokeWidth: 1.2,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 80,
                            width: 120,
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(pickedImage!, fit: BoxFit.cover),
                          ),
                    const SizedBox(height: 16),
                    // Save Tool button
                    SizedBox(
                      width: double.infinity,
                      child: FlowvaButton.mediumBlack2Button(
                        name: "Submit Mission",
                        fontSize: 14,
                        apply: () => widget.apply(pickedImage),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
