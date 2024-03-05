import 'package:com/pages/patient_care_system/sql_file_care_system.dart';
import 'package:flutter/material.dart';

class AddPriceList extends StatefulWidget {
  final Map? data;

  const AddPriceList({super.key, this.data});

  @override
  State<AddPriceList> createState() => _AddPriceListState();
}

class _AddPriceListState extends State<AddPriceList> {
  TextEditingController opdChargesController = TextEditingController();
  TextEditingController chargesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      opdChargesController.text = widget.data!['PriceDetail'].toString();
      chargesController.text = widget.data!['Prce'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: opdChargesController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                label: Text(
                  'OPD Charges',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: chargesController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                label: Text(
                  'Charges',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close')),
              ElevatedButton(
                  onPressed: () async {
                    if (widget.data == null) {
                      await addNewPriceList(
                          PriceDetail: opdChargesController.text,
                          Price: chargesController.text);
                    } else {
                      updatePriceList(
                          PriceDetail: opdChargesController.text,
                          Price: chargesController.text,
                          ID: widget.data!['ID'].toString());
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Add')),
            ],
          )
        ],
      ),
    );
  }
}
