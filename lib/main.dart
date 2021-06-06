import 'package:autogeneraterwidget/item_model.dart';
import 'package:autogeneraterwidget/widget_arrows.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ItemModel> _listOffset = [ItemModel(id: 'note0',offset: Offset(20, 20), isShow: false,target: ""),ItemModel(id: 'note1',offset: Offset(100, 110), isShow: false,target: "")];
  int seleted = -1;

  void showPopupSetting() => showDialog(context: context, builder: (builder) => AlertDialog(content: SingleChildScrollView(child: Column(children: [
    Container(child: _custompopup(),width: 100,height: 100,)
  ],mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.min,),),));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ArrowContainer(child: Scaffold(
      body: Column(children: [
        Expanded(child: SafeArea(child: Stack(children: _listOffset.map((e) {
          var index = _listOffset.indexOf(e);
          return _draggableWidget(e.offset,index);
        }).toList(),),)),
        Center(child: RaisedButton(child: Text("Generate"),onPressed: (){
          showPopupSetting();
          // setState(() {
          //   seleted = -1;
          //   _listOffset.add(ItemModel(offset: Offset.zero, isShow: false,target: ""));
          // });
        },),)
      ],),
    ));
  }

  Widget _draggableWidget(Offset position,int index) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        child: GestureDetector(child: ArrowElement(
          id: _listOffset[index].id,
          show: seleted != -1 ? _listOffset[seleted - 1].isShow : _listOffset[index].isShow,
          targetId: _listOffset[index].target,
          sourceAnchor: Alignment.bottomCenter,
          targetAnchor: Alignment.centerRight,
          color: Colors.orange,
          child: IconButton(onPressed: (){
            setState(() {
              seleted = index;
              _listOffset[seleted - 1].isShow = true;
              _listOffset[seleted - 1].target = 'note$seleted';
              print("selected : $seleted");
            });
          }, icon: Icon(Icons.add_box,size: 50,)),
        ),onTap: (){
          print("tap tap");
        },),
        feedback: Icon(Icons.add_box,size: 50,),
        onDraggableCanceled: (Velocity velocity, Offset offset){
          setState(() => _listOffset[index].offset = offset);
        },
      ),
    );
  }

  Widget _custompopup() => Center(child:
  ListView.builder(
    itemBuilder: (ctx,index) => Card(child: Padding(child: Text(_listOffset[index].id,textAlign: TextAlign.center,),padding: EdgeInsets.all(10),)),
    itemCount: _listOffset.length,));
}
