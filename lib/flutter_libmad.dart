import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef DecodeCallback = Void Function(Pointer<Int16>, Int32);
typedef DecodeFileC = Void Function(Pointer<Utf8>, Pointer<NativeFunction<DecodeCallback>>);
typedef DecodeFileDart = void Function(Pointer<Utf8>, Pointer<NativeFunction<DecodeCallback>>);
typedef PcmDataCallback = void Function(List<int> pcmData);
PcmDataCallback? globalPcmDataCallback;

class FlutterLibmad {
  late DynamicLibrary _lib;
  late DecodeFileDart _decodeFile;
  final PcmDataCallback onPcmData;

  static void _decodeCallback(Pointer<Int16> pcm, int length) {
    final List<int> pcmList = pcm.asTypedList(length);
    globalPcmDataCallback?.call(pcmList);
  }
  FlutterLibmad({ required this.onPcmData }) {
    globalPcmDataCallback = onPcmData;

    _lib = Platform.isAndroid ? DynamicLibrary.open("libdecoder.so") : DynamicLibrary.process();
    _decodeFile = _lib.lookupFunction<DecodeFileC, DecodeFileDart>('decode_file');
  }

  void decode(String filePath) {
    final nativeCallback = Pointer.fromFunction<DecodeCallback>(_decodeCallback);
    final cFilePath = filePath.toNativeUtf8();
    _decodeFile(cFilePath, nativeCallback);
    calloc.free(cFilePath);
  }
}
