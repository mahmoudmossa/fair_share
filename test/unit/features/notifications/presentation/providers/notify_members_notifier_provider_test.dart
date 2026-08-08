import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/domain/entities/notification_type.dart';
import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fair_share/features/notifications/presentation/providers/notifications_repository_provider.dart';
import 'package:fair_share/features/notifications/presentation/providers/notify_members_notifier_provider.dart';
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

  group('NotifyMembersNotifierProvider', () {
    const tUserIds = ['user_1', 'user_2'];
    const tNotification = NotificationsEntity(
      id: 'notif_1',
      title: 'New expense',
      body: 'Mahmoud added a new expense',
      type: NotificationType.expenseAdded,
      isRead: false,
    );

    test('initial state is ActionInitial', () {
      // Arrange
      final container = makeContainer();

      // Act
      final state = container.read(notifyMembersProvider);

      // Assert
      expect(state, isA<ActionInitial>());
    });

    test('state is ActionSuccess after successful notify', () async {
      // Arrange
      when(
        () => mockRepo.notifyFlatMembers(
          userIds: tUserIds,
          notification: tNotification,
        ),
      ).thenAnswer((_) async {});
      final container = makeContainer();
      final notifier =
          container.read(notifyMembersProvider.notifier);

      // Act
      await notifier.notify(tUserIds, tNotification);

      // Assert
      expect(
        container.read(notifyMembersProvider),
        isA<ActionSuccess<void>>(),
      );
      verify(
        () => mockRepo.notifyFlatMembers(
          userIds: tUserIds,
          notification: tNotification,
        ),
      ).called(1);
    });

    test('state is ActionError when repository throws', () async {
      // Arrange
      when(
        () => mockRepo.notifyFlatMembers(
          userIds: tUserIds,
          notification: tNotification,
        ),
      ).thenThrow(Exception('Network error'));
      final container = makeContainer();
      final notifier =
          container.read(notifyMembersProvider.notifier);

      // Act
      await notifier.notify(tUserIds, tNotification);

      // Assert
      expect(
        container.read(notifyMembersProvider),
        isA<ActionError>(),
      );
    });
  });
}
