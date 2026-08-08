import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fair_share/features/notifications/domain/usecases/notify_flat_members.dart';
import 'package:fair_share/features/notifications/domain/entities/notification_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  late MockNotificationsRepository mockRepo;
  late NotifyFlatMembersUseCase useCase;

  setUp(() {
    mockRepo = MockNotificationsRepository();
    useCase = NotifyFlatMembersUseCase(mockRepo);
  });

  group('NotifyFlatMembersUseCase', () {
    const tUserIds = ['user_1', 'user_2'];
    const tNotification = NotificationsEntity(
      id: '1',
      title: 'Title',
      body: 'Body',
      type: NotificationType.settle,
      isRead: false,
    );

    test('should call repository.notifyFlatMembers with correct params',
        () async {
      // Arrange
      when(
        () => mockRepo.notifyFlatMembers(
          userIds: tUserIds,
          notification: tNotification,
        ),
      ).thenAnswer((_) async {});

      // Act
      await useCase(userIds: tUserIds, notification: tNotification);

      // Assert
      verify(
        () => mockRepo.notifyFlatMembers(
          userIds: tUserIds,
          notification: tNotification,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should propagate exception thrown by repository', () async {
      // Arrange
      when(
        () => mockRepo.notifyFlatMembers(
          userIds: tUserIds,
          notification: tNotification,
        ),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase(userIds: tUserIds, notification: tNotification),
        throwsA(isA<Exception>()),
      );
    });
  });
}
