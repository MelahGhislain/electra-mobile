import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// After any successful auth → mark session → go to Home.
/// Home is the single source of truth for post-login routing.
void handlePostAuthNavigation(BuildContext context) {
  context.read<AppAuthCubit>().onLoginSuccess();
  context.goNamed(RouteNames.home);
}
