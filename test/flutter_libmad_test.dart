import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_libmad/flutter_libmad.dart';
import 'package:flutter_libmad/flutter_libmad_platform_interface.dart';
import 'package:flutter_libmad/flutter_libmad_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLibmadPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLibmadPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLibmadPlatform initialPlatform = FlutterLibmadPlatform.instance;

  test('$MethodChannelFlutterLibmad is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLibmad>());
  });

  test('getPlatformVersion', () async {
    FlutterLibmad flutterLibmadPlugin = FlutterLibmad();
    MockFlutterLibmadPlatform fakePlatform = MockFlutterLibmadPlatform();
    FlutterLibmadPlatform.instance = fakePlatform;

    expect(await flutterLibmadPlugin.getPlatformVersion(), '42');
  });
}
