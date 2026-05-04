import 'package:compasscare_flutter/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:compasscare_flutter/features/auth/presentation/pages/auth_page.dart';
import 'package:compasscare_flutter/features/shell/presentation/pages/app_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.unknown) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == AuthStatus.authenticated) {
          return const AppShellPage();
        }

        return const AuthPage();
      },
    );
  }
}
