
import 'flutter_libmad_platform_interface.dart';

class FlutterLibmad {
  Future<String?> getPlatformVersion() {
    return FlutterLibmadPlatform.instance.getPlatformVersion();
  }
}
