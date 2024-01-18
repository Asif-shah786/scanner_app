import 'dart:io';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/modules/home/presentation/scanner/scanner_controller.dart';
import 'package:scanner/modules/home/presentation/scanner/scanner_page.dart';

///APPDIR
late final Directory appDir;

///Function to saveCaptureedImage
Future<File> saveCapturedImage(File capturedImage, {bool crop = true}) async {
  final imagePath =
      '${appDir.path}/${DateTime.now().microsecondsSinceEpoch}${capturedImage.path.split('/').last}';

  if (crop) {
    final inputImage = await img.decodeImageFile(capturedImage.path);

    final scanWidth = (inputImage!.width - scannerMargin * 2).round();
    final scanHeight = (scanWidth / scannerAspectRatio).round();

    final cmd = img.Command()
      // Decode the image file at the given path
      ..decodeImageFile(capturedImage.path)
      ..copyCrop(
        x: ((inputImage.width / 2) - scanWidth + scannerMargin).round(),
        y: ((inputImage.height - scanHeight) / 2).round(),
        width: scanWidth,
        height: scanHeight,
      )
      ..writeToFile(imagePath);

    await cmd.executeThread();
  } else {
    ////Defualt save behavoir{}
    final newImage = File(capturedImage.path);
    await newImage.copy(imagePath).then((_) => true).catchError((_) => false);
  }

  return File(imagePath);
}
