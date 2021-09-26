import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_expense_tracker/services/user-handler.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  googleLogin() async {
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
      await new UserHandler().createUser();
    }
  }

  signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  signIn({String email, String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  signUp({String email, String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}
