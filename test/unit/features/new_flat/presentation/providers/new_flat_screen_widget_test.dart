import 'package:fair_share/features/new_flat/domain/repositories/flat_repository.dart';
import 'package:fair_share/features/new_flat/presentation/provider/new_flat_repository_provider.dart';
import 'package:fair_share/features/new_flat/presentation/screens/new_flat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockFlatRepository extends Mock implements FlatRepository {}

void main() {
  late MockFlatRepository mockFlatRepository;
  setUp(() {
    mockFlatRepository = MockFlatRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        newFlatRepositoryProvider.overrideWithValue(mockFlatRepository),
      ],
      child: const MaterialApp(home: NewFlatScreen()),
    );
  }

  testWidgets('renders initial Step 1 flat name input field', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
  });
}
