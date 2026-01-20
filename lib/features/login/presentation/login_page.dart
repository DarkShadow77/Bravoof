import 'package:Bravoo/features/common/app_enum.dart';
import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:Bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:Bravoo/features/dashboard/nav_bar.dart';
import 'package:Bravoo/features/onbaording/data/bloc/user_cubit.dart';
import 'package:Bravoo/features/onbaording/data/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with UIToolMixin {
  final formkey = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();
  ValueNotifier<bool> isSending = ValueNotifier(false);
  late UserCubit userCubit;

  @override
  void initState() {
    userCubit = UserCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UserCubit, UserState>(
        bloc: userCubit,
        listener: (context, state) {
          print(state);
          if (state is UserLoading) {
            print(state);
            setState(() {
              isSending.value = true;
            });
          } else if (state is UserSuccess) {
            setState(() {
              isSending.value = false;
            });
            showMessage(
              'Login successfully.',
              context,
              color: Colors.green,
              styleColor: Colors.white,
              status: true,
            );
            Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 1500),
                child: BottomNavBar(),
              ),
              (ctx) => false,
            );
          }
          if (state is UserFailure) {
            setState(() {
              isSending.value = false;
            });
            showMessage(
              state.error,
              context,
              color: Colors.red,
              styleColor: Colors.white,
              status: true,
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Form(
                key: formkey,
                child: Container(
                  width: double.infinity,
                  // padding: const EdgeInsets.all(16),
                  child: ListView(
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    shrinkWrap: true,
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Let’s get you started.",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email field
                      TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          hintText: "Email address",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                          filled: true,
                          fillColor: Colors.white,
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
                        validator: RequiredValidator(
                          errorText: "Email is required",
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Password field
                      TextFormField(
                        controller: pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                          suffixIcon: Image.asset(
                            "assets/images/open_eye.png",
                            height: 35,
                          ),
                          filled: true,
                          fillColor: Colors.white,
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
                        validator: RequiredValidator(
                          errorText: "Password is required",
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Continue button with gradient
                      SizedBox(
                        width: double.infinity,
                        child: ValueListenableBuilder(
                          valueListenable: isSending,

                          builder: (context, val, _) {
                            print(val);
                            return FlowvaButton.blueButton(
                              buttonState: val
                                  ? AppButtonState.loading
                                  : AppButtonState.idle,
                              name: "Login",
                              apply: () {
                                if (!formkey.currentState!.validate()) return;
                                final profile = UserProfile.empty();
                                userCubit.signIn(
                                  userProfile: profile.copyWith(
                                    email: email.text,
                                    pass: pass.text,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              height: 4,
                              color: Colors.transparent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "OR",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              height: 4,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Social Buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,

                            child: Image.asset(
                              "assets/images/google_button.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,

                            child: Image.asset(
                              "assets/images/apple_b.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
