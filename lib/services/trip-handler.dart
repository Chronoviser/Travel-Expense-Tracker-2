import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_expense_tracker/constants/global-user.dart';
import 'package:travel_expense_tracker/models/app-user.dart';
import 'package:travel_expense_tracker/models/mytrips.dart';
import 'package:travel_expense_tracker/models/trip.dart';

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

  Future<bool> createTrip(Trip newTrip) async {
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
      print(e.message);
      return false;
    }
  }

  Future<bool> deleteTrip(String id) async {
    try {
      await tripReference.doc(id).delete();
      return true;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> updateTrip(Trip updatedTrip, String docId) async {
    try {
      await tripReference.doc(docId).update(updatedTrip.TripToJSON());
      return true;
    } catch (e) {
      print(e.message);
      return false;
    }
  }
}
