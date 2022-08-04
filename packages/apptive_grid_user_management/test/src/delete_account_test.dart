import 'dart:async';

import 'package:apptive_grid_user_management/src/delete_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../infrastructure/mocks.dart';
import '../infrastructure/test_app.dart';

void main() {
  final client = MockApptiveGridUserManagementClient();

  const errorColor = Color(0xffd32f2f);

  setUp(() {
    when(() => client.deleteAccount()).thenAnswer((_) async => true);
  });

  testWidgets('Delete Account', (tester) async {
    final completer = Completer<bool>();
    const style = TextStyle(fontSize: 24);
    final target = StubUserManagement(
      client: client,
      child: DeleteAccount.textButton(
        onAccountDeleted: () => completer.complete(true),
        style: style,
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    expect(find.byType(TextButton), findsOneWidget);
    final button =
        find.byType(TextButton).evaluate().first.widget as TextButton;
    final buttonLabel = button.child as Text;
    expect(
      buttonLabel.style?.fontSize,
      style.fontSize,
    );
    expect(
      buttonLabel.style?.color,
      errorColor,
    );

    await tester.tap(find.byType(DeleteAccount));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    verify(() => client.deleteAccount()).called(1);
    expect(await completer.future, true);
  });

  testWidgets('Delete Account List Tile', (tester) async {
    final completer = Completer<bool>();
    const style = TextStyle(fontSize: 24);
    final target = StubUserManagement(
      client: client,
      child: DeleteAccount.listTile(
        onAccountDeleted: () => completer.complete(true),
        style: style,
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOneWidget);
    final listTile = find.byType(ListTile).evaluate().first.widget as ListTile;
    final listTileTitle = listTile.title as Text;
    expect(
      listTileTitle.style?.fontSize,
      style.fontSize,
    );
    expect(
      listTileTitle.style?.color,
      errorColor,
    );

    await tester.tap(find.byType(DeleteAccount));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    verify(() => client.deleteAccount()).called(1);
    expect(await completer.future, true);
  });

  testWidgets('Delete Account with custom widget', (tester) async {
    final completer = Completer<bool>();
    final target = StubUserManagement(
      client: client,
      child: DeleteAccount(
        onAccountDeleted: () => completer.complete(true),
        child: const Center(child: Text('Custom Widget')),
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    expect(find.byType(Center), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(DeleteAccount),
        matching: find.byType(GestureDetector),
      ),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    verify(() => client.deleteAccount()).called(1);
    expect(await completer.future, true);
  });

  testWidgets('Delete Account shows Error', (tester) async {
    when(client.deleteAccount).thenAnswer((_) => Future.error('Error'));
    final target = StubUserManagement(
      client: client,
      child: DeleteAccount(
        onAccountDeleted: () => {},
        child: const Text('Custom Widget'),
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(DeleteAccount),
        matching: find.byType(GestureDetector),
      ),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    verify(() => client.deleteAccount()).called(1);
    expect(
      find.text('An error occurred. Please try again.\nError'),
      findsOneWidget,
    );
  });

  testWidgets('Delete Account Error with Reponse shows Body', (tester) async {
    when(client.deleteAccount)
        .thenAnswer((_) => Future.error(http.Response('Error', 400)));
    final target = StubUserManagement(
      client: client,
      child: DeleteAccount(
        onAccountDeleted: () => {},
        child: const Text('Custom Widget'),
      ),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(DeleteAccount),
        matching: find.byType(GestureDetector),
      ),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    verify(() => client.deleteAccount()).called(1);
    expect(find.text('400: Error'), findsOneWidget);
  });

  testWidgets('Delete Account Cancel Dialog', (tester) async {
    final target = StubUserManagement(
      client: client,
      child: DeleteAccount.listTile(onAccountDeleted: () => {}),
    );

    await tester.pumpWidget(target);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DeleteAccount));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    verifyNever(() => client.deleteAccount());
  });
}
