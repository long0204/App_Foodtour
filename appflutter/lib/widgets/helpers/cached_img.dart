// // ignore_for_file: depend_on_referenced_packages

// import 'package:file/file.dart';
// import 'package:file/local.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// // ignore: implementation_imports
// import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart'
//     as c;
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';

// import '../../../config/constants/strings.dart';

// class CustomImageCache extends WidgetsFlutterBinding {
//   @override
//   ImageCache createImageCache() {
//     final ImageCache imageCache = super.createImageCache();
//     // Set your image cache size
//     imageCache.maximumSizeBytes = 1024 * 1024 * 100; // 100 MB
//     return imageCache;
//   }
// }

// class CustomCacheManager {
//   static CacheManager instance = CacheManager(
//     Config(
//       Strings.kCustomCacheKey,
//       stalePeriod: const Duration(days: 99),
//       maxNrOfCacheObjects: 100,
//       repo: JsonCacheInfoRepository(databaseName: Strings.kCustomCacheKey),
//       fileSystem: IOFileSystem(Strings.kCustomCacheKey),
//       fileService: HttpFileService(),
//     ),
//   );
// }

// class IOFileSystem implements c.FileSystem {
//   final Future<Directory> _fileDir;

//   IOFileSystem(String key) : _fileDir = createDirectory(key);

//   static Future<Directory> createDirectory(String key) async {
//     final baseDir = await getTemporaryDirectory();
//     final path = p.join(baseDir.path, key);

//     const fs = LocalFileSystem();
//     final directory = fs.directory(path);
//     await directory.create(recursive: true);
//     return directory;
//   }

//   @override
//   Future<File> createFile(String name) async {
//     return (await _fileDir).childFile(name);
//   }
// }
