import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:lamp_control/main.dart';
import 'package:lamp_control/ledwidgets.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class ColorCirclePickerPage extends StatefulWidget {
  @override
  ColorCirclePickerPageState createState() => new ColorCirclePickerPageState();
}

class ColorCirclePickerPageState extends State<ColorCirclePickerPage> {
  HSVColor color = new HSVColor.fromColor(Colors.blue);
  /*void onChanged(HSVColor value) {
    this.color = value;
    Color rgb = value.toColor();
    sendInstruction([47, rgb.red, rgb.green, rgb.blue]);
  }*/

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Container(
      //width: 260,

      child: CircleColorPicker(
        initialColor: Colors.blue,
        onChanged: (color) => print(color),
        size: const Size(340, 340),
        strokeWidth: 4,
        thumbSize: 36,
      ),
    ));
  }
}
