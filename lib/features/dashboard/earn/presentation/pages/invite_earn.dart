import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/core/constants/app_colors.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/referral_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/routes.dart';
import '../../../../onbaording/data/model/user_profile.dart';
import '../../../home/presentation/bloc/home_cubit.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import 'jackpot_page.dart';

String referralMessage(String code, [bool encode = false]) {
  if (encode) {
    return Uri.encodeComponent(
      'Join me on Bravoo 🚀\n'
      'Use my referral link:\n'
      'https://app.joinbravoo.com?ref=$code',
    );
  } else {
    return 'Join me on Bravoo 🚀\n'
        'Use my referral link:\n'
        'https://app.joinbravoo.com?ref=$code';
  }
}

class InviteAndEarnPage extends StatefulWidget {
  InviteAndEarnPage({super.key});

  @override
  State<InviteAndEarnPage> createState() => _InviteAndEarnPageState();
}

class _InviteAndEarnPageState extends State<InviteAndEarnPage> {
  Duration timeLeft = Duration(days: 00, hours: 24, minutes: 13, seconds: 13);

  UserProfile userProfile = UserProfile.empty();

  List<UserProfile> referrals = [];
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = context.read<ProfileBloc>();
    profileBloc.add(GetProfileEvent());
    userProfile = profileBloc.state.profile;
    BlocProvider.of<HomeCubit>(context).getUserReferrals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: FlowvaRoute.userCubit),
          BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              setState(() {
                referrals = state.referrals;
              });
            },
          ),
        ],
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Invite and Earn",
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF191919),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  children: [
                    Text(
                      "Invite your friends and win big on Bravoo",
                      style: GoogleFonts.manrope(
                        color: Color(0xFF767676),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// --- Invite Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            "Invites",
                            "${userProfile.referralCount}",
                            Icon(Icons.group, size: 18, color: Colors.black87),
                            Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// --- Invite Button
                    FlowvaButton.blueButton(
                      name: "Share with Friends",
                      icon: Icon(Icons.person_add_alt_1, color: Colors.white),
                      apply: () {
                        SharePlus.instance.share(
                          ShareParams(
                            text: referralMessage(
                              userProfile.referralCode ?? "",
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    /// --- Active Missions Section
                    Row(
                      children: [
                        _circleIcon(
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedUserGroup,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Active Referral Missions",
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// --- Mission Card
                    _buildMissionCard(),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // small description under title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _circleIcon(
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedUserList,
                                    size: 18,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Referral History",
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => ReferralHistoryPage(),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  "See more",
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191919),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Referral list
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: referrals.length <= 5
                              ? referrals.length
                              : 5,
                          itemBuilder: (context, index) {
                            final user = referrals[index];
                            return _buildReferralCard(
                              avatar: user.profilePic ?? "",
                              name: user.name ?? "",
                              statusLabel: "Joined",
                              statusColor: const Color(0xFFE3FAE1),
                              textColor: const Color(0xFF008753),
                              time: user.createdAt?.toIso8601String() ?? "",
                            );
                          },
                          separatorBuilder: (_, _) {
                            return SizedBox(height: 12.h);
                          },
                        ),

                        const SizedBox(height: 26),

                        // Tip / Anti Abuse box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 22,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF8FE),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFDCC6FF,
                                ).withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Tipping/Anti Abuse",
                                style: GoogleFonts.baloo2(
                                  color: const Color(0xFF957DAB),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Don’t spam. Earn honest invites. Abuse may freeze your rewards.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// --- Stat Card
  Widget _buildStatCard(String title, String value, Widget icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFEFEFEF),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: icon,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: Color(0xFFA5A5A5),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),

              Text(
                value,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// --- Mission Card
  Widget _buildMissionCard() {
    final days = timeLeft.inDays;
    final hours = timeLeft.inHours.remainder(24);
    final minutes = timeLeft.inMinutes.remainder(60);
    final seconds = timeLeft.inSeconds.remainder(60);
    return Container(
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/images/giveaway_bg.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/oraimo.png",
                      fit: BoxFit.cover,
                      height: 32,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Oraimo OpenSnap Giveaway',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 250,
                        child: Text(
                          'Enter to Win: Oraimo OpenSnap Airpods',
                          style: GoogleFonts.baloo2(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Color(0xFFDEC4FF),
                          child: Image.asset(
                            "assets/images/ear_pod.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // SvgPicture.asset("assets/images/ear_pod.svg",height: 40,),
                  ],
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  width: 320,
                  child: Text(
                    "Invite 2 friends to qualify. All qualifiers entered in the draw.",
                    style: GoogleFonts.baloo2(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _timeBox("03", "DAYS"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/images/_.svg',
                          color: Colors.white,
                        ),
                      ),
                      _timeBox("24", "HRS"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/images/_.svg',
                          color: Colors.white,
                        ),
                      ),
                      _timeBox("00", "MIN"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/images/_.svg',
                          color: Colors.white,
                        ),
                      ),
                      _timeBox("00", "SEC"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => JackpotScreen()),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: 320,

                    child: Center(
                      child: Text(
                        'Join the draw',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2B2B2B),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                FlowvaButton.transparentButton(name: "Mission Details"),
                const SizedBox(height: 4),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset("assets/avatar/1.png", height: 24),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset("assets/avatar/2.png", height: 24),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset("assets/avatar/3.png", height: 24),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset("assets/avatar/4.png", height: 24),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset("assets/avatar/4.png", height: 24),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.group, color: Colors.white, size: 15),
                            Text(
                              '+12',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Qualify by inviting 2 friends who sign up via your link.',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.56),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// --- Helper Widgets
  Widget _timeBox(String value, String label) {
    return Container(
      width: 55,
      height: 55,
      padding: EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.baloo2(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 10,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget timeColon() {
    return Text(
      ":",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // referral list item (rounded card)
  Widget _buildReferralCard({
    required String avatar,
    required String name,
    required String statusLabel,
    Color statusColor = Colors.grey,
    Color textColor = Colors.black87,
    required String time,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundImage: NetworkImage(avatar),
            backgroundColor: AppColors.grey300.withValues(alpha: .5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                // status chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    statusLabel,
                    style: GoogleFonts.manrope(
                      color: textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // right side small circle icon and time
          Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 16, color: Colors.purple),
              ),
              RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  text: formatSmartDate(time),
                  style: TextStyles.cardSemibold10(context, opacity: .65),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(Widget child) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Color(0xFFF1F1F1),
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );
  }

  // Template card replicating your design
  Widget _buildTemplateCard({required Widget text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text,

          const SizedBox(height: 12),
          Row(
            children: [
              _actionButton(
                icon: HugeIcon(icon: HugeIcons.strokeRoundedCopy01, size: 18),
                label: "Copy",
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _actionButton(
                icon: HugeIcon(icon: HugeIcons.strokeRoundedShare03, size: 18),
                label: "Share",
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,

      label: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          icon,
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _Mission {
  final String id;
  final String title;
  String rightIcon;
  final String points;
  final String subject;
  final int progress;
  final bool completed;

  _Mission({
    required this.id,
    required this.title,
    required this.rightIcon,
    required this.points,
    required this.subject,
    required this.progress,
    required this.completed,
  });

  Widget get icon {
    switch (id) {
      case 'watch':
        return Image.asset("assets/images/play.png", height: 28);
      case 'download':
        return Image.asset("assets/images/qr.png", height: 28);
      case 'stars':
        return Image.asset("assets/images/thumb_stars.png", height: 28);
      default:
        return Container();
    }
  }

  _Mission copyWith({bool? completed}) {
    return _Mission(
      id: id,
      title: title,
      rightIcon: rightIcon,
      points: points,
      subject: subject,
      progress: progress,
      completed: completed ?? this.completed,
    );
  }
}

String _progressTextFromValue(double progress) {
  // simple mapping for demo: 0 -> 0/1, 1/3 -> 1/3, etc.
  if (progress == 0.0) return '0/1';
  if ((progress - 1 / 3).abs() < 0.01) return '1/3';
  // fallback
  return '${(progress * 1).round()}/${1}';
}

class MissionTile extends StatelessWidget {
  final _Mission mission;
  final VoidCallback onClaim;

  const MissionTile({required this.mission, required this.onClaim, super.key});

  @override
  Widget build(BuildContext context) {
    print(mission.id);
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 2, right: 2, bottom: 2),
      decoration: BoxDecoration(
        color: mission.completed ? Color(0xFFF6FDF5) : Color(0xFFF6FDF5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          mission.icon,
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    mission.title!,
                    style: GoogleFonts.baloo2(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: mission.id == "rate"
                          ? Colors.black.withOpacity(0.24)
                          : Colors.black.withOpacity(0.50),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                mission.completed
                    ? Image.asset("assets/images/mark.png")
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  // Background color (track)
                                  Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF1F1F1),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          const Color(0xFFD9AEFF),
                                          const Color(0xFF550AA9),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Gradient progress bar
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        height: 16,
                                        width:
                                            constraints.maxWidth *
                                            mission.progress!,
                                        // width proportional to value
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF1F1F1),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color(0xFFD9AEFF),
                                              const Color(0xFF550AA9),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 50,
                              right: 50,
                              top: -1,

                              child: Center(
                                child: Text(
                                  progressTextFromValue(mission.progress!),
                                  style: GoogleFonts.baloo2(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withOpacity(0.42),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                // const SizedBox(height: 4),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: EdgeInsets.only(top: 8, right: 8, left: 8),
            // height: 80,
            width: 88,
            decoration: BoxDecoration(
              color: mission.completed
                  ? Color(0xFFF1F1F1)
                  : Color(0xFF9013FE).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mission.id.isNotEmpty
                        ? Image.asset(mission.rightIcon, height: 22)
                        : Image.network(mission.rightIcon, height: 22),
                    SizedBox(width: 5),
                    Text(
                      "${mission.points}",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.34),
                      ),
                    ),
                  ],
                ),

                // SizedBox(height: 5),
                // const SizedBox(height: 10),
                FlowvaButton.purpleButton(
                  color: mission.completed! ? Colors.grey : null,
                  name: "${mission.subject}",
                  apply: onClaim,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String progressTextFromValue(int progress) {
  // simple mapping for demo: 0 -> 0/1, 1/3 -> 1/3, etc.
  if (progress == 1) return '0/1';
  if ((progress - 1 / 3).abs() < 0.01) return '1/3';
  // fallback
  return '${(progress * 1).round()}/${1}';
}
