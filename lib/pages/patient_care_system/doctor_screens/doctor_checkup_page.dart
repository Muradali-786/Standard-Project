import 'package:flutter/material.dart';


class DoctorCheckUPPage extends StatefulWidget {
  const DoctorCheckUPPage({super.key});

  @override
  State<DoctorCheckUPPage> createState() => _DoctorCheckUPPageState();
}

class _DoctorCheckUPPageState extends State<DoctorCheckUPPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Doctor Checkup page',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all()
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text(
                          'Old Checkup History',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            Text('12-2-2023'),
                            Text('12-2-2023'),
                            Text('12-2-2023'),
                          ],
                        )
                      ],
                    ),

                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Detail of the patient',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Text(
                'Date : ',
              ),
              Text(
                'Time : ',
              ),
              Text(
                'Delivered Date : 02-43-3545',
              ),
              Text(
                'Name of the patient :}',
              ),
              Text(
                'Mobile Number :}',
              ),
              Text(
                'Gender :}',
              ),
              Text(
                'Doctor Name :}',
              ),
              Text(
                'Other Detail : }',
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Diagnose Detail of Doctor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              Text(
                '1. Adfa alkdj',
              ),
              Text(
                '2. Adfa alkdj',
              ),
              Text(
                '3. Adfa alkdj',
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Treatment',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              Text(
                '1. Adfa alkdj',
              ),
              Text(
                '2. Adfa alkdj',
              ),
              Text(
                '3. Adfa alkdj',
              ),



            ],
          ),
        ),
      ),
    );
  }
}
