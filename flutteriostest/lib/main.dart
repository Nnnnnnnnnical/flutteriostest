import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: PlatformChannel(),
    );
  }
}

class PlatformChannel extends StatefulWidget {
  @override
  _PlatformChannelState createState() => _PlatformChannelState();
}



class _PlatformChannelState extends State<PlatformChannel> {
  static const MethodChannel methodChannel = MethodChannel('hit.flutter.io/count');
   static const EventChannel eventChannel = EventChannel('time.flutter.io/count');
  int _hitNum = 0;
  int _time = 0;

  Future<void> _hitEvent() async{
    int hitNum;
    try {
        final int result = await methodChannel.invokeMethod('hitCount');
        hitNum =result;
      } on PlatformException {
      }
      if (hitNum !=null) {
      setState(() {
        _hitNum = hitNum;
    });  
    } 
  }
  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object event) {
    setState(() {
      print("{$event}");
      _time = event;
    });
  }

  void _onError(Object error) {
    setState(() {
    });
  }


 @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("当前点击次数：$_hitNum", key: const Key('hitEvent')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  child: const Text('hit'),
                  onPressed: _hitEvent,
                ),
              ),
            ],
          ),
          Text("计时器时间${_time}s"),
        ],
      ),
    );
  }
}