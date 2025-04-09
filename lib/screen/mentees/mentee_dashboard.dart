import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/leaderboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MenteeHomePage extends StatefulWidget {
  const MenteeHomePage({super.key});

  @override
  State<MenteeHomePage> createState() => _MenteeHomePageState();
}

class _MenteeHomePageState extends State<MenteeHomePage> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    LeaderboardScreen(),
    Center(child: Text('Tasks Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Task Review Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: const <Widget>[
          Icon(Icons.leaderboard, size: 15),
          Icon(Icons.task, size: 15),
          Icon(Icons.reviews, size: 20),
          Icon(Icons.perm_identity, size: 15),
        ],
        color: AppColors.background,
        buttonBackgroundColor: AppColors.background,
        backgroundColor: AppColors.primary,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: AppColors.surface,
        child: _pages[_page],
      ),
    );
  }
}