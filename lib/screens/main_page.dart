import 'package:flutter/material.dart';
import 'package:tripo/screens/main/ai_planner_tab.dart';
import 'package:tripo/screens/main/forum_tab.dart';
import 'package:tripo/screens/main/home_tab.dart';
import 'package:tripo/screens/main/itinerary_tab.dart';
import 'package:tripo/screens/main/profile_tab.dart';
import 'package:tripo/theme/app_colors.dart';
import 'package:tripo/widgets/floating_pill_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;
  late final PageController _pageController;
  NavBarTheme _navBarTheme = NavBarTheme.dark;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _toggleNavBarTheme() {
    setState(() {
      if (_navBarTheme == NavBarTheme.dark) {
        _navBarTheme = NavBarTheme.light;
      } else if (_navBarTheme == NavBarTheme.light) {
        _navBarTheme = NavBarTheme.primary;
      } else {
        _navBarTheme = NavBarTheme.dark;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: [
              HomeTab(onNavigateToAiPlanner: () => _onTabSelected(2)),
              const ItineraryTab(),
              const AiPlannerTab(),
              const ForumTab(),
              ProfileTab(
                currentTheme: _navBarTheme,
                onToggleTheme: _toggleNavBarTheme,
              ),
            ],
          ),

          // Floating Pill Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingPillNavBar(
              currentIndex: _currentIndex,
              onTap: _onTabSelected,
              theme: _navBarTheme,
            ),
          ),
        ],
      ),
    );
  }
}
