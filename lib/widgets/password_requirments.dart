import 'package:flutter/material.dart';
import 'package:tripo/core/validators.dart';
import 'package:tripo/theme/app_colors.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, value, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final rule in passwordRules)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(
                    rule.isMet(value.text)
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    size: 18,
                    color: rule.isMet(value.text)
                        ? const Color(0xFF2E9E5B)
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    rule.label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
