import 'package:com/pages/patient_care_system/patient_screens/add_new_case_screen.dart';
import 'package:com/pages/patient_care_system/patient_screens/detail_case_screen.dart';
import 'package:com/pages/patient_care_system/sql_file_care_system.dart';
import 'package:com/pages/patient_care_system/widgets.dart';
import 'package:flutter/material.dart';

class PatientDashBoardScreen extends StatefulWidget {
  const PatientDashBoardScreen({super.key});

  @override
  State<PatientDashBoardScreen> createState() => _PatientDashBoardScreenState();
}

class _PatientDashBoardScreenState extends State<PatientDashBoardScreen> {
  String selectedAction = 'New';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
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
                            selectedAction = 'New';
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: selectedAction == 'New'
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black)),
                          child: Center(child: Text('New Case')),
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
                            selectedAction = 'Old';
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: selectedAction == 'Old'
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black)),
                          child: Center(child: Text('Old Case')),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedAction = 'Detail';
                        });
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: selectedAction == 'Detail'
                                ? Colors.blue.shade100
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black)),
                        child: Center(child: Text('Doctor Detail')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewCaseScreen(),
                        ));
                  },
                  child: Text('Add New Case')),
            ),
            FutureBuilder<List>(
              future: getAllNewCases(),
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailCaseScreen(data: snapshot.data![index]),
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0),
                                      child: Text(
                                        snapshot.data![index]['CaseID'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(snapshot.data![index]['PatientName'].toString(),),
                                        Text(snapshot.data![index]['CheckupToDoctorID'].toString(),)
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        menuBtnForCareSystem(onSelected: (value){
                                          if(value == 1){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewCaseScreen(data: snapshot.data![index]),));
                                          }
                                        }),
                                        Text(
                                            snapshot.data![index]['BillAmount'].toString(),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  );
                }else{
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
