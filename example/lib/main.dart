import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libmad/flutter_libmad.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late FlutterLibmad _flutterLibmadPlugin;

  Future<String> _loadAsset() async {
    final ByteData data = await rootBundle.load('assets/sample.mp3');
    final List<int> bytes = data.buffer.asUint8List();
    final String tempPath = (await getTemporaryDirectory()).path;
    final String filePath = '$tempPath/sample.mp3';
    final File tempFile = File(filePath);
    await tempFile.writeAsBytes(bytes, flush: true);

    return filePath;
  }

  @override
  void initState() {
    super.initState();
    _flutterLibmadPlugin = FlutterLibmad(onPcmData: (List<int> pcmData) {

      // here you can do whatever you wanna do with pcm data...
      log(pcmData.toString(), name: "PCM Data");
    });

    _loadAsset()
    .then((value) {
      //Pass the path of the file (mp3) which is needed to be decoded...
      _flutterLibmadPlugin.decode(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Libmad example app'),
        ),
        body: const Center(
          child: Text('Check Your Logs'),
        ),
      ),
    );
  }
}
