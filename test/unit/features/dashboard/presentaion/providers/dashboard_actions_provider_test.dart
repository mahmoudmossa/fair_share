import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:fair_share/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_repository_provider.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_actions_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core/shared_core.dart';

class MockDashboardRepository extends Mock implements DashboardRepositoryImpl {}

void main() {
  late MockDashboardRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockDashboardRepository();
    container = ProviderContainer(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(mockRepository),
        authStateProvider.overrideWith(
          (ref) {
            final controller = StreamController<UserEntity?>.broadcast();
            ref.onDispose(controller.close);
            scheduleMicrotask(() {
              if (!controller.isClosed) {
                controller.add(
                  const UserEntity(
                    id: 'mahmoud',
                    email: 'mahmoud@example.com',
                    displayName: 'Medo',
                  ),
                );
              }
            });
            return controller.stream;
          },
        ),
      ],
    );
    container.listen(authStateProvider, (previous, next) {});
  });
  tearDown(() {
    container.dispose();
  });

  test('dashboardTest', () async {
    await container.read(authStateProvider.future);

    when(
      () => mockRepository.createFlat(any(), any(), any()),
    ).thenAnswer((_) async => right('flat_id_123'));

    final notifier = container.read(dashboardActionsProvider.notifier);
    await notifier.createFlat('My New Flat');
    final state = container.read(dashboardActionsProvider);
    expect(state, isA<ActionSuccess>());
    verify(() => mockRepository.createFlat('My New Flat', 'mahmoud', 'Medo')).called(1);
  });
}
