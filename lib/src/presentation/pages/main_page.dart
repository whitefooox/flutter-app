import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:search3/src/presentation/colors/colors.dart';
import 'package:search3/src/presentation/pages/camera_page.dart';
import 'package:search3/src/presentation/pages/gallery_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late CameraDescription cameraDescription;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;
  final List<Widget> _pages = [const GalleryPage()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (cameraIsAvailable) {
        cameraDescription = (await availableCameras()).first;
        _pages.add(CameraPage(camera: cameraDescription));
      }
    });
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.image), label: "Image"),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt), label: "Camera"),
          ],
          backgroundColor: DarkColors.backgroundColor,
          selectedItemColor: DarkColors.selectedColor,
          currentIndex: _selectedIndex,
          onTap: _onTap,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
