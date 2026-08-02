import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fair_share/features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  late MockNotificationsRepository mockRepo;
  late MarkNotificationAsReadUseCase useCase;

  setUp(() {
    mockRepo = MockNotificationsRepository();
    useCase = MarkNotificationAsReadUseCase(mockRepo);
  });

  group('MarkNotificationAsReadUseCase', () {
    const tUserId = 'user_123';
    const tNotificationId = 'notification_abc';

    test('should call repository.markAsRead with correct params', () async {
      // Arrange
      when(
        () => mockRepo.markAsRead(tUserId, tNotificationId),
      ).thenAnswer((_) async {});

      // Act
      await useCase(tUserId, tNotificationId);

      // Assert
      verify(() => mockRepo.markAsRead(tUserId, tNotificationId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should propagate exception thrown by repository', () async {
      // Arrange
      when(
        () => mockRepo.markAsRead(tUserId, tNotificationId),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase(tUserId, tNotificationId),
        throwsA(isA<Exception>()),
      );
    });
  });
}
