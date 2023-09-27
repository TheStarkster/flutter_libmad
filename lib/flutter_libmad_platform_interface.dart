import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_libmad_method_channel.dart';

abstract class FlutterLibmadPlatform extends PlatformInterface {
  /// Constructs a FlutterLibmadPlatform.
  FlutterLibmadPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLibmadPlatform _instance = MethodChannelFlutterLibmad();

  /// The default instance of [FlutterLibmadPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLibmad].
  static FlutterLibmadPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLibmadPlatform] when
  /// they register themselves.
  static set instance(FlutterLibmadPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
