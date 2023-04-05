import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'listen_for_sms_method_channel.dart';

abstract class ListenForSmsPlatform extends PlatformInterface {
  /// Constructs a ListenForSmsPlatform.
  ListenForSmsPlatform() : super(token: _token);

  static final Object _token = Object();

  static ListenForSmsPlatform _instance = MethodChannelListenForSms();

  /// The default instance of [ListenForSmsPlatform] to use.
  ///
  /// Defaults to [MethodChannelListenForSms].
  static ListenForSmsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ListenForSmsPlatform] when
  /// they register themselves.
  static set instance(ListenForSmsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream smsStream() async* {
    // throw Exception();
  }

  // Future<String?> getPlatformVersion() {
  //   throw UnimplementedError('platformVersion() has not been implemented.');
  // }
}
