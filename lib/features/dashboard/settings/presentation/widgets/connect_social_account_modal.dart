import 'dart:io';
import 'dart:ui';

import 'package:Bravoo/app/view/widgets/loading/outer_loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../profile/data/model/user_profile.dart';
import '../../../profile/presentation/bloc/auth_link_bloc.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import 'verify_social_account_modal.dart';

Future connectSocialAccountModal() {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    ConnectSocialAccountModal(),
  );
}

class ConnectSocialAccountModal extends StatefulWidget {
  const ConnectSocialAccountModal({super.key});

  @override
  State<ConnectSocialAccountModal> createState() =>
      _ConnectSocialAccountModalState();
}

class _ConnectSocialAccountModalState extends State<ConnectSocialAccountModal>
    with UIToolMixin {
  UserProfile _userProfile = UserProfile.empty();

  String? _pendingProvider;
  String? _pendingProviderEmail;
  String? _currentEmail;
  bool _emailsMatch = false;

  @override
  void initState() {
    super.initState();
    final profileBloc = context.read<ProfileBloc>();
    _userProfile = profileBloc.state.profile;
    profileBloc.add(GetProfileEvent());
  }

  Future<void> _unlinkProvider(String provider) async {
    if (!_userProfile.authProviders.canUnlink(provider)) {
      showMessage(
        'You must have at least one authentication method',
        context,
        color: Colors.green,
        styleColor: Colors.black,
        status: true,
      );
      return;
    }
    final bool confirmed =
        await _showConfirmationDialog(provider: provider) ?? false;
    if (confirmed == true) {
      _pendingProvider = provider;
      _pendingProviderEmail = _userProfile.providerEmails.getEmail(provider);
      context.read<AuthLinkBloc>().add(UnlinkEvent(provider: provider));
    }
  }

  _verifyLink(String verificationCode) {
    if (verificationCode.length != 6) {
      showMessage(
        "Please enter a 6-digit code",
        context,
        color: Colors.green,
        styleColor: Colors.white,
        status: true,
      );
      return;
    }
    context.read<AuthLinkBloc>().add(VerifyLinkEvent(code: verificationCode));
  }

  void _loadingAuthLinkState(BuildContext context, AuthLinkLoadingState state) {
    if (state.type == AuthLinkType.unlinkProvider) {
      outerLoadingDialog(
        text: "Unlinking ${_pendingProvider} Account...",
        canPop: false,
      );
    } else if (state.type == AuthLinkType.linkGoogle) {
      outerLoadingDialog(text: "Linking Google Account...");
    } else if (state.type == AuthLinkType.linkApple) {
      outerLoadingDialog(text: "Linking Apple Account...");
    } else if (state.type == AuthLinkType.verifyLink) {
      outerLoadingDialog(text: "Verifying ${_pendingProvider} Linking...");
      setState(() {
        _pendingProvider = null;
        _pendingProviderEmail = null;
      });
    }
  }

  void _successAuthLinkState(BuildContext context, AuthLinkSuccessState state) {
    if (state.type == AuthLinkType.unlinkProvider) {
      Future.delayed((Duration(milliseconds: 500)), () {
        if (Get.isDialogOpen == true)
          Navigator.of(context, rootNavigator: true).pop();
        showMessage(
          '${_pendingProvider?.capitalize ?? ""} account unlinked successfully!',
          context,
          color: Colors.green,
          styleColor: Colors.white,
        );
        setState(() {
          _pendingProvider = null;
          _pendingProviderEmail = null;
        });
      });
    }
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  void _OAuthResponseStateState(
    BuildContext context,
    AuthLinkOAuthResponseState state,
  ) {
    if (state.type == AuthLinkType.linkGoogle ||
        state.type == AuthLinkType.linkApple) {
      Future.delayed((Duration(milliseconds: 500)), () async {
        if (Get.isDialogOpen == true)
          Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _pendingProvider = state.type == AuthLinkType.linkGoogle
              ? 'google'
              : 'apple';
        });
        if (state.response.requiresVerification) {
          setState(() {
            _pendingProviderEmail = state.response.providerEmail;
            _currentEmail = state.response.currentEmail;
            _emailsMatch = state.response.emailsMatch;
          });
          String verify =
              await verifySocialAccountModal(
                provider: _pendingProvider ?? "",
                providerEmail: _pendingProviderEmail ?? "",
                currentEmail: _currentEmail ?? "",
                emailMatch: _emailsMatch,
              ) ??
              "";
          if (verify.isNotEmpty) {
            _verifyLink(verify);
          } else {
            setState(() {
              _pendingProvider = null;
              _pendingProviderEmail = null;
            });
            return;
          }
        } else {
          showMessage(
            '${_pendingProvider?.capitalize ?? ""} account linked successfully!',
            context,
            color: Colors.green,
            styleColor: Colors.white,
          );

          setState(() {
            _pendingProvider = null;
            _pendingProviderEmail = null;
          });

          context.read<ProfileBloc>().add(GetProfileEvent());
        }
      });
    }
  }

  void _verifyAuthLinkState(
    BuildContext context,
    AuthLinkVerifyResponseState state,
  ) {
    Future.delayed((Duration(milliseconds: 500)), () {
      if (Get.isDialogOpen == true)
        Navigator.of(context, rootNavigator: true).pop();
      showMessage(
        '${state.response.provider.capitalize ?? ""} account linked successfully!',
        context,
        color: Colors.green,
        styleColor: Colors.white,
      );
      context.read<ProfileBloc>().add(GetProfileEvent());
    });
  }

  void _failedAuthLinkState(BuildContext context, AuthLinkFailureState state) {
    Future.delayed((Duration(milliseconds: 500)), () {
      if (Get.isDialogOpen == true)
        Navigator.of(context, rootNavigator: true).pop();
      if (state.message.toLowerCase().contains("cancelled by")) {
      } else {
        showMessage(
          state.message,
          context,
          color: Colors.green,
          styleColor: Colors.white,
          status: true,
        );
      }
      if (state.type == AuthLinkType.unlinkProvider) {
        setState(() {
          _pendingProvider = null;
          _pendingProviderEmail = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocListener<AuthLinkBloc, AuthLinkState>(
      listener: (context, state) {
        if (state is AuthLinkLoadingState) {
          _loadingAuthLinkState(context, state);
        } else if (state is AuthLinkSuccessState) {
          _successAuthLinkState(context, state);
        } else if (state is AuthLinkFailureState) {
          _failedAuthLinkState(context, state);
        } else if (state is AuthLinkOAuthResponseState) {
          _OAuthResponseStateState(context, state);
        } else if (state is AuthLinkVerifyResponseState) {
          _verifyAuthLinkState(context, state);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          _userProfile = state.profile;

          final authProviders = _userProfile.authProviders;
          final providerEmails = _userProfile.providerEmails;
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
                            text: "Connected Accounts",
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
                          border: Border.all(
                            width: 1,
                            color: AppColors.black05,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),

                          icon: HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  OptionTile(
                    title: "Google",
                    subtitle: providerEmails.google,
                    isLinked: authProviders.google,
                    onTap: () {
                      context.read<AuthLinkBloc>().add(LinkGoogleEvent());
                    },
                    onUnlink: () => _unlinkProvider('google'),
                  ),
                  if (Platform.isIOS) ...[
                    SizedBox(height: 16.h),
                    OptionTile(
                      title: "Apple",
                      subtitle: providerEmails.apple,
                      isLinked: authProviders.apple,
                      onTap: () {
                        context.read<AuthLinkBloc>().add(LinkAppleEvent());
                      },
                      onUnlink: () => _unlinkProvider('apple'),
                    ),
                  ],
                  SizedBox(
                    height: 20.h + MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onUnlink,
    this.trailing,
    required this.isLinked,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onUnlink;
  final Widget? trailing;
  final bool isLinked;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () {
          if (!isLinked) {
            onTap!();
          }
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            spacing: 12.w,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  spacing: 8.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: title,
                        style: TextStyles.normalBold14(context),
                      ),
                    ),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: isLinked
                            ? (subtitle ?? 'Connected')
                            : 'Not Connected',
                        style: TextStyles.smallMedium12(
                          context,
                        ).copyWith(color: AppColors.grey550),
                      ),
                    ),
                  ],
                ),
              ),
              isLinked
                  ? RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Disconnect",
                        recognizer: TapGestureRecognizer()..onTap = onUnlink,
                        style: TextStyles.smallBold12(
                          context,
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                    )
                  : Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18.sp,
                      color: AppColors.grey500,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> _showConfirmationDialog({required String provider}) async {
  return Get.dialog<bool>(
    name: "unlink_account_confirmation_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    UnlinkAccountConfirmationDialog(provider: provider),
  );
}

class UnlinkAccountConfirmationDialog extends StatelessWidget {
  const UnlinkAccountConfirmationDialog({super.key, required this.provider});

  final String provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(color: AppColors.black.withValues(alpha: 0.2)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.white85,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15.h),
                    // Icon
                    Center(
                      child: Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          color: AppColors.redBrown11,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedCopyLink,
                            color: AppColors.redBrown50,
                            size: 24.r,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Title
                    RichText(
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Unlink Account?",
                        style: TextStyles.bigTitleBold24(
                          context,
                        ).copyWith(fontFamily: AppFonts.baloo2),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'Are you sure you want to unlink your $provider account? '
                            'You will no longer be able to sign in with this method.',
                        style: TextStyles.smallMedium12(context),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      spacing: 8.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: IconTextButton(
                            height: 48,
                            color: AppColors.grey300,
                            textColor: AppColors.black,
                            onPressed: () => Navigator.pop(context, false),
                            text: "Cancel",
                          ),
                        ),
                        Expanded(
                          child: IconTextButton(
                            height: 48,
                            color: AppColors.black,
                            textColor: AppColors.white,
                            onPressed: () => Navigator.pop(context, true),
                            text: "Confirm",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
