import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'ledwidgets.dart';
import 'widgets.dart';
import "package:flutter/cupertino.dart";
import "Pages/HSVPickerPage.dart";
import "Pages/HSVPickerPageFrost.dart";
import "Pages/HSVPickerPageAquarium.dart";
import "Pages/HSVPickerPageLiquorice.dart";
import 'package:flutter/services.dart';
//import 'Pages/HSVPickerPage.dart';
//import 'Pages/HSVPickerPageFrost.dart';

BluetoothCharacteristic tx;
Color appBarColor = Colors.blue;
// pattern ids, oonfetti (U - 85), bpm ( V -86), halfCylon (W - 87), simplePulse (X - 88)
// gradedPulse ((a -97), fadingPulse( b - 98)
var frostPatterns = [85, 86, 87, 88, 89, 97, 98];
var standardPatterns = [85, 86, 87, 88];
var lampType;
var lampProg;

void main() {
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceScreen(device: d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    print('starting device screen and device is');
    print(device.name);
    if (device.name == 'FrostTester') {
      lampProg = HSVPickerPageFrost();
      print("set the variable for Frost");
    } else if (device.name == 'LiquoriceTester') {
      lampProg = HSVPickerPage();
    } else if (device.name.contains('VoodoomoodooAquarium')) {
      print("aquarium option chosen");
      lampProg = HSVPickerPageAquarium();
    } else if (device.name.contains('VoodoomoodooLiquorice')) {
      print("liquorice option chosen");
      lampProg = HSVPickerPageLiquorice();
    } else {
      lampProg = HSVPickerPage();
    }

    return Scaffold(
      //backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  print("connected and startiung process");
                  device.discoverServices().then((services) {
                    // discover services
                    services.forEach((service) {
                      if (service.uuid ==
                          new Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b")) {
                        print("early early Service found!");
                        service.characteristics.forEach((characteristic) {
                          if (characteristic.uuid ==
                              new Guid(
                                  "beb5483e-36e1-4688-b7f5-ea07361b26a8")) {
                            tx = characteristic;

                            print("fuck!!!EARLY characteristic  found");
                          } else {
                            print("Nope, not yoiur day for the charactersiti");
                          }
                        });
                      } else {
                        print("Nope, nothing found for service");
                      }
                    });
                  });

                  onPressed = () {
                    device.disconnect();
                  };
                  text = 'DISCONNECT';
                  //appBarColor = Colors.grey;
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();

                  text = 'CONNECT';

                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),

      body: lampProg,
    );
  }
}

void sendInstruction(List<int> rgbList) async {
  await tx.write(rgbList);
}

void sendSingleInstruction(List<int> myData) async {
  await tx.write(myData);
}

/*void sendHexInstruction() async {
  tx.write([213]);
}*/

/*List rgbBuilder(value) {
  Color rgb = value.toColor();
  print(rgb);
  print(rgb.blue);
  print(rgb.red);
  print(rgb.green);
  List rgbList = new List(4);
  rgbList[0] = 47; // symbol /
  rgbList[1] = rgb.red;
  rgbList[2] = rgb.green;
  rgbList[3] = rgb.blue;
  print(rgbList);
  sendInstruction([47, rgb.red, rgb.green, rgb.blue]);

  /*
  String colorString = value.hue.toString();
  //String colorStringed = (int.parse ('$colorString'), radix: 16));
  print('colorstringed here is $colorString');
  String redString = colorString.substring(14, 16);
  String greenString = colorString.substring(12, 14);
  String blueString = colorString.substring(14, 16);
  print(value.hue);
  print(value.saturation);
  print(value.value);

  //print(' and then colorstringed here is $colorStringed');
  double r = (value.hue);
  print(r);
  //int g = (int.parse('$greenString', radix: 16));
  //int b = (int.parse('$blueString', radix: 16));
  List rgbList = new List(4);
  rgbList[0] = 47; // symbol /
  rgbList[1] = r;
  //rgbList[2] = g;
  //rgbList[3] = b;
  print(rgbList);
  //sendInstruction([47, r, g, b]);
  return (rgbList);*/
}*/
