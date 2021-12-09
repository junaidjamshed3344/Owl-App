import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/TimeSlot.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Model/ViewVariables.dart';

class TimeRange extends StatefulWidget {
  final List<TimeSlot> timeSlots;

  TimeRange(this.timeSlots);

  @override
  _TimeRangeState createState() => _TimeRangeState();
}

class _TimeRangeState extends State<TimeRange> {
  DateTime _time1;
  DateTime _time2;
  String _errorMsg;
  bool _errorStatus;

  Widget getHeightSizeBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget getWidthSizeBox(double width) {
    return SizedBox(
      width: width,
    );
  }

  @override
  void initState() {
    _time1 = new DateTime.now();
    _time2 = new DateTime.now().add(new Duration(minutes: 1));
    _errorMsg = "";
    _errorStatus = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.twentyMultiplier))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LabelsClass.selectDuration(context),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          getHeightSizeBox(SizeConfig.tenMultiplier),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    LabelsClass.startTime(context),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    padding: EdgeInsets.only(right: SizeConfig.fiveMultiplier),
                    child: TimePickerSpinner(
                      is24HourMode: true,
                      normalTextStyle: TextStyle(
                          fontSize: SizeConfig.eighteenMultiplier,
                          color: Colors.grey[400]),
                      highlightedTextStyle: TextStyle(
                          fontSize: SizeConfig.eighteenMultiplier,
                          color: Theme.of(context).buttonColor),
                      itemHeight: SizeConfig.thirtyMultiplier,
                      itemWidth: SizeConfig.thirtyMultiplier,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        setState(() {
                          print(time);
                          print(_time2);
                          if (time.compareTo(_time2) < 0) {
                            _time1 = time;
                            setState(() {
                              _errorStatus = false;
                              _errorMsg = "";
                            });
                          } else {
                            print(LabelsClass.error(context));
                            setState(() {
                              _errorStatus = true;
                              _errorMsg =
                                  LabelsClass.startTimeErrorMessage1(context);
                            });
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              getWidthSizeBox(SizeConfig.fortyMultiplier),
              Column(
                children: [
                  Text(
                    LabelsClass.endTime(context),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    padding: EdgeInsets.only(right: SizeConfig.fiveMultiplier),
                    child: TimePickerSpinner(
                      is24HourMode: true,
                      normalTextStyle: TextStyle(
                          fontSize: SizeConfig.eighteenMultiplier,
                          color: Colors.grey[400]),
                      highlightedTextStyle: TextStyle(
                          fontSize: SizeConfig.eighteenMultiplier,
                          color: Theme.of(context).buttonColor),
                      itemHeight: SizeConfig.thirtyMultiplier,
                      itemWidth: SizeConfig.thirtyMultiplier,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        setState(() {
                          print(time);
                          print(_time1);
                          if (time.compareTo(_time1) > 0) {
                            _time2 = time;
                            setState(() {
                              _errorStatus = false;
                              _errorMsg = "";
                            });
                          } else {
                            print(LabelsClass.error(context));
                            setState(() {
                              _errorStatus = true;
                              _errorMsg =
                                  LabelsClass.endTimeErrorMessage1(context);
                            });
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          getHeightSizeBox(SizeConfig.tenMultiplier),
          Text(
            _errorMsg,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_errorStatus == false) {
              if (Controller.addProfileScreenToTimeSlots(
                      timeSlots: widget.timeSlots,
                      time: TimeSlot(startTime: _time1, endTime: _time2)) ==
                  0) {
                widget.timeSlots
                    .add(TimeSlot(startTime: _time1, endTime: _time2));
                ViewVariables.profileDataInputScreenRefresh.call();
                Navigator.of(context).pop();
              } else {
                setState(() {
                  _errorMsg =
                      "${LabelsClass.timeOverlapErrorMessage1(context)}\n ${Controller.addProfileScreenToGetOverlapTimeSlot().startTime.hour}:${Controller.addProfileScreenToGetOverlapTimeSlot().startTime.minute} - ${Controller.addProfileScreenToGetOverlapTimeSlot().endTime.hour}:${Controller.addProfileScreenToGetOverlapTimeSlot().endTime.minute}";
                });
              }
            }
          },
          child: Text(
            LabelsClass.save(context),
          ),
        ),
      ],
    );
  }
}
