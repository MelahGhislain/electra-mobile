import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/text_fields/text_field.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/core/utils/auth/auth_navigation.dart';
import 'package:electra/l10n/app_localizations.dart';
import 'package:electra/presentation/auth/bloc/auth_cubit.dart';
import 'package:electra/presentation/auth/bloc/auth_state.dart';
import 'package:electra/presentation/auth/widgets/auth_divider.dart';
import 'package:electra/presentation/auth/widgets/auth_social_button.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            handlePostAuthNavigation(context); // sync, no async needed
          }
          if (state is AuthCancelled) {
            context.read<AuthCubit>().reset();
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Column(
            children: [
              // Decorative header blobs
              SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      left: -40,
                      child: _Blob(size: 220, color: const Color(0xFF60A5FA)),
                    ),
                    Positioned(
                      top: 10,
                      right: 20,
                      child: _Blob(size: 70, color: const Color(0xFFFBBF24)),
                    ),
                    Positioned(
                      top: 50,
                      right: 0,
                      child: _Blob(size: 80, color: const Color(0xFF34D399)),
                    ),
                    Positioned(
                      top: 110,
                      right: 50,
                      child: _Blob(size: 90, color: const Color(0xFFF87171)),
                    ),
                  ],
                ),
              ),

              // Scrollable form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.letsSignYouIn,
                          style: TextStyle(
                            fontSize: AppFontSize.xxl,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.signInAndStartPlanning,
                          style: TextStyle(fontSize: AppFontSize.sm),
                        ),
                        const SizedBox(height: 28),

                        AppTextField(
                          label: l.emailAddress,
                          hint: l.enterYourMailAddress,
                          controller: _emailController,
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
                          controller: _passwordController,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return l.passwordIsRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        MainButton(
                          text: l.signIn,
                          isLoading: isLoading,
                          size: ButtonSize.small,
                          width: double.infinity,
                          onPressed: () => _submit(context),
                        ),

                        const SizedBox(height: 28),

                        AuthDivider(label: l.orSignWith),
                        const SizedBox(height: 16),

                        AuthSocialButton(
                          label: l.continueWithGoogle,
                          icon: const Icon(
                            Icons.g_mobiledata,
                            size: 26,
                            color: Color(0xFF4285F4),
                          ),
                          isLoading: isLoading,
                          onPressed: () =>
                              context.read<AuthCubit>().signInWithGoogle(),
                        ),
                        const SizedBox(height: 24),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(RouteNames.signUp);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: l.dontHaveAnAccount,
                                style: TextStyle(
                                  fontSize: AppFontSize.sm,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                                children: [
                                  TextSpan(
                                    text: l.signUp,
                                    style: TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Decorative blob widget ────────────────────────────────────────────────────

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
