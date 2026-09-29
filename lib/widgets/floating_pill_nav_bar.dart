import 'package:flutter/material.dart';
import 'package:tripo/theme/app_colors.dart';

enum NavBarTheme { dark, light, primary }

class FloatingPillNavBar extends StatelessWidget {
  const FloatingPillNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.theme = NavBarTheme.dark,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final NavBarTheme theme;

  Color get _navBarBgColor {
    switch (theme) {
      case NavBarTheme.dark:
        return const Color(0xFF181A20);
      case NavBarTheme.light:
        return Colors.white;
      case NavBarTheme.primary:
        return AppColors.primary;
    }
  }

  Color get _unselectedItemColor {
    switch (theme) {
      case NavBarTheme.dark:
        return Colors.white.withOpacity(0.5);
      case NavBarTheme.light:
        return AppColors.textSecondary;
      case NavBarTheme.primary:
        return Colors.white.withOpacity(0.65);
    }
  }

  Color get _selectedItemColor {
    switch (theme) {
      case NavBarTheme.dark:
        return Colors.white;
      case NavBarTheme.light:
        return AppColors.primary;
      case NavBarTheme.primary:
        return Colors.white;
    }
  }

  Color get _selectedPillBgColor {
    switch (theme) {
      case NavBarTheme.dark:
        return Colors.white.withOpacity(0.16);
      case NavBarTheme.light:
        return AppColors.primary.withOpacity(0.12);
      case NavBarTheme.primary:
        return Colors.white.withOpacity(0.22);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: bottomPadding > 0 ? bottomPadding + 6 : 18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: _navBarBgColor,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: theme == NavBarTheme.light
                    ? AppColors.border
                    : Colors.white.withOpacity(0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tab 0: Home
                _PillNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                  selectedColor: _selectedItemColor,
                  unselectedColor: _unselectedItemColor,
                  pillBgColor: _selectedPillBgColor,
                ),

                // Tab 1: My Itinerary & logs
                _PillNavItem(
                  icon: Icons.receipt_long_rounded,
                  label: 'Itinerary',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                  selectedColor: _selectedItemColor,
                  unselectedColor: _unselectedItemColor,
                  pillBgColor: _selectedPillBgColor,
                ),

                // Tab 2: Middle AI Itinerary Planner Button
                _CenterAiNavButton(
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),

                // Tab 3: Forum / Community
                _PillNavItem(
                  icon: Icons.forum_rounded,
                  label: 'Forum',
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                  selectedColor: _selectedItemColor,
                  unselectedColor: _unselectedItemColor,
                  pillBgColor: _selectedPillBgColor,
                ),

                // Tab 4: Profile
                _PillNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: currentIndex == 4,
                  onTap: () => onTap(4),
                  selectedColor: _selectedItemColor,
                  unselectedColor: _unselectedItemColor,
                  pillBgColor: _selectedPillBgColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillNavItem extends StatelessWidget {
  const _PillNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.pillBgColor,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Color pillBgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? pillBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: isSelected ? 1.08 : 1.0),
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutBack,
              builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
              child: Icon(
                icon,
                color: isSelected ? selectedColor : unselectedColor,
                size: 22,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment.centerLeft,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: isSelected ? 1.0 : 0.0,
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: selectedColor,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterAiNavButton extends StatefulWidget {
  const _CenterAiNavButton({
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_CenterAiNavButton> createState() => _CenterAiNavButtonState();
}

class _CenterAiNavButtonState extends State<_CenterAiNavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulse = 1.0 + (_pulseController.value * 0.06);

          return Transform.scale(
            scale: widget.isSelected ? pulse : 1.0,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryLight,
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: widget.isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.35),
                  width: widget.isSelected ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(
                      widget.isSelected ? 0.6 : 0.35,
                    ),
                    blurRadius: widget.isSelected ? 16 : 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: widget.isSelected ? 26 : 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
