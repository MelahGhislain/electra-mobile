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
                        const Text(
                          "Let's Sign you in",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in and start planning.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 28),

                        AppTextField(
                          label: 'Email Address',
                          hint: 'Enter your mail address',
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
                          hint: 'Enter your password',
                          controller: _passwordController,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),

                        const AuthDivider(),
                        const SizedBox(height: 16),

                        AuthSocialButton(
                          label: 'Continue With Apple',
                          icon: const Icon(Icons.apple, size: 22),
                          isLoading: isLoading,
                          onPressed: () =>
                              context.read<AuthCubit>().signInWithApple(),
                        ),
                        const SizedBox(height: 12),

                        AuthSocialButton(
                          label: 'Continue With Google',
                          icon: _GoogleIcon(),
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
                              text: const TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign up',
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
                          text: 'Sign In',
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

// ── Google "G" icon ───────────────────────────────────────────────────────────

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFFBBC05),
      const Color(0xFFEA4335),
    ];

    final sweeps = [90.0, 90.0, 90.0, 90.0];
    final starts = [-90.0, 0.0, 90.0, 180.0];

    for (int i = 0; i < 4; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.72),
        starts[i] * 3.14159 / 180,
        sweeps[i] * 3.14159 / 180,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
