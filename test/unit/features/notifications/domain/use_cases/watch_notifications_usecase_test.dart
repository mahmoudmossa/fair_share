import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fair_share/features/notifications/domain/usecases/watch_notifications_usecase.dart';
import 'package:fair_share/features/notifications/domain/entities/notification_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  late MockNotificationsRepository mockRepo;
  late WatchNotificationsUseCase useCase;

  setUp(() {
    mockRepo = MockNotificationsRepository();
    useCase = WatchNotificationsUseCase(mockRepo);
  });

  group('WatchNotificationsUseCase', () {
    const tUserId = 'user_123';
    final tNotifications = [
      NotificationsEntity(
        id: 'notif_1',
        title: 'New expense',
        body: 'Mahmoud added a new expense',
        type: NotificationType.expenseAdded,
        isRead: false,
      ),
    ];

    test('should return a stream from the repository', () {
      // Arrange
      when(
        () => mockRepo.watchNotifications(tUserId),
      ).thenAnswer((_) => Stream.value(tNotifications));

      // Act
      final result = useCase(tUserId);

      // Assert
      expect(result, isA<Stream<List<NotificationsEntity>>>());
      verify(() => mockRepo.watchNotifications(tUserId)).called(1);
    });

    test('should emit the list of notifications from the stream', () async {
      // Arrange
      when(
        () => mockRepo.watchNotifications(tUserId),
      ).thenAnswer((_) => Stream.value(tNotifications));

      // Act & Assert
      await expectLater(useCase(tUserId), emits(tNotifications));
    });

    test('should emit empty list when repository emits empty list', () async {
      // Arrange
      when(
        () => mockRepo.watchNotifications(tUserId),
      ).thenAnswer((_) => Stream.value([]));

      // Act & Assert
      await expectLater(useCase(tUserId), emits([]));
    });
  });
}
