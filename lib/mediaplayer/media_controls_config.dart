import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class MediaControlsConfig {
  static List<String> _imageControlsAsJson = List.empty(growable: true);
  static List<String> get imageControlsAsJson => _imageControlsAsJson;

  static List<String> _videoControlsAsJson = List.empty(growable: true);
  static List<String> get videoControlsAsJson => _videoControlsAsJson;

  static List<String> _audioControlsAsJson = List.empty(growable: true);
  static List<String> get audioControlsAsJson => _audioControlsAsJson;

  static List<String> controlsAsJsonByType(Type type) {
    switch (type) {
      case Type.IMAGE:
        return _imageControlsAsJson;
      case Type.VIDEO:
        return _videoControlsAsJson;
      case Type.AUDIO:
        return _audioControlsAsJson;
    }
  }

  MediaControlsConfig();

  static Future<void> init() async {
    if (!isInitialized) {
      _imageControlsAsJson = await readConfigFromPersistence(Type.IMAGE);
      _videoControlsAsJson = await readConfigFromPersistence(Type.VIDEO);
      _audioControlsAsJson = await readConfigFromPersistence(Type.AUDIO);
    }
    log("MediaControlsConfig inititialized");
  }

  static bool get isInitialized => (_imageControlsAsJson.isNotEmpty ||
      _videoControlsAsJson.isNotEmpty ||
      _audioControlsAsJson.isNotEmpty);

  static void updateJson(Type type, List<String> groupsJson) {
    switch (type) {
      case Type.IMAGE:
        _imageControlsAsJson.clear();
        _imageControlsAsJson = groupsJson;
        break;
      case Type.VIDEO:
        _videoControlsAsJson.clear();
        _videoControlsAsJson = groupsJson;
        break;
      case Type.AUDIO:
        _audioControlsAsJson.clear();
        _audioControlsAsJson = groupsJson;
        break;
    }

    writeConfigToPersistence(type, groupsJson);
  }

  static Future<void> clearJson(Type type) async {
    switch (type) {
      case Type.IMAGE:
        _imageControlsAsJson.clear();
        break;
      case Type.VIDEO:
        _videoControlsAsJson.clear();
        break;
      case Type.AUDIO:
        _audioControlsAsJson.clear();
        break;
    }

    File file = await getFileByType(type);
    file.delete();
  }

  static Future<List<String>> readConfigFromPersistence(Type type) async {
    try {
      final file = await getFileByType(type);

      return await file.readAsLines();
    } catch (e) {
      final String error =
          "MediaControlsConfig - Read error: " + "${e.toString()}";
      log(error);
      return Future.error(error);
    }
  }

  static void writeConfigToPersistence(
      Type type, List<String> groupsJson) async {
    File file = await getFileByType(type);

    await file.writeAsString(groupsJson.join("\n"));
    log("MediaControlsConfig - Config written to persistence.");
  }

  static Future<File> getFileByType(Type type) async {
    switch (type) {
      case Type.IMAGE:
        return await _imageControlsFile;
      case Type.VIDEO:
        return await _videoControlsFile;
      case Type.AUDIO:
        return await _audioControlsFile;
    }
  }

  static Future<Directory> get _directory async {
    final directory = await getApplicationDocumentsDirectory();

    return directory;
  }

  static Future<File> get _imageControlsFile async {
    final path = (await _directory).path;
    return File('$path/imageControls.json');
  }

  static Future<File> get _videoControlsFile async {
    final path = (await _directory).path;
    return File('$path/videoControls.json');
  }

  static Future<File> get _audioControlsFile async {
    final path = (await _directory).path;
    return File('$path/audioControls.json');
  }
}
