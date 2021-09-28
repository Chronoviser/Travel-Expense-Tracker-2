import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/custom-colors.dart';
import '../../models/activity.dart';
import '../../models/record.dart';
import '../../models/spending.dart';
import '../../models/trip.dart';
import '../trips/activity-details.dart';
import '../trips/trip-tally.dart';
import '../../services/trip-handler.dart';

class TripDetail extends StatefulWidget {
  final Trip tripData;
  final String docId;

  TripDetail({Key key, this.tripData, this.docId}) : super(key: key);

  @override
  _TripDetailState createState() => _TripDetailState(
      tripData.id,
      tripData.tripName,
      tripData.from,
      tripData.to,
      tripData.travellers,
      tripData.activities,
      tripData.tally);
}

class _TripDetailState extends State<TripDetail> {
  TripHandler tripHandler = new TripHandler();
  Trip currentTrip;
  bool updatesDone = false;
  bool allowOperations = false;
  String tripStatus = "Pending";

  _TripDetailState(id, tripName, from, to, travellers, activities, tally) {
    currentTrip = new Trip.withActivity(
        id, tripName, from, to, travellers, activities, tally);
  }

  Future<List<String>> createActivityDialog(BuildContext context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return await showDialog(
        context: context,
        builder: (context) {
          TextEditingController activityController = TextEditingController();
          String priceType = "perHead";
          TextEditingController priceController = TextEditingController();
          List<int> spendings = [];
          String whoPaid;
          bool enabled = false;

          currentTrip.travellers.forEach((_) => spendings.add(0));

          void setSpendings({String type}) {
            if (type == "custom") {
              setState(() {
                enabled = true;
                priceController.text = "0";
              });
            } else {
              setState(() {
                enabled = false;
              });
            }
          }

          Widget customTextField(
              {TextEditingController controller, String hintText}) {
            return TextFormField(
              controller: controller,
              validator: (value) {
                return value.isNotEmpty ? null : "Invalid Activity Name";
              },
              decoration: InputDecoration(hintText: hintText),
            );
          }

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customTextField(
                            controller: activityController,
                            hintText: 'Activity Name'),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: DropdownButton<String>(
                                value: priceType,
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
                                iconSize: 24,
                                elevation: 16,
                                onChanged: (newValue) {
                                  setSpendings(type: newValue);
                                  setState(() {
                                    priceType = newValue;
                                  });
                                },
                                items: <String>[
                                  'perHead',
                                  'Total',
                                  'custom'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(width: 20),
                            enabled
                                ? Container()
                                : Container(
                                    width: 100,
                                    child: TextFormField(
                                      enabled: !enabled,
                                      controller: priceController,
                                      validator: (value) {
                                        return (value.isEmpty ||
                                                value.length > 5)
                                            ? "Invalid Price"
                                            : null;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: 'Activity Price'),
                                    ))
                          ],
                        ),
                        SizedBox(height: 10),
                        DropdownButton<String>(
                          hint: Text('Who Paid?'),
                          value: whoPaid,
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (newValue) {
                            setState(() {
                              whoPaid = newValue;
                            });
                          },
                          items: [...currentTrip.travellers, 'dutch']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        enabled
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 150,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: CustomColor.hint),
                                ),
                                child: ListView.builder(
                                  itemCount: currentTrip.travellers.length,
                                  itemBuilder: (context, index) {
                                    return FractionallySizedBox(
                                      widthFactor: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: TextField(
                                                onChanged: (val) {
                                                  spendings[index] =
                                                      int.parse(val);
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                style: TextStyle(
                                                    color: Colors.blue),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'spent',
                                                ),
                                              )),
                                          Expanded(
                                              flex: 6,
                                              child: Text(currentTrip
                                                  .travellers[index])),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (_formKey.currentState.validate() && whoPaid != null) {
                      var activityData = {
                        'activity': activityController.text.toString().trim(),
                        'type': priceType,
                        'price': priceController.text.toString(),
                        'paidBy': whoPaid,
                        'spendings': spendings
                      };

                      List<String> _data = [];
                      _data.add(jsonEncode(activityData));

                      Navigator.of(context).pop(_data);
                    }
                  },
                )
              ],
            );
          });
        });
  }

  // ignore: non_constant_identifier_names
  Widget ActivityCard({Activity activityData}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, _, __) =>
                ActivityDetails(activity: activityData)));
      },
      child: Card(
        color: CustomColor.blackTrans,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activityData.activity,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,
                    color: CustomColor.white),
              ),
              SizedBox(height: 10),
              Text(
                activityData.type == "custom"
                    ? "₹ custom"
                    : '₹ ${activityData.price} /${activityData.type}',
                style: TextStyle(fontSize: 16,
                    color: CustomColor.white),
              ),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  '💰 ${activityData.paidBy}',
                  style: TextStyle(fontSize: 16,
                      color: CustomColor.white),
                ),
                allowOperations
                    ? GestureDetector(
                        onTap: () {
                          deleteActivity(activityData);
                        },
                        child: Icon(Icons.delete, color: CustomColor.hint))
                    : Container()
              ])
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, updatesDone);
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(currentTrip.tripName),
            actions: [
              Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child:
                      Text(tripStatus, style: TextStyle(color: Colors.green)))
            ],
          ),
          body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/greenery.jpg"), fit: BoxFit.cover),
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
                          Text("Trip Id: ${currentTrip.id}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("From: ${currentTrip.from}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("To: ${currentTrip.to}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Travellers: ${currentTrip.travellers}',
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
                      children: currentTrip.activities.reversed
                          .map<Widget>((activityData) =>
                              ActivityCard(activityData: activityData))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: CustomColor.blackTrans,
                    heroTag: null,
                    child: Icon(Icons.account_balance_wallet_outlined),
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, _, __) =>
                              TripTally(tripData: currentTrip)));
                    },
                  ),
                  allowOperations
                      ? FloatingActionButton(
                          backgroundColor: CustomColor.blackTrans,
                          heroTag: null,
                          child: Icon(Icons.add),
                          onPressed: () {
                            createActivityDialog(context).then((value) {
                              if (value != null && value.length > 0) {
                                Activity activity = activityFromData(value[0]);

                                createActivity(activity);
                              }
                            });
                          })
                      : Container()
                ],
              ))),
    );
  }

  @override
  void initState() {
    super.initState();
    updateTripStatus();
  }

  updateTripStatus() {
    int a = DateTime.now().difference(DateTime.parse(currentTrip.from)).inDays;
    int b = DateTime.now().difference(DateTime.parse(currentTrip.to)).inDays;
    if (a >= 0 && b <= 0) {
      setState(() {
        tripStatus = "Day ${a + 1}";
        allowOperations = true;
      });
    } else if (b > 0) {
      setState(() {
        tripStatus = "Complete";
      });
    }
  }

  showNetworkError() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Network Error!')));
  }

  createActivity(Activity activity) async {
    updateTally(activity);
    currentTrip.activities.add(activity);
    var response = await tripHandler.updateTrip(currentTrip, widget.docId, context);
    if (response)
      setState(() {
        updatesDone = true;
      });
    else {
      showNetworkError();
      currentTrip.activities.removeLast();
    }
  }

  deleteActivity(Activity activity) async {
    deUpdateTally(activity);
    int index = currentTrip.activities.indexOf(activity);
    currentTrip.activities.removeAt(index);
    var response = await tripHandler.updateTrip(currentTrip, widget.docId, context);
    if (response)
      setState(() {
        updatesDone = true;
      });
    else {
      showNetworkError();
      currentTrip.activities.insert(index, activity);
    }
  }

  activityFromData(String data) {
    var activityData = json.decode(data);

    String _activity = activityData['activity'];
    String _type = activityData['type'];
    int _price = int.parse(activityData['price']);
    String _paidBy = activityData['paidBy'];
    List<int> _spendings = [];
    activityData['spendings'].forEach((e) => _spendings.add(e));

    if (_paidBy != "dutch") {
      if (_type == "perHead") {
        for (int i = 0; i < _spendings.length; i++) {
          _spendings[i] = _price;
        }
      } else if (_type == "Total") {
        for (int i = 0; i < _spendings.length; i++) {
          _spendings[i] = (_price / _spendings.length).round();
        }
      }
    }

    List<Spending> _spends = [];

    for (int i = 0; i < currentTrip.travellers.length; i++) {
      _spends.add(new Spending(currentTrip.travellers[i], _spendings[i]));
    }

    return new Activity(_activity, _price, _paidBy, _type, _spends);
  }

  void updateTally(Activity activity) {
    for (int i = 0; i < activity.spendings.length; i++) {
      bool present = false;
      for (int j = 0; j < currentTrip.tally.length; j++) {
        if (currentTrip.tally[j].to != activity.paidBy) continue;
        if (currentTrip.tally[j].by == activity.spendings[i].name &&
            activity.spendings[i].name != activity.paidBy) {
          currentTrip.tally[j].amount += activity.spendings[i].amount;
          present = true;
          break;
        }
      }

      if (!present && activity.spendings[i].name != activity.paidBy) {
        currentTrip.tally.add(new Record(activity.spendings[i].name,
            activity.paidBy, activity.spendings[i].amount));
      }
    }
  }

  void deUpdateTally(Activity activity) {
    for (int i = 0; i < activity.spendings.length; i++) {
      for (int j = 0; j < currentTrip.tally.length; j++) {
        if (currentTrip.tally[j].to != activity.paidBy) continue;
        if (currentTrip.tally[j].by == activity.spendings[i].name &&
            activity.spendings[i].name != activity.paidBy) {
          currentTrip.tally[j].amount -= activity.spendings[i].amount;
          break;
        }
      }
    }
  }
}
