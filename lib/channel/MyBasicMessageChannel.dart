import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class MyBasicMessageChannel extends StatefulWidget {
  @override
  _MyBasicMessageChannelState createState() => _MyBasicMessageChannelState();
}

class _MyBasicMessageChannelState extends State<MyBasicMessageChannel> {
  static const BasicMessageChannel _basicMessageChannel = const BasicMessageChannel('flutter_demo_jiaohu.flutter.io/basic_message_channel', StandardMessageCodec());
  //用户名的控制器
  TextEditingController userController = TextEditingController();
  List<String> list = new List<String>();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    list.add('value0');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('原生交互 - BasicMessageChannel'),),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 25,),
            Text('F:/VscodeProject/flutter_demo_jiaohu'),
            SizedBox(height: 25,),

            Expanded(
              flex: 1,
              child: ListView.builder(
                reverse:true,//组件反向排列
                controller: _scrollController,
                shrinkWrap: true,
                physics:AlwaysScrollableScrollPhysics(),
                itemCount: this.list.length,
                padding:EdgeInsets.all(5),
                itemBuilder: (BuildContext context, int index) {
                  String str = list[index];
                  if(str.isEmpty){
                    return Text('data');
                  }else if(str.startsWith('Flutter')){
                    str = str.replaceFirst('Flutter', '');
                    return getWidgetR(child: Text(str));
                  }else{
                    str = str.replaceFirst('Android', '');
                    return getWidgetL(child: Text(str));
                  }
                },
              ),
            ),
            Container(
              color: Colors.black26,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: userController, //控制器，控制TextField文字   同 Android View id
                        decoration: new InputDecoration(
                          labelText: '请输入...',
                        ),
                        autofocus: false,
                      ),
                    ),
                  ),

                  SizedBox(height: 5,),

                  IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.blue,
                    onPressed: ()async{
                      if(userController.text.trim().isEmpty){
                        // userController.
                      }else {
                        setState(() {
                          list.insert(0, 'Flutter${userController.text.trim()}');
                          _scrollController.animateTo(
                            0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        });
                        String reply = await _basicMessageChannel.send(userController.text.trim());
                        setState(() {
                          list.insert(0, 'Android$reply');
                          // _scrollController.animateTo(
                          //   0.0,   //滚动到顶部
                          //   // _scrollController.position.maxScrollExtent,// 滚动到底部
                          //   curve: Curves.easeOut,
                          //   duration: const Duration(milliseconds: 300),
                          // );
                        });
                        userController.text = '';
                      }
                    },
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  getWidgetR({Widget child}){
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 50,),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topRight,
              child: child,
            ),
          ),

          SizedBox(width: 5,),
          Container(
            alignment: Alignment.center,
            height: 45,
            width: 45,
            color: Colors.red[200],
            child: Text('Flutter'),
          )
        ],
      ),
    );
  }

  getWidgetL({Widget child}){
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 45,
            width: 45,
            color: Colors.blue[200],
            child: Text('java'),
          ),
          SizedBox(width: 5,),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topLeft,
              child: child,
            ),
          ),
          SizedBox(width: 50,),
        ],
      ),
    );
  }
}