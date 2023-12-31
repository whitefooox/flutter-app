import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:search3/src/features/recognize/presentation/bloc/recognize_bloc.dart';

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
  final recognizeBloc = RecognizeBloc();

  late CameraController cameraController;
  bool _isProcessing = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    super.initState();
    recognizeBloc.add(RecognizeOpenServiceEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    recognizeBloc.add(RecognizeCloseServiceEvent());
    super.dispose();
  }

  void initCamera() {
    cameraController = CameraController(widget.camera, ResolutionPreset.medium,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420);
    cameraController.initialize().then((_) async {
      if (!mounted) return;
      await cameraController.startImageStream(imageAnalysis);
      setState(() {});
    });
  }

  Future<void> imageAnalysis(CameraImage cameraImage) async {
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    recognizeBloc.add(RecognizeImageFromCameraEvent(cameraImage));
    _isProcessing = false;
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

  Widget cameraWidget(context) {
    final camera = cameraController.value;
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
    return BlocProvider(
      create: (context) => RecognizeBloc(),
      child: SafeArea(
        child: BlocBuilder<RecognizeBloc, RecognizeState>(
          bloc: recognizeBloc,
          builder: (context, state) {
            return Stack(children: [
              SizedBox(
                child: (!cameraController.value.isInitialized)
                    ? Container()
                    : cameraWidget(context),
              ),
              if (state.results.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Text(state.results.first.label),
                            const Spacer(),
                            Text("${state.results.first.percent}%")
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
            ]);
          },
        ),
      ),
    );
  }
}
