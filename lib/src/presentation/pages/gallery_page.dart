import 'dart:developer';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:search3/src/domain/entities/recognize_result.dart';
import 'package:search3/src/domain/usecases/recognize_image_use_case.dart';
import 'package:search3/src/presentation/presenter/input_image_presenter.dart';
import 'package:search3/src/presentation/widgets/result_info.dart';

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
  img.Image? image;
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
    }
    processImage();
  }

  @override
  void initState() {
    log("open");
    //imageRecognizer.init();
    //classificator.open();
    //recognizeRepo.init();
    super.initState();
  }

  @override
  void dispose() {
    log("close");
    //imageRecognizer.close();
    //classificator.close();
    super.dispose();
  }

  Future<void> processImage() async {
    if (_imagePath != null) {
      final imageData = File(_imagePath!).readAsBytesSync();
      image = img.decodeImage(imageData);
      setState(() {
        status = "start";
      });
      //classification = await classificator.recognize(InputImage(image!, false));
      classification =
          await recognizeUseCase.call(InputImagePresenter.fromImage(image!));
      setState(() {
        status = "finish";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (status == "start") LinearProgressIndicator(),
              if (status == "finish") ResultInfo(result: classification!.first),
              SizedBox(height: 16.0),

              Expanded(
                  child: Stack(
                children: [
                  if (_imagePath != null)
                    Image.file(
                      File(_imagePath!),
                    ),
                ],
              )),
              //if (_imagePath != null) ImageDisplay(imagePath: _imagePath!),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color.fromRGBO(57, 62, 70, 1)),
                    iconColor: MaterialStatePropertyAll(
                        Color.fromRGBO(238, 238, 238, 1))),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Распознать',
                      style: TextStyle(color: Color.fromRGBO(238, 238, 238, 1)),
                    ), // <-- Text
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      // <-- Icon
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
