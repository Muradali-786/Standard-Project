import 'package:com/pages/beauty_salon/sql_file_beauty_salon.dart';
import 'package:flutter/material.dart';

class AddServicePriceList extends StatefulWidget {
  final Map? data;

  const AddServicePriceList({super.key, this.data});

  @override
  State<AddServicePriceList> createState() => _AddServicePriceListState();
}

class _AddServicePriceListState extends State<AddServicePriceList> {
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceDesController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController chargeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      serviceNameController.text = widget.data!['ServiceName'].toString();
      serviceDesController.text = widget.data!['ServiceDescriptions'].toString();
      durationController.text = widget.data!['ServiceDuration'].toString();
      chargeController.text = widget.data!['Price'].toString();
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
              controller: serviceNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                label: Text(
                  'Service Name',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: serviceDesController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                label: Text(
                  'Service Description',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: durationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                label: Text(
                  'Duration in minutes',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: chargeController,
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

                    if(widget.data == null) {
                      await addNewServicePriceList(
                          Price: chargeController.text,
                          ServiceDuration: durationController.text,
                          ServiceDescriptions: serviceDesController.text,
                          ServiceName: serviceNameController.text);

                      // if (insert) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text('Inserted Successfully')));
                      //
                      // }
                    }else{
                      updateServicePriceList( Price: chargeController.text,
                          ServiceDuration: durationController.text,
                          ServiceDescriptions: serviceDesController.text,
                          ServiceName: serviceNameController.text , ID: widget.data!['ID'].toString());
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
