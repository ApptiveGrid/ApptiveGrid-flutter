import 'dart:async';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/util/submit_progress.dart';
import 'package:apptive_grid_form/src/widgets/apptive_grid_form_widgets.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/attachment_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

/// A Widget to display a ApptiveGrid Form
///
/// In order to use this there needs to be a [ApptiveGrid] Widget in the Widget tree
class ApptiveGridForm extends StatefulWidget {
  /// Creates a ApptiveGridForm.
  ///
  /// The [formId] determines what Form is displayed. It works with empty and pre-filled forms.
  const ApptiveGridForm({
    super.key,
    required this.uri,
    this.titleStyle,
    this.descriptionStyle,
    this.contentPadding,
    this.titlePadding,
    this.descriptionPadding,
    this.hideTitle = false,
    this.hideDescription = false,
    this.onFormLoaded,
    this.onActionSuccess,
    this.onSavedToPending,
    this.onCreated,
    this.onError,
    this.scrollController,
    this.buttonAlignment = Alignment.center,
    this.buttonLabel,
    this.hideButton = false,
    this.componentBuilder,
  });

  /// [Uri] of the Form to display
  final Uri uri;

  /// Style for the Form Title. If no style is provided [headline5] of the [TextTheme] will be used
  final TextStyle? titleStyle;

  /// Style for the Form Description. If no style is provided [bodyText1] of the [TextTheme] will be used
  final TextStyle? descriptionStyle;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsetsGeometry? contentPadding;

  /// Padding for the title. If no Padding is provided the [contentPadding] is used
  final EdgeInsetsGeometry? titlePadding;

  /// Padding for the description. If no Padding is provided the [contentPadding] is used
  final EdgeInsetsGeometry? descriptionPadding;

  /// Flag to hide the form title, default is false
  final bool hideTitle;

  /// Flag to hide the form description, default is false
  final bool hideDescription;

  /// Callback after [FormData] loads successfully
  ///
  /// Use this to modify the UI Displaying the Form
  /// ```dart
  /// ApptiveGridForm(
  ///   onFormLoaded: (data) {
  ///     setState(() {
  ///       title = data.title;
  ///     });
  ///   }
  /// ),
  /// ```
  final void Function(FormData)? onFormLoaded;

  /// Callback after Form is Submitted completes Successfully
  ///
  /// If this returns false the default success screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  /// If this is set, any actions passed by the [AfterSubmitAction] in the [FormDataProperties] of the [FormData] will be ignored
  final Future<bool> Function(ApptiveLink, FormData)? onActionSuccess;

  /// Callback after Form is saved to pending Items
  /// Note: This will only be triggerd if an [ApptiveGridCache] is specified in the [ApptiveGridOptions]
  ///
  /// If this returns false the default saved for later screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  final Future<bool> Function(ApptiveLink, FormData)? onSavedToPending;

  /// Callback after Form submission returns a link to a newly created entity, if available
  ///
  /// This can be used to access the newly created entity via the uri.
  final void Function(Uri)? onCreated;

  /// Callback if an Error occurs
  ///
  /// If this returns false the default error screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  final Future<bool> Function(dynamic)? onError;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  /// Alignment of the Send Button
  final Alignment buttonAlignment;

  /// Label of the Button to submit a form.
  /// Defaults to a localized version of `Send`
  final String? buttonLabel;

  /// Show or hide the submit button at the bottom of the form.
  final bool hideButton;

  /// A custom Builder for Building custom Widgets for FormComponents
  final Widget? Function(BuildContext, FormComponent)? componentBuilder;

  @override
  ApptiveGridFormState createState() => ApptiveGridFormState();
}

/// [State] for an [ApptiveGridForm].
/// Use this to access [currentData] to get the most up to date version and call [submitForm] manually
class ApptiveGridFormState extends State<ApptiveGridForm> {
  FormData? _formData;
  late ApptiveGridClient _client;

  dynamic _error;

  final _dataKey = GlobalKey<ApptiveGridFormDataState>();

  /// Returns the data currently being edited
  FormData? get currentData => _dataKey.currentState?.currentData;

  /// Returns the current submitting status
  bool get submitting => _dataKey.currentState?.submitting == true;

  /// Submits the [currentData] if not already submitting
  Future<void>? submitForm() => _dataKey.currentState?.submitForm();

  @override
  void didUpdateWidget(covariant ApptiveGridForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uri != oldWidget.uri) {
      loadForm(resetData: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = ApptiveGrid.getClient(context);
    loadForm();
  }

  @override
  Widget build(BuildContext context) {
    return ApptiveGridFormData(
      key: _dataKey,
      formData: _formData,
      error: _error,
      titleStyle: widget.titleStyle,
      descriptionStyle: widget.descriptionStyle,
      contentPadding: widget.contentPadding,
      titlePadding: widget.titlePadding,
      descriptionPadding: widget.descriptionPadding,
      hideTitle: widget.hideTitle,
      hideDescription: widget.hideDescription,
      onActionSuccess: widget.onActionSuccess,
      onSavedToPending: widget.onSavedToPending,
      onCreated: widget.onCreated,
      onError: widget.onError,
      triggerReload: () => loadForm(resetData: false),
      scrollController: widget.scrollController,
      buttonAlignment: widget.buttonAlignment,
      buttonLabel: widget.buttonLabel,
      hideButton: widget.hideButton,
      componentBuilder: widget.componentBuilder,
    );
  }

  /// Loads the form
  ///
  /// If [resetData] is `true` it will call setState with [_formData] = `null`
  /// Useful if a manual reload of the form is required
  void loadForm({bool resetData = false}) {
    if (resetData) {
      setState(() {
        _formData = null;
        _error = null;
      });
    }
    _client.loadForm(uri: widget.uri).then((value) {
      if (widget.onFormLoaded != null) {
        widget.onFormLoaded!(value);
      }
      if (mounted) {
        setState(() {
          _formData = value;
          _error = null;
        });
      }
    }).catchError((error) {
      _onError(error);
    });
  }

  void _onError(dynamic error) async {
    if (await widget.onError?.call(error) ?? true) {
      if (mounted) {
        setState(() {
          _error = error;
        });
      }
    }
  }
}

/// A Widget to display [FormData]
///
/// Of the [AfterSubmitAction] in the [FormDataProperties] only the custom additional answer button label is used in the package.
class ApptiveGridFormData extends StatefulWidget {
  /// Creates a Widget to display [formData]
  ///
  /// if [error] is not null it will display a error
  const ApptiveGridFormData({
    super.key,
    this.formData,
    this.error,
    this.titleStyle,
    this.descriptionStyle,
    this.contentPadding,
    this.titlePadding,
    this.descriptionPadding,
    this.hideTitle = false,
    this.hideDescription = false,
    this.onActionSuccess,
    this.onSavedToPending,
    this.onCreated,
    this.onError,
    this.triggerReload,
    this.scrollController,
    this.buttonAlignment = Alignment.center,
    this.buttonLabel,
    this.hideButton = false,
    this.componentBuilder,
  });

  /// [FormData] that should be displayed
  final FormData? formData;

  /// Error that should be displayed. Having a error will have priority over [formData]
  final dynamic error;

  /// Style for the Form Title. If no style is provided [headline5] of the [TextTheme] will be used
  final TextStyle? titleStyle;

  /// Style for the Form Description. If no style is provided [bodyText1] of the [TextTheme] will be used
  final TextStyle? descriptionStyle;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsetsGeometry? contentPadding;

  /// Padding for the title. If no Padding is provided the [contentPadding] is used
  final EdgeInsetsGeometry? titlePadding;

  /// Padding for the description. If no Padding is provided the [contentPadding] is used
  final EdgeInsetsGeometry? descriptionPadding;

  /// Flag to hide the form title, default is false
  final bool hideTitle;

  /// Flag to hide the form description, default is false
  final bool hideDescription;

  /// Callback after [ApptiveLink] completes Successfully
  ///
  /// If this returns false the default success screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  final Future<bool> Function(ApptiveLink, FormData)? onActionSuccess;

  /// Callback after Form is saved to pending Items
  /// Note: This will only be triggerd if an [ApptiveGridCache] is specified in the [ApptiveGridOptions]
  ///
  /// If this returns false the default saved for later screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  final Future<bool> Function(ApptiveLink, FormData)? onSavedToPending;

  /// Callback after Form submission returns a link to a newly created entity, if available
  ///
  /// This can be used to access the newly created entity via the uri.
  final void Function(Uri)? onCreated;

  /// Callback if an Error occurs
  ///
  /// If this returns false the default error screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  final Future<bool> Function(dynamic)? onError;

  /// Will be called when [formData] should be reloaded
  final void Function()? triggerReload;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  /// Alignment of the Send Button
  final Alignment buttonAlignment;

  /// Label of the Button to submit a form.
  /// Defaults to a localized version of `Send`
  final String? buttonLabel;

  /// Show or hide the submit button at the bottom of the form.
  /// Please build a custom buttom using the [submitButtonCallback] to create a way for the user to submit their forms.
  final bool hideButton;

  /// A custom Builder for Building custom Widgets for FormComponents
  final Widget? Function(BuildContext, FormComponent)? componentBuilder;

  @override
  ApptiveGridFormDataState createState() => ApptiveGridFormDataState();
}

/// [State] for [ApptiveGridFormData]
///
/// Use this to access [currentData] and call [submitForm] manually
class ApptiveGridFormDataState extends State<ApptiveGridFormData> {
  FormData? _formData;
  late ApptiveGridClient _client;

  final _formKey = GlobalKey<FormState>();

  bool _success = false;

  dynamic _error;

  bool _saved = false;

  late AttachmentManager _attachmentManager;

  bool _submitting = false;

  /// Returns the current submitting status
  bool get submitting => _submitting;

  StreamSubscription<SubmitFormProgressEvent>? _submitProgressSubscription;
  SubmitProgress? _progress;

  /// Returns the current [FormData] held in this Widget
  FormData? get currentData {
    if (!_success && !_saved) {
      return _formData;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _formData = widget.formData;
    _attachmentManager = AttachmentManager(_formData);
  }

  @override
  void didUpdateWidget(covariant ApptiveGridFormData oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_success && !_saved && _error == null) {
      _updateView(resetFormData: widget.formData != oldWidget.formData);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = ApptiveGrid.getClient(context);
  }

  @override
  void dispose() {
    _submitProgressSubscription?.cancel();
    super.dispose();
  }

  void _updateView({
    bool resetFormData = true,
  }) {
    setState(() {
      if (resetFormData) {
        _formData = widget.formData != null
            ? FormData.fromJson(widget.formData!.toJson())
            : null;
        _attachmentManager = AttachmentManager(_formData);
      }
      _error = widget.error;
      _success = false;
      _saved = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ApptiveGridLocalization(
      child: Builder(
        builder: (buildContext) {
          if (_error != null) {
            return FormErrorWidget(
              error: _error,
              padding: widget.contentPadding ?? _defaultPadding,
              didTapBackButton: () {
                if (_formData == null) {
                  widget.triggerReload?.call();
                }
                _updateView(resetFormData: false);
              },
              scrollController: widget.scrollController,
              formData: _formData,
            );
          } else if (_saved) {
            return SavedSubmitWidget(
              didTapAdditionalAnswer: () {
                widget.triggerReload?.call();
                _updateView();
              },
              scrollController: widget.scrollController,
              formData: _formData,
            );
          } else if (_success) {
            return SuccessfulSubmitWidget(
              didTapAdditionalAnswer: () {
                widget.triggerReload?.call();
                _updateView();
              },
              scrollController: widget.scrollController,
              formData: _formData,
            );
          } else if (_formData == null) {
            return const LoadingFormWidget();
          } else {
            return Provider<AttachmentManager>.value(
              value: _attachmentManager,
              child: FormDataWidget(
                data: _formData!,
                formKey: _formKey,
                isSubmitting: _submitting,
                padding: widget.contentPadding ?? _defaultPadding,
                hideTitle: widget.hideTitle,
                titlePadding: widget.titlePadding,
                titleStyle: widget.titleStyle,
                hideDescription: widget.hideDescription,
                descriptionPadding: widget.descriptionPadding,
                descriptionStyle: widget.descriptionStyle,
                componentBuilder: widget.componentBuilder,
                hideButton: widget.hideButton,
                buttonLabel: widget.buttonLabel,
                buttonAlignment: widget.buttonAlignment,
                submitForm: submitForm,
                progress: _progress,
                scrollController: widget.scrollController,
              ),
            );
          }
        },
      ),
    );
  }

  EdgeInsets get _defaultPadding => const EdgeInsets.all(8.0);

  /// Submits the [currentData] if not already submitting
  Future<void> submitForm() async {
    final link = _formData?.links[ApptiveLinkType.submit];
    if (link != null && _formKey.currentState!.validate()) {
      setState(() {
        _submitting = true;
      });
      const doneAttachmentPercentage = 0.6;
      const uploadFormPercentage = 0.8;
      const startPercentage = 0.1;
      _submitProgressSubscription?.cancel();
      final attachmentsToUpload = _formData!.attachmentActions.length;
      int attachmentCount = 0;
      setState(() {
        _progress = SubmitProgress(
          step: SubmitStep.uploadingAttachments,
          processedAttachments: attachmentCount,
          totalAttachments: attachmentsToUpload,
          
          progress: startPercentage,
        );
      });
      _submitProgressSubscription =
          _client.submitFormWithProgress(link, _formData!).listen(
        (event) async {
          if (event is ProcessedAttachmentProgressEvent) {
            setState(() {
              _progress = SubmitProgress(
                step: SubmitStep.uploadingAttachments,
                processedAttachments: ++attachmentCount,
                totalAttachments: attachmentsToUpload,
                progress: startPercentage +
                    (attachmentCount *
                        (doneAttachmentPercentage - startPercentage) /
                        attachmentsToUpload),
              );
            });
          } else if (event is AttachmentCompleteProgressEvent) {
            final response = event.response;
            if (response != null && response.statusCode >= 400) {
              _onSavedOffline(link);
            }
          } else if (event is UploadFormProgressEvent) {
            setState(() {
              _progress = SubmitProgress(
                step: SubmitStep.submittingForm,
                processedAttachments: attachmentCount,
                totalAttachments: attachmentsToUpload,
                progress: uploadFormPercentage,
              );
            });
          } else if (event is SubmitCompleteProgressEvent) {
            final response = event.response;
            if (response != null && response.statusCode < 400) {
              final createdUri = _parseCreatedBody(response: response);
              if (createdUri != null) {
                widget.onCreated?.call(createdUri);
              }
              if (await widget.onActionSuccess?.call(link, _formData!) !=
                  false) {
                if (_formData?.properties?.reloadAfterSubmit == true) {
                  widget.triggerReload?.call();
                  _updateView();
                } else {
                  setState(() {
                    _success = true;
                  });
                }
              }
            } else {
              // FormData was saved to [ApptiveGridCache]
              _onSavedOffline(link);
            }
          } else if (event is ErrorProgressEvent) {
            _onError(event.error);
          }
        },
        onError: (error) {
          _onError(error);
        },
        onDone: () {
          setState(() {
            _submitting = false;
          });
        },
      );
    }
  }

  Future<void> _onSavedOffline(ApptiveLink link) async {
    final hasCache =
        ApptiveGrid.getClient(context, listen: false).options.cache != null;
    if (hasCache) {
      if (await widget.onSavedToPending?.call(link, _formData!) != false) {
        if (mounted) {
          setState(() {
            _saved = true;
          });
        }
      }
    }
  }

  void _onError(dynamic error) async {
    if (await widget.onError?.call(error) ?? true) {
      setState(() {
        _error = error;
      });
    }
  }

  Uri? _parseCreatedBody({required http.Response response}) {
    try {
      return Uri.parse(
        response.body.replaceFirstMapped('Created ', (match) => '').trim(),
      );
    } catch (e) {
      return null;
    }
  }
}

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
class FormDataWidget extends StatelessWidget {
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
            (data.components?.length ?? 0) +
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
          } else if (index < (data.components?.length ?? 0) + indexOffset) {
            final componentIndex = index - indexOffset;
            final component = data.components![componentIndex];
            final componentWidget = fromModel(component);
            if (componentWidget is EmptyFormWidget) {
              // UserReference Widget should be invisible in the Form
              // So returning without any Padding
              return componentWidget;
            } else {
              return IgnorePointer(
                ignoring: isSubmitting,
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

/// Displays an error the occured while submitting
class FormErrorWidget extends StatelessWidget {
  /// Creates a new error widget
  const FormErrorWidget({
    super.key,
    required this.error,
    required this.padding,
    required this.didTapBackButton,
    this.scrollController,
    this.formData,
  });

  /// The error being displayed
  final dynamic error;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsetsGeometry padding;

  /// Triggers when the user taps the back button
  final Function() didTapBackButton;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  /// The current form data
  final FormData? formData;

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
    this.scrollController,
    this.formData,
  });

  /// Triggers when the user taps the button to submit an additional answer
  final Function() didTapAdditionalAnswer;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  /// The current form data
  final FormData? formData;

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
          formData?.properties?.successTitle ?? localization.sendSuccess,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (formData?.properties?.successMessage != null) ...[
          const SizedBox(height: 4),
          Text(
            formData!.properties!.successMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        Center(
          child: TextButton(
            onPressed: didTapAdditionalAnswer,
            child: Text(
              formData?.properties?.afterSubmitAction?.buttonTitle ??
                  localization.additionalAnswer,
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
    this.scrollController,
    this.formData,
  });

  /// Triggers when the user taps the button to submit an additional answer
  final Function() didTapAdditionalAnswer;

  /// Optional ScrollController for the Form
  final ScrollController? scrollController;

  /// The current form data
  final FormData? formData;

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
              formData?.properties?.afterSubmitAction?.buttonTitle ??
                  localization.additionalAnswer,
            ),
          ),
        ),
      ],
    );
  }
}
