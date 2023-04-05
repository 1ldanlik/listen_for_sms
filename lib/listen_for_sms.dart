
import 'listen_for_sms_platform_interface.dart';

class ListenForSms {
  Stream smsStream() {
    return ListenForSmsPlatform.instance.smsStream();
  }
}
