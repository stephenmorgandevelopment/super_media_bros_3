// class ImageBloc extends MediaBloc {
//   @override
//   final ImageRepo repo;
//
//   ImageBloc(mediaList, {this.repo = const ImageRepo()})
//       : super(mediaList, Type.IMAGE);
//
//   Future<Uint8List?> getThumbnail(int index) async {
//     return await repo.getThumbnailBytes(mediaList[index]);
//   }
//
//   Future<MediaResource> getMedia(int index) async {
//     // _currentIndex = index;
//     MediaData mediaData = mediaList[index];
//
//     // Uint8List? bytes = await repo.getBytes(mediaList[index]);
//     // Uint8List bytes = Uint8List(int.parse(mediaData.metadata["_size"]!));
//     // repo.getBytes(mediaData).listen(
//     //       (data) => {bytes.addAll(data!)},
//     //       // onDone: () {
//     //       //   if (bytes != null) {
//     //       //     log("ImageScreenBloc-ln33: Made with ${bytes.lengthInBytes} bytes.");
//     //       //   }
//     //       // },
//     //       // onError: () => Future.error("unDone..")
//     // );
//
//
//
//     repo.getBytes(mediaData);
//
//     return MediaResource.withBytes(mediaList[index], bytes);
//
//     // return MediaResource(mediaList[index], null, null);
//     return Future.error("Unexpected IO error, check permissions.");
//
//     // MediaResource image;
//     // try {
//     //
//     // } catch(e) {
//     //   log("ImageScreenBloc-ln31: Null Bytes and Null File passed to ImageResource.");
//     // }
//   }
//
//   void onData(Uint8List? data) => if(data != null) {
//     bytes.addAll(data);
//   }
// }
