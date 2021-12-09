import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:owl/Controller/Controller.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Controller.initFirebaseMessagingForNotifications();
      Controller.saveLoginType(0, email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Controller.initFirebaseMessagingForNotifications();
      Controller.saveLoginType(0, email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential uc = await FirebaseAuth.instance.signInWithCredential(credential);
    Controller.checkIfFirstTimeSignUp();
    Controller.initFirebaseMessagingForNotifications();
    Controller.saveLoginType(1);
    return uc;
  }

  /*Future<bool> signOutOfGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }*/

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken.token);
      UserCredential uc =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Controller.checkIfFirstTimeSignUp();
      Controller.initFirebaseMessagingForNotifications();
      Controller.saveLoginType(2);
      return uc;
    } else if (result.status == LoginStatus.failed) {
      print("\n\nreturning null");
      print(result.message);
      print("\n\n");
    }
    return null;
  }
}
