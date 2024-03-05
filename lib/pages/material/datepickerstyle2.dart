// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DatePickerStyle2 extends StatefulWidget {
  const DatePickerStyle2({Key? key}) : super(key: key);

  @override
  _DatePickerStyle2State createState() => _DatePickerStyle2State();
}

class _DatePickerStyle2State extends State<DatePickerStyle2> {
  int selectedDay = DateTime.now().month;
  int selectedDay2 = DateTime.now().month;

  int selectedYear = DateTime.now().year;
  int selectedYear2 = DateTime.now().year;

  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> year = List<int>.generate(100, (int index) => 2000 + index);
  DateTime _currentDate = DateTime.now();

  String date2 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)!;
  String date1 =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.fromDate)!;

  List<int> months2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> year2 = List<int>.generate(100, (int index) => 2000 + index);
  DateTime _currentDate2 = DateTime.now();
  String? dropdownvalue =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat);

  //String  dropdownvalue = 'yyyy-MM-dd';
  var items = [
    // SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat) == 'yyyy-MM-dd' ? 'yyyy-MM-dd' : 'yy-MM-dd',
    // SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat) == 'yy-MM-dd' ? 'yy-MM-dd' : 'dd-MM-yyyy',
    // SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat) == 'dd-MM-yyyy' ? 'dd-MM-yyyy' : 'dd-MM-yy',
    // SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat) == 'dd-MM-yy' ? 'dd-MM-yy' : 'dd-MMM-yy',
    // SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat) == 'dd-MMM-yy' ? 'dd-MMM-yy' : 'dd-MMMM-yy',
    // 'select',
    'yyyy-MM-dd',
    'yy-MM-dd',
    'dd-MM-yyyy',
    'dd-MM-yy',
    'dd-MMM-yy',
    'dd-MMMM-yy',
  ];

  @override
  void initState() {
    _MyCalender();
    _MyCalender2();
    SharedPreferencesKeys.prefs!.setString( SharedPreferencesKeys.dateFormat,SharedPreferencesKeys.dateFormat);
    super.initState();
    _currentDate = DateTime(
        int.parse(date1.substring(0, 4)),
        int.parse(date1.substring(
          6,
          7,
        )),
        int.parse(date1.substring(9, 10)));
    _currentDate2 = DateTime(
        int.parse(date2.substring(0, 4)),
        int.parse(date2.substring(
          6,
          7,
        )),
        int.parse(date2.substring(9, 10)));
    selectedDay = DateTime(
            int.parse(date1.substring(0, 4)),
            int.parse(date1.substring(
              6,
              7,
            )),
            int.parse(date1.substring(9, 10)))
        .month;
    selectedDay2 = DateTime(
            int.parse(date2.substring(0, 4)),
            int.parse(date2.substring(
              6,
              7,
            )),
            int.parse(date2.substring(9, 10)))
        .month;
    selectedYear = DateTime(
            int.parse(date1.substring(0, 4)),
            int.parse(date1.substring(
              6,
              7,
            )),
            int.parse(date1.substring(9, 10)))
        .year;
    selectedYear2 = DateTime(
            int.parse(date2.substring(0, 4)),
            int.parse(date2.substring(
              6,
              7,
            )),
            int.parse(date2.substring(9, 10)))
        .year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 25,
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.blue, width: 2)),
              //     child: Row(
              //       children: [
              //         Icon(
              //           CupertinoIcons.back,
              //           size: 15,
              //         ),
              //         Expanded(
              //           child: ListView.builder(
              //               scrollDirection: Axis.horizontal,
              //               shrinkWrap: true,
              //               itemCount: 3,
              //               itemBuilder: (context, index) {
              //                 return Padding(
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 24.0, vertical: 0),
              //                   child: GestureDetector(
              //                       onTap: () {},
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.center,
              //                         children: [
              //                           Text(
              //                             "ThisDay",
              //                             style: TextStyle(
              //                                 fontWeight: FontWeight.bold,
              //                                 color: Colors.grey),
              //                           ),
              //                         ],
              //                       )),
              //                 );
              //               }),
              //         ),
              //         Icon(
              //           CupertinoIcons.forward,
              //           size: 15,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 35,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text('Date Forment:'),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownvalue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            SharedPreferencesKeys.prefs!.setString(
                                SharedPreferencesKeys.dateFormat,
                                dropdownvalue!);
                          });
                        },
                      ),

                    ],
                  ),
                ),
              ),
              GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, mainAxisExtent: 250),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Column(
                        children: [
                          /////////////////////////////////////////year contaner///////////////////////////////////////
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0,left: 8,right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('From',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(DateFormat(SharedPreferencesKeys.prefs!
                                    .getString(SharedPreferencesKeys.dateFormat))
                                    .format(_currentDate)
                                    .toString(),style: TextStyle(color: Colors.red),),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.blue, width: 2)),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.back,
                                    size: 15,
                                  ),
                                  Expanded(
                                    child: ScrollablePositionedList.builder(
                                        initialScrollIndex:
                                            year.indexOf(_currentDate.year - 1),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: year.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24.0, vertical: 0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _currentDate = DateTime(
                                                        year[index],
                                                        selectedDay,
                                                        1);
                                                    //_calendarCarousel;
                                                    _MyCalender();
                                                    selectedYear = year[index];
                                                  });
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      year[index].toString(),
                                                      style: TextStyle(
                                                          fontSize: year[
                                                                      index] ==
                                                                  selectedYear
                                                              ? 15
                                                              : 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: year[index] ==
                                                                  selectedYear
                                                              ? Colors.black
                                                              : Colors.grey),
                                                    ),
                                                  ],
                                                )),
                                          );
                                        }),
                                  ),
                                  Icon(
                                    CupertinoIcons.forward,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /////////////////////////////////////////whole calender ///////////////////////////////////////
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.blue, width: 2)),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.back,
                                    size: 15,
                                  ),
                                  Expanded(
                                    child: ScrollablePositionedList.builder(
                                        initialScrollIndex: months
                                            .indexOf(_currentDate2.month-1),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: months2.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24.0, vertical: 0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _currentDate = DateTime(
                                                        selectedYear,
                                                        index + 1,
                                                        1);
                                                    //_calendarCarousel;
                                                    _MyCalender();
                                                    selectedDay = index;
                                                  });
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                     months2[index].toString(),
                                                      style: TextStyle(
                                                          fontSize: index ==
                                                                  selectedDay
                                                              ? 15
                                                              : 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: index ==
                                                                  selectedDay
                                                              ? Colors.black
                                                              : Colors.grey),
                                                    ),
                                                  ],
                                                )),
                                          );
                                        }),
                                  ),
                                  Icon(
                                    CupertinoIcons.forward,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              height: 110,
                              child: _MyCalender(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0,left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('To',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(DateFormat(SharedPreferencesKeys.prefs!
                                    .getString(SharedPreferencesKeys.dateFormat))
                                    .format(_currentDate2)
                                    .toString(),style: TextStyle(color: Colors.green)),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.blue, width: 2)),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.back,
                                    size: 15,
                                  ),
                                  Expanded(
                                    child: ScrollablePositionedList.builder(
                                        initialScrollIndex: year
                                            .indexOf(_currentDate2.year - 1),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: year.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24.0, vertical: 0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _currentDate = DateTime(
                                                        year2[index],
                                                        selectedDay2,
                                                        1);
                                                    //_calendarCarousel;
                                                    _MyCalender2();
                                                    selectedYear2 =
                                                        year2[index];
                                                  });
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      year2[index].toString(),
                                                      style: TextStyle(
                                                          fontSize: year2[
                                                                      index] ==
                                                                  selectedYear2
                                                              ? 15
                                                              : 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: year2[index] ==
                                                                  selectedYear2
                                                              ? Colors.black
                                                              : Colors.grey),
                                                    ),
                                                  ],
                                                )),
                                          );
                                        }),
                                  ),
                                  Icon(
                                    CupertinoIcons.forward,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.blue, width: 2)),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.back,
                                    size: 15,
                                  ),
                                  Expanded(
                                    child: ScrollablePositionedList.builder(
                                        initialScrollIndex: months2
                                            .indexOf(_currentDate2.month - 1),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: months2.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24.0, vertical: 0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _currentDate2 = DateTime(
                                                        selectedYear2,
                                                        index + 1,
                                                        1);
                                                    //_calendarCarousel;
                                                    // _MyCalender2();
                                                    selectedDay2 = index;
                                                  });
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      months2[index].toString(),
                                                      style: TextStyle(
                                                          fontSize: index ==
                                                                  selectedDay2
                                                              ? 15
                                                              : 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: index ==
                                                                  selectedDay2
                                                              ? Colors.black
                                                              : Colors.grey),
                                                    ),
                                                  ],
                                                )),
                                          );
                                        }),
                                  ),
                                  Icon(
                                    CupertinoIcons.forward,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.0),
                            width: MediaQuery.of(context).size.width,
                            height: 110,
                            child: _MyCalender2(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back'))
            ],
          ),
        ),
      ),
    );
  }

  _MyCalender() {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        print('.....................$date...........................');
        SharedPreferencesKeys.prefs!
            .setString(SharedPreferencesKeys.fromDate, date.toString());
        setState(() => _currentDate = date);
      },
      maxSelectedDate: DateTime(2050),
      minSelectedDate: DateTime(2000),
      //onCalendarChanged: ,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      selectedDateTime: _currentDate,
      targetDateTime: _currentDate,
      showIconBehindDayText: false,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      isScrollable: false,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      headerMargin: EdgeInsets.all(0),
      showHeader: false,
      dayPadding: 0,
      childAspectRatio: 3,
      daysHaveCircularBorder: false,
    );
  }

  _MyCalender2() {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        print('.........date............$date');
        SharedPreferencesKeys.prefs!
            .setString(SharedPreferencesKeys.toDate, date.toString());
        
        print('.........................${ SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.toDate)}');
        setState(() => _currentDate2 = date);
      },
      maxSelectedDate: DateTime(2050),
      minSelectedDate: DateTime(2000),
      //onCalendarChanged: ,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      selectedDateTime: _currentDate2,
      targetDateTime: _currentDate2,
      showIconBehindDayText: false,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      isScrollable: false,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      showHeader: false,
      headerMargin: EdgeInsets.all(0),
      dayPadding: 0,
      childAspectRatio: 3,
      daysHaveCircularBorder: false,
    );
  }
}
