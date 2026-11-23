import 'dart:io';

import 'package:path/path.dart' as p;

/// A picked image/document that will be sent as a multipart file part.
class UploadFile {
  UploadFile({
    required this.path,
    required this.name,
    required this.size,
    required this.mimeType,
  });

  final String path;
  final String name;
  final int size;
  final String mimeType;

  bool get isImage =>
      mimeType == 'image/jpeg' ||
      mimeType == 'image/png' ||
      mimeType == 'image/webp';

  static String mimeFromName(String name) {
    switch (p.extension(name).toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  static Future<UploadFile> fromPath(String path, {String? name}) async {
    final file = File(path);
    final fileName = name ?? p.basename(path);
    return UploadFile(
      path: path,
      name: fileName,
      size: await file.length(),
      mimeType: mimeFromName(fileName),
    );
  }
}
