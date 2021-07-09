import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/services/userAuth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthBloc {
  final authService = UserAuth(auth: FirebaseAuth.instance);
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User> get currentUser => authService.currentUser;
  User get user => authService.user;

  Future<String> loginGoogle() async {

    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken
      );

      //Firebase Sign in
     String result = await authService.signInWithCredential(credential);
     return result;

    } catch(error){
      print(error);
      return error.toString();
    }

  }

  logout() {
    authService.logout();
  }
}