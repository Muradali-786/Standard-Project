import 'package:flutter/material.dart';

class ModelShowYearListView extends ChangeNotifier{

   List<Map> schYear = [];
   List<Map> schClasses = [];
   List<Map> clssection = [];
   List<Map> sectionStudent = [];
   List<Map> studentFeeDue = [];
   List<Map> FeeRec2 = [];
   String status = 'Branch';

   String studentQuantity = '';


   void setSchYear(List<Map>  schYear){
     this.schYear = schYear;
     notifyListeners();
   }

   List<Map> getSchYear(){
     return schYear;
   }

   void setClsSection(List<Map>  clssection){
     this.clssection = clssection;
     notifyListeners();
   }

   List<Map> getClsSection(){
     return clssection;
   }

   void setSectionStudent(List<Map>  sectionStudent){
     this.sectionStudent = sectionStudent;
     notifyListeners();
   }

   List<Map> getSectionStudent(){
     return sectionStudent;
   }

   void setStudentFeeDue(List<Map>  studentFeedue){
     this.studentFeeDue = studentFeedue;
     notifyListeners();
   }

   List<Map> getStudentFeeDue(){
     return studentFeeDue;
   }

   void setFeeRec2(List<Map>  feeRec2){
     this.FeeRec2 = feeRec2;
     notifyListeners();
   }

   List<Map> getFeeRec2(){
     return FeeRec2;
   }

   void setSchClasses(List<Map>  schClass){
     this.schClasses = schClass;
     notifyListeners();
   }

   List<Map> getSchClasses(){
     return schClasses;
   }
   void setStatus(String  status){
     this.status = status;
     notifyListeners();
   }

   String getStatus(){
     return status;
   }

   void setStudentQTY(String  qty){
     this.studentQuantity = qty;
     notifyListeners();
   }

   String getStudentQTY(){
     return studentQuantity;
   }



}