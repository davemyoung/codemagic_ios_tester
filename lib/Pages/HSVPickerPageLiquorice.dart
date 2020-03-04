import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:lamp_control/main.dart';
import 'package:lamp_control/ledwidgets.dart';

class HSVPickerPageLiquorice extends StatefulWidget {
  @override
  HSVPickerPageLiquoriceState createState() =>
      new HSVPickerPageLiquoriceState();
}

class HSVPickerPageLiquoriceState extends State<HSVPickerPageLiquorice> {
  HSVColor color = new HSVColor.fromColor(Colors.blue);

  void onChanged(HSVColor value) {
    this.color = value;
    Color rgb = value.toColor();
    sendInstruction([47, rgb.red, rgb.green, rgb.blue]);
  }

  @override
  Widget build(BuildContext context) {
    /*return new Center(
        child:*/
    print(lampType);
    print('THIS IS TTHE FROST PAGE');
    return new Container(

        //width: 260,

        child: new Card(
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            elevation: 2.0,
            child: new Padding(
                padding: const EdgeInsets.all(10),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Visibility(
                        child: new inkwellLamp(
                          color: this.color.toColor(),
                          myData: 67, //ascii character C - off instruction
                        ),
                        visible: true,
                      ),

                      ///---------------------------------
                      new HSVPicker(
                        color: this.color,
                        onChanged: (value) =>
                            super.setState(() => this.onChanged(value)),
                      ),

                      ///---------------------------------

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          inkwellLED(
                            myString: '1',
                            myData: 85, //ascii character U - confetti pattern
                            color: Colors.blue,
                            textColor: Colors.black,
                          ),
                          inkwellLED(
                            myString: '2',
                            myData:
                                97, // ascii character a - gradedPulse pattern
                            color: Colors.blue,
                            textColor: Colors.black,
                          ),
                          inkwellLED(
                            myString: '3',
                            myData: 87, //ascii character W - halfCylon pattern
                            color: Colors.blue,
                            textColor: Colors.black,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          inkwellLED(
                            myString: '4',
                            myData:
                                88, // ascii character X - simplePulse pattern
                            color: Colors.blue,
                            textColor: Colors.black,
                          ),
                          inkwellLED(
                            myString: '5',
                            myData: 86, //ascii character V - bpm pattern
                            color: Colors.blue,
                            textColor: Colors.black,
                          ),
                          inkwellLED(
                            myString: '6',
                            myData:
                                98, // ascii character b - fadedPulse pattern
                            color: Colors.blue,
                            textColor: Colors.black,
                          ),
                        ],
                      ),
                    ]))));
  }
}
