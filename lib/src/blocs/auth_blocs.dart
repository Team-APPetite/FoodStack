import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/services/userAuth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthBloc {
  final authService = UserAuth(auth: FirebaseAuth.instance);
  final googleSignin = GoogleSignIn(scopes: ['email']);

  Stream<User> get currentUser => authService.currentUser;

  loginGoogle() async {

    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken
      );

      //Firebase Sign in
      await authService.signInWithCredential(credential);


    } catch(error){
      print(error);
    }

  }

  logout() {
    authService.logout();
  }
}