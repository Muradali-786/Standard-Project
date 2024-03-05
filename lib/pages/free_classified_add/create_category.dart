import 'dart:convert';
import 'dart:io';

import 'package:com/pages/free_classified_add/drop_down_list_view.dart';
import 'package:com/pages/free_classified_add/image_upload_to_server/image_upload_to_server.dart';
import 'package:com/pages/free_classified_add/sql_file.dart';
import 'package:com/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared_preferences/shared_preference_keys.dart';
import '../../utils/show_inserting_table_row_server.dart';
import '../login/create_account_and_login_code_provider.dart';
import '../material/countrypicker.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  TextEditingController clientAddNumberController = TextEditingController();
  TextEditingController addStatusController = TextEditingController();
  TextEditingController addTitleController = TextEditingController();
  TextEditingController addDetailsController = TextEditingController();
  TextEditingController nameOfPersonController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  Map dropDownMap = {
    "ID": 0,
    'CountryName': "Select Country",
    'CountryCode': 0,
    "ClientID": 0,
    "Image": "",
    'DateFormat': '',
    'CurrencySign': '',
    'Code2': '',
  };
  String countryCode = '+92';
  int? countryClinetId;
  bool check = true;
  String selectCategory1 = 'Select Category';
  List selectedCategory = [];
  List selectedSUBCategory = [];
  List selectedCity = [];

  List<File> imagesPicked = [];

  @override
  void initState() {
    super.initState();

    nameOfPersonController.text = SharedPreferencesKeys.prefs!
        .getString(SharedPreferencesKeys.nameOfPerson)!;
    contactNumberController.text = SharedPreferencesKeys.prefs!
                .getString(SharedPreferencesKeys.mobileNumber)
                .toString()
                .length >
            4
        ? SharedPreferencesKeys.prefs!
            .getString(SharedPreferencesKeys.mobileNumber)!
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Your Ads'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  children: [
                    imagesPicked.isNotEmpty
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imagesPicked.length,
                              itemBuilder: (context, index) => Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(imagesPicked[index]))),
                              ),
                            ),
                          )
                        : SizedBox(),
                    ElevatedButton(
                        onPressed: () async {
                          File? file = await imageUploadingToServer(
                              status: '', mainContext: context);
                          if (file == null) return;
                          imagesPicked.add(file);
                          setState(() {});
                        },
                        child: Text('PIck')),
                  ],
                ),
                FutureBuilder(
                  future: Provider.of<AuthenticationProvider>(context,
                          listen: false)
                      .getAllDataFromCountryCodeTable(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      Future.delayed(
                        Duration.zero,
                        () {
                          if (check) {
                            for (int i = 0; i < snapshot.data!.length; i++) {
                              if (DateTime.now().timeZoneName ==
                                  snapshot.data![i]['SName']) {
                                dropDownMap['ID'] =
                                    snapshot.data[i]['ID'].toString();
                                dropDownMap['CountryName'] =
                                    snapshot.data[i]['CountryName'].toString();
                                dropDownMap['Image'] =
                                    'assets/ProjectImages/CountryFlags/${snapshot.data[i]['CountryName']}.png';
                                dropDownMap['CountryCode'] =
                                    snapshot.data[i]['CountryCode'].toString();
                                dropDownMap['DateFormat'] =
                                    snapshot.data[i]['DateFormat'].toString();
                                dropDownMap['CurrencySign'] = snapshot.data[i]
                                        ['CurrencySigne']
                                    .toString();
                                dropDownMap['Code2'] =
                                    snapshot.data[i]['Code2'].toString();
                                countryClinetId = int.parse(
                                    snapshot.data[i]['ClientID'].toString());
                                // phoneNumberController.text =
                                //     snapshot.data[i]['CountryCode'].toString();
                                SharedPreferencesKeys.prefs!.setString(
                                    SharedPreferencesKeys.dateFormat,
                                    dropDownMap['DateFormat'].toString());
                                SharedPreferencesKeys.prefs!.setString(
                                    SharedPreferencesKeys.currencySign,
                                    dropDownMap['CurrencySign'].toString());
                                SharedPreferencesKeys.prefs!.setString(
                                    'CountryName',
                                    dropDownMap['CountryName'].toString());

                                setState(() {});
                              }
                            }
                            check = false;
                          }
                        },
                      );
                      return Center(
                        child: InkWell(
                          onTap: () async {
                            dropDownMap = await showDialog(
                                  context: context,
                                  builder: (_) => DropDownStyle1Image(
                                    acc1TypeList: snapshot.data,
                                    // dropdown_title: dropDownMap['Title'],
                                    //dropdown_title: dropDownMap['Title'],
                                    map: dropDownMap,
                                  ),
                                ) ??
                                {};

                            if (dropDownMap.isNotEmpty) {
                              setState(
                                () {
                                  countryCode =
                                      dropDownMap['CountryCode'].toString();
                                  String obj =
                                      dropDownMap['ClientID'].toString();
                                  // ignore: unnecessary_null_comparison
                                  if (obj != null) {
                                    countryClinetId = int.parse(obj.toString());
                                  }
                                  print(countryCode);
                                  print(countryClinetId);
                                },
                              );
                            }
                          },
                          child: DropDownStyle1State.DropDownButton(
                            title: dropDownMap['CountryName'].toString(),
                            id: dropDownMap['CountryCode'].toString(),
                            image: dropDownMap['Image'].toString(),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FutureBuilder<List>(
                    future: fetchCityFromServer(
                        countryName: dropDownMap['Code2'].toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return InkWell(
                          onTap: () async {
                            selectedCity = await showDialog(
                                context: context,
                                builder: (_) => DropDownListViewForAds(
                                    data: snapshot.data!, searchTitle: 'City'));

                            setState(() {});
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: ListTile(
                              title: Text(selectedCity.isEmpty
                                  ? 'Select City'
                                  : selectedCity.first),
                              trailing: Icon(
                                Icons.arrow_downward,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FutureBuilder<List>(
                    future: getAddCategory1Data(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return InkWell(
                          onTap: () async {
                            selectedCategory = await showDialog(
                                context: context,
                                builder: (_) => DropDownListViewForAds(
                                    data: snapshot.data!,
                                    searchTitle: 'Category1Name'));

                            selectedSUBCategory.clear();

                            setState(() {});
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: ListTile(
                              title: Text(selectedCategory.isEmpty
                                  ? 'Select Category'
                                  : selectedCategory.first),
                              trailing: Icon(
                                Icons.arrow_downward,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FutureBuilder<List>(
                    future: getAddCategory2Data(
                        ID1: selectedCategory.isEmpty
                            ? 0
                            : selectedCategory.last),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return InkWell(
                          onTap: () async {
                            selectedSUBCategory = await showDialog(
                                context: context,
                                builder: (_) => DropDownListViewForAds(
                                    data: snapshot.data!,
                                    searchTitle: 'Category2Name'));

                            setState(() {});
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: ListTile(
                              title: Text(selectedSUBCategory.isEmpty
                                  ? 'Select Sub Category'
                                  : selectedSUBCategory.first),
                              trailing: Icon(
                                Icons.arrow_downward,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                      controller: clientAddNumberController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text('Client Add Number'))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                      controller: addStatusController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text('Add Status'))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                      controller: addTitleController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text('Add Title'))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                      controller: addDetailsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text('Add Details'))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text('Price'))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                      controller: nameOfPersonController,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text('Name Of Person'))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                      readOnly: true,
                      controller: contactNumberController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          label: Text('Contact Number'))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        Provider.of<ShowInsertingTableRowTOServer>(context,
                                listen: false)
                            .totalNumberOfTableRow(
                                totalNumberOfRow: imagesPicked.length.toInt());
                        Constants.onLoading(
                            context, 'Image Uploading to Server');
                        for (int i = 0; i < imagesPicked.length; i++) {
                          String base64Image =
                              base64Encode(imagesPicked[i].readAsBytesSync());

                          Provider.of<ShowInsertingTableRowTOServer>(context,
                                  listen: false)
                              .insertingRow();
                          await ImageUploadToServer(
                              base64Image, i.toString(), context);
                        }

                        String status = await createCategory(
                            ID3: 0,
                            ClientAddNo: clientAddNumberController.text,
                            AddStatus: addStatusController.text,
                            AddTitle: addTitleController.text,
                            AddDetail: addDetailsController.text,
                            Price: priceController.text,
                            AddGPSPostFrom: '',
                            AddGPSLocation: '',
                            AddArea: '',
                            AddCategory: selectedCategory[0],
                            AddCategory2: selectedSUBCategory[0],
                            context: context,
                            ContactNo: contactNumberController.text,
                            NameOfPerson: nameOfPersonController.text,
                            Country: dropDownMap['CountryName'].toString(),
                            City: selectedCity[0]);

                        Constants.hideDialog(
                          context,
                        );

                        Provider.of<ShowInsertingTableRowTOServer>(context,
                                listen: false)
                            .resetRow();

                        Provider.of<ShowInsertingTableRowTOServer>(context,
                                listen: false)
                            .resetTotalNumber();

                        if (status == 'Insert') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Category Inserted Successfully')));

                          Navigator.pop(context);
                        } else {
                          print(status);
                        }
                      },
                      child: Text('SAVE')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
