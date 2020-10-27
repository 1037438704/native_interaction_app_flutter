import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'channel/MyBasicMessageChannel.dart';
import 'channel/MyEventChannel.dart';
import 'channel/MyMethodChannel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('BasicMessageChannel'), //用于传递字符串和半结构化的信息
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyBasicMessageChannel()));
              },
            ),
            SizedBox(height: 25),
            RaisedButton(
              child: Text('MethodChannel'), //用于传递方法调用（method invocation）
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyMethodChannel()));
              },
            ),
            SizedBox(height: 25),
            RaisedButton(
              child: Text('EventChannel'), //用于数据流（event streams）的通信
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyEventChannel()));
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyEventChannel())).then((value){
                //   print('_result' + value);
                // });
              },
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
