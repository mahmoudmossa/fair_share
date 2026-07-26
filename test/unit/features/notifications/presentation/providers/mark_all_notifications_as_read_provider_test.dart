import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fair_share/features/notifications/presentation/providers/mark_all_notifications_as_read_provider.dart';
import 'package:fair_share/features/notifications/presentation/providers/notifications_repository_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core/shared_core.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  late MockNotificationsRepository mockRepo;

  setUp(() {
    mockRepo = MockNotificationsRepository();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        notificationsRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('MarkAllNotificationsAsReadProvider', () {
    const tUserId = 'user_123';

    test('initial state is ActionInitial', () {
      // Arrange
      final container = makeContainer();

      // Act
      final state = container.read(markAllNotificationsAsReadProvider);

      // Assert
      expect(state, isA<ActionInitial>());
    });

    test('state is ActionSuccess after successful markAllAsRead', () async {
      // Arrange
      when(
        () => mockRepo.markAllAsRead(tUserId),
      ).thenAnswer((_) async {});
      final container = makeContainer();
      final notifier =
          container.read(markAllNotificationsAsReadProvider.notifier);

      // Act
      await notifier.markAllAsRead(userId: tUserId);

      // Assert
      expect(
        container.read(markAllNotificationsAsReadProvider),
        isA<ActionSuccess<void>>(),
      );
      verify(() => mockRepo.markAllAsRead(tUserId)).called(1);
    });

    test('state is ActionError when repository throws', () async {
      // Arrange
      when(
        () => mockRepo.markAllAsRead(tUserId),
      ).thenThrow(Exception('Network error'));
      final container = makeContainer();
      final notifier =
          container.read(markAllNotificationsAsReadProvider.notifier);

      // Act
      await notifier.markAllAsRead(userId: tUserId);

      // Assert
      expect(
        container.read(markAllNotificationsAsReadProvider),
        isA<ActionError>(),
      );
    });
  });
}
