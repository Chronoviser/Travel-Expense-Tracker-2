import 'package:Travel_Expense_Tracker/services/toast-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../constants/global-user.dart';
import '../models/app-user.dart';
import '../models/mytrips.dart';
import '../models/trip.dart';

class TripHandler {
  CollectionReference tripReference =
      FirebaseFirestore.instance.collection('trips');

  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<dynamic> getMyTrips() async {
    QuerySnapshot querySnapshot = await tripReference.get();
    MyTrips.fromJSON(querySnapshot.docs);
    return MyTrips.trips;
  }

  Future<bool> createTrip(Trip newTrip, BuildContext context) async {
    String id = newTrip.tripName.split(' ').first +
        "#" +
        newTrip.from.split('-').join('');

    newTrip.id = id;

    try {
      GlobalUser.trips.add(id);
      AppUser user = new AppUser(GlobalUser.email, GlobalUser.trips);

      await userReference.doc(GlobalUser.uid).update(user.AppUserToJSON());
      await tripReference.add(newTrip.TripToJSON());
      return true;
    } catch (e) {
      ToastService.errorToast(message: e.message, context: context);
      return false;
    }
  }

  Future<bool> deleteTrip(String id, BuildContext context) async {
    try {
      await tripReference.doc(id).delete();
      return true;
    } catch (e) {
      ToastService.errorToast(message: e.message, context: context);
      return false;
    }
  }

  Future<bool> updateTrip(Trip updatedTrip, String docId, BuildContext context) async {
    try {
      await tripReference.doc(docId).update(updatedTrip.TripToJSON());
      return true;
    } catch (e) {
      ToastService.errorToast(message: e.message, context: context);
      return false;
    }
  }
}
