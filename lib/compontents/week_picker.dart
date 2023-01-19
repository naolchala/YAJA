import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kPrimary = Color(0xFF219EBC);
const kSecondary = Color(0xFFF26419);
const kDarkBg = Color(0xFF023047);
const kPrimaryLight = Color(0xFF8ECAE6);
const kSecondaryAccent = Color(0xFFF6AE2D);

// Sizes
const kPadding = 20.0;

class WeekDatePicker extends StatefulWidget {
  const WeekDatePicker({
    super.key,
    required this.initialDate,
    required this.onChange,
  });
  final DateTime initialDate;
  final void Function(DateTime value) onChange;

  @override
  State<WeekDatePicker> createState() => _WeekDatePickerState();
}

class _WeekDatePickerState extends State<WeekDatePicker> {
  @override
  Widget build(BuildContext context) {
    var current = widget.initialDate;
    var prevMonthLength = DateTime(current.year, current.month - 1)
        .difference(DateTime(current.year, current.month))
        .abs()
        .inDays;

    var monthLength = DateTime(current.year, current.month)
        .difference(DateTime(current.year, current.month + 1))
        .abs()
        .inDays;

    var startIndex = current.weekday - 1;
    var today = current.day;

    List<DateTime> dates = [];
    List<DateTime> prev = [];

    for (int i = today - startIndex; i < today - startIndex + 7; i++) {
      if (i > 0 && i <= monthLength) {
        dates.add(DateTime(current.year, current.month, i));
      } else if (i <= 0) {
        prev.add(
            DateTime(current.year, current.month - 1, prevMonthLength + i));
      } else {
        dates.add(DateTime(current.year, current.month + 1, i - monthLength));
      }
    }

    dates = [...prev, ...dates];

    var now = DateTime.now();
    var todayDate = DateTime(now.year, now.month, now.day);
    var selectedDate = DateTime(current.year, current.month, current.day);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: kPadding),
      padding: const EdgeInsets.all(kPadding / 2),
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(kPadding / 2),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 30,
            color: kPrimary.withOpacity(0.2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  widget.onChange(
                    current.subtract(
                      const Duration(days: 7),
                    ),
                  );
                },
                icon: const Icon(Icons.keyboard_arrow_left),
                color: Colors.white,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat.yMMMM().format(current),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.onChange(current.add(const Duration(days: 7)));
                  });
                },
                icon: const Icon(Icons.keyboard_arrow_right),
                color: Colors.white,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: kPadding),
          ),
          Row(
            children: [
              ...["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map(
                (e) => Expanded(
                  child: Center(
                    child: Text(
                      e,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...dates.map(
                (date) {
                  return day(
                    date,
                    selected: date.compareTo(selectedDate) == 0,
                    today: date.compareTo(todayDate) == 0,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded day(DateTime date, {bool selected = false, bool today = false}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            widget.onChange(date);
          });
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: kPadding / 4, horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: kPadding / 2),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : kPrimary,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: today
                      ? [
                          const BoxShadow(
                            spreadRadius: 1,
                            color: Colors.white,
                            blurStyle: BlurStyle.inner,
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    "${date.day}",
                    style: TextStyle(
                      color: selected ? kPrimary : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
