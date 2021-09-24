/// Class for representing messages send between ApptiveGrid Web an the Apptive
class ApptiveMessage {
  /// Creates a new [ApptiveMessage] with [message]
  const ApptiveMessage({
    required this.message,
  });

  /// Deserializes a [ApptiveMessage] from a [json] object
  factory ApptiveMessage.fromJson(dynamic json) {
    if (json is Map && json.containsKey('message')) {
      return ApptiveMessage(
        message: json['message'],
      );
    } else {
      throw ArgumentError('$json is not a valid ApptiveMessage');
    }
  }

  /// The [message] send
  final String message;

  @override
  String toString() {
    return 'ApptiveMessage(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveMessage && other.message == message;
  }

  @override
  int get hashCode => toString.hashCode;
}
