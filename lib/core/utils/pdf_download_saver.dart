import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Saves a PDF where the user can find it (Downloads on Android/desktop).
class PdfDownloadSaver {
  static const _channel = MethodChannel('dental_app/files');

  static Future<void> save({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final safeName = fileName.toLowerCase().endsWith('.pdf')
        ? fileName
        : '$fileName.pdf';

    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod<String>('savePdfToDownloads', {
          'fileName': safeName,
          'bytes': bytes,
        });
        return;
      } on MissingPluginException {
        // App was not fully rebuilt after adding native code.
        await _saveWithFileSaver(safeName, bytes);
        return;
      }
    }

    if (Platform.isIOS) {
      await _saveWithFileSaver(safeName, bytes);
      return;
    }

    final downloads = await getDownloadsDirectory();
    if (downloads == null) {
      throw Exception('downloads folder unavailable');
    }
    await File('${downloads.path}/$safeName').writeAsBytes(bytes, flush: true);
  }

  static Future<void> _saveWithFileSaver(String safeName, Uint8List bytes) {
    final baseName = safeName.replaceAll(
      RegExp(r'\.pdf$', caseSensitive: false),
      '',
    );
    return FileSaver.instance.saveFile(
      name: baseName.isEmpty ? 'report' : baseName,
      bytes: bytes,
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
  }
}
