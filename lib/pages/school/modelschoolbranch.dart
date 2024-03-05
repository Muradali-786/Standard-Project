

import 'package:flutter/material.dart';

class ModelSchoolBranchSystem  extends ChangeNotifier{
String name = '';
bool accountManagement = true;
int id = 0;
double  opacity = 0.0;

void setName(String name){
  this.name = name;
  notifyListeners();
}

void setAccount(bool account){
  this.accountManagement = account;
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
bool getAccount(){
  return this.accountManagement;
}


double getOpacity(){
  return this.opacity;
}

int getID(){
  return this.id;
}


}