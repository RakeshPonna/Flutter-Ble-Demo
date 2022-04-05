// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// @dart=2.10
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            'Complete Local Name' + result.advertisementData.localName,
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            'Manufacturer Data ${getNiceManufacturerData(result.advertisementData.manufacturerData) ?? 'N/A'}',
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            'Service Data ${getNiceServiceData(result.advertisementData.serviceData) ?? 'N/A'}',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(result.rssi.toString()),
      trailing: RaisedButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
      /*children: <Widget>[
        _buildAdvRow(
            context, 'Complete Local Name', result.advertisementData.localName),
        _buildAdvRow(context, 'Tx Power Level',
            '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildAdvRow(
            context,
            'Manufacturer Data',
            getNiceManufacturerData(
                    result.advertisementData.manufacturerData) ??
                'N/A'),
        _buildAdvRow(
            context,
            'Service UUIDs',
            (result.advertisementData.serviceUuids.isNotEmpty)
                ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                : 'N/A'),
        _buildAdvRow(context, 'Service Data',
            getNiceServiceData(result.advertisementData.serviceData) ?? 'N/A'),
      ],*/
    );
  }
}

Widget _charWidget(BluetoothService service) {
  if (service.uuid.toString() == '4880c12c-fdcb-4077-8920-a450d7f9b907') {
    return Text('Status Service UUID');
  } else if (service.uuid.toString() ==
      '6468b776-9aad-4e0d-a0f0-091b69f094c1') {
    return Text('Setup Service UUID');
  } else if (service.uuid.toString() ==
      '6cf0aa4a-6dd8-43b3-a4ec-02a8f0bf39d9') {
    return Text('Schedule Service UUID');
  } else if (service.uuid.toString() ==
      '3769a009-5c0e-45b1-804e-fe87ecc1da1c') {
    return Text('Ovveride Service UUID');
  } else if (service.uuid.toString() ==
      'a0506fa4-92e7-4651-a678-21912680f707') {
    return Text('Ovveride Extra Service UUID');
  } else {
    return Text('Main Service UUID');
  }
}

Widget _characteristicWidget(
    BluetoothCharacteristic characteristic, BuildContext context) {
  if (characteristic.uuid.toString() ==
      'fec26ec4-6d71-4442-9f81-55bc21d658d6') {
    return Text(
        '${'Motor Status ON/OFF -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      'eb403733-c9f0-452c-9da8-6830a122ae98') {
    return Text(
        '${'RPM -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      'f7ffbb81-566e-4488-a42c-e9ce7d787c7e') {
    return Text(
        '${'Time Remaining -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '8bde8d1b-79d5-4e54-afee-3a0392c59307') {
    return Text(
        '${'Active Status -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '40c16f4e-fae9-4baf-ba06-f389b2669788') {
    return Text(
        '${'Priming ON/OFF -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '930b724d-28e6-4480-b1eb-b61b72ba6c0d') {
    return Text(
        '${'Priming speed -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      'e857ba31-3547-4fce-9dd0-5eeb551a50d2') {
    return Text(
        '${'Freeze protection ON/OFF -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      'd789cbe1-f03d-4c76-9ea8-63388e9d36ee') {
    return Text(
        '${'Freeze protection Speed -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '8834bfee-cccd-404d-80f0-18aafb9a814c') {
    return Text(
        '${'Schedule current step-'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '4f9dedc3-f463-457c-b95b-1bf0402177e8') {
    return Text(
        '${'Schedule cycle count-'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      'fede9c4d-0080-4dde-8a55-7e771d5c6595') {
    return Text(
        '${'Schedule Configuration -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      'f53783a6-b1eb-475e-ab03-da1e502a93c0') {
    return Text(
        '${'Ovveride 2 ON/OFF -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '6c67c623-865e-4064-99b4-469bc43e1b13') {
    return Text(
        '${'Ovveride 2 RPM/Duration-'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '29bb5bf6-c471-41fb-9201-47fa98802134') {
    return Text(
        '${'Ovveride 1 ON/OFF -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '23c94cd9-2ce1-4eb1-8b71-6f03c39a4384') {
    return Text(
        '${'Ovveride 1 RPM/Duration -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '21c8d72f-c200-4f9f-b423-75b3741e4266') {
    return Text(
        '${'no.of Ovverides -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      'f6fe9838-082f-4e73-9471-d57ac7205078') {
    return Text(
        '${'Ovveride3 ON/OFF -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      'e1d9a979-4fb0-4eee-9ad1-180475b69b56') {
    return Text(
        '${'Ovveride3 RPM/Duration -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      'ef9924db-8188-48b4-bc97-24855f5b01c3') {
    return Text(
        '${'Ovveride4 ON/OFF  -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '41b7c038-3e7d-474f-a0af-4e855599fc33') {
    return Text(
        '${'Ovveride4 RPM/Duration  -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '5f2cd7a1-2212-4b01-9e31-ae740c110dcf') {
    return Text(
        '${'Ovveride5 ON/OFF  -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '9a485aa0-3c76-48b4-9587-a44c462c4ad9') {
    return Text(
        '${'Ovveride5 RPM/Duration  -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '0df55d48-318b-43d2-abd6-c96fae65c1dd') {
    return Text(
        '${'Ovveride6 ON/OFF  -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else if (characteristic.uuid.toString() ==
      '57ab777a-0d60-43dc-984c-9395d973a1c6') {
    return Text(
        '${'Ovveride6 RPM/Duration  -'} 0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  } else {
    return Text(
        '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).textTheme.caption?.color));
  }
}

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({Key key, this.service, this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.length > 0) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text('Main Service UUID'),///*0x*/
            // if(service.uuid.toString() == '4880c12c-fdcb-4077-8920-a450d7f9b907'){
            //   Text('Main Service UUID'),
            // }else{
            //
            // }
            _charWidget(service),
            Text('${service.uuid.toString().toUpperCase().substring(4, 8)}',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Theme.of(context).textTheme.caption?.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: Text('Service Characteristic'),
        subtitle:
            ///*0x*
            Text(
                '${service.uuid.toString().toUpperCase() /*.substring(4, 8)*/}'),
      );
    }
  }
}

String getNiceHexArray(List<int> bytes) {
  return '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join('')}'
      .toUpperCase();
}

String getHexArray(List<int> bytes) {
  return '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(',')}'
      .toUpperCase();
}
String getTime(int hh,int mm) {
  String hrs = "";
  String min = "";
  if (hh < 10) {
    hrs = '0$hh';
  } else {
    hrs = '$hh';
  }
  if (mm < 10) {
    min = '0$mm';
  } else {
    min = '$mm';
  }
  return '$hrs:$min';
}

List<String> getHexListArray(List<int> bytes) {
  String data =
      '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(',')}'
          .toUpperCase();
  List<String> split = data.split(',');
  return split;
}

Widget _charParseData(
    BluetoothCharacteristic characteristic, List<int> result) {
  print("_charParseData :: ${result.toString()}");
  if (characteristic.uuid.toString() ==
      'fec26ec4-6d71-4442-9f81-55bc21d658d6') {
    if (result.isNotEmpty) {
      return Text('${result.first}');
    }
  } else if (characteristic.uuid.toString() ==
      'eb403733-c9f0-452c-9da8-6830a122ae98') {
    if (result.isNotEmpty) {
      return Text('${int.parse(getNiceHexArray(result), radix: 16)}');
    }
  } else if (characteristic.uuid.toString() ==
      '8bde8d1b-79d5-4e54-afee-3a0392c59307') {
    if (result.isNotEmpty) {
      int status = int.parse(getNiceHexArray(result), radix: 16);
      String statusValue = "";
      if(status == 1){
        statusValue = "priming";
      }else if(status == 2){
        statusValue = "Step 1";
      }else if(status == 3){
        statusValue = "Step 2";
      }else if(status == 4){
        statusValue = "Step 3";
      }else if(status == 5){
        statusValue = "Step 4";
      }else if(status == 6){
        statusValue = "Step 5";
      }else if(status == 7){
        statusValue = "Override 2";
      }else if(status == 8){
        statusValue = "Override 1";
      }else if(status == 9){
        statusValue = "Override 3";
      }else if(status == 10){
        statusValue = "Override 4";
      }else if(status == 11){
        statusValue = "Override 5";
      }else if(status == 12){
        statusValue = "Override 6";
      }
      return Text('${statusValue}');
    }
  } else if (characteristic.uuid.toString() ==
      'e857ba31-3547-4fce-9dd0-5eeb551a50d2') {
    if (result.isNotEmpty) {
      return Text('${int.parse(getNiceHexArray(result), radix: 16)}');
    }
  } else if (characteristic.uuid.toString() ==
      '40c16f4e-fae9-4baf-ba06-f389b2669788') {
    if (result.isNotEmpty) {
      return Text('${int.parse(getNiceHexArray(result), radix: 8)}');
    }
  } else if (characteristic.uuid.toString() ==
      '8834bfee-cccd-404d-80f0-18aafb9a814c') {
    if (result.isNotEmpty) {
      return Text('${int.parse(getNiceHexArray(result), radix: 16)}');
    }
  } else if (characteristic.uuid.toString() ==
      '930b724d-28e6-4480-b1eb-b61b72ba6c0d') {
    if (result.isNotEmpty) {
      if (result.isNotEmpty) {
        List<String> split = getHexListArray(result);
        int rpm =
            int.parse(split[0].toString() + split[1].toString(), radix: 16);
        int duration = int.parse(split[2].toString(), radix: 16);
        return Text('Rpm:${rpm} , Duration:${duration} min');
      }
    }
  } else if (characteristic.uuid.toString() ==
      'd789cbe1-f03d-4c76-9ea8-63388e9d36ee') {
    if (result.isNotEmpty) {
      if (result.isNotEmpty) {
        List<String> split = getHexListArray(result);
        int rpm = int.parse(split[0].toString() + split[1].toString(), radix: 16);
        int duration = int.parse(split[2].toString(), radix: 16);
        int temp = int.parse(split[3].toString(), radix: 16);
        return Text('Rpm:${rpm} , Dur:${duration} min , temp :${temp}');
      }
    }
  }else if (characteristic.uuid.toString() ==
      'fede9c4d-0080-4dde-8a55-7e771d5c6595') {
    if (result.isNotEmpty) {
      if (result.isNotEmpty) {
        List<String> split = getHexListArray(result);
        int startTimehrs = int.parse(split[0].toString() , radix: 16);
        int startTimemin = int.parse(split[1].toString(), radix: 16);
        String startTimeStep1 = getTime(startTimehrs,startTimemin);
        int endTimehrsStep1 = int.parse(split[2].toString() , radix: 16);
        int endTimeminStep1 = int.parse(split[3].toString(), radix: 16);
        int rpmStep1 = int.parse(split[4].toString()+split[5].toString(), radix: 16);
        String endTimeStep1 = getTime(endTimehrsStep1,endTimeminStep1);

        int startTimehrsStep2 = int.parse(split[6].toString() , radix: 16);
        int startTimeminStep2 = int.parse(split[7].toString(), radix: 16);
        String startTimeStep2 = getTime(startTimehrsStep2,startTimeminStep2);
        int endTimehrsStep2 = int.parse(split[8].toString() , radix: 16);
        int endTimeminStep2 = int.parse(split[9].toString(), radix: 16);
        int rpmStep2 = int.parse(split[10].toString()+split[11].toString(), radix: 16);

        String endTimeStep2 = getTime(endTimehrsStep2,endTimeminStep2);
        String output = 'step 1 -> $startTimeStep1 - $endTimeStep1 - $rpmStep1\n'
            'step 2 -> $startTimeStep2 - $endTimeStep2 - $rpmStep2';
        return Text('$output');
      }
    }
  } else if (characteristic.uuid.toString() ==
      '4f9dedc3-f463-457c-b95b-1bf0402177e8') {
    if (result.isNotEmpty) {
        return Text('${int.parse(getNiceHexArray(result), radix: 8)}');
    }
  } else if (characteristic.uuid.toString() ==
      'f7ffbb81-566e-4488-a42c-e9ce7d787c7e') {
    if (result.isNotEmpty) {
      List<String> split = getHexListArray(result);
      int hh = int.parse(split[0].toString(), radix: 16);
      int mm = int.parse(split[1].toString(), radix: 16);
      String hhs = "";
      String mms = "";
      if (hh < 10) {
        hhs = '0$hh';
      } else {
        hhs = '$hh';
      }
      if (mm < 10) {
        mms = '0$mm';
      } else {
        mms = '$mm';
      }
      return Text('${hhs}:${mms}');
    }
  } else {
    return Text(result.toString());
  }
}

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;

  const CharacteristicTile(
      {Key key,
      this.characteristic,
      this.descriptorTiles,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Characteristic'),
                _characteristicWidget(characteristic, context),
                /*Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).textTheme.caption?.color))*/
              ],
            ),
            subtitle: _charParseData(characteristic, value),
            contentPadding: EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.5),
                ),
                onPressed: onReadPressed,
              ),
              IconButton(
                icon: Icon(Icons.file_upload,
                    color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
                onPressed: onWritePressed,
              ),
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.sync_disabled
                        : Icons.sync,
                    color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
                onPressed: onNotificationPressed,
              )
            ],
          ),
          children: descriptorTiles,
        );
      },
    );
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;

  const DescriptorTile(
      {Key key, this.descriptor, this.onReadPressed, this.onWritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Descriptor'),
          Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: Theme.of(context).textTheme.caption?.color))
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.value,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onReadPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
        trailing: Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subtitle1?.color,
        ),
      ),
    );
  }
}
