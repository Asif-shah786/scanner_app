// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanner/generated/l10n.dart';
import 'package:scanner/modules/home/presentation/scanner/camera_icon_button.dart';
import 'package:scanner/modules/home/presentation/scanner/scanner_controller.dart';
import 'package:scanner/services/analytics/posthog.dart';
import 'package:scanner/services/navigation/route_url.dart';
import 'package:scanner/utils/pallets.dart';
import 'package:scanner/utils/snackbar_util.dart';

//
///
late List<CameraDescription> cameras;

const scannerMargin = 10.0;
const scannerAspectRatio = 4 / 2.5;

/// Camera example home widget.
class ScannerPage extends StatefulWidget {
  /// Default Constructor
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() {
    return _ScannerPageState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.cameraswitch;
    case CameraLensDirection.front:
      return Icons.cameraswitch;
    case CameraLensDirection.external:
      return Icons.cameraswitch;
  }
  // This enum is from a different package, so a new value could be added at
  // any time. The example should keep working if that happens.
  // ignore: dead_code
  return Icons.camera;
}

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

class _ScannerPageState extends State<ScannerPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;

  XFile? imageFile;
  XFile? videoFile;
  VoidCallback? videoPlayerListener;
  bool enableAudio = false;
  late AnimationController _flashModeControlRowAnimationController;

  late AnimationController _exposureModeControlRowAnimationController;
  final double _minAvailableZoom = 1;
  final double _maxAvailableZoom = 1;
  double _currentScale = 1;
  double _baseScale = 1;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  int _cameraIndex = -1;
  final camDirection = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ScanAnalytics.captureEvent('scan.start');

    if (cameras.any(
      (element) =>
          element.lensDirection == camDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
          (element) =>
              element.lensDirection == camDirection &&
              element.sensorOrientation == 90,
        ),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == camDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }

    _initCams();

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamCtrl();
    super.dispose();
  }

  dynamic _initCams() async {
    if (_cameraIndex != -1 && cameras.isNotEmpty) {
      await _initializeCameraController(cameras[_cameraIndex]);
    }
  }

  dynamic _disposeCamCtrl() async {
    try {
      await controller?.dispose();
    } on CameraException catch (_) {}
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      if (mounted) {
        // await _disposeCamCtrl();
      }
    } else if (state == AppLifecycleState.resumed) {
      await _initializeCameraController(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1500),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _cameraPreviewWidget(),
      ),
    );
  }

  Widget _getOverlay() {
    return ClipPath(
      clipper: InvertedClipper(),
      child: Container(
        color: Colors.black54,
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is
  /// not available).
  Widget _cameraPreviewWidget() {
    final cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const SizedBox();
    } else {
      return Consumer(
        builder: (context, ref, child) {
          ref.listen(scannerProvider, (previous, next) async {
            if (next is ScannerError) {
              imageFile = null;
              showErrorSnackBar(next.message);
              await controller?.resumePreview();
            }
          });
          return Stack(
            children: [
              _getCamPreview(),
              if (imageFile != null)
                Center(
                  child: Image.file(
                    File(imageFile!.path),
                  ),
                ),
              _getOverlay(),
              _controlsWidget(context, ref),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).placeCardInsideRectangle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: scannerAspectRatio,
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      margin: const EdgeInsets.fromLTRB(scannerMargin, 0, scannerMargin, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Pallets.scheme.primary, width: 3),
                      ),
                      // child: Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Widget _getCamPreview() {
    final size = MediaQuery.of(context).size;

    if (controller != null && controller!.value.isInitialized) {
      var scale = size.aspectRatio * (controller?.value.aspectRatio ?? 0.0);
      if (scale < 1) {
        scale = 1 / scale;
      }
      return Transform.scale(
        key: ValueKey(_cameraIndex),
        scale: scale,
        child: Center(
          child: Listener(
            onPointerDown: (_) => _pointers++,
            onPointerUp: (_) => _pointers--,
            child: CameraPreview(
              controller!,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onScaleStart: _handleScaleStart,
                    onScaleUpdate: _handleScaleUpdate,
                    onTapDown: (details) async =>
                        onViewFinderTap(details, constraints),
                    // child:
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }

    // to prevent scaling down, invert the value
  }

  Container _controlsWidget(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
        // horizontal: 32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    child: CameraIconButton(
                      key: ValueKey(
                        _getFlashModeIcon(
                          controller?.value.flashMode,
                        ),
                      ),
                      iconData: _getFlashModeIcon(
                        controller?.value.flashMode,
                      ),
                      onTap: () async {
                        if (controller != null) {
                          await onSetFlashModeTap(
                            FlashMode.off,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              CameraIconButton(
                iconData: Icons.close,
                onTap: () {
                  context.pop();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CameraIconButton(
                iconData: Icons.filter,

                onTap: () async {
                  ScanAnalytics.captureEvent('scan.camera.gallery');

                  await ImagePicker()
                      .pickImage(source: ImageSource.gallery)
                      .then((value) {
                    if (value != null) {
                      imageFile = XFile(value.path);

                      _onScanned(
                        ref,
                        File(imageFile!.path),
                        shouldCrop: false,
                      );
                      setState(() {});
                    }
                  });
                },
                // onTap: () async => ImageManager()
                //     .pickImageFromGallery()
                //     .then(
                //       (value) => context.pop(value),
                //     ),
              ),
              const SizedBox(
                width: 70,
              ),
              Stack(
                children: [
                  CaptureButton(
                    onTap: () async {
                      if (ref.watch(scannerProvider) is ScannerLoading) {
                        return;
                      }
                      if (controller != null &&
                          controller!.value.isInitialized &&
                          !controller!.value.isRecordingVideo) {
                        await onTakePictureButtonPressed(ref);
                      }
                    },
                  ),
                  if (ref.watch(scannerProvider) is ScannerLoading)
                    const Positioned.fill(
                      child: Center(
                        child: Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                width: 70,
              ),
              CameraIconButton(
                iconData: Icons.cameraswitch,
                onTap: _onCameraSwitch,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onScanned(
    WidgetRef ref,
    File image, {
    bool shouldCrop = true,
  }) async {
    await controller?.pausePreview().then(
          (value) => SnackBarUtil.showSnackBar(
            context,
            'Scanning your card... (this can take some seconds)',
          ),
        );

    await ref
        .read(scannerProvider.notifier)
        .scanCard(image, shouldCrop: shouldCrop)
        .then((value) {
      if (value != null) {
        context
          ..pop()
          ..pushNamed(
            PageUrl.details,
            queryParameters: {
              'id': value,
            },
          );
      }
    });
    // await Future.delayed(Duration(seconds: 2));
  }

  Future<void> _onCameraSwitch() async {
    if (cameras.isEmpty) {
      return;
    }

    CameraDescription newCamera;
    final currentCameraIndex =
        cameras.indexWhere((camera) => camera == cameras[_cameraIndex]);

    if (currentCameraIndex != -1) {
      var nextCameraIndex = (currentCameraIndex + 1) % cameras.length;
      while (cameras[nextCameraIndex].lensDirection ==
          cameras[currentCameraIndex].lensDirection) {
        nextCameraIndex = (nextCameraIndex + 1) % cameras.length;
      }
      newCamera = cameras[nextCameraIndex];
      _cameraIndex = nextCameraIndex;
    } else {
      newCamera = cameras[0];
    }

    ScanAnalytics.captureEvent('scan.camera.switch');

    await onNewCameraSelected(newCamera);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  IconData _getFlashModeIcon(FlashMode? mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.torch:
        return Icons.flashlight_on;
      case null:
        return Icons.flash_off;
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text(message)));
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> onViewFinderTap(
    TapDownDetails details,
    BoxConstraints constraints,
  ) async {
    if (controller == null) {
      return;
    }

    final cameraController = controller!;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    try {
      await cameraController.setExposurePoint(offset);
      await cameraController.setFocusPoint(offset);
    } on CameraException catch (_) {}
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      return controller!.setDescription(cameraDescription);
    } else {
      return _initializeCameraController(cameraDescription);
    }
  }

  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    final cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.max,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
          'Camera error ${cameraController.value.errorDescription}',
        );
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onTakePictureButtonPressed(WidgetRef ref) async {
    await takePicture().then((file) async {
      ScanAnalytics.captureEvent('scan.camera');

      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          await _onScanned(ref, File(file.path));
        }
      }
    });
  }

  Future<void> onSetFlashModeTap(FlashMode mode) async {
    await cycleFlashMode().then((_) {
      ScanAnalytics.captureEvent('scan.camera.flashlight');

      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> cycleFlashMode() async {
    var currentModeIndex = 0;
    final flashModes = <FlashMode>[
      FlashMode.auto,
      FlashMode.always,
      FlashMode.off,
    ];

    if (Platform.isAndroid) {
      flashModes.add(FlashMode.torch);
    }

    final currentIndex = flashModes.indexWhere(
      (mode) => mode == controller?.value.flashMode,
    );

    if (currentIndex != -1) {
      currentModeIndex = (currentIndex + 1) % flashModes.length;
    } else {
      currentModeIndex = 0; // If not found, default to the first flash mode
    }
    await setFlashMode(flashModes[currentModeIndex]);
  }

  Future<XFile?> takePicture() async {
    final cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

///CaptureButton

class CaptureButton extends StatefulWidget {
  ///CaptureButton
  const CaptureButton({
    super.key,
    this.onTap,
  });

  ///ONTAP
  final VoidCallback? onTap;

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
        widget.onTap?.call();
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: isPressed ? 45 : 50,
            height: isPressed ? 45 : 50,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Transform.scale(
              scale: isPressed ? 0.9 : 1.0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///InvertedClipper
class InvertedClipper extends CustomClipper<Path> {
  ///

  ///InvertedClipper
  @override
  Path getClip(Size size) {
    // Define the aspect ratio for the inner rectangle
    const boxAspectRatio = scannerAspectRatio; // Replace this with your desired aspect ratio

    double boxWidth;
    double boxHeight;
    if (size.width / size.height > boxAspectRatio) {
      boxHeight = size.height;
      boxWidth = boxHeight * boxAspectRatio;
    } else {
      boxWidth = size.width;
      boxHeight = boxWidth / boxAspectRatio;
    }

    final left = (size.width - boxWidth) / 2;
    const cornerRadius = 10.0;
    final top = (size.height - boxHeight) / 2;
    final right = left + boxWidth;
    final bottom = top + boxHeight;
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromLTRBAndCorners(
          left + 10,
          top,
          right - 10,
          bottom,
          topLeft: const Radius.circular(cornerRadius),
          topRight: const Radius.circular(cornerRadius),
          bottomLeft: const Radius.circular(cornerRadius),
          bottomRight: const Radius.circular(cornerRadius),
        ),
      )
      // ..addRect(
      //   Rect.fromCenter(
      //     center: Offset(sizeidth / 2, sizeeight / 2),
      //     width: 300,
      //     height: 200,
      //   ),
      // )
      // ..addOval(Rect.fromCircle(
      //     center: Offset(sizeidth - 44, sizeeight - 44), radius: 40))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
