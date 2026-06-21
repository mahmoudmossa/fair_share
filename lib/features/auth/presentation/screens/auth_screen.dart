import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import '../provider/auth_notifier_provider.dart';

class AuthScreen extends ConsumerWidget {
  static const String routeName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: state.when(
          initial: () => const Text('Initial State'),
          loading: () => const Text('Loading State'),
          success: (user) => const Text('Loaded State'),
          error: (error, stackTrace) => const Text('Error State'),
        ),
      ),
    );
  }
}
