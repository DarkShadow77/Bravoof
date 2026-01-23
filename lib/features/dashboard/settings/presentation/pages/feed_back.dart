import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/app/view/widgets/loading/outer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../profile/presentation/bloc/feedback_bloc.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> with UIToolMixin {
  final message = TextEditingController();
  String? selectedValue;
  bool _isPressed = false;
  final List<String> feedbackOptions = [
    "Bug Report",
    "Feature Request",
    "Appreciation",
    "Other",
  ];

  bool get _canSubmit => message.text.isNotEmpty && selectedValue != null;

  void _loadingFeedbackState(BuildContext context, FeedbackLoadingState state) {
    outerLoadingDialog(text: "Submitting Feedback");
  }

  void _successFeedbackState(BuildContext context, FeedbackSuccessState state) {
    if (Get.isDialogOpen == true) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    Navigator.of(context).pop();
    showMessage(
      "Feedback Submitted Successfully",
      context,
      color: Colors.green,
      styleColor: Colors.white,
    );
  }

  void _failureFeedbackState(BuildContext context, FeedbackFailureState state) {
    if (Get.isDialogOpen == true) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    showMessage(
      state.message,
      context,
      color: Colors.white,
      styleColor: Colors.black,
      status: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackLoadingState) {
          _loadingFeedbackState(context, state);
        } else if (state is FeedbackFailureState) {
          _failureFeedbackState(context, state);
        } else if (state is FeedbackSuccessState) {
          _successFeedbackState(context, state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Share your feedback",
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              // Emoji / icon at top
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/reply.png', // replace with your asset
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 25),

              // Main title
              Text(
                "Your feedback is important!",
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF191919),
                ),
              ),
              const SizedBox(height: 8),

              // Description text
              Text(
                "Thanks for send us your ideas issues or appreciations. "
                "We might not respond individually, be we will pass it on "
                "to the teams who are working to help make Flowva better for everyone",

                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A4A4A),
                ),
              ),

              const SizedBox(height: 30),

              // Dropdown title #
              Text(
                "Whats your feedback about?",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF767676),
                ),
              ),
              const SizedBox(height: 10),

              // Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Please Select"),
                    value: selectedValue,
                    isExpanded: true,
                    items: feedbackOptions
                        .map(
                          (option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),
              const Divider(thickness: 0.8, color: Color(0xFFE6E6E6)),
              const SizedBox(height: 20),
              TextFormField(
                controller: message,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Your message here",
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 0.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),

                    borderSide: BorderSide(
                      width: 0.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                validator: RequiredValidator(errorText: "Message is required"),
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 20),
              // Need to get in touch?
              Text(
                "Need to get in touch?",
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191919),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Let’s start with a few questions to guide you to the right spot",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Reach out to us at ",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    TextSpan(
                      text: "support@Bravoo.com ",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9013FE),
                      ),
                    ),
                    TextSpan(
                      text: "or whatsapp us at +1 (587) 287-2064 ",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              IconTextButton(
                onPressed: () {
                  if (_canSubmit) {
                    context.read<FeedbackBloc>().add(
                      SubmitFeedbackEvent(
                        title: selectedValue ?? "",
                        message: message.text,
                      ),
                    );
                  }
                },
                text: "Submit",
                height: 54,
                color: _canSubmit ? AppColors.black : AppColors.grey300,
                textColor: AppColors.white,
                borderColor: AppColors.grey100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
