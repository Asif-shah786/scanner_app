import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scanner/services/image/image_saver.dart';

Directory? mockAppDir;

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

void main() {
  setUp(() {
    mockAppDir = MockDirectory();
    appDir = mockAppDir!;
  });

  test('saveCapturedImage - image saved successfully', () async {
    final capturedImage = MockFile();

    when(() => mockAppDir!.path).thenReturn('/mocked/app/path');
    when(() => capturedImage.path).thenReturn('/path/to/capturedImage.jpg');
    when(() => capturedImage.copy(any()))
        .thenAnswer((_) async => capturedImage);

    final savedImage = await saveCapturedImage(capturedImage);

    expect(savedImage.path, contains('/mocked/app/path/'));
  });

  test('saveCapturedImage - image save failed', () async {
    final capturedImage = MockFile();

    when(() => mockAppDir!.path).thenReturn('/mocked/app/path');
    when(() => capturedImage.path).thenReturn('/path/to/capturedImage.jpg');
    when(() => capturedImage.copy(any()))
        .thenAnswer((_) => throw const FileSystemException());

    final savedImage = await saveCapturedImage(capturedImage);

    expect(savedImage, isNotNull);
  });
}
