import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/text_fields/text_field.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/core/utils/auth/auth_navigation.dart';
import 'package:electra/presentation/auth/bloc/auth_cubit.dart';
import 'package:electra/presentation/auth/bloc/auth_state.dart';
import 'package:electra/presentation/auth/widgets/auth_divider.dart';
import 'package:electra/presentation/auth/widgets/auth_social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                backgroundColor: Colors.red.shade600,
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

          return SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // balance the back button
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          AppTextField(
                            label: 'Full Name',
                            hint: 'john smith',
                            controller: _nameController,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Name is required'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          AppTextField(
                            label: 'Email Address',
                            hint: 'johnsmith@mail.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(
                                r'^[\w-.]+@([\w-]+\.)+[\w]{2,}$',
                              ).hasMatch(v)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          AppTextField(
                            label: 'Password',
                            hint: '••••••••••',
                            controller: _passwordController,
                            isPassword: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              if (v.length < 8) return 'Minimum 8 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          AppTextField(
                            label: 'Re-Enter Password',
                            hint: '••••••••••',
                            controller: _confirmPasswordController,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            validator: (v) {
                              if (v != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),

                          const AuthDivider(),
                          const SizedBox(height: 16),

                          // AuthSocialButton(
                          //   label: 'Continue With Apple',
                          //   icon: const Icon(Icons.apple, size: 22),
                          //   isLoading: isLoading,
                          //   onPressed: () =>
                          //       context.read<AuthCubit>().signInWithApple(),
                          // ),
                          // const SizedBox(height: 12),
                          AuthSocialButton(
                            label: 'Continue With Google',
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
                                context.goNamed(RouteNames.signIn);
                              },
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Do you have an account? ',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Sign in',
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
                          const SizedBox(height: 20),

                          MainButton(
                            text: 'Sign Up',
                            isLoading: isLoading,
                            size: ButtonSize.small,
                            width: double.infinity,
                            onPressed: () => _submit(context),
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
            ),
          );
        },
      ),
    );
  }
}
