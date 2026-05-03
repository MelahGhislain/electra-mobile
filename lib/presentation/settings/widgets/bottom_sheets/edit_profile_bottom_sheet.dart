import 'package:electra/common/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/text_fields/text_field.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/user/user.dart';
import 'package:electra/presentation/user/bloc/user_cubit.dart';
import 'package:electra/presentation/user/bloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileBottomSheet {
  static Future<bool> show(BuildContext context, User user) async {
    final result = await AppBottomSheet.show<bool>(
      context,
      title: 'Edit Profile',
      icon: Icons.person_outline_rounded,
      maxHeightPct: 0.80,
      child: BlocProvider.value(
        value: context.read<UserCubit>(),
        child: _EditProfileBody(user: user),
      ),
    );
    return result ?? false;
  }
}

class _EditProfileBody extends StatefulWidget {
  final User user;
  const _EditProfileBody({required this.user});

  @override
  State<_EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<_EditProfileBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _emailCtrl = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<UserCubit>().updateUser(widget.user.id, {
      'name': _nameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
    });
    if (context.mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name field
              AppTextField(
                label: 'Full Name',
                hint: 'Enter your name',
                controller: _nameCtrl,
                keyboardType: TextInputType.name,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Name cannot be empty';
                  }
                  if (v.trim().length < 2) return 'Name is too short';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email — editable
              AppTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email cannot be empty';
                  }
                  if (!RegExp(
                    r'^[\w-.]+@([\w-]+\.)+[\w]{2,}$',
                  ).hasMatch(v.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Save button
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  final isSaving = state is UserSaving;
                  return MainButton(
                    text: 'Save Changes',
                    width: double.infinity,
                    isLoading: isSaving,
                    onPressed: isSaving ? () {} : () => _save(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
