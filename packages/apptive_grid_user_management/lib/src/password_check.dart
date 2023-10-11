import 'package:apptive_grid_user_management/apptive_grid_user_management.dart';
import 'package:flutter/widgets.dart';
import 'package:password_rule_check/password_rule_check.dart';

/// A widget to show password strength hints/requirements
class PasswordCheck extends StatelessWidget {
  /// Shows a [PasswordRuleCheck] based on [ApptiveGridUserManagement.passwordRequirement]
  const PasswordCheck({
    super.key,
    required this.controller,
    required this.validationKey,
  });

  /// [TextEditingController] managing the input of the password field
  final TextEditingController controller;

  /// Key to validate [PasswordRuleCheckState]
  final GlobalKey<PasswordRuleCheckState> validationKey;

  @override
  Widget build(BuildContext context) {
    final requirement = ApptiveGridUserManagement.maybeOf(context)
            ?.widget
            .passwordRequirement ??
        PasswordRequirement.enforced;
    return switch (requirement) {
      PasswordRequirement.enforced => PasswordRuleCheck(
          key: validationKey,
          controller: controller,
          ruleSet: PasswordRuleSet(
            minLength: 8,
            digits: 1,
            specialCharacters: 1,
            lowercase: 1,
            uppercase: 1,
          ),
        ),
      PasswordRequirement.safetyHint => PasswordRuleCheck.suggestedSafety(
          key: validationKey,
          controller: controller,
          ruleSet: PasswordRuleSet(
            minLength: 8,
          ),
          optimalRules: [
            PasswordRuleSet(
              minLength: 8,
              digits: 1,
              lowercase: 1,
              uppercase: 1,
              specialCharacters: 1,
            ),
          ],
        ),
    };
  }
}

/// Sets the level of password requirements
enum PasswordRequirement {
  /// In order to allow passwords it needs to be:
  /// minLength of 8 Characters and contain at least one of each:
  /// Special Character, Digit, Uppercase Letter, Lowercase Letter
  enforced,

  /// In order to allow a password it needs to be 8 characters long
  /// Furthermore the indication bar will turn green if the password contains at least one of each:
  /// Special Character, Digit, Uppercase Letter, Lowercase Letter
  safetyHint,
}
