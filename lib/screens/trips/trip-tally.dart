import 'package:flutter/material.dart';
import 'package:travel_expense_tracker/constants/custom-colors.dart';
import 'package:travel_expense_tracker/models/trip.dart';

class TripTally extends StatefulWidget {
  final Trip tripData;

  TripTally({Key key, this.tripData}) : super(key: key);

  @override
  _TripTallyState createState() => _TripTallyState(tripData);
}

class _TripTallyState extends State<TripTally> {
  final Trip trip;

  _TripTallyState(this.trip);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tally'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: trip.tally
                  .map<Widget>((record) => record.amount == 0
                      ? Container()
                      : Card(
                          color: CustomColor.blackTrans,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: record.by,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColor.white,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' should pay ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColor.white)),
                                TextSpan(
                                    text: record.to,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColor.white,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: '\n\n₹ ${record.amount}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: CustomColor.teal,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                          ),
                        ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
