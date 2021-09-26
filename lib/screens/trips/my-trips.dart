import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_expense_tracker/constants/custom-colors.dart';
import 'package:travel_expense_tracker/constants/global-user.dart';
import 'package:travel_expense_tracker/models/trip.dart';
import 'package:travel_expense_tracker/screens/trips/trip-details.dart';
import 'package:travel_expense_tracker/services/authentication-service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:travel_expense_tracker/services/trip-handler.dart';
import 'package:travel_expense_tracker/services/user-handler.dart';

class MyTrips extends StatefulWidget {
  @override
  _MyTripsState createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool fetchingData = false;
  TripHandler tripHandler = new TripHandler();
  UserHandler userHandler = new UserHandler();
  List<Trip> trips = [];

  signOut() {
    GlobalUser.trips = [];
    GlobalUser.email = "";
    GlobalUser.uid = "";
    context.read<AuthenticationService>().signOut();
  }

  Future<String> joinTripDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          TextEditingController tripidController = TextEditingController();

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: tripidController,
                          validator: (value) {
                            return value.isNotEmpty ? null : "Invalid Field";
                          },
                          decoration: InputDecoration(
                              hintText: 'Trip ID', labelText: 'Enter Trip ID'),
                        )
                      ],
                    ),
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Join'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.of(context).pop(tripidController.text);
                    }
                  },
                )
              ],
            );
          });
        });
  }

  Future<List<String>> createTripDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          TextEditingController tripController = TextEditingController();
          TextEditingController fromController = TextEditingController();
          TextEditingController toController = TextEditingController();

          List<TextEditingController> travelControllers = [
            new TextEditingController()
          ];

          int travellers = 1;

          Widget customTextField(
              {TextEditingController controller, String hintText}) {
            return TextFormField(
              controller: controller,
              validator: (value) {
                return value.isNotEmpty ? null : "Invalid Field";
              },
              decoration: InputDecoration(hintText: hintText),
            );
          }

          // ignore: non_constant_identifier_names
          Widget DatePicker({TextEditingController controller, String label}) {
            controller.text = '$label Date';
            final format = DateFormat("yyyy-MM-dd");
            return DateTimeField(
              controller: controller,
              format: format,
              onShowPicker: (context, _) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(2021),
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2100));
              },
              onChanged: (val) {
                if (val != null) {
                  controller.text =
                      DateFormat('yyyy-MM-dd').format(val).toString();
                }
              },
            );
          }

          List<Widget> wids = [
            customTextField(controller: tripController, hintText: 'Trip Name'),
            DatePicker(controller: fromController, label: 'From'),
            DatePicker(controller: toController, label: 'To'),
            customTextField(
                controller: travelControllers[0], hintText: 'Traveller Name'),
          ];

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: wids,
                    ),
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      List<String> tripData = [];
                      tripData.add(tripController.text.toString().trim());
                      tripData.add(fromController.text.toString().trim());
                      tripData.add(toController.text.toString().trim());
                      for (TextEditingController _controller
                          in travelControllers) {
                        tripData.add(_controller.text.toString().trim());
                      }
                      Navigator.of(context).pop(tripData);
                    }
                  },
                ),
                TextButton(
                  child: Text('Add Traveller'),
                  onPressed: () {
                    setState(() {
                      travelControllers.add(new TextEditingController());
                      wids.add(customTextField(
                          controller: travelControllers[travellers++],
                          hintText: 'Traveller$travellers\'s Name'));
                    });
                  },
                )
              ],
            );
          });
        });
  }

  // ignore: non_constant_identifier_names
  Widget TravelCard({Trip tripData, String docId}) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, _, __) =>
                TripDetail(tripData: tripData, docId: docId)));
      },
      child: Card(
        color: CustomColor.blackTrans,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  tripData.tripName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: CustomColor.white),
                ),
                GestureDetector(
                    onTap: () {
                      deleteTrip(docId);
                    },
                    child: Icon(Icons.delete, color: CustomColor.hint))
              ]),
              SizedBox(height: 10),
              Text(
                '${tripData.travellers.length} Travellers',
                style: TextStyle(fontSize: 16, color: CustomColor.white),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tripData.from,
                      style: TextStyle(fontSize: 16, color: CustomColor.white)),
                  Text('-',
                      style: TextStyle(fontSize: 16, color: CustomColor.white)),
                  Text(tripData.to,
                      style: TextStyle(fontSize: 16, color: CustomColor.white))
                ],
              )
            ],
          ),
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
          title: Text("My Trips"),
          leading: GestureDetector(
              onTap: () {
                joinTripDialog(context).then((val) {
                  if (val != null && val.length > 9) {
                    joinTrip(val);
                  }
                });
              },
              child: Icon(Icons.add_road_rounded)),
          actions: [
            GestureDetector(
                onTap: signOut,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.logout),
                ))
          ]),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/deer.jpg"), fit: BoxFit.cover),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('trips').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            trips.clear();
            List docIds = [];

            snapshot.data.docs.forEach((t) {
              if (GlobalUser.trips.contains(t.data()['id'])) {
                docIds.add(t.id);
                trips.add(Trip.fromJSON(t.data()));
              }
            });

            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return TravelCard(tripData: trips[index], docId: docIds[index]);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.blackTrans,
        child: Icon(Icons.add),
        onPressed: () {
          createTripDialog(context).then((value) {
            if (value != null && value.length > 0) {
              List<String> _travellers = [];
              for (int i = 3; i < value.length; i++) _travellers.add(value[i]);
              Trip newTrip =
                  new Trip(value[0], value[1], value[2], _travellers);
              createTrip(newTrip);
            }
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  fetchUserInfo() async {
    User currentUser = FirebaseAuth.instance.currentUser;
    GlobalUser.uid = currentUser.uid;
    GlobalUser.email = currentUser.email;
    await new UserHandler().fetchUserTrips(email: GlobalUser.email);
    setState(() {});
  }

  showNetworkError() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Network Error!')));
  }

  joinTrip(String tripId) async {
    setState(() {
      fetchingData = true;
    });

    print('before');
    print(GlobalUser.trips);

    await userHandler.joinTrip(tripId);

    print('after');
    print(GlobalUser.trips);

    setState(() {
      fetchingData = false;
    });
  }

  createTrip(newTrip) async {
    await tripHandler.createTrip(newTrip);
  }

  deleteTrip(id) async {
    await tripHandler.deleteTrip(id);
  }
}
