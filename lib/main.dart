import 'package:Travel_Expense_Tracker/screens/trips/my-trips.dart';
import 'package:Travel_Expense_Tracker/services/shared-prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/authentication/signIn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  SharedPrefs sharedPrefs = new SharedPrefs();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.black),
        //    home: SignIn()
        home: FutureBuilder(
          future: sharedPrefs.tryAutoLogin(),
          builder: (context, res) {
            if (res.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white60,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (res.data == true) {
                return MyTrips();
              }
              return SignIn();
            }
          },
        ));
  }
}
