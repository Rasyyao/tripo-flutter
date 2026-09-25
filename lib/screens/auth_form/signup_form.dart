import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripo/blocs/auth/auth_bloc.dart';
import 'package:tripo/core/validators.dart';
import 'package:tripo/widgets/app_text_field.dart';
import 'package:tripo/widgets/password_requirments.dart';
import 'package:tripo/widgets/primary_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
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
      SignUpSubmitted(email: _email.text.trim(), password: _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            // Email: listens to the BLoC for server error
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
            AppTextField(
              label: 'Password',
              controller: _password,
              focusNode: _passwordFocus,
              isPassword: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: Validators.compose([
                Validators.required('Password is required'),
                Validators.password(),
              ]),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _passwordFocus.hasFocus
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: PasswordRequirements(controller: _password),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Confirm password',
              controller: _confirm,
              isPassword: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              validator: Validators.compose([
                Validators.required('Please confirm your password'),
                Validators.match(_password),
              ]),
            ),
            const SizedBox(height: 28),

            // Submit button: listens to the BLoC for loading
            BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (p, c) => p.isLoading != c.isLoading,
              builder: (context, state) => PrimaryButton(
                label: 'Sign Up',
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
