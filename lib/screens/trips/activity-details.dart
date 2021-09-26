import 'package:flutter/material.dart';
import 'package:travel_expense_tracker/constants/custom-colors.dart';
import 'package:travel_expense_tracker/models/activity.dart';
import 'package:travel_expense_tracker/models/spending.dart';

class ActivityDetails extends StatefulWidget {
  final Activity activity;

  ActivityDetails({Key key, this.activity}) : super(key: key);

  @override
  _ActivityDetailsState createState() => _ActivityDetailsState(activity);
}

class _ActivityDetailsState extends State<ActivityDetails> {
  final Activity activity;

  _ActivityDetailsState(this.activity);

  // ignore: non_constant_identifier_names
  Widget SpendingCard({Spending spendingData}) {
    return Card(
      color: CustomColor.blackTrans,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spendingData.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: CustomColor.white),
            ),
            SizedBox(height: 10),
            Text(
              '₹ ${spendingData.amount}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.teal),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(activity.activity),
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    color: Colors.black54,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Price: ${activity.price}",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Price Type: ${activity.type}",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Paid by: ${activity.paidBy}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: activity.spendings
                        .map<Widget>(
                            (spending) => SpendingCard(spendingData: spending))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
