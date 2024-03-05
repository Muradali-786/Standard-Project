import 'package:flutter/material.dart';
import 'package:com/pages/general_trading/SalePur/salePurItemUI.dart';
import 'package:com/pages/material/dateGrouping.dart';

class SalePur1UI extends StatefulWidget {
  final List list;
  final Color color;
  final String menuName;
  final Map dropDownMap;
  final String viewStatus;
  final  List newEntriesRecord ;
  final List modifiedRecord;

  const SalePur1UI(
      {required this.color,
        required this.list,
        required this.viewStatus,
        required this.modifiedRecord,
        required this.newEntriesRecord,
        required this.menuName,
        required this.dropDownMap,
        Key? key})
      : super(key: key);

  @override
  State<SalePur1UI> createState() => _SalePur1UIState();
}

class _SalePur1UIState extends State<SalePur1UI> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .6,
        child: ListView(
          children: [
            ///     new Entries /////////    tile
            widget.newEntriesRecord.length == 0
                ? SizedBox()
                : ExpansionTile(
              initiallyExpanded: true,
              children: [
                SalePurItemUI(
                  list: widget.list,
                  entryType: widget.dropDownMap['SubTitle'],
                  color: widget.color,
                  itemData: widget.newEntriesRecord,
                  status: 'newEntriesRecord',
                  menuName: widget.menuName,
                )
              ],
              title: Text('New Entries',
                  style: TextStyle(color: Colors.green)),
            ),

            ///     Modified Record /////////    tile

            widget.modifiedRecord.length == 0
                ? SizedBox()
                : ExpansionTile(
              initiallyExpanded: true,
              children: [
                SalePurItemUI(
                    list: widget.list,
                    entryType: widget.dropDownMap['SubTitle'],
                    menuName: widget.menuName,
                    color: widget.color,
                    itemData:widget.modifiedRecord,
                    status: 'modifiedRecord')
              ],
              title: Text('Modified record',
                  style: TextStyle(color: Colors.orange)),
            ),


            ///   grouping by   date  /////////    tile
            Column(
              children: [
                widget.viewStatus == 'DateTreeView'
                    ? DateGrouping(
                  list: widget.list,
                  color: widget.color,
                  date: 'Date',
                  amount: 'BillAmount',
                  updatedDate: 'UpdatedDate',
                  childWidget: 'Sale',
                  menuName: widget.menuName,
                  dropDownMap: widget.dropDownMap,
                )
                    : SalePurItemUI(
                    color: widget.color,
                    list: widget.list,
                    entryType: widget.dropDownMap['SubTitle'],
                    menuName: widget.menuName,
                    itemData: widget.list,
                    status: 'ListView')
              ],
            ),
          ],
        ),
      ),
    );
  }
}