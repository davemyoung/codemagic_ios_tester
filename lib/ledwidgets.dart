import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'main.dart';

// the variables that will change the design to suit differing screensizes
double colorBlob;
double ledButtonPadding;
double ledButtonFontsize;

class buttonLED extends StatelessWidget {
  const buttonLED({
    Key key,
    this.color,
    this.myData,
  }) : super(key: key);

  final Color color;
  final int myData;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        //sendInstruction(myData);
        print('send data should happen here');
      },
      child: new Icon(
        Icons.panorama_fish_eye,
        color: Colors.blueGrey[600],
        size: 65.0,
      ),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,

      ///child: Text('AAA'),
      //padding: const EdgeInsets.all(10.0),
    );
  }
}

class inkwellLED extends StatelessWidget {
  const inkwellLED({
    Key key,
    this.myString,
    this.myData,
    this.color,
    this.textColor,
  }) : super(key: key);

  final String myString;
  final int myData;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        sendSingleInstruction([myData]);
        print('send data should happen here');
      },
      child: new Container(
        //width: 50.0,
        //height: 50.0,
        padding: EdgeInsets.all(
            ledButtonPadding), //I used some padding without fixed width and height
        decoration: new BoxDecoration(
          shape: BoxShape
              .circle, // You can use like this way or like the below line
          //borderRadius: new BorderRadius.circular(30.0),
          color: color,
        ),
        child: new Text(myString,
            style: new TextStyle(
                color: textColor,
                fontSize:
                    ledButtonFontsize)), // You can add a Icon instead of text also, like below.
        //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
      ), //............
    );
  }
}

class inkwellLamp extends StatelessWidget {
  const inkwellLamp({
    Key key,
    this.color,
    this.myData,
  }) : super(key: key);

  final Color color;
  final int myData;

  @override
  Widget build(BuildContext context) {
    var pixRatio = MediaQuery.of(context).devicePixelRatio;
    var currentScreenWidth = MediaQuery.of(context).size.width * pixRatio;
    //var screenSize = MediaQuery.of(context).size;

    if (currentScreenWidth >= 1080) {
      colorBlob = 103;
      ledButtonPadding = 29;
      ledButtonFontsize = 29;
    } else if (currentScreenWidth >= 720) {
      colorBlob = 78;
      ledButtonPadding = 29;
      ledButtonFontsize = 29;
    } else if (currentScreenWidth >= 480) {
      colorBlob = 57;
      ledButtonPadding = 23;
      ledButtonFontsize = 23;
    } else {
      colorBlob = 40;
      ledButtonPadding = 16;
      ledButtonFontsize = 16;
    }
    print('colorBlob si ....."');
    print(colorBlob);
    print('width of screen is ....');
    print(currentScreenWidth);

    return InkWell(
      onTap: () {
        sendSingleInstruction([myData]);
        print('send data should happen here');
      },
      child: new Container(
          height: colorBlob,
          //padding: const EdgeInsets.all(
          //25.0), //I used some padding without fixed width and height
          decoration: new BoxDecoration(
            shape: BoxShape
                .circle, // You can use like this way or like the below line
            //borderRadius: new BorderRadius.circular(30.0),
            color: color,
          ),
          // You can add a Icon instead of text also, like below.
          child:
              new Icon(Icons.adjust, size: colorBlob, color: Colors.black38)),
    ); //............
  }
}
