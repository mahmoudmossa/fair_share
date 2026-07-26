import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fair_share/features/notifications/domain/usecases/mark_all_notification_as_read.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  late MockNotificationsRepository mockRepo;
  late MarkAllNotificationAsReadUseCase useCase;

  setUp(() {
    mockRepo = MockNotificationsRepository();
    useCase = MarkAllNotificationAsReadUseCase(mockRepo);
  });

  group('MarkAllNotificationAsReadUseCase', () {
    const tUserId = 'user_123';

    test('should call repository.markAllAsRead with correct userId', () async {
      // Arrange
      when(
        () => mockRepo.markAllAsRead(tUserId),
      ).thenAnswer((_) async {});

      // Act
      await useCase(tUserId);

      // Assert
      verify(() => mockRepo.markAllAsRead(tUserId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should propagate exception thrown by repository', () async {
      // Arrange
      when(
        () => mockRepo.markAllAsRead(tUserId),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase(tUserId),
        throwsA(isA<Exception>()),
      );
    });
  });
}
