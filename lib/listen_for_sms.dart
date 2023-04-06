import 'dart:async';

import 'package:flutter/services.dart';

class ListenForSms {
  static ListenForSms? _singleton;
  static const MethodChannel _channel = MethodChannel('listen_for_sms');
  final StreamController<String> _code = StreamController.broadcast();

  factory ListenForSms() => _singleton ??= ListenForSms._();

  Stream<String> get code => _code.stream;

  ListenForSms._() {
    _channel.setMethodCallHandler(_didReceive);
  }

  Future<void> _didReceive(MethodCall method) async {
    if (method.method == 'smscode') {
      _code.add(method.arguments);
    }
  }

  Future<bool?> startListening(
      {String smsCodeRegexPattern = '\\d{4, 6}'}) async {
    bool? result = await _channel.invokeMethod('startListening',
        <String, String>{'smsCodeRegexPattern': smsCodeRegexPattern});
    return result;
  }

  Future<bool?> stopListening() async {
    bool? result = await _channel.invokeMethod('stopListening');
    return result;
  }
}
