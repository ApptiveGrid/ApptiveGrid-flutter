import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:http/http.dart';

/// An Event indicating that a Form Submission has progressed
sealed class SubmitFormProgressEvent {
  const SubmitFormProgressEvent._();
}

/// Event indicating that an Attachment has been processed
class ProcessedAttachmentProgressEvent extends SubmitFormProgressEvent {
  /// Creates a new [ProcessedAttachmentProgressEvent] with the given [attachment]
  const ProcessedAttachmentProgressEvent(this.attachment) : super._();

  /// The Attachment that has been processed
  final Attachment attachment;

  @override
  String toString() {
    return 'ProcessedAttachmentProgressEvent(attachment: $attachment)';
  }

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is ProcessedAttachmentProgressEvent &&
          attachment == other.attachment;

  @override
  int get hashCode => attachment.hashCode;
}

/// Event indicating that all Attachments have been processed
class AttachmentCompleteProgressEvent extends SubmitFormProgressEvent {
  /// Creates a new [AttachmentCompleteProgressEvent] with the given [response] indiciating the result of the Attachment Process
  const AttachmentCompleteProgressEvent(this.response) : super._();

  /// The Response from the Attachment Process
  final Response? response;

  @override
  String toString() {
    return 'AttachmentCompleteProgressEvent(response: ${response?.statusCode}:${response?.body})';
  }

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentCompleteProgressEvent &&
          response?.body == other.response?.body &&
          response?.statusCode == other.response?.statusCode;

  @override
  int get hashCode => Object.hash(response?.statusCode, response?.body);
}

/// Event indicating that a Form Submission is send to ApptiveGrid
class UploadFormProgressEvent extends SubmitFormProgressEvent {
  /// Creates a new [UploadFormProgressEvent] for the given [form]
  const UploadFormProgressEvent(this.form) : super._();

  /// The form that is being submitted
  final FormData form;

  @override
  String toString() {
    return 'UploadFormProgressEvent(formData: $form)';
  }

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is UploadFormProgressEvent && form == other.form;

  @override
  int get hashCode => form.hashCode;
}

/// Event indicating that a Form has been completed
class SubmitCompleteProgressEvent extends SubmitFormProgressEvent {
  /// Creates a new [SubmitCompleteProgressEvent] with the given [response] indicating the result of the Form Submission
  const SubmitCompleteProgressEvent(this.response) : super._();

  /// The Response from the Form Submission
  final Response? response;

  @override
  String toString() {
    return 'SubmitCompleteProgressEvent(response: ${response?.statusCode}:${response?.body})';
  }

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is SubmitCompleteProgressEvent &&
          response?.body == other.response?.body &&
          response?.statusCode == other.response?.statusCode;

  @override
  int get hashCode => Object.hash(response?.statusCode, response?.body);
}

/// Event indicating that a Form Submission has failed
class ErrorProgressEvent extends SubmitFormProgressEvent {
  /// Creates a new [ErrorProgressEvent] with the given [error]
  const ErrorProgressEvent(this.error) : super._();

  /// The Error that occurred
  final dynamic error;

  @override
  String toString() {
    return 'ErrorProgressEvent(error: $error)';
  }

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorProgressEvent && error == other.error;

  @override
  int get hashCode => error.hashCode;
}
