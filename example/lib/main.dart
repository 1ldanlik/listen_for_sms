import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:listen_for_sms/listen_for_sms.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _listenForSmsPlugin = ListenForSms();
  String sms = '';

  @override
  void initState() {
    super.initState();

    // getPermission().then((value) {
    //   if (value) {
    //     _listenForSmsPlugin.smsStream().listen((value) {
    //       if(value == '') return;
    //
    //       sms = value.toString().substring(9, 15);
    //       print(value);
    //       print(':::');
    //       setState(() {});
    //     });
    //   }
    // }
    // );

    getPermission().then((value) {
      if (value) {
        _listenForSmsPlugin.startListening(smsCodeRegexPattern: '');
        _listenForSmsPlugin.code.listen((value) {
          if(value == '') return;

          sms = value.toString().substring(9, 15);
          print(value);
          print(':::');
          setState(() {});
        });
      }
    }
    );
  }

  Future<bool> getPermission() async {
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $sms\n'),
        ),
      ),
    );
  }
}
