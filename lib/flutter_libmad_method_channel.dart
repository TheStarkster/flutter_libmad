import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_libmad_platform_interface.dart';

/// An implementation of [FlutterLibmadPlatform] that uses method channels.
class MethodChannelFlutterLibmad extends FlutterLibmadPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_libmad');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
