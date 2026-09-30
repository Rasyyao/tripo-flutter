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
        return const Color(0xFF1F2026);
      case NavBarTheme.light:
        return Colors.white;
      case NavBarTheme.primary:
        return AppColors.primary;
    }
  }

  Color get _unselectedItemColor {
    switch (theme) {
      case NavBarTheme.dark:
        return const Color(0xFF6B6D73);
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

  Color get _centerColor =>
      theme == NavBarTheme.primary ? Colors.white : AppColors.primary;

  Color get _centerIconColor =>
      theme == NavBarTheme.primary ? AppColors.primary : Colors.white;

  Color get _homeIndicatorColor {
    switch (theme) {
      case NavBarTheme.dark:
        return const Color(0xFF6B6D73);
      case NavBarTheme.light:
        return Colors.black.withOpacity(0.2);
      case NavBarTheme.primary:
        return Colors.white.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 12,
        left: 8,
        right: 8,
        bottom: bottomPadding > 0 ? bottomPadding : 10,
      ),
      decoration: BoxDecoration(
        color: _navBarBgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
                selectedColor: _selectedItemColor,
                unselectedColor: _unselectedItemColor,
              ),
              _NavItem(
                icon: Icons.receipt_long_outlined,
                selectedIcon: Icons.receipt_long_rounded,
                label: 'Itinerary',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
                selectedColor: _selectedItemColor,
                unselectedColor: _unselectedItemColor,
              ),
              Expanded(
                child: _CenterAiNavButton(
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                  color: _centerColor,
                  iconColor: _centerIconColor,
                ),
              ),
              _NavItem(
                icon: Icons.forum_outlined,
                selectedIcon: Icons.forum_rounded,
                label: 'Forum',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
                selectedColor: _selectedItemColor,
                unselectedColor: _unselectedItemColor,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: 'Profile',
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
                selectedColor: _selectedItemColor,
                unselectedColor: _unselectedItemColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isSelected ? selectedIcon : icon, color: color, size: 28),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterAiNavButton extends StatelessWidget {
  const _CenterAiNavButton({
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.iconColor,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedScale(
          scale: isSelected ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutBack,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isSelected ? 0.55 : 0.35),
                  blurRadius: isSelected ? 18 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.auto_awesome_rounded, color: iconColor, size: 28),
          ),
        ),
      ),
    );
  }
}
