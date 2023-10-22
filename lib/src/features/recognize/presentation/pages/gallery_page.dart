import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:search3/src/features/recognize/domain/entities/recognize_result.dart';
import 'package:search3/src/features/recognize/domain/usecases/recognize_image_use_case.dart';
import 'package:search3/src/core/presentation/colors/colors.dart';
import 'package:search3/src/features/recognize/presentation/presenter/input_image_presenter.dart';
import 'package:search3/src/features/recognize/presentation/widgets/result_info.dart';

final injector = Injector.appInstance;

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GalleryPageState();
  }
}

class _GalleryPageState extends State<GalleryPage> {
  final recognizeUseCase = injector.get<RecognizeImageUseCase>();

  String? _imagePath;
  List<RecognizeResult>? classification;
  String status = "init";

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
      _processImage();
    }
  }

  @override
  void initState() {
    recognizeUseCase.open();
    super.initState();
  }

  @override
  void dispose() {
    recognizeUseCase.close();
    super.dispose();
  }

  Future<void> _processImage() async {
    setState(() {
      status = "start";
    });
    classification = await recognizeUseCase
        .recognize(InputImagePresenter.fromPath(_imagePath!));
    setState(() {
      status = "finish";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (status == "start") const LinearProgressIndicator(),
              if (status == "finish") ResultInfo(result: classification!.first),
              const SizedBox(height: 16.0),
              Expanded(
                  child: Stack(
                children: [
                  if (_imagePath != null)
                    Image.file(
                      File(_imagePath!),
                    ),
                ],
              )),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(DarkColors.backgroundColor),
                    iconColor:
                        MaterialStatePropertyAll(DarkColors.selectedColor)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Распознать',
                      style: TextStyle(color: Color.fromRGBO(238, 238, 238, 1)),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.auto_fix_high,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
