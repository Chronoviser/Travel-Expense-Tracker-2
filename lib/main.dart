import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travel_expense_tracker/screens/authentication/authentication-wrapper.dart';
import 'package:travel_expense_tracker/services/authentication-service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider<User>(
            create: (context) =>
            context.read<AuthenticationService>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:
          ThemeData(primaryColor: Colors.black, accentColor: Colors.black),
          home: AuthenticationWrapper()),
    );
  }
}
