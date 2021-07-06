import 'package:agenda_manager_app/ui/addpage.dart';
import 'package:agenda_manager_app/ui/homepage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  final Map<DateTime, List<CleanCalendarEvent>> _events = {};

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Calendar(
            startOnMonday: true,
            weekDays: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
            events: _events,
            isExpandable: true,
            eventDoneColor: Colors.green,
            selectedColor: Colors.pink,
            todayColor: Colors.blue,
            eventColor: Colors.grey,
            locale: 'id_ID',
            todayButtonText: '',
            isExpanded: true,
            expandableDateFormat: 'EEEE, dd MMMM yyyy',
            dayOfWeekStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.list_alt_rounded, title: 'Agenda'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.date_range, title: 'Calendar'),
          ],
          initialActiveIndex: 2, //optional, default as 0
          onTap: (int i) {
            if (i == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return HomePage(text :"OP");
              }));
            } else if (i == 1) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Add("Add");
              }));
            } else if (i == 2) {}
          }),
    );
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}
