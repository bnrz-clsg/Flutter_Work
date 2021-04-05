import 'package:capstone_project/services/globalvariable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String gusername;
String email;
String imageUrl;

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    gusername = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;

    // FirebaseDatabase.instance.reference().child('users').child(user.uid).set({
    //   'username': name,
    //   'email': email,

    // });
    currentFirebaseUser = user;

    if (gusername.contains(" ")) {
      gusername = gusername.substring(0, gusername.indexOf(" "));
    }

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');

    return '$user';
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Signed Out");
}

Future<void> signOutEmail() async {
  await FirebaseAuth.instance.signOut();
  await googleSignIn.signOut();
  print("User Signed Out");
}
