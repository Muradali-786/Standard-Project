import 'package:com/pages/patient_care_system/price_list_screen/add_price_list.dart';
import 'package:com/pages/patient_care_system/widgets.dart';
import 'package:flutter/material.dart';

import '../sql_file_care_system.dart';

class PriceListMainScreen extends StatefulWidget {
  const PriceListMainScreen({super.key});

  @override
  State<PriceListMainScreen> createState() => _PriceListMainScreenState();
}

class _PriceListMainScreenState extends State<PriceListMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                          child: Text(
                        'Price List',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                menuBtnForCareSystem(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Center(
                              child: Text(
                            'Price List',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Center(
                            child: Text(
                          'Charges',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder <List>(
              future: getAllPriceList(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all()),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Center(
                                          child: Text(
                                            snapshot.data![index]['PriceDetail'].toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Center(
                                        child: Text(
                                          snapshot.data![index]['Prce'].toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                              ),
                              menuBtnForCareSystem(
                                onSelected: (value) async{
                                  if(value == 1) {

                                    await  showGeneralDialog(
                                    context: context,
                                    pageBuilder: (BuildContext
                                    context,
                                        Animation<double> animation,
                                        Animation<double>
                                        secondaryAnimation) {
                                      return AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            bottom:
                                            MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        duration: const Duration(
                                            milliseconds: 300),
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: SizedBox(
                                            height: 300,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(8.0),
                                              child: Material(
                                                  child: AddPriceList(data: snapshot.data![index],)
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    );

                                    setState(() {

                                    });



                                  }
                                }
                              ),
                            ],
                          ),
                        ),
                  );
                }else{
                  return  const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async{

                      await  showGeneralDialog(
                      context: context,
                      pageBuilder: (BuildContext
                      context,
                          Animation<double> animation,
                          Animation<double>
                          secondaryAnimation) {
                        return AnimatedContainer(
                          padding: EdgeInsets.only(
                              bottom:
                              MediaQuery.of(context)
                                  .viewInsets
                                  .bottom),
                          duration: const Duration(
                              milliseconds: 300),
                          alignment: Alignment.center,
                          child: Center(
                            child: SizedBox(
                              height: 300,
                              child: Padding(
                                padding:
                                const EdgeInsets
                                    .all(8.0),
                                child: Material(
                                  child: AddPriceList()
                                ),
                              ),
                            ),
                          ),
                        );

                      },
                      );
                      setState(() {

                      });

                    },
                    child: Text('Add')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
