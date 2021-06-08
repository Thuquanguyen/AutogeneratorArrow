import 'package:flutter/cupertino.dart';

class ItemModel{
  String id;
  Offset offset;
  bool isShow;
  List<String> target;

  ItemModel({required this.id, required this.offset,required this.isShow,required this.target});

}