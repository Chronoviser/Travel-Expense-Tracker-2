import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_expense_tracker/constants/global-user.dart';
import 'package:travel_expense_tracker/models/app-user.dart';

class UserHandler {
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  final User user = FirebaseAuth.instance.currentUser;

  Future<bool> joinTrip(String tripId) async {
    try {
      GlobalUser.trips.add(tripId);
      AppUser user = new AppUser(GlobalUser.email, GlobalUser.trips);
      await userReference.doc(GlobalUser.uid).update(user.AppUserToJSON());
      return true;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> createUser({String email}) async {
    if (email == "") {
      email = user.email;
    }

    AppUser newUser = AppUser(email, []);
    try {
      userReference.doc(user.uid).set(newUser.AppUserToJSON());
      return true;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  fetchUserTrips({String email}) async {
    try {
      await userReference.where('email', isEqualTo: email).get().then((val) {
        if (val.docs.length > 0) {
          GlobalUser.trips.clear();

          val.docs[0]
              .data()['trips']
              .forEach((e) => GlobalUser.trips.add(e.toString()));
        }
      });
    } catch (e) {}
  }
}
