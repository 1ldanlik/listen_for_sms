import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'listen_for_sms_platform_interface.dart';

/// An implementation of [ListenForSmsPlatform] that uses method channels.
class MethodChannelListenForSms extends ListenForSmsPlatform {
  /// The method channel used to interact with the native platform.
  // @visibleForTesting
  // final methodChannel = const MethodChannel('listen_for_sms');
  final eventChannel = const EventChannel('com.example.app/smsStream');

  // @override
  // Future<String?> getPlatformVersion() async {
  //   final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
  //   return version;
  // }
  @override
  Stream smsStream() async* {
    eventChannel.receiveBroadcastStream();
  }
}
