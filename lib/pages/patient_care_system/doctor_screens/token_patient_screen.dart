import 'package:flutter/material.dart';


class TokenPatientScreen extends StatefulWidget {
  const TokenPatientScreen({super.key});

  @override
  State<TokenPatientScreen> createState() => _TokenPatientScreenState();
}

class _TokenPatientScreenState extends State<TokenPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.green,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Token Line'  , style: TextStyle(fontSize: 18),),
                  ),
                ),
              ),
            ),

          ListView.builder (itemCount: 5 , shrinkWrap : true ,  physics:  NeverScrollableScrollPhysics(), itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 50,
                        child: Text('$index', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Junaid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('12344'),
                              Text('Checked :  8 :00')
                            ],
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.check, color: Colors.green,),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),)

          ],
        ),
      ),
    );
  }
}
