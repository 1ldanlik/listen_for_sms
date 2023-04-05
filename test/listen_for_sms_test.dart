import 'package:flutter_test/flutter_test.dart';
import 'package:listen_for_sms/listen_for_sms.dart';
import 'package:listen_for_sms/listen_for_sms_platform_interface.dart';
import 'package:listen_for_sms/listen_for_sms_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockListenForSmsPlatform
    with MockPlatformInterfaceMixin
    implements ListenForSmsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ListenForSmsPlatform initialPlatform = ListenForSmsPlatform.instance;

  test('$MethodChannelListenForSms is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelListenForSms>());
  });

  test('getPlatformVersion', () async {
    ListenForSms listenForSmsPlugin = ListenForSms();
    MockListenForSmsPlatform fakePlatform = MockListenForSmsPlatform();
    ListenForSmsPlatform.instance = fakePlatform;

    expect(await listenForSmsPlugin.getPlatformVersion(), '42');
  });
}
