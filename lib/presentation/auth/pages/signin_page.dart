import 'package:qleo/common/widgets/buttons/main_button.dart';
import 'package:qleo/common/widgets/text_fields/text_field.dart';
import 'package:qleo/core/configs/fonts.dart';
import 'package:qleo/core/router/route_names.dart';
import 'package:qleo/core/utils/auth/auth_navigation.dart';
import 'package:qleo/l10n/app_localizations.dart';
import 'package:qleo/presentation/auth/bloc/auth_cubit.dart';
import 'package:qleo/presentation/auth/bloc/auth_state.dart';
import 'package:qleo/presentation/auth/widgets/auth_divider.dart';
import 'package:qleo/presentation/auth/widgets/auth_scaffold.dart';
import 'package:qleo/presentation/auth/widgets/auth_social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) handlePostAuthNavigation(context);
          if (state is AuthCancelled) context.read<AuthCubit>().reset();
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          final isEmailLoading = state is AuthEmailLoading;
          final isGoogleLoading = state is AuthGoogleLoading;
          final isAnyLoading = isEmailLoading || isGoogleLoading;

          return AuthScaffold(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // ── Logo + brand ────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Qleo',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Spend with clarity',
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── Heading ────────────────────────────────────
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: AppFontSize.xxxl,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),

                  // const SizedBox(height: 6),

                  // Text(
                  //   'Continue to Qleo.',
                  //   style: TextStyle(fontSize: AppFontSize.sm),
                  // ),
                  const SizedBox(height: 32),

                  // ── Fields ─────────────────────────────────────
                  AppTextField(
                    label: l.emailAddress,
                    hint: l.enterYourEmail,
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return l.emailIsRequired;
                      }

                      if (!RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w]{2,}$',
                      ).hasMatch(v)) {
                        return l.enterValidEmail;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: l.password,
                    hint: l.enterYourPassword,
                    controller: _passwordCtrl,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return l.passwordIsRequired;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  MainButton(
                    text: l.signIn,
                    isLoading: isEmailLoading,
                    disabled: isAnyLoading,
                    size: ButtonSize.small,
                    width: double.infinity,
                    onPressed: () => _submit(context),
                  ),

                  const SizedBox(height: 28),

                  AuthDivider(label: l.orSignWith),

                  const SizedBox(height: 20),

                  AuthGoogleButton(
                    label: l.continueWithGoogle,
                    isLoading: isGoogleLoading,
                    disabled: isAnyLoading,
                    onPressed: () {
                      context.read<AuthCubit>().signInWithGoogle();
                    },
                  ),

                  const SizedBox(height: 32),

                  // ── Sign up link ───────────────────────────────
                  Center(
                    child: GestureDetector(
                      onTap: isAnyLoading
                          ? null
                          : () => context.pushNamed(RouteNames.signUp),
                      child: RichText(
                        text: TextSpan(
                          text: l.dontHaveAnAccount,
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          children: [
                            TextSpan(
                              text: ' ${l.signUp}',
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
