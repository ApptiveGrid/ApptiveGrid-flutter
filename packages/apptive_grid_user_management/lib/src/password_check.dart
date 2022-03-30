import 'package:flutter/widgets.dart';
import 'package:password_rule_check/password_rule_check.dart';

class PasswordCheck extends StatelessWidget {
  const PasswordCheck({Key? key, required this.controller, this.requirement = PasswordRequirement.enforced, required this.validationKey,}) : super(key: key);

  final TextEditingController controller;
  final GlobalKey<PasswordRuleCheckState> validationKey;
  final PasswordRequirement requirement;

  @override
  Widget build(BuildContext context) {
    switch (requirement) {
      case PasswordRequirement.enforced:
        return PasswordRuleCheck(
          key: validationKey,
          controller: controller,
          ruleSet: PasswordRuleSet(
            minLength: 8,
            digits: 1,
            specialCharacters: 1,
            lowercase: 1,
            uppercase: 1,
          ),
        );
      case PasswordRequirement.safetyHint:
        return PasswordRuleCheck.suggestedSafety(
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
        );
    }
  }
}

enum PasswordRequirement {
  enforced, safetyHint
}
