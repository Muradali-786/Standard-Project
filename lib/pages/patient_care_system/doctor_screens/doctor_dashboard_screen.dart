import 'package:com/pages/patient_care_system/doctor_screens/add_new_doctor.dart';
import 'package:com/pages/patient_care_system/doctor_screens/token_patient_screen.dart';
import 'package:com/pages/patient_care_system/sql_file_care_system.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class DoctorDashBoardScreen extends StatefulWidget {
  const DoctorDashBoardScreen({super.key});

  @override
  State<DoctorDashBoardScreen> createState() => _DoctorDashBoardScreenState();
}

class _DoctorDashBoardScreenState extends State<DoctorDashBoardScreen> {
  String selectedAction = 'duty';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewDoctor(),));
                  },
                  child: Text('Add New Doctor')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedAction = 'duty';
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: selectedAction == 'duty'
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black)),
                          child: Center(child: Text('On Duty')),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedAction = 'list';
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: selectedAction == 'list'
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black)),
                          child: Center(child: Text('All List')),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List>(
              future: getAllDoctor(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TokenPatientScreen(),));
                            },
                            child: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text('${snapshot.data![index]['DoctorName']}', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),),
                                    menuBtnForCareSystem(
                                      onSelected: (value){
                                        if(value == 1){

                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewDoctor(data: snapshot.data![index]),));
                                        }
                                      }
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  );
                }else{
                  return  const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
