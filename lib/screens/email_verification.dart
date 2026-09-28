import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripo/core/validators.dart';
import 'package:tripo/screens/login_page.dart';
import 'package:tripo/theme/app_colors.dart';
import 'package:tripo/widgets/app_text_field.dart';
import 'package:tripo/widgets/primary_button.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key, this.email});

  final String? email;

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  static const int _otpLength = 4;
  static const int _initialTimerSeconds = 59;

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();

  Timer? _timer;
  int _secondsRemaining = _initialTimerSeconds;
  bool _isLoading = false;
  bool _isPinMode = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _codeController.addListener(_onCodeChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  void _onCodeChanged() {
    if (!mounted) return;

    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    } else {
      setState(() {});
    }

    // Auto submit when 4 digits are completed in PIN mode
    if (_isPinMode &&
        _codeController.text.length == _otpLength &&
        !_isLoading) {
      _verifyCode();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (mounted) {
      setState(() => _secondsRemaining = _initialTimerSeconds);
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    if (_secondsRemaining > 0) return;

    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "A new verification code has been sent to ${widget.email ?? 'your email'}.",
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _verifyCode() async {
    FocusScope.of(context).unfocus();

    final code = _codeController.text.trim();
    if (code.length < _otpLength) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Please enter the complete $_otpLength-digit code';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    // Simulate verification API call
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isLoading = false);

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Email Verified!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your email has been verified successfully. You can now proceed to login.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: "Back to Login",
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPinBoxes() {
    final text = _codeController.text;

    return GestureDetector(
      onTap: () => _codeFocusNode.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Invisible text field handling user input, autofill, and keyboard
          Opacity(
            opacity: 0,
            child: SizedBox(
              height: 0,
              width: 0,
              child: TextField(
                controller: _codeController,
                focusNode: _codeFocusNode,
                keyboardType: TextInputType.number,
                maxLength: _otpLength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofillHints: const [AutofillHints.oneTimeCode],
                decoration: const InputDecoration(counterText: ''),
              ),
            ),
          ),

          // Responsive visual digit cells
          Row(
            children: List.generate(_otpLength, (index) {
              final isFilled = index < text.length;
              final isCurrent = index == text.length && _codeFocusNode.hasFocus;
              final hasError = _errorMessage != null;

              Color borderColor = const Color(0xFFEDEFF3);
              if (hasError) {
                borderColor = AppColors.error;
              } else if (isCurrent || isFilled) {
                borderColor = AppColors.primary;
              }

              return Expanded(
                child: Container(
                  height: 62,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 6,
                    right: index == _otpLength - 1 ? 0 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderColor,
                      width: (isCurrent || (isFilled && !hasError)) ? 1.5 : 1,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      isFilled ? text[index] : '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayEmail = (widget.email != null && widget.email!.isNotEmpty)
        ? widget.email!
        : 'your email address';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Navigation Bar / Back button
                  InkWell(
                    onTap: () => Navigator.of(context).maybePop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title & Subtitle
                  const Text(
                    "Verify Your Email",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text: "We have sent a verification code to \n",
                        ),
                        TextSpan(
                          text: displayEmail,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Text(
                      "Wrong email? Change",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Mode Toggle Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Enter Code",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isPinMode = !_isPinMode),
                        child: Text(
                          _isPinMode ? "Use Text Field" : "Use PIN Boxes",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Code input section: PIN Boxes or AppTextField
                  if (_isPinMode) ...[
                    _buildPinBoxes(),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ] else ...[
                    Form(
                      key: _formKey,
                      child: AppTextField(
                        label: 'Verification Code',
                        hint: 'Enter 4-digit code',
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        errorText: _errorMessage,
                        prefixIcon: const Icon(
                          Icons.pin_outlined,
                          color: AppColors.textSecondary,
                        ),
                        validator: Validators.compose([
                          Validators.required('Verification code is required'),
                          Validators.minLength(
                            _otpLength,
                            'Must be at least $_otpLength digits',
                          ),
                        ]),
                        onSubmitted: (_) => _verifyCode(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Resend Code Timer
                  Center(
                    child: _secondsRemaining > 0
                        ? Text(
                            "Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: _resendCode,
                                child: const Text(
                                  "Resend Code",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 28),

                  // Primary Button (from existing widgets)
                  PrimaryButton(
                    label: "Verify Email",
                    isLoading: _isLoading,
                    onPressed: _verifyCode,
                  ),
                  const SizedBox(height: 32),

                  // Footer back to login
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Back to Log In",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
