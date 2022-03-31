
// @dart=2.10
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DashboardPage extends StatefulWidget {
  final BluetoothDevice device;
  DashboardPage({ Key key,  this.device}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>{
 var connectionState;
  @override
  void initState() {
    super.initState();
    discoverServices(widget.device);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
          title: Text('Dashboard'),
          actions: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: widget.device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) {
                VoidCallback onPressed;
                String text;
                switch (snapshot.data) {
                  case BluetoothDeviceState.connected:
                    onPressed = () => widget.device.disconnect();
                    text = 'DISCONNECT';
                    break;
                  case BluetoothDeviceState.disconnected:
                    onPressed = () => widget.device.connect();
                    text = 'CONNECT';
                    break;
                  default:
                    onPressed = { } as VoidCallback;
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
                          ?.copyWith(color: Colors.white),
                    ));
              },
            )
          ]
      ),

    );

  }
 //https://stackoverflow.com/questions/63138321/flutter-blue-set-notification-and-read-characteristic-errors-on-android-ble-de
  void discoverServices(BluetoothDevice device) async{
    device.state.listen((state) async {
      if (state == BluetoothDeviceState.connected) {
        device.discoverServices();
        setState(() {
          connectionState = "connected";
        });
      }else  if (state == BluetoothDeviceState.disconnected) {
        setState(() {
          connectionState = "disconnected";
        });
      }else  if (state == BluetoothDeviceState.connecting) {
        setState(() {
          connectionState = "connecting";
        });
      }
    });

  }


}