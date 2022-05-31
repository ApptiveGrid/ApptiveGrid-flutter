import 'dart:async';

import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:apptive_grid_user_management/src/login_content.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_translation.dart';
import 'package:apptive_grid_user_management/src/translation/l10n/translation_de.dart'
    as de;
import 'package:apptive_grid_user_management/src/translation/l10n/translation_en.dart'
    as en;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uni_links_platform_interface/uni_links_platform_interface.dart';

import '../../infrastructure/mocks.dart';

void main() {
  group('Locales', () {
    testWidgets('Uses Locale from App', (tester) async {
      late final BuildContext context;
      final target = MaterialApp(
        locale: const Locale('de'),
        supportedLocales: const [Locale('de')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: ApptiveGridUserManagementLocalization(
          child: Builder(
            builder: (buildContext) {
              context = buildContext;
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(
        ApptiveGridUserManagementLocalization.of(context),
        isInstanceOf<de.ApptiveGridUserManagementLocalizedTranslation>(),
      );
    });

    testWidgets('Default locale is en', (tester) async {
      late final BuildContext context;
      final target = ApptiveGridUserManagementLocalization(
        child: Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(
        ApptiveGridUserManagementLocalization.of(context),
        isInstanceOf<en.ApptiveGridUserManagementLocalizedTranslation>(),
      );
    });

    testWidgets('Switch Locale updates', (tester) async {
      late BuildContext context;
      final localeKey = GlobalKey<_ReloadLocalizationsState>();
      final target = MaterialApp(
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('de')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Material(
          child: ApptiveGridUserManagementLocalization(
            child: _ReloadLocalizations(
              key: localeKey,
              child: Builder(
                builder: (buildContext) {
                  context = buildContext;
                  return const LoginContent();
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pump();

      expect(
        ApptiveGridUserManagementLocalization.of(context),
        isInstanceOf<en.ApptiveGridUserManagementLocalizedTranslation>(),
      );

      localeKey.currentState!.locale = const Locale('de');
      await tester.pump();

      expect(
        ApptiveGridUserManagementLocalization.of(context),
        isInstanceOf<de.ApptiveGridUserManagementLocalizedTranslation>(),
      );
    });
  });

  group('Custom Translations', () {
    final client = MockApptiveGridUserManagementClient();
    late UniLinksPlatform initialUniLinks;

    late Completer<String?> initialLink;
    late StreamController<String?> controller;

    late MockUniLinks uniLink;

    setUpAll(() {
      initialLink = Completer<String?>();
      controller = StreamController.broadcast();
      initialUniLinks = UniLinksPlatform.instance;
      uniLink = MockUniLinks();
      UniLinksPlatform.instance = uniLink;

      when(() => uniLink.linkStream).thenAnswer((_) => controller.stream);
      when(uniLink.getInitialLink).thenAnswer((_) async => initialLink.future);
    });

    tearDownAll(() {
      UniLinksPlatform.instance = initialUniLinks;
      controller.close();
      reset(uniLink);
    });

    testWidgets('Login Content', (tester) async {
      final target = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement(
            customTranslations: {
              const Locale.fromSubtags(languageCode: 'en'):
                  CustomTestTranslation(),
            },
            client: client,
            group: 'test',
            clientId: 'client',
            onAccountConfirmed: (bool loggedIn) {},
            confirmAccountPrompt: (Widget confirmationWidget) {},
            resetPasswordPrompt: (Widget resetPasswordWidget) {},
            onPasswordReset: (bool loggedIn) {},
            child: const ApptiveGridUserManagementContent(
              initialContentType: ContentType.login,
            ),
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('actionLogin'), findsOneWidget);
    });

    testWidgets('Register Content', (tester) async {
      final target = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement(
            customTranslations: {
              const Locale.fromSubtags(languageCode: 'en'):
                  CustomTestTranslation(),
            },
            client: client,
            group: 'test',
            clientId: 'client',
            onAccountConfirmed: (bool loggedIn) {},
            confirmAccountPrompt: (Widget confirmationWidget) {},
            resetPasswordPrompt: (Widget resetPasswordWidget) {},
            onPasswordReset: (bool loggedIn) {},
            child: const ApptiveGridUserManagementContent(
              initialContentType: ContentType.register,
            ),
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();

      expect(find.text('actionRegister'), findsOneWidget);
    });

    testWidgets('Default Reset Password Dialog', (tester) async {
      final target = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement(
            customTranslations: {
              const Locale.fromSubtags(languageCode: 'en'):
                  CustomTestTranslation(),
            },
            client: client,
            group: 'test',
            clientId: 'client',
            onAccountConfirmed: (bool loggedIn) {},
            confirmAccountPrompt: (Widget confirmationWidget) {},
            resetPasswordPrompt: (Widget resetPasswordWidget) {},
            onPasswordReset: (bool loggedIn) {},
            child: const ApptiveGridUserManagementContent(
              initialContentType: ContentType.login,
            ),
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.text('forgotPassword'));
      await tester.pumpAndSettle();

      expect(find.text('forgotPasswordMessage'), findsOneWidget);
    });

    testWidgets('Custom Reset Password Widget', (tester) async {
      final completer = Completer<Widget>();
      final target = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement(
            customTranslations: {
              const Locale.fromSubtags(languageCode: 'en'):
                  CustomTestTranslation(),
            },
            client: client,
            group: 'test',
            clientId: 'client',
            onAccountConfirmed: (bool loggedIn) {},
            confirmAccountPrompt: (Widget confirmationWidget) {},
            resetPasswordPrompt: (Widget resetPasswordWidget) {},
            onPasswordReset: (bool loggedIn) {},
            child: ApptiveGridUserManagementContent(
              requestResetPassword: (widget, _) {
                completer.complete(Material(child: MaterialApp(home: widget)));
              },
              initialContentType: ContentType.login,
            ),
          ),
        ),
      );

      await tester.pumpWidget(target);
      await tester.pumpAndSettle();
      await tester.tap(find.text('forgotPassword'));
      final widget = await completer.future;

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text('forgotPasswordMessage'), findsOneWidget);
    });

    testWidgets('Reset Password Prompt', (tester) async {
      final callbackCompleter = Completer<Widget>();

      final uri = Uri.parse(
        'https://app.apptivegrid.de/auth/group/resetPassword/userId/resetToken',
      );

      final apptiveGridUserManagement = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement(
            customTranslations: {
              const Locale.fromSubtags(languageCode: 'en'):
                  CustomTestTranslation(),
            },
            group: 'group',
            clientId: 'clientId',
            confirmAccountPrompt: (_) {},
            onAccountConfirmed: (_) {},
            onChangeEnvironment: (_) async {},
            resetPasswordPrompt: (widget) {
              callbackCompleter.complete(widget);
            },
            onPasswordReset: (_) async {},
            client: client,
          ),
        ),
      );

      await tester.pumpWidget(apptiveGridUserManagement);
      await tester.pump();

      controller.add(uri.toString());

      final confirmWidget = await callbackCompleter.future;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: SingleChildScrollView(child: confirmWidget)),
        ),
      );

      await tester.pump();
      expect(find.text('actionResetPassword'), findsOneWidget);
    });

    testWidgets('Confirm Account Prompt', (tester) async {
      final callbackCompleter = Completer<Widget>();

      final uri =
          Uri.parse('https://app.apptivegrid.de/auth/group/confirm/userId');

      final apptiveGridUserManagement = MaterialApp(
        home: Material(
          child: ApptiveGridUserManagement(
            customTranslations: {
              const Locale.fromSubtags(languageCode: 'en'):
                  CustomTestTranslation(),
            },
            group: 'group',
            clientId: 'clientId',
            confirmAccountPrompt: (widget) {
              callbackCompleter.complete(widget);
            },
            onAccountConfirmed: (_) {},
            onChangeEnvironment: (_) async {},
            resetPasswordPrompt: (_) {},
            onPasswordReset: (_) async {},
            client: client,
          ),
        ),
      );

      await tester.pumpWidget(apptiveGridUserManagement);
      await tester.pump();

      controller.add(uri.toString());

      final confirmWidget = await callbackCompleter.future;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: SingleChildScrollView(child: confirmWidget)),
        ),
      );

      await tester.pump();
      expect(find.text('confirmAccountCreation'), findsOneWidget);
    });
  });
}

class _ReloadLocalizations extends StatefulWidget {
  const _ReloadLocalizations({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<_ReloadLocalizations> createState() => _ReloadLocalizationsState();
}

class _ReloadLocalizationsState extends State<_ReloadLocalizations> {
  Locale? _locale;

  set locale(Locale? locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: _locale ?? Localizations.localeOf(context),
      delegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      child: widget.child,
    );
  }
}

class CustomTestTranslation extends ApptiveGridUserManagementTranslation {
  @override
  String get actionCancel => 'actionCancel';

  @override
  String get actionConfirm => 'actionConfirm';

  @override
  String get actionLogin => 'actionLogin';

  @override
  String get actionOk => 'actionOk';

  @override
  String get actionPasswordReset => 'actionPasswordReset';

  @override
  String get actionRegister => 'actionRegister';

  @override
  String get actionResetPassword => 'actionResetPassword';

  @override
  String get confirmAccountCreation => 'confirmAccountCreation';

  @override
  String get errorConfirm => 'errorConfirm';

  @override
  String get errorLogin => 'errorLogin';

  @override
  String get errorRegister => 'errorRegister';

  @override
  String get errorReset => 'errorReset';

  @override
  String get errorUnknown => 'errorUnknown';

  @override
  String get forgotPassword => 'forgotPassword';

  @override
  String get forgotPasswordMessage => 'forgotPasswordMessage';

  @override
  String get hintConfirmPassword => 'hintConfirmPassword';

  @override
  String get hintEmail => 'hintEmail';

  @override
  String get hintFirstName => 'hintFirstName';

  @override
  String get hintLastName => 'hintLastName';

  @override
  String get hintNewPassword => 'hintNewPassword';

  @override
  String get hintPassword => 'hintPassword';

  @override
  String get registerWaitingForConfirmation => 'registerWaitingForConfirmation';

  @override
  String requestResetPasswordSuccess(String email) {
    return 'requestResetPasswordSuccess(String $email)';
  }

  @override
  String get resetPasswordMessage => 'resetPasswordMessage';

  @override
  String get resetPasswordSuccess => 'resetPasswordSuccess';

  @override
  String get validateErrorEmailEmpty => 'validateErrorEmailEmpty';

  @override
  String get validateErrorEmailFormat => 'validateErrorEmailFormat';

  @override
  String get validateErrorFirstNameEmpty => 'validateErrorFirstNameEmpty';

  @override
  String get validateErrorLastNameEmpty => 'validateErrorLastNameEmpty';

  @override
  String get validateErrorPasswordsNotMatching =>
      'validateErrorPasswordsNotMatching';
}
