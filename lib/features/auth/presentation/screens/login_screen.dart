import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/router/app_router.dart';
import '../provider/auth_notifier_provider.dart';
import '../../domain/entities/user_entity.dart';

@RoutePage()
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // Listen to authentication provider states
    ref.listen(authProvider, (previous, next) {
      if (next is ActionSuccess<UserEntity?>) {
        if (next.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.login_auth_success.tr()),
              backgroundColor: colorScheme.primary,
            ),
          );
          AutoRouter.of(context).replace(const DashboardRoute());
        }
      } else if (next is ActionError<UserEntity?>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.login_auth_failed.tr(args: [next.error.toString()]),
            ),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: _LoginContent(),
          ),
        ),
      ),
    );
  }
}

class _LoginContent extends HookConsumerWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isLoginMode = useState(true);
    final state = ref.watch(authProvider);

    void handleSubmit() {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (isLoginMode.value) {
        if (email.isNotEmpty && password.isNotEmpty) {
          ref.read(authProvider.notifier).signIn(email, password);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.login_validation_empty.tr()),
            ),
          );
        }
      } else {
        final confirmPassword = confirmPasswordController.text;
        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.login_validation_empty.tr()),
            ),
          );
          return;
        }
        if (confirmPassword.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.login_confirm_password_empty.tr()),
            ),
          );
          return;
        }
        if (password != confirmPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.login_passwords_do_not_match.tr()),
            ),
          );
          return;
        }
        ref.read(authProvider.notifier).signUp(email, password);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _LogoSection(),
        const SizedBox(height: 48),
        _AuthForm(
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          isLoginMode: isLoginMode.value,
        ),
        const SizedBox(height: 24),
        _ActionButtons(
          isLoginMode: isLoginMode.value,
          isLoading: state is ActionLoading,
          onPrimaryPressed: handleSubmit,
          onToggleModePressed: () => isLoginMode.value = !isLoginMode.value,
        ),
      ],
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.balance,
              size: 40,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          LocaleKeys.login_title.tr(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.login_subtitle.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'Inter',
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AuthForm extends HookWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoginMode;

  const _AuthForm({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoginMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: AppKeys.auth.emailField,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontFamily: 'Inter'),
          decoration: InputDecoration(
            labelText: LocaleKeys.login_email_label.tr(),
            prefixIcon: const Icon(Icons.email_outlined),
            labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            floatingLabelStyle: TextStyle(color: colorScheme.primary),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: AppKeys.auth.passwordField,
          controller: passwordController,
          obscureText: obscurePassword.value,
          style: const TextStyle(fontFamily: 'Inter'),
          decoration: InputDecoration(
            labelText: LocaleKeys.login_password_label.tr(),
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => obscurePassword.value = !obscurePassword.value,
            ),
            labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            floatingLabelStyle: TextStyle(color: colorScheme.primary),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        if (!isLoginMode) ...[
          const SizedBox(height: 16),
          TextFormField(
            key: AppKeys.auth.confirmPasswordField,
            controller: confirmPasswordController,
            obscureText: obscureConfirmPassword.value,
            style: const TextStyle(fontFamily: 'Inter'),
            decoration: InputDecoration(
              labelText: LocaleKeys.login_confirm_password_label.tr(),
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirmPassword.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    obscureConfirmPassword.value = !obscureConfirmPassword.value,
              ),
              labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              floatingLabelStyle: TextStyle(color: colorScheme.primary),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isLoginMode;
  final bool isLoading;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onToggleModePressed;

  const _ActionButtons({
    required this.isLoginMode,
    required this.isLoading,
    required this.onPrimaryPressed,
    required this.onToggleModePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isLoginMode) ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                LocaleKeys.login_forgot_password.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        ElevatedButton(
          key: isLoginMode ? AppKeys.auth.signInButton : AppKeys.auth.signUpButton,
          onPressed: isLoading ? null : onPrimaryPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : Text(
                  isLoginMode
                      ? LocaleKeys.login_sign_in.tr()
                      : LocaleKeys.login_sign_up.tr(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Divider(color: colorScheme.outlineVariant),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                LocaleKeys.login_or.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: colorScheme.outlineVariant),
            ),
          ],
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          key: AppKeys.auth.toggleAuthModeButton,
          onPressed: onToggleModePressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            isLoginMode
                ? LocaleKeys.login_create_account.tr()
                : LocaleKeys.login_already_have_account.tr(),
            style: TextStyle(
              fontFamily: 'Inter',
              color: colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
