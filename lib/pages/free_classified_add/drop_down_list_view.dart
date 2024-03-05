import 'package:flutter/material.dart';

class DropDownListViewForAds extends StatefulWidget {
  final List data;
  final String searchTitle;

  const DropDownListViewForAds(
      {super.key, required this.data, required this.searchTitle});

  @override
  State<DropDownListViewForAds> createState() => _DropDownListViewForAdsState();
}

class _DropDownListViewForAdsState extends State<DropDownListViewForAds> {
  TextEditingController _searchController = TextEditingController();

  List filterList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            children: [
              Container(
                height: 50,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: "Search",
                    hintText: "Search",
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.green,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 20,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  controller: _searchController,
                  onChanged: (value) {
                    getSearchList(value);

                    setState(() {});
                  },
                ),
              ),
              Expanded(
                  child: filterList.isEmpty
                      ? ListView.builder(
                          itemCount: widget.data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                String id = '';
                                if(widget.searchTitle == 'Category1Name'){
                                  id = 'ID1';
                                }else if(widget.searchTitle == 'Category2Name'){
                                  id= 'ID2';
                                }
                                Navigator.pop(context, [widget.data[index][widget.searchTitle], widget.data[index][id]]);
                              },
                              child: ListTile(
                                title:
                                    Text(widget.data[index][widget.searchTitle]),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                String id = '';
                                if(widget.searchTitle == 'Category1Name'){
                                  id = 'ID1';
                                }else if(widget.searchTitle == 'Category2Name'){
                                  id= 'ID2';
                                }
                                Navigator.pop(context, [filterList[index][widget.searchTitle], filterList[index][id]]);
                              },
                              child: ListTile(

                                title:
                                    Text(filterList[index][widget.searchTitle]),
                              ),
                            );
                          },
                        ))
            ],
          ),
        ),
      ),
    );
  }

  getSearchList(String searchValue) {
    List<Map<dynamic, dynamic>> tempList = [];

    for (Map<dynamic, dynamic> element in widget.data) {
      if (element[widget.searchTitle]
          .toString()
          .toLowerCase()
          .contains(searchValue.toLowerCase())) {
        tempList.add(element);
      }
    }
    filterList = tempList;
  }
}
