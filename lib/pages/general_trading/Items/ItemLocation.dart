import 'package:com/pages/general_trading/Items/ItemsSQL.dart';
import 'package:flutter/material.dart';
import '../../../shared_preferences/shared_preference_keys.dart';

/////////////////////////////////////////////////////////////////////////////////
///////////       Location Entry Dialog    ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class ItemLocationDialogUI extends StatefulWidget {
  final Map? locationName;
  final String status;

  ItemLocationDialogUI({required this.status, Key? key, this.locationName})
      : super(key: key);

  @override
  _ItemLocationDialogUIState createState() => _ItemLocationDialogUIState();
}

class _ItemLocationDialogUIState extends State<ItemLocationDialogUI> {
  int? clientID =
      SharedPreferencesKeys.prefs!.getInt(SharedPreferencesKeys.clinetId);

  TextEditingController location_name = TextEditingController();
  int maxID = 0;
  String btnCondition = 'save';
  ItemSql _itemSql = ItemSql();

  @override
  void initState() {
    super.initState();
    if (widget.status == 'Edit') {
      btnCondition = 'Edit';
      location_name.text = widget.locationName!['Title'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Location Entry",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Center(
                    child: FutureBuilder(
                      future: _itemSql.maxIdForSalePurLocation(),
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!.toString(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: DropdownButton(
                    //     items: LocationDetailList.map((String location) {
                    //       return DropdownMenuItem<String>(
                    //         value: location,
                    //         child: new Text(location),
                    //       );
                    //     }).toList(),
                    //     onChanged: (val) {
                    //       setState(() {
                    //         location_name.text = val.toString();
                    //         location = val.toString();
                    //         btnCondition = 'Edit';
                    //       });
                    //     },
                    //     value: _selectedLocation,
                    //   ),
                    // ),
                    TextFormField(
                      controller: location_name,
                      decoration: InputDecoration(
                          label: Text('Stock Location'),
                          border: OutlineInputBorder()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width / 3,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown,
                                      // background
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ) // foreground
                                      ),
                                  onPressed: () async {
                                    if (btnCondition == 'save') {
                                      var res =
                                          await _itemSql.insertSalePurLocation(
                                              location_name.text,
                                              context: context);
                                      print('111');
                                      print(res);
                                    } else {
                                      await _itemSql.UpdateSalePurLocation(
                                          widget.locationName!['ID'],
                                          location_name.text);
                                    }
                                  },
                                  child: Text(
                                    btnCondition,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.brown[100],
                            border: Border.all(width: 0, color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
