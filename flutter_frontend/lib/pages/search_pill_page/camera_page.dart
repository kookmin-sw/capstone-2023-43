import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function(XFile value) aftertake;
  const TakePictureScreen({
    Key? key,
    required this.cameras,
    required this.aftertake,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Container();
    }
    return MaterialApp(
      home: Stack(
        children: [
          Align(alignment: Alignment.center, child: CameraPreview(controller)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 40.h),
              child: GestureDetector(
                onTap: () async {
                  try {
                    await controller.takePicture().then((value) {
                      widget.aftertake(value);
                    });
                  } catch (e) {
                    print("$e");
                  }
                },
                child: Container(
                  height: 100.h,
                  width: 100.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.h)),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 224.w,
              width: 224.w,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}
