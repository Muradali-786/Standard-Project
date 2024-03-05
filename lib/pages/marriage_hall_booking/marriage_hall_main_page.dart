import 'package:com/pages/marriage_hall_booking/details_page.dart';
import 'package:com/pages/marriage_hall_booking/sql_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import 'booking_page.dart';

class MarriageHallMainPage extends StatefulWidget {
  const MarriageHallMainPage({super.key});

  @override
  State<MarriageHallMainPage> createState() => _MarriageHallMainPageState();
}

class _MarriageHallMainPageState extends State<MarriageHallMainPage> {
  String selectedShift = 'Day';

  List<MarkedDate> markedEventDate = [];
  List<DateTime> eventDate = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              markedEventDate.clear();
                              selectedShift = 'Night';
                            });
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: selectedShift == 'Night'
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black)),
                            child: Center(child: Text('Night')),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              markedEventDate.clear();
                              selectedShift = 'Day';
                            });
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: selectedShift == 'Day'
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black)),
                            child: Center(child: Text('Day')),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            markedEventDate.clear();
                            selectedShift = 'Morning';
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: selectedShift == 'Morning'
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black)),
                          child: Center(child: Text('Morning')),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              FutureBuilder<List>(
                future: getOrderShiftStatus(Shift: selectedShift),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    markedEventDate.clear();
                    eventDate.clear();
                    snapshot.data!.forEach((element) {
                      eventDate.add(
                          DateTime.parse(element!['EventDate'].toString()));
                      if (element['ClientName'] == 'Jua') {
                        markedEventDate.add(
                          MarkedDate(
                              color: Colors.blue,
                              date: DateTime.parse(
                                  element!['EventDate'].toString())),
                        );
                      } else {
                        markedEventDate.add(
                          MarkedDate(
                              color: Colors.lightGreen,
                              date: DateTime.parse(
                                  element!['EventDate'].toString())),
                        );
                      }
                    });

                    return CalendarCarousel<Event>(

                      onDayPressed: (DateTime date, List<Event> events) async {
                        List data = await getBookingDate(
                          Shift: selectedShift,
                          eventDate: date.toString().substring(0, 10),
                        );

                        if (data.isEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingPage(
                                    eventDate: date.toString(),
                                    shift: selectedShift),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsBookingPage(data: data[0]),
                              ));
                        }
                      },

                      multipleMarkedDates: MultipleMarkedDates(
                        markedDates: markedEventDate,
                      ),
                      maxSelectedDate: DateTime(2060),
                      minSelectedDate: DateTime(2000),
                      scrollDirection: Axis.vertical,
                      showIconBehindDayText: false,
                      customGridViewPhysics: NeverScrollableScrollPhysics(),
                      markedDateShowIcon: true,
                      markedDateIconMaxShown: 2,
                      selectedDayTextStyle: TextStyle(
                        color: Colors.yellow,
                      ),
                      thisMonthDayBorderColor: Colors.grey,
                      weekFormat: false,
                      height: MediaQuery.of(context).size.height * .5,

                      width: MediaQuery.of(context).size.width,
                      daysHaveCircularBorder: false,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
