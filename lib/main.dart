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
  List<ItemModel> _listOffset = [ItemModel(id: 'note0',offset: Offset(20, 20), isShow: false,target: [])];
  int seleted = -1;

  void showPopupSetting(Function seletedNote) => showDialog(context: context, builder: (builder) => AlertDialog(content: SingleChildScrollView(child: Column(children: [
    Container(child: _custompopup((target,index) => seletedNote(target,index)),width: 230,height: 200,)
  ],mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.min,),),));

  void addTarget(List<String> target,List<int> index){
    setState(() {
    seleted = -1;
    _listOffset.add(ItemModel(id: 'note${_listOffset.length}',offset: Offset.zero, isShow: false,target: target));
    for (int indexSeleted in index){
      _listOffset[indexSeleted].target.add('note${_listOffset.length - 1}');
      _listOffset[indexSeleted].isShow = true;
    }
    });
    Navigator.pop(context);
    for(ItemModel item in _listOffset){
      print("item ${item.id} ---- ${item.offset} ---- ${item.target} ----- ${item.isShow}");
    }
  }
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
          showPopupSetting((target,index) => addTarget(target,index));
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
          targetIds: _listOffset[index].target,
          sourceAnchor: Alignment.bottomCenter,
          targetAnchor: Alignment.centerRight,
          color: Colors.orange,
          child: Column(children: [
            Text(_listOffset[index].id),
            SizedBox(height: 0),
            IconButton(onPressed: (){
              // setState(() {
              //   seleted = index;
              //   _listOffset[seleted - 1].isShow = true;
              //   _listOffset[seleted - 1].target = 'note$seleted';
              //   print("selected : $seleted");
              // });
            }, icon: Icon(Icons.add_box,size: 50,))
          ],),
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

  Widget _custompopup(Function selectedNote(List<String> target,List<int> index)){
    List<String> listTarget = [];
    List<int> listIndex = [];
    return Center(child:
    Column(children: [
      Expanded(child: GridView.builder(gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (ctx,index) =>
            Card(child: Center(child:
            GestureDetector(child: Text(_listOffset[index].id,textAlign: TextAlign.center,),
              onTap: (){
                listTarget.add(_listOffset[index].id);
                listIndex.add(index);
              },),)),shrinkWrap: true,itemCount: _listOffset.length,)),
      RaisedButton(onPressed: (){
        selectedNote(listTarget,listIndex);
        for (String item in listTarget){
          print("itemkakaka : $item");
        }
      },child: Text("Add"),)
    ],));
  }
}