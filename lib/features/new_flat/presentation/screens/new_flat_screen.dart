import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/new_flat_provider.dart';
import '../provider/new_flat_state.dart';

class New_flatScreen extends ConsumerWidget {
  static const String routeName = '/new_flat';
  const New_flatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newFlatProvider);

    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) {
            if (state is New_flatInitial) {
              return const Text('Initial State');
            } else if (state is New_flatLoading) {
              return const Text('Loading State');
            } else if (state is New_flatLoaded) {
              return const Text('Loaded State');
            }
            return const Text('Unknown State');
          },
        ),
      ),
    );
  }
}
