import 'package:Travel_Expense_Tracker/services/toast-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../constants/global-user.dart';
import '../models/app-user.dart';

class UserHandler {
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  final User user = FirebaseAuth.instance.currentUser;

  joinTrip(String tripId) async {
    GlobalUser.trips.add(tripId);
    AppUser user = new AppUser(GlobalUser.email, GlobalUser.trips);
    await userReference.doc(GlobalUser.uid).update(user.AppUserToJSON());
  }

  Future<bool> createUser(BuildContext context) async {
    AppUser newUser = new AppUser(user.email, []);
    try {
      await userReference.doc(user.uid).set(newUser.AppUserToJSON());
      return true;
    } catch (e) {
      ToastService.errorToast(message: e.message, context: context);
      return false;
    }
  }

  fetchUserTrips({String email}) async {
    await userReference.where('email', isEqualTo: email).get().then((val) {
      if (val.docs.length > 0) {
        GlobalUser.trips.clear();

        val.docs[0]
            .data()['trips']
            .forEach((e) => GlobalUser.trips.add(e.toString()));
      }
    });
  }

}
