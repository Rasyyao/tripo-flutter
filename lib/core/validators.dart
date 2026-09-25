import 'package:flutter/material.dart';

typedef Validator = String? Function(String? value);

class PasswordRule {
  const PasswordRule(this.label, this.isMet);
  final String label;
  final bool Function(String value) isMet;
}

final List<PasswordRule> passwordRules = [
  PasswordRule('At least 8 characters', (v) => v.length >= 8),
  PasswordRule('One uppercase letter', (v) => v.contains(RegExp(r'[A-Z]'))),
  PasswordRule('One number', (v) => v.contains(RegExp(r'[0-9]'))),
];

abstract final class Validators {
  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  static Validator required([String message = 'This field is required']) =>
      (v) => (v == null || v.trim().isEmpty) ? message : null;

  // Returns null on empty input so `required` owns that error.
  static Validator email([String message = 'Enter a valid email address']) =>
      (v) {
        final value = v?.trim() ?? '';
        if (value.isEmpty) return null;
        return _emailRegex.hasMatch(value) ? null : message;
      };

  static Validator minLength(int length, [String? message]) => (v) {
    final value = v ?? '';
    if (value.isEmpty) return null;
    return value.length >= length
        ? null
        : message ?? 'Must be at least $length characters';
  };

  static Validator password() => (v) {
    final value = v ?? '';
    if (value.isEmpty) return null;
    for (final rule in passwordRules) {
      if (!rule.isMet(value)) {
        return 'Password needs ${rule.label.toLowerCase()}';
      }
    }
    return null;
  };

  static Validator match(
    TextEditingController other, [
    String message = 'Passwords do not match',
  ]) =>
      (v) => v == other.text ? null : message;

  static Validator compose(List<Validator> validators) => (v) {
    for (final validate in validators) {
      final error = validate(v);
      if (error != null) return error;
    }
    return null;
  };
}
