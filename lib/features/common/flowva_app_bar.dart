import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/core/utils/helpers.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dashboard/earn/presentation/pages/jackpot_page.dart';
import '../dashboard/profile/presentation/bloc/profile_bloc.dart';

class FlowvaAppBar extends StatefulWidget {
  final String title;

  FlowvaAppBar({this.title = '', Function? apply, super.key});

  @override
  State<FlowvaAppBar> createState() => _FlowvaAppBarState();
}

class _FlowvaAppBarState extends State<FlowvaAppBar> {
  UserProfile profile = UserProfile.empty();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        profile = state.profile;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            spacing: 20.w,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: widget.title,
                  style: TextStyles.titleSemiBold20(context),
                ),
              ),
              Row(
                spacing: 8.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => JackpotScreen()),
                      );
                    },
                    child: Row(
                      spacing: 4.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetsPngImages.jackpot,
                          height: 18.h,
                          width: 18.w,
                          fit: BoxFit.contain,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "x${formatAmount(profile.spins ?? 0)}",
                            style: TextStyles.normalSemibold14(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 4.w,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/one_50.png", height: 18),

                      RichText(
                        text: TextSpan(
                          text: "${formatAmount(profile.totalPoints ?? 0)}",
                          style: TextStyles.normalSemibold14(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
