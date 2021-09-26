import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_expense_tracker/screens/authentication/signIn.dart';
import 'package:travel_expense_tracker/screens/trips/my-trips.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return firebaseUser == null ? SignIn() : MyTrips();
  }
}
