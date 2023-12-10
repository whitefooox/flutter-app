import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:search3/src/core/presentation/colors/colors.dart';
import 'package:search3/src/features/recognize/presentation/bloc/recognize_bloc.dart';
import 'package:search3/src/features/recognize/presentation/widgets/result_info.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GalleryPageState();
  }
}

class _GalleryPageState extends State<GalleryPage> {
  final recognizeBloc = RecognizeBloc();
  String? _imagePath;

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
    super.initState();
    recognizeBloc.add(RecognizeOpenServiceEvent());
  }

  @override
  void dispose() {
    recognizeBloc.add(RecognizeCloseServiceEvent());
    super.dispose();
  }

  Future<void> _processImage() async {
    recognizeBloc.add(RecognizeImageFromGalleryEvent(_imagePath!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => recognizeBloc,
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<RecognizeBloc, RecognizeState>(
              bloc: recognizeBloc,
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.isProcessing) const LinearProgressIndicator(),
                    if (state.state == "result")
                      ResultInfo(result: state.results.first),
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
                          backgroundColor: MaterialStatePropertyAll(
                              AppColors.mainColor),
                          iconColor: MaterialStatePropertyAll(
                              AppColors.textColor)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Распознать',
                            style: TextStyle(
                                color: Color.fromRGBO(238, 238, 238, 1)),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
