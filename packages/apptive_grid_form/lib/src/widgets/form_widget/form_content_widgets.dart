import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/util/submit_progress.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:collection/collection.dart';

/// Shows a spinner while loading the form data
class LoadingFormWidget extends StatelessWidget {
  /// Creates a new loading widget
  const LoadingFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

/// Displays the current form data with all customizations
class FormDataWidget extends StatefulWidget {
  /// Creates a new form data widget
  const FormDataWidget({
    super.key,
    required this.data,
    required this.formKey,
    required this.isSubmitting,
    required this.padding,
    this.titlePadding,
    this.titleStyle,
    required this.hideTitle,
    this.descriptionPadding,
    this.descriptionStyle,
    required this.hideDescription,
    this.componentBuilder,
    required this.hideButton,
    required this.buttonAlignment,
    this.buttonLabel,
    required this.submitForm,
    this.progress,
    this.scrollController,
  });

  /// The current form data
  final FormData data;

  /// A key to access the state of the current form
  final GlobalKey<FormState> formKey;

  /// A flag to signal the the form is currently being submitted
  final bool isSubmitting;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsetsGeometry padding;

  /// Style for the Form Title. If no style is provided [headline5] of the [TextTheme] will be used
  final TextStyle? titleStyle;

  /// Padding for the title. If no Padding is provided the [padding] is used
  final EdgeInsetsGeometry? titlePadding;

  /// Flag to hide the form title, default is false
  final bool hideTitle;

  /// Style for the Form Description. If no style is provided [bodyText1] of the [TextTheme] will be used
  final TextStyle? descriptionStyle;

  /// Padding for the description. If no Padding is provided the [padding] is used
  final EdgeInsetsGeometry? descriptionPadding;

  /// Flag to hide the form description, default is false
  final bool hideDescription;

  /// A custom Builder for Building custom Widgets for FormComponents
  final Widget? Function(BuildContext, FormComponent)? componentBuilder;

  /// Alignment of the Send Button
  final Alignment buttonAlignment;

  /// Label of the Button to submit a form.
  /// Defaults to a localized version of `Send`
  final String? buttonLabel;

  /// Show or hide the submit button at the bottom of the form.
  final bool hideButton;

  /// Triggers when the send button it tapped
  final Function() submitForm;

  /// The current submission progress
  final SubmitProgress? progress;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  @override
  State<StatefulWidget> createState() => _FormDataWidgetState();
}

class _FormDataWidgetState extends State<FormDataWidget> {
  late final _pageController = PageController();

  late final List<GlobalKey<FormState>> _pageKeys = widget
          .data.properties?.pageIds
          .map((_) => GlobalKey<FormState>())
          .toList() ??
      [];

  @override
  Widget build(BuildContext context) {
    final pages = widget.data.properties?.pageIds;
    if (pages != null && pages.length > 1) {
      return PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages.map(
          (pageId) {
            final key = _pageKeys[pageId.indexOf(pageId)];
            return FormPage(
              pageId: pageId,
              data: widget.data,
              formKey: key,
              isSubmitting: widget.isSubmitting,
              padding: widget.padding,
              titlePadding: widget.titlePadding,
              titleStyle: widget.titleStyle,
              hideTitle: widget.hideTitle,
              descriptionPadding: widget.descriptionPadding,
              descriptionStyle: widget.descriptionStyle,
              hideDescription: widget.hideDescription,
              buttonLabel: widget.buttonLabel,
              hideButton: widget.hideButton,
              buttonAlignment: widget.buttonAlignment,
              componentBuilder: widget.componentBuilder,
              progress: widget.progress,
              submitForm: () {
                if (key.currentState!.validate()) {
                  widget.submitForm();
                }
              },
              pageBack: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceInOut,
              ),
              pageForward: () {
                if (key.currentState!.validate()) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceInOut,
                  );
                }
              },
            );
          },
        ).toList(),
      );
    } else {
      return FormPage(
        pageId: pages?.firstOrNull,
        data: widget.data,
        formKey: _pageKeys.first,
        isSubmitting: widget.isSubmitting,
        padding: widget.padding,
        titlePadding: widget.titlePadding,
        titleStyle: widget.titleStyle,
        hideTitle: widget.hideTitle,
        descriptionPadding: widget.descriptionPadding,
        descriptionStyle: widget.descriptionStyle,
        hideDescription: widget.hideDescription,
        buttonLabel: widget.buttonLabel,
        hideButton: widget.hideButton,
        buttonAlignment: widget.buttonAlignment,
        componentBuilder: widget.componentBuilder,
        progress: widget.progress,
        scrollController: widget.scrollController,
        submitForm: () {
          if (_pageKeys.first.currentState!.validate()) {
            widget.submitForm();
          }
        },
      );
    }
  }
}

/// Displays an error the occured while submitting
class FormErrorWidget extends StatelessWidget {
  /// Creates a new error widget
  const FormErrorWidget({
    super.key,
    required this.error,
    required this.padding,
    required this.didTapBackButton,
    this.scrollController,
  });

  /// The error being displayed
  final dynamic error;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsetsGeometry padding;

  /// Triggers when the user taps the back button
  final Function() didTapBackButton;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridLocalization.of(context)!;
    final theme = Theme.of(context);
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(32.0),
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Lottie.asset(
            'packages/apptive_grid_form/assets/error.json',
            repeat: false,
          ),
        ),
        Text(
          localization.errorTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium,
        ),
        Padding(
          padding: padding,
          child: Text(
            error is http.Response
                ? '${error.statusCode}: ${error.body}'
                : error.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.error),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: didTapBackButton,
            child: Text(localization.backToForm),
          ),
        ),
      ],
    );
  }
}

/// Displays a success message after a succesful submission
class SuccessfulSubmitWidget extends StatelessWidget {
  /// Creates a new success widget
  const SuccessfulSubmitWidget({
    super.key,
    required this.didTapAdditionalAnswer,
    this.successTitle,
    this.successMessage,
    this.additionalAnswerButtonLabel,
    this.scrollController,
  });

  /// Triggers when the user taps the button to submit an additional answer
  final Function() didTapAdditionalAnswer;

  /// The label for the additional answer button
  final String? successTitle;

  /// The label for the additional answer button
  final String? successMessage;

  /// The label for the additional answer button
  final String? additionalAnswerButtonLabel;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridLocalization.of(context)!;
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(32.0),
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Lottie.asset(
            'packages/apptive_grid_form/assets/success.json',
            repeat: false,
          ),
        ),
        Text(
          successTitle ?? localization.sendSuccess,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (successMessage != null) ...[
          const SizedBox(height: 4),
          Text(
            successMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        Center(
          child: TextButton(
            onPressed: didTapAdditionalAnswer,
            child: Text(
              additionalAnswerButtonLabel ?? localization.additionalAnswer,
            ),
          ),
        ),
      ],
    );
  }
}

/// Displays a message after a submission has been saved locally
class SavedSubmitWidget extends StatelessWidget {
  /// Creates a new saved submission widget
  const SavedSubmitWidget({
    super.key,
    required this.didTapAdditionalAnswer,
    this.additionalAnswerButtonLabel,
    this.scrollController,
  });

  /// Triggers when the user taps the button to submit an additional answer
  final Function() didTapAdditionalAnswer;

  /// The label for the additional answer button
  final String? additionalAnswerButtonLabel;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridLocalization.of(context)!;
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(32.0),
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Lottie.asset(
            'packages/apptive_grid_form/assets/saved.json',
            repeat: false,
          ),
        ),
        Text(
          localization.savedForLater,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Center(
          child: TextButton(
            onPressed: didTapAdditionalAnswer,
            child: Text(
              additionalAnswerButtonLabel ?? localization.additionalAnswer,
            ),
          ),
        ),
      ],
    );
  }
}

/// Represents a single form page
///
/// If there is only one page, this is the only child of the [FormDataWidget].
/// If there are mutliple pages, they are added together in a [PageView].
class FormPage extends StatelessWidget {
  /// Creates a new form data widget
  const FormPage({
    super.key,
    required this.pageId,
    required this.data,
    required this.formKey,
    required this.isSubmitting,
    required this.padding,
    this.titlePadding,
    this.titleStyle,
    required this.hideTitle,
    this.descriptionPadding,
    this.descriptionStyle,
    required this.hideDescription,
    this.componentBuilder,
    required this.hideButton,
    required this.buttonAlignment,
    this.buttonLabel,
    required this.submitForm,
    this.pageForward,
    this.pageBack,
    this.progress,
    this.scrollController,
  });

  /// The id of the current page
  final String? pageId;

  /// The current form data
  final FormData data;

  /// A key to access the state of the current form
  final GlobalKey<FormState> formKey;

  /// A flag to signal the the form is currently being submitted
  final bool isSubmitting;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsetsGeometry padding;

  /// Style for the Form Title. If no style is provided [headline5] of the [TextTheme] will be used
  final TextStyle? titleStyle;

  /// Padding for the title. If no Padding is provided the [padding] is used
  final EdgeInsetsGeometry? titlePadding;

  /// Flag to hide the form title, default is false
  final bool hideTitle;

  /// Style for the Form Description. If no style is provided [bodyText1] of the [TextTheme] will be used
  final TextStyle? descriptionStyle;

  /// Padding for the description. If no Padding is provided the [padding] is used
  final EdgeInsetsGeometry? descriptionPadding;

  /// Flag to hide the form description, default is false
  final bool hideDescription;

  /// A custom Builder for Building custom Widgets for FormComponents
  final Widget? Function(BuildContext, FormComponent)? componentBuilder;

  /// Alignment of the Send Button
  final Alignment buttonAlignment;

  /// Label of the Button to submit a form.
  /// Defaults to a localized version of `Send`
  final String? buttonLabel;

  /// Show or hide the submit button at the bottom of the form.
  final bool hideButton;

  /// Triggers when the send button it tapped
  final Function() submitForm;

  /// Triggers when the next page button it tapped
  final Function()? pageForward;

  /// Triggers when the back page button it tapped
  final Function()? pageBack;

  /// The current submission progress
  final SubmitProgress? progress;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  List<FormFieldProperties> get _fieldProperties => data.fieldProperties
      .where((properties) => properties.pageId == pageId)
      .toList();

  List<FormComponent>? get _components => data.components
      ?.where(
        (component) =>
            _fieldProperties.firstWhereOrNull(
              (properties) => properties.fieldId == component.fieldId,
            ) !=
            null,
      )
      .toList();

  bool get _canPageBack =>
      data.properties?.pageIds.firstOrNull != pageId &&
      (data.properties?.pageIds.length ?? 0) > 1;

  bool get _canPageForward =>
      data.properties?.pageIds.lastOrNull != pageId &&
      (data.properties?.pageIds.length ?? 0) > 1;

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridLocalization.of(context)!;
    final submitLink = data.links[ApptiveLinkType.submit];
    // Offset for title and description
    const indexOffset = 2;
    return Form(
      key: formKey,
      child: ListView.builder(
        controller: scrollController,
        itemCount: indexOffset +
            (_components?.length ?? 0) +
            (submitLink != null ? 1 : 0),
        itemBuilder: (context, index) {
          // Title
          if (index == 0) {
            if (hideTitle || data.title == null) {
              return const SizedBox();
            } else {
              return Padding(
                padding: titlePadding ?? padding,
                child: Text(
                  data.title!,
                  style:
                      titleStyle ?? Theme.of(context).textTheme.headlineSmall,
                ),
              );
            }
          } else if (index == 1) {
            if (hideDescription || data.description == null) {
              return const SizedBox();
            } else {
              return Padding(
                padding: descriptionPadding ?? padding,
                child: Text(
                  data.description!,
                  style:
                      descriptionStyle ?? Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
          } else if (index < (_components?.length ?? 0) + indexOffset) {
            final componentIndex = index - indexOffset;
            final component = _components![componentIndex];
            final properties = _fieldProperties
                .firstWhereOrNull((e) => e.fieldId == component.field.id);
            if (properties?.defaultValue?.value != null) {
              component.data.value = properties?.defaultValue?.value;
            }
            if (properties?.hidden == true) {
              return const SizedBox();
            }
            final componentWidget =
                fromModel(component, enabled: properties?.disabled != true);
            if (componentWidget is EmptyFormWidget) {
              // UserReference Widget should be invisible in the Form
              // So returning without any Padding
              return componentWidget;
            } else {
              return IgnorePointer(
                ignoring: properties?.disabled == true || isSubmitting,
                child: Padding(
                  padding: padding,
                  child: Builder(
                    builder: (context) {
                      final customBuilder =
                          componentBuilder?.call(context, component);
                      if (customBuilder != null) {
                        return customBuilder;
                      } else {
                        return componentWidget;
                      }
                    },
                  ),
                ),
              );
            }
          } else {
            return Padding(
              padding: padding,
              child: Align(
                alignment: buttonAlignment,
                child: Builder(
                  builder: (_) {
                    if (isSubmitting) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const TextButton(
                            onPressed: null,
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                          if (progress != null)
                            Padding(
                              padding: padding,
                              child: SubmitProgressWidget(progress: progress!),
                            ),
                        ],
                      );
                    } else if (_canPageBack || _canPageForward) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _canPageBack
                              ? ElevatedButton(
                                  onPressed: () => pageBack?.call(),
                                  child: Text('pageBack'),
                                )
                              : const SizedBox(),
                          if (_canPageForward)
                            ElevatedButton(
                              onPressed: () => pageForward?.call(),
                              child: Text('nextPage'),
                            ),
                          if (!hideButton && !_canPageForward)
                            ElevatedButton(
                              onPressed: submitForm,
                              child: Text(
                                buttonLabel ??
                                    data.properties?.buttonTitle ??
                                    localization.actionSend,
                              ),
                            ),
                        ],
                      );
                    } else if (!hideButton) {
                      return ElevatedButton(
                        onPressed: submitForm,
                        child: Text(
                          buttonLabel ??
                              data.properties?.buttonTitle ??
                              localization.actionSend,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
