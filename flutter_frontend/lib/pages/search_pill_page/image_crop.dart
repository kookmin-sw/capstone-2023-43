import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Rectangle<int> getCropRect({
  required int sourceWidth,
  required int sourceHeight,
  required double aspectRatio,
}) {
  var left = 0;
  var top = 0;
  var width = sourceWidth;
  var height = sourceHeight;

  if (aspectRatio < sourceWidth / sourceHeight) {
    // crop horizontally, from width
    width = (sourceHeight * aspectRatio).toInt(); // set new cropped width
    left = (sourceWidth - width) ~/ 2;
  } else if (aspectRatio > sourceWidth / sourceHeight) {
    // crop vertically, from height
    height = sourceWidth ~/ aspectRatio; // set new cropped height
    top = (sourceHeight - height) ~/ 2;
  }
  // else source and destination have same aspect ratio

  return Rectangle<int>(left, top, width, height);
}

img.Image centerCrop(img.Image source, double aspectRatio) {
  final rect = getCropRect(
      sourceWidth: source.width,
      sourceHeight: source.height,
      aspectRatio: aspectRatio);

  return img.copyCrop(source, (source.width / 2).toInt() - 224,
      (source.height / 2).toInt() - 224, 448, 448);
}

img.Image cropAndResize(img.Image src, double aspectRatio, int width) {
  final cropped = centerCrop(src, aspectRatio);
  // final croppedResized = img.copyResize(
  //   cropped,
  //   width: width,
  //   interpolation: img.Interpolation.average,
  // );
  return cropped;
}

Future<File> cropAndResizeFile({
  required File file,
  required double aspectRatio,
  required int width,
  int quality = 100,
}) async {
  final tempDir = await getTemporaryDirectory();
  final destPath = p.join(
    tempDir.path,
    p.basenameWithoutExtension(file.path) + '_compressed.jpg',
  );

  return compute<_CropResizeArgs, File>(
      _cropAndResizeFile,
      _CropResizeArgs(
        sourcePath: file.path,
        destPath: destPath,
        aspectRatio: aspectRatio,
        width: width,
        quality: quality,
      ));
}

class _CropResizeArgs {
  final String sourcePath;
  final String destPath;
  final double aspectRatio;
  final int width;
  final int quality;
  _CropResizeArgs({
    required this.sourcePath,
    required this.destPath,
    required this.aspectRatio,
    required this.width,
    required this.quality,
  });
}

Future<File> _cropAndResizeFile(_CropResizeArgs args) async {
  final image =
      await img.decodeImage(await File(args.sourcePath).readAsBytes());

  if (image == null) throw Exception('Unable to decode image from file');

  final croppedResized = cropAndResize(image, args.aspectRatio, args.width);
  // Encoding image to jpeg to compress the image.
  final jpegBytes = img.encodeJpg(croppedResized, quality: args.quality);

  final croppedImageFile = await File(args.destPath).writeAsBytes(jpegBytes);
  return croppedImageFile;
}
