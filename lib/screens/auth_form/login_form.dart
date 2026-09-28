import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripo/blocs/auth/auth_bloc.dart';
import 'package:tripo/core/validators.dart';
import 'package:tripo/screens/auth_form/forgot_password.dart';
import 'package:tripo/theme/app_colors.dart';
import 'package:tripo/widgets/app_text_field.dart';
import 'package:tripo/widgets/primary_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordFocus.addListener(() => setState(() {}));
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      LoginSubmitted(email: _email.text.trim(), password: _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (p, c) => p.emailError != c.emailError,
              builder: (context, state) => AppTextField(
                label: 'Email',
                hint: 'you@example.com',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                errorText: state.emailError,
                onChanged: (_) {
                  if (state.emailError != null) {
                    context.read<AuthBloc>().add(AuthErrorsCleared());
                  }
                },
                validator: Validators.compose([
                  Validators.required('Email is required'),
                  Validators.email(),
                ]),
              ),
            ),
            const SizedBox(height: 20),

            // Password: local validation only
            BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (p, c) => p.passwordError != c.passwordError,
              builder: (context, state) => AppTextField(
                label: 'Password',
                controller: _password,
                focusNode: _passwordFocus,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                errorText: state.passwordError,
                onChanged: (_) {
                  if (state.passwordError != null) {
                    context.read<AuthBloc>().add(AuthErrorsCleared());
                  }
                },
                validator: Validators.compose([
                  Validators.required('Password is required'),
                  Validators.password(),
                ]),
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ForgotPassword(initialEmail: _email.text.trim()),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  "Forgot Password",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (p, c) => p.isLoading != c.isLoading,
              builder: (context, state) => PrimaryButton(
                label: 'Log In',
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
