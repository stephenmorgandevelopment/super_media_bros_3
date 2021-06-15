import 'package:super_media_bros_3/repo/media_repo.dart';

class ImageRepo extends MediaRepo {
  const ImageRepo();

  // @override
  // Stream<Uint8List?> getBytes(MediaData media) async* {
  //   if (media.isLocal()) {
  //     yield await ImageAccess.getImageAsBytes(media);
  //   } else {}
  // }

  // Future<Uint8List?> getThumbnailBytes(MediaData media) async {
  //   if (media.isLocal()) {
  //     return getLocalThumbnailBytes(media);
  //   } else {}
  // }

  // Future<Uint8List?> getLocalThumbnailBytes(MediaData media) async {
  //   return MediaAccess.getThumbnail(media);
  // }

  // @override
  // File? getLocalFile(MediaData media) {
  //   String? filePath = media.metadata['_data'];
  //   String? relativePath = media.metadata['relative_path'];
  //
  //   File? mediaFile;
  //   if (filePath != null) {
  //     mediaFile = File(filePath);
  //   } else if (relativePath != null) {
  //     log("Used relative path for ${media.metadata}");
  //     mediaFile = File(relativePath);
  //   }
  //   return mediaFile;
  // }
}
