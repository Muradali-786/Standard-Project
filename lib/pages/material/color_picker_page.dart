import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:com/config/screen_config.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return AlertDialog(
      title: const Text('Pick a color!'),
      content:  SizedBox(
        width: ScreenConfig.screenWidth,
        height: ScreenConfig.screenHeight,
        child: SingleChildScrollView(
          child: Card(
            elevation: 2,
            child: ColorPicker(
              // Use the screenPickerColor as start color.
              color: pickerColor,
              // Update the screenPickerColor using the callback.
              onColorChanged: (Color color){
                currentColor=color;
              },
              width: 44,
              height: 44,
              borderRadius: 22,
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.headline5,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Got it'),
          onPressed: () {
            Navigator.pop(context,currentColor);
          },
        ),
      ],
    );
  }
}
