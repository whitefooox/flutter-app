import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:search3/src/features/recognize/domain/entities/recognize_result.dart';
import 'package:search3/src/features/recognize/domain/usecases/recognize_image_use_case.dart';
import 'package:search3/src/features/recognize/presentation/presenter/input_image_presenter.dart';

final injector = Injector.appInstance;

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<StatefulWidget> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final recognizeUseCase = injector.get<RecognizeImageUseCase>();

  late CameraController cameraController;
  List<RecognizeResult>? classification;
  bool _isProcessing = false;

  initCamera() {
    cameraController = CameraController(widget.camera, ResolutionPreset.medium,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420);
    cameraController.initialize().then((value) {
      cameraController.startImageStream(imageAnalysis);
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> imageAnalysis(CameraImage cameraImage) async {
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    classification = await recognizeUseCase
        .recognize(InputImagePresenter.fromCameraImage(cameraImage));
    _isProcessing = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    recognizeUseCase.open();
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController.value.isStreamingImages) {
          await cameraController.startImageStream(imageAnalysis);
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    recognizeUseCase.close();
    super.dispose();
  }

  Widget cameraWidget(context) {
    var camera = cameraController.value;
    final size = MediaQuery.of(context).size;

    var scale = size.aspectRatio * camera.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        SizedBox(
          child: (!cameraController.value.isInitialized)
              ? Container()
              : cameraWidget(context),
        ),
        if (classification != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(classification!.first.name),
                      const Spacer(),
                      Text("${classification!.first.getPercent()}%")
                    ],
                  ),
                ),
              ]),
            ),
          ),
      ]),
    );
  }
}
