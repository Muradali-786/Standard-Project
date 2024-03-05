import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'dart:typed_data';
import '../../../config/screen_config.dart';



class CropImagePage extends StatefulWidget {
  final Uint8List imageData;
  CropImagePage({Key? key, required this.imageData}) : super(key: key);

  @override
  _CropImagePageState createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final _controller = CropController();
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: ScreenConfig.blockHeight * 90,
            width: ScreenConfig.blockWidth * 100,
            child: Crop(
              image: widget.imageData,
              controller: _controller,
              withCircleUi: true,
              onStatusChanged: (status) {
                debugPrint(status.toString());
              },
              cornerDotBuilder: (size, edgeAlignment) =>
                  const DotControl(color: Colors.blue),
              onCropped: (image) {
                debugPrint("File Path");
                Navigator.pop(context, image);
              },

              aspectRatio: 4 / 3,
              initialSize: 0.5,
              initialArea: Rect.fromLTWH(240, 212, 800, 600),
              // withCircleUi: true,
              baseColor: Colors.blue.shade900,
              maskColor: Colors.white.withAlpha(100),
            ),
          ),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                _controller.crop();
              },
              child: Text("OK"),
            ),
          )
        ],
      ),
    );
  }
}
