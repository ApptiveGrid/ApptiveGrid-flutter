import 'package:flutter/cupertino.dart';

class ApptiveMessage {
  const ApptiveMessage({
    required this.message,});

  factory ApptiveMessage.fromJson(dynamic json) {
    if (json is Map && json.containsKey('message')) {
      return ApptiveMessage(
        message: json['message'],);
    } else {
      throw ArgumentError('$json is not a valid ApptiveMessage');
    }
  }

  final String message;

  @override
  String toString() {
    return 'ApptiveMessage(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveMessage &&
        other.message == message;
  }

  @override
  int get hashCode => toString.hashCode;
}