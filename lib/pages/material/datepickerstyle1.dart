// ignore_for_file: non_constant_identifier_names, unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:com/shared_preferences/shared_preference_keys.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DatePickerStyle1 extends StatefulWidget {
  const DatePickerStyle1({Key? key}) : super(key: key);

  @override
  _DatePickerStyle1State createState() => _DatePickerStyle1State();
}

class _DatePickerStyle1State extends State<DatePickerStyle1> {
  int selectedDay = DateTime.now().day;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> year = List<int>.generate(100, (int index) => 2000 + index);
  DateTime _currentDate = DateTime.now();
  CalendarCarousel _calendarCarousel = CalendarCarousel();
  String? dropdownvalue =
      SharedPreferencesKeys.prefs!.getString(SharedPreferencesKeys.dateFormat);

  //String  dropdownvalue = 'yyyy-MM-dd';
  var items = [
    'yyyy-MM-dd',
    'yy-MM-dd',
    'dd-MM-yyyy',
    'dd-MM-yy',
    'dd-MMM-yy',
    'dd-MMMM-yy',
  ];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
    setState(() {
      _MyCalender();
    });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? obj = SharedPreferencesKeys.prefs!
        .getString(SharedPreferencesKeys.dateFormat);
    DateTime dateTimeData = DateTime.now();
    var formated = DateFormat('yyyy-MM-dd');
    String formattedDate = formated.format(dateTimeData);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text('Date Format:'),
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
                      // Text(
                      //   "From",
                      //   style: TextStyle(
                      //       color: Colors.red, fontWeight: FontWeight.bold),
                      // ),
                      Spacer(),
                      // Text(
                      //   DateFormat(SharedPreferencesKeys.prefs!.getString(
                      //           SharedPreferencesKeys.dateFormat))
                      //       .format(_currentDate)
                      //       .toString(),
                      //   style: TextStyle(
                      //       color: Colors.green,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      obj == null
                          ? Text(
                        formattedDate,
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                          : Text(
                        DateFormat(SharedPreferencesKeys.prefs!
                            .getString(SharedPreferencesKeys
                            .dateFormat))
                            .format(_currentDate)
                            .toString(),
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 2)),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.back),
                      Expanded(
                        child: ScrollablePositionedList.builder(
                            scrollDirection: Axis.horizontal,
                            initialScrollIndex:
                            year.indexOf(selectedYear- 1),
                            itemCount: year.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 0),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _currentDate = DateTime(
                                            year[index], selectedMonth, 1);
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
                                              fontSize: year[index] ==
                                                  selectedYear
                                                  ? 30
                                                  : 25,
                                              fontWeight: FontWeight.bold,
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
                      Icon(CupertinoIcons.forward),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: _MyCalender(),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      width: 300,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                          Border.all(color: Colors.blue, width: 2)),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.back),
                          Expanded(
                            child: ScrollablePositionedList.builder(
                                scrollDirection: Axis.horizontal,

                                initialScrollIndex:
                                months.indexOf(_currentDate.month -2),
                                itemCount: months.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 0),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _currentDate = DateTime(
                                                selectedYear,
                                                index + 1,
                                                1);
                                            //_calendarCarousel;
                                            _MyCalender();
                                            selectedMonth = months[index];
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              months[index].toString(),
                                              style: TextStyle(
                                                  fontSize: months[
                                                  index] ==
                                                      selectedMonth
                                                      ? 30
                                                      : 25,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: months[index] ==
                                                      selectedMonth
                                                      ? Colors.black
                                                      : Colors.grey),
                                            ),
                                            // Container(
                                            //  // margin: EdgeInsets.symmetric(vertical: 20 / 2),
                                            //   height: 6,
                                            //   width: 40,
                                            //   decoration: BoxDecoration(
                                            //     borderRadius: BorderRadius.circular(10),
                                            //     color: index == selectedDay
                                            //         ? Colors.black
                                            //         : Colors.transparent,
                                            //   ),
                                            // )
                                          ],
                                        )),
                                  );
                                }),
                          ),
                          Icon(CupertinoIcons.forward),
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _MyCalender() {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        print('......$date');
        Navigator.pop(context, date);
        //Navigator.pop(context, DateFormat('yyyy-MM-dd').format(date));
        // print(date);
        // setState(() => _currentDate = date);
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
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
       height: MediaQuery.of(context).size.height  * .6,
      width: MediaQuery.of(context).size.width,
      daysHaveCircularBorder: false,
    );
  }
}
