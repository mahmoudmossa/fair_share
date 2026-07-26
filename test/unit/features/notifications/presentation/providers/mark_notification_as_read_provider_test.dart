import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fair_share/features/notifications/presentation/providers/mark_notification_as_read_provider.dart';
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

  group('MarkNotificationAsReadProvider', () {
    const tUserId = 'user_123';
    const tNotificationId = 'notification_abc';

    test('initial state is ActionInitial', () {
      // Arrange
      final container = makeContainer();

      // Act
      final state =
          container.read(markNotificationAsReadProvider);

      // Assert
      expect(state, isA<ActionInitial>());
    });

    test('state is ActionSuccess after successful markAsRead', () async {
      // Arrange
      when(
        () => mockRepo.markAsRead(tUserId, tNotificationId),
      ).thenAnswer((_) async {});
      final container = makeContainer();
      final notifier =
          container.read(markNotificationAsReadProvider.notifier);

      // Act
      await notifier.markAsRead(
        userId: tUserId,
        notificationId: tNotificationId,
      );

      // Assert
      expect(
        container.read(markNotificationAsReadProvider),
        isA<ActionSuccess<void>>(),
      );
      verify(() => mockRepo.markAsRead(tUserId, tNotificationId)).called(1);
    });

    test('state is ActionError when repository throws', () async {
      // Arrange
      when(
        () => mockRepo.markAsRead(tUserId, tNotificationId),
      ).thenThrow(Exception('Network error'));
      final container = makeContainer();
      final notifier =
          container.read(markNotificationAsReadProvider.notifier);

      // Act
      await notifier.markAsRead(
        userId: tUserId,
        notificationId: tNotificationId,
      );

      // Assert
      expect(
        container.read(markNotificationAsReadProvider),
        isA<ActionError>(),
      );
    });
  });
}
