import 'package:flowva/features/dashboard/earn/presentation/pages/earn_screen.dart';
import 'package:flowva/features/dashboard/home/home_page.dart';
import 'package:flowva/features/mission/presentation/page/mission_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../utility/permission_handler.dart';

class BottomNavBar extends StatefulWidget {
  int index;
  final int? missionIndex;
  // int i;
  BottomNavBar({this.index = 0, super.key, this.missionIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  int currentI = 0;
  @override
  void initState() {
    currentIndex = widget.index;
    // currentI=widget.i;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestNotificationPermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //,DiscoverScreen(),LibraryScreen(),
        body: IndexedStack(
          index: currentIndex,
          children: [
            FlowvaHomePage(),
            MissionPage(index: widget.missionIndex),
            RewardScreen(),
          ],
        ),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFA5A5A5).withOpacity(0.3), // Outline color
                width: 0.5, // Thickness
              ),
            ),
          ),

          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            currentIndex: currentIndex,
            selectedLabelStyle: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFFF2B2B2B),
            ),
            unselectedLabelStyle: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFFA5A5A5),
            ),
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: currentIndex == 0
                    ? Image.asset("assets/images/home.png")
                    : Image.asset("assets/images/Home_light.png"),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 1
                    ? Image.asset(
                        "assets/images/mission_solid.png",
                        color: Colors.black,
                      )
                    : Image.asset(
                        "assets/images/mission_light.png",
                        color: Colors.grey,
                      ),
                label: "Mission",
              ),
              BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedCoins01,
                  color: currentIndex == 2 ? Colors.black : Colors.grey,
                  size: 24.0,
                  strokeWidth: 2.5, // Custom stroke width
                ),
                label: "Redeem",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit this app'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop(true);
                }, // <-- SEE HERE
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
