import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/buttons/main_text_button.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Sign In',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Access to 240+ hours of content. Learn design and code, by building real apps with Flutter and Swift.',
            style: TextStyle(
              fontSize: AppFontSize.sm,
              color: AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 32),

          // Email Field
          _buildTextField(
            label: 'Email',
            icon: Icons.email_outlined,
            hint: 'test@gmail.com',
            controller: _emailController,
          ),

          const SizedBox(height: 20),

          // Password Field with Eye Icon
          _buildTextField(
            label: 'Password',
            icon: Icons.lock_outline,
            hint: '••••••••',
            controller: _passwordController,
            isObscure: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.lightTextSecondary,
              ),
              onPressed: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
            ),
          ),

          const SizedBox(height: 20),

          // Sign In Button
          MainButton(text: 'Sign In', width: double.infinity, onPressed: () {}),

          const SizedBox(height: 16),

          // Don't have account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(color: Colors.grey[600]),
              ),
              MainTextButton(
                text: "Sign Up",
                color: AppColors.primary,
                fontSize: AppFontSize.sm,
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // OR Divider
          Row(
            children: [
              Expanded(child: Divider()),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('OR', style: TextStyle(color: Colors.grey)),
              ),
              Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 24),

          // Social Logins
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialButton(Icons.email, Colors.black, () {}),
              const SizedBox(width: 16),
              _socialButton(Icons.apple, Colors.black, () {}),
              const SizedBox(width: 16),
              _socialButton(Icons.g_mobiledata, const Color(0xFFEA4335), () {}),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool isObscure = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSize.sm,
            fontWeight: FontWeight.w500,
            color: AppColors.lightText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.dividerLight),
          ),
          child: TextField(
            controller: controller,
            obscureText: isObscure,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]), // Greyer hint
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}
