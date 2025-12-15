import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class FocusTimerPage extends StatefulWidget {
  const FocusTimerPage({super.key});

  @override
  State<FocusTimerPage> createState() => _FocusTimerPageState();
}

class _FocusTimerPageState extends State<FocusTimerPage> {
  bool isPlaying = true;
  String currentSong = "Ambient Song 2";

  @override
  Widget build(BuildContext context) {
    // space reserved at bottom so list items aren't hidden by floating player
    const double bottomPlayerHeight = 86.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              // add bottom padding to avoid content being covered by the floating player
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          child: const Icon(Icons.keyboard_arrow_down_rounded, size: 28)),
                      Text(
                        "Focus Haven",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.music_note_outlined, size: 22),
                    ],
                  ),

                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 28),

                        // Timer Circle
                        Container(
                          width: 260,
                          height: 260,
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle,

                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFCE7E7), Color(0xFFE9E2FF)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: Colors.black.withOpacity(0.1),width: 0.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Edit button
                              Container(
                                width: 60,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedEdit03,
                                  strokeWidth: 2.5,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Time Text
                              Text(
                                "30:00",
                                style: GoogleFonts.manrope(
                                  fontSize: 64,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Start Focus Button
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/play.svg",
                                      height: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Start Focus",
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Music Section Title & meta
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Ambient",
                                    style: GoogleFonts.manrope(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Flowva’s Library • 12 tracks • 28 mins",
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: Color(0xFFA5A5A5),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                              ],
                            ),

                            SvgPicture.asset("assets/images/play_badge.svg")
                          ],
                        ),

                        // Download button
                        SizedBox(
                          height: 100,
                          child: Stack(
                            children: [
                              // Bottom bar
                              Positioned(
                                bottom: 40,
                                right: 0,
                                left: 0,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F8F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedArrowDown03,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Download for offline",
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Browse playlists button — just above bottom bar
                              Positioned(
                                bottom: 0, // 👈 move up slightly above the bottom bar
                                left: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.black.withOpacity(0.1),width: 0.5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Browse Playlists",
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Songs list (scrollable)
                        _songTile("Ambient Song 1", "6 mins"),
                        _songTile("Ambient Song 2", "6 mins", isPlaying: true),
                        _songTile("Ambient Song 3", "6 mins"),
                        _songTile("Ambient Song 4", "6 mins"),
                        _songTile("Ambient Song 5", "6 mins"),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 0,
            bottom: 20, // same base as the button so glow sits behind it
            child: IgnorePointer(
              child: Center(
                child: SizedBox(
                  width: 100,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Purple soft central glow
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7367F0).withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                      ),

                      // Red/pink subtle offset glow (left side)
                      Positioned(
                        left: 0,
                        right: 20,
                        child: Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF8A80,
                                ).withOpacity(0.5),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Floating player - positioned above bottom
          Positioned(left: 20, right: 20, bottom: 30, child: _floatingPlayer()),

        ],
      ),
    );
  }

  Widget _floatingPlayer() {
    return  GestureDetector(
      onTap: () {
        // optional: open full player or toggle
        setState(() => isPlaying = !isPlaying);
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // circular pause/play buttonColor(0xFFFCE7E7), Color(0xFFE9E2FF)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFCE7E7), Color(0xFFE9E2FF)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black.withOpacity(0.1),width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isPlaying ? Icons.pause  : Icons.play_circle_outline,
                    size: 20,
                  ),
                  onPressed: () => setState(() => isPlaying = !isPlaying),
                ),
              ),

              const SizedBox(width: 12),

              // Song title + small progress indicator
              Text(
                currentSong,
                style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 12),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.graphic_eq_rounded, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _songTile(String title, String duration, {bool isPlaying = false}) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: Icon(
        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outline,
        size: 25,
        color: isPlaying ? Colors.black : Color(0xFF767676),
      ),
      subtitle: Text(
        duration,
        style: GoogleFonts.manrope(fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF767676)),
      ),
      trailing:  const Icon(Icons.more_horiz, size: 18),
      dense: true,
      minTileHeight: 10,
      minVerticalPadding: 10,
      minLeadingWidth: 2,
      horizontalTitleGap: 10,
      contentPadding: EdgeInsets.zero,
    );

      Container(

      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isPlaying ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [

          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


            ],
          ),
Spacer(),

        ],
      ),
    );
  }
}
