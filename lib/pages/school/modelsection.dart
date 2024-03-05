
import 'package:flutter/material.dart';

class ModelShowSectionListView  extends ChangeNotifier{
  String name = '';
  int id = 0;
  double opacity =0.0;

  void setName(String name){
    this.name = name;
    notifyListeners();
  }

  void setID(int id){
    this.id = id;
    notifyListeners();
  }

  void setOpacity(double opacity){
    this.opacity = opacity;
    notifyListeners();
  }
  String getName(){
    return this.name;
  }
  int getID(){
    return this.id;
  }


  double getOpacity(){
    return this.opacity;
  }

}