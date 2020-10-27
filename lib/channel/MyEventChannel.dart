import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyEventChannel extends StatefulWidget {
  @override
  _MyEventChannelState createState() => _MyEventChannelState();
}

class _MyEventChannelState extends State<MyEventChannel> {
  static const EventChannel _eventChannel = const EventChannel('flutter_demo_jiaohu.flutter.io/event_channel');
  Object obj;

  @override
  void initState() {
    super.initState();
    // 监听开始
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('原生交互 - BasicMessageChannel'),),
      body: Center(
        child: Text('$obj'),
      ),
    );
  }

  void _onEvent(Object event) {
    print('Flutter - 返回的内容: $event');
    setState(() {
      obj = event;
    });
  }

  void _onError(Object error) {
    print('Flutter - 返回的错误');
    setState(() {
      obj = error;
    });
  }

// void deactivate(){
//   print('deactivate');
// }

// void dispose(){
//   print('dispose');
// }

}