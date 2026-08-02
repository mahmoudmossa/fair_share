import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/features/profile/domain/use_cases/update_profile_photo_use_case.dart';
import 'package:fair_share/features/profile/presentation/providers/profile_notifier_provider.dart';
import 'package:fair_share/features/profile/presentation/providers/update_profile_photo_use_case_provider.dart';

class MockUpdateProfilePhotoUseCase extends Mock
    implements UpdateProfilePhotoUseCase {}

void main() {
  late MockUpdateProfilePhotoUseCase mockUseCase;
  late ProviderContainer container;

  setUp(() {
    mockUseCase = MockUpdateProfilePhotoUseCase();
    container = ProviderContainer(
      overrides: [
        updateProfilePhotoUseCaseProvider
            .overrideWith((ref) => mockUseCase),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('ProfileNotifier.updateProfilePhoto', () {
    const userId = 'user_123';
    const flatId = 'flat_abc';
    const base64Photo = 'dGVzdGJhc2U2NA==';

    test(
      'should emit [ActionLoading, ActionSuccess] when photo update succeeds',
      () async {
        when(
          () => mockUseCase(
            userId: userId,
            flatId: flatId,
            base64Photo: base64Photo,
          ),
        ).thenAnswer((_) async {});

        final notifier = container.read(profileProvider.notifier);
        final states = <ActionState<void>>[];

        container.listen<ActionState<void>>(
          profileProvider,
          (_, next) => states.add(next),
          fireImmediately: false,
        );

        await notifier.updateProfilePhoto(
          userId: userId,
          flatId: flatId,
          base64Photo: base64Photo,
        );

        expect(states, [
          const ActionLoading<void>(),
          const ActionSuccess<void>(null),
        ]);
        verify(
          () => mockUseCase(
            userId: userId,
            flatId: flatId,
            base64Photo: base64Photo,
          ),
        ).called(1);
      },
    );

    test(
      'should emit [ActionLoading, ActionError] when photo update fails',
      () async {
        final exception = Exception('Upload failed');
        when(
          () => mockUseCase(
            userId: userId,
            flatId: flatId,
            base64Photo: base64Photo,
          ),
        ).thenThrow(exception);

        final notifier = container.read(profileProvider.notifier);
        final states = <ActionState<void>>[];

        container.listen<ActionState<void>>(
          profileProvider,
          (_, next) => states.add(next),
          fireImmediately: false,
        );

        await notifier.updateProfilePhoto(
          userId: userId,
          flatId: flatId,
          base64Photo: base64Photo,
        );

        expect(states.length, 2);
        expect(states[0], const ActionLoading<void>());
        expect(states[1], isA<ActionError<void>>());
      },
    );
  });
}
