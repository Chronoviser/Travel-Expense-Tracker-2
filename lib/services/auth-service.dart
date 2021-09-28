import 'package:Travel_Expense_Tracker/services/shared-prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user-handler.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  googleLogin(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential authResult =
        await _firebaseAuth.signInWithCredential(credential);

    User _user = authResult.user;

    if (_user != null && authResult.additionalUserInfo.isNewUser) {
      await new UserHandler().createUser(context);
    }

    await SharedPrefs.storeData(email: _user.email, uid: _user.uid);
  }

  signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();

    await SharedPrefs.logout();
  }

  signIn({String email, String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    await SharedPrefs.storeData(
        email: email, uid: _firebaseAuth.currentUser.uid);
  }

  signUp({String email, String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await SharedPrefs.storeData(
        email: email, uid: _firebaseAuth.currentUser.uid);
  }
}
