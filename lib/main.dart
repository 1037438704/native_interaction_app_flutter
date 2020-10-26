import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const String CHINAL_NAME = "samples.flutter.study/call_native";
  static const platform = const MethodChannel(CHINAL_NAME);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            FlatButton(
              child: Text("调用native 接口"),
              onPressed: () async {
                String result =
                    await platform.invokeMethod("call_native_method");
                setState(() {
                  //这里将我们拿到回传的值 赋值给我们自己定义的  _result  然后打
                  //印到控制台观察
                  print("_result ---->" + result);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
