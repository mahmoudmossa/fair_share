import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  final featureName = context.vars['feature_name'] as String;
  final withRouting = context.vars['with_routing'] as bool;

  logger.info('');
  logger.success('✅ Feature "$featureName" scaffolded successfully!');
  logger.info('');
  logger.info('📁 Generated files in lib/features/${_toSnakeCase(featureName)}/');
  logger.info('   domain/entities, domain/repositories');
  logger.info('   data/data_sources, data/repositories');
  logger.info('   presentation/providers, presentation/screens');
  logger.info('');

  if (withRouting) {
    logger.warn(
      '⚠️  Remember to register the route in lib/core/router/app_router.dart',
    );
    logger.info(
      '   See the TODO comment at the bottom of the generated screen file.',
    );
    logger.info('');
  }

  final progress = logger.progress('Running build_runner...');

  try {
    final result = await Process.run(
      'dart',
      ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      runInShell: true,
    );

    if (result.exitCode == 0) {
      progress.complete('build_runner completed ✅');
    } else {
      progress.fail('build_runner failed ❌');
      logger.err(result.stderr.toString());
      logger.warn(
        'Run manually: dart run build_runner build --delete-conflicting-outputs',
      );
    }
  } catch (e) {
    progress.fail('Could not run build_runner ❌');
    logger.warn('Run manually: dart run build_runner build --delete-conflicting-outputs');
  }
}

String _toSnakeCase(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (m) => '_${m.group(0)!.toLowerCase()}',
      )
      .replaceFirst(RegExp(r'^_'), '');
}
