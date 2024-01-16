import 'dart:developer';
import 'package:image/image.dart' as img;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './text_recognizer_painter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';

// typedef OnCaptureImageCallback = void Function(Uint8List imageBytes);
typedef CaptureImageCallback = void Function(Uint8List imageBytes);

class ScalableOCR extends StatefulWidget {
  const ScalableOCR({
    Key? key,
    this.boxLeftOff = 4,
    this.boxRightOff = 4,
    this.boxBottomOff = 2.7,
    this.boxTopOff = 2.7,
    this.boxHeight,
    required this.getScannedText,
    this.getRawData,
    this.paintboxCustom,
    required this.onCaptureImage, // Add this line
  }) : super(key: key);

  final CaptureImageCallback? onCaptureImage;

  /// Offset on recalculated image left
  final double boxLeftOff;

  /// Offset on recalculated image bottom
  final double boxBottomOff;

  /// Offset on recalculated image right
  final double boxRightOff;

  /// Offset on recalculated image top
  final double boxTopOff;

  /// Height of narowed image
  final double? boxHeight;

  /// Function to get scanned text as a string
  final Function getScannedText;

  /// Get raw data from scanned image
  final Function? getRawData;

  /// Narower box paint
  final Paint? paintboxCustom;

  // final OnCaptureImageCallback onCaptureImage; // Add this line

  @override
  ScalableOCRState createState() => ScalableOCRState();
}

class ScalableOCRState extends State<ScalableOCR> {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final cameraPrev = GlobalKey();
  final thePainter = GlobalKey();
  // final CaptureImageCallback? onCaptureImage;

  final bool _canProcess = true;
  bool _isBusy = false;
  bool converting = false;
  CustomPaint? customPaint;
  // String? _text;
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  double zoomLevel = 3.0, minZoomLevel = 0.0, maxZoomLevel = 10.0;
  // Counting pointers (number of user fingers on screen)
  final double _minAvailableZoom = 1.0;
  final double _maxAvailableZoom = 10.0;
  double _currentScale = 3.0;
  double _baseScale = 3.0;
  double maxWidth = 0;
  double maxHeight = 0;
  String convertingAmount = "";

  @override
  void initState() {
    super.initState();
    startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeH = MediaQuery.of(context).size.height / 100;
    return Padding(
        padding: EdgeInsets.all(sizeH * 3),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _controller == null ||
                      _controller?.value == null ||
                      _controller?.value.isInitialized == false
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: sizeH * 19,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(17),
                      ),
                    )
                  : _liveFeedBody(),
              SizedBox(height: sizeH * 2),
            ],
          ),
        ));
  }

  // Body of live camera stream
  Widget _liveFeedBody() {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text('Tap a camera');
    } else {
      const double previewAspectRatio = 0.5;
      return SizedBox(
        height: widget.boxHeight ?? MediaQuery.of(context).size.height / 5,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: SizedBox(
                height:
                    widget.boxHeight ?? MediaQuery.of(context).size.height / 5,
                key: cameraPrev,
                child: AspectRatio(
                  aspectRatio: 1 / previewAspectRatio,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      child: Transform.scale(
                        scale: cameraController.value.aspectRatio /
                            previewAspectRatio,
                        child: Center(
                          child: CameraPreview(cameraController, child:
                              LayoutBuilder(builder: (BuildContext context,
                                  BoxConstraints constraints) {
                            maxWidth = constraints.maxWidth;
                            maxHeight = constraints.maxHeight;

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onScaleStart: _handleScaleStart,
                              onScaleUpdate: _handleScaleUpdate,
                              onTapDown: (TapDownDetails details) =>
                                  onViewFinderTap(details, constraints),
                            );
                          })),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (customPaint != null)
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                maxWidth = constraints.maxWidth;
                maxHeight = constraints.maxHeight;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  onTapDown: (TapDownDetails details) =>
                      onViewFinderTap(details, constraints),
                  child: customPaint!,
                );
              }),
          ],
        ),
      );
    }
  }

  // Start camera stream function
  Future startLiveFeed() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.max);
    final camera = _cameras[0];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            log('User denied camera access.');
            break;
          default:
            log('Handle other errors.');
            break;
        }
      }
    });
  }

  // Process image from camera stream
  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = _cameras[0];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    processImage(inputImage);
  }

  // Scale image
  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  // Handle scale update
  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (_controller == null) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await _controller!.setZoomLevel(_currentScale);
  }

  // Focus image
  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (_controller == null) {
      return;
    }

    final CameraController cameraController = _controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  // Stop camera live stream
  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  // Process image
  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null &&
        cameraPrev.currentContext != null) {
      final RenderBox renderBox =
          cameraPrev.currentContext?.findRenderObject() as RenderBox;

      var painter = TextRecognizerPainter(
          recognizedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
          renderBox, (value) {
        widget.getScannedText(value);
      }, getRawData: (value) {
        if (widget.getRawData != null) {
          widget.getRawData!(value);
        }
      },
          boxBottomOff: widget.boxBottomOff,
          boxTopOff: widget.boxTopOff,
          boxRightOff: widget.boxRightOff,
          boxLeftOff: widget.boxRightOff,
          paintboxCustom: widget.paintboxCustom);

      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    Future.delayed(const Duration(milliseconds: 900)).then((value) {
      if (!converting) {
        _isBusy = false;
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> handleCaptureImage() async {
    if (_controller == null) {
      return;
    }

    try {
      await _controller!.setFlashMode(FlashMode.off);
      final XFile imageFile = await _controller!.takePicture();
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // Calculate the crop coordinates based on the box position
      double boxLeft = widget.boxLeftOff;
      double boxTop = widget.boxTopOff;
      double boxRight = 1.0 - widget.boxRightOff;
      double boxBottom = 1.0 - widget.boxBottomOff;

      // Clamp box coordinates to ensure they are within valid range
      boxLeft = boxLeft.clamp(0.0, 1.0);
      boxTop = boxTop.clamp(0.0, 1.0);
      boxRight = boxRight.clamp(0.0, 1.0);
      boxBottom = boxBottom.clamp(0.0, 1.0);

      // Ensure left is less than right and top is less than bottom
      if (boxLeft > boxRight) {
        final temp = boxLeft;
        boxLeft = boxRight;
        boxRight = temp;
      }

      if (boxTop > boxBottom) {
        final temp = boxTop;
        boxTop = boxBottom;
        boxBottom = temp;
      }

      // Get the aspect ratio of the camera preview
      double previewAspectRatio = _controller!.value.previewSize!.height /
          _controller!.value.previewSize!.width;

      // int imageWidth = _controller!.value.previewSize!.width as int;
      // int imageHeight = _controller!.value.previewSize!.height as int;
      int imageWidth = _controller!.value.previewSize!.width.toInt();
      int imageHeight = _controller!.value.previewSize!.height.toInt();

      // Calculate the adjusted crop coordinates based on the aspect ratio
      int left = (boxLeft * imageWidth).toInt();
      int top = (boxTop * imageHeight).toInt();
      int right = (boxRight * imageWidth).toInt();
      int bottom = (boxBottom * imageHeight).toInt();

      // Adjust the crop coordinates to match the aspect ratio
      double cropAspectRatio = (right - left) / (bottom - top);
      if (cropAspectRatio > previewAspectRatio) {
        // Adjust top and bottom to match the aspect ratio
        int newHeight = (cropAspectRatio * (right - left)).toInt();
        int offsetY = ((bottom - top - newHeight) / 2).toInt();
        top += offsetY;
        bottom = top + newHeight;
      } else {
        // Adjust left and right to match the aspect ratio
        int newWidth = ((bottom - top) / cropAspectRatio).toInt();
        int offsetX = ((right - left - newWidth) / 2).toInt();
        left += offsetX;
        right = left + newWidth;
      }

      print('Image dimensions: $imageWidth x $imageHeight');
      print(
          'Box coordinates: left=$left, top=$top, right=$right, bottom=$bottom');

      // Convert Uint8List to Image object
      img.Image? image = img.decodeImage(imageBytes);

      // Crop the image
      img.Image croppedImage = img.copyCrop(
        image!,
        x: left,
        y: top,
        width: right - left,
        height: bottom - top,
      );

      // Convert the cropped image back to Uint8List
      final Uint8List croppedImageBytes =
          Uint8List.fromList(img.encodePng(croppedImage));

      widget.onCaptureImage!(croppedImageBytes);
    } catch (e) {
      print('Error capturing image: $e');
    }
  }
}
