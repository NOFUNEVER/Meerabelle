import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:meerabelle/client_search.dart';
import 'package:meerabelle/create_profile.dart';
import 'home_widget.dart';
import 'vet_home_widget.dart';
import 'create_vet_profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const users = {
  'jason.lamphere@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
@override
  State<LoginScreen> createState() => _LoginScreenState();

}


class _LoginScreenState extends State<LoginScreen> {
  @override
  User? user =  FirebaseAuth.instance.currentUser;
  Duration get loginTime => Duration(milliseconds: 4250);

  // sign in with google
  Future<UserCredential> signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    ).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );




  User? user =  await FirebaseAuth.instance.signInWithCredential(credential) as User?;


    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        // Access your after your get the data
      } else {
        showAlertGoogleDialog(context);
      }

return user;
    });

    // Once signed in, return the UserCredential
    return  FirebaseAuth.instance.signInWithCredential(credential);
  }

  //
  Future<String?> _signupUser(SignupData data, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: '${data.name}', password: '${data.password}');
      User user = userCredential.user!;








    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return Future.delayed(loginTime).then((_) {
      showAlertDialog(data,context);

      return null;
    });
  }

  Future<String?> _authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: data.name, password: data.password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          return 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');




          return 'Wrong password provided for that user.';
        }


      }


      if (user != null && user!.emailVerified) {
        await user!.sendEmailVerification();
      }

      return null;
    });
  }



  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return 'null';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'meerabelle',
      logo: 'assets/images/meera2.png',
      onLogin: _authUser,
      onSignup: (data) => _signupUser(data,context),
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: Icons.g_mobiledata,
          label: 'Google',
          callback: () async {
            print('start google sign in');
            signInWithGoogle(context);
            await Future.delayed(loginTime);
            print('stop google sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () async {
        User? user = await FirebaseAuth.instance.currentUser;

       // print(user!.uid);

        FirebaseFirestore.instance
            .collection('vets')
            .doc(user!.uid)
            .get()
            .then((value) async {
          if (value.exists ) {


                   await Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => ClientSearchPage(petdex: 0, dex: 0),
                    ));



/*

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomePage(petdex: 0, dex: 0),
              )); // Acc

  */

          }
        });


        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((value) async {
          if (value.exists ) {







              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomePage(petdex: 0, dex: 0),
              )); // Acc



          }
        });



      },
      onRecoverPassword: _recoverPassword,
    );
  }
}

showAlertDialog(data, BuildContext context) {
  // set up the buttons

  User? user = FirebaseAuth.instance.currentUser;
  Widget petButton = TextButton(
    child: const Text("Pet Parent"),
    onPressed: () async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({'profile_exists': 'no'});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'email': '${data.name}'});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profile_type': 'pet'});

      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => CreateProfile(),
      ));
    },
  );
  Widget vetButton = TextButton(
    child: const Text("Veterinarian"),
    onPressed: () async {
      await FirebaseFirestore.instance
          .collection('vets')
          .doc(user!.uid)
          .set({'profile_exists': 'no'});

      await FirebaseFirestore.instance
          .collection('vets')
          .doc(user.uid)
          .update({'email': '${data.name}'});

      await FirebaseFirestore.instance
          .collection('vets')
          .doc(user.uid)
          .update({'profile_type': 'vet'});
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => CreateVetProfile(),
      ));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hey!"),
    content: Text("What are you using this App For?"),
    actions: [
      petButton,
      vetButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertGoogleDialog( BuildContext context) {
  // set up the buttons

  User? user = FirebaseAuth.instance.currentUser;
  Widget petButton = TextButton(
    child: Text("Pet Parent"),
    onPressed: () async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({'profile_exists': 'no'});


      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profile_type': 'pet'});

      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => CreateProfile(),
      ));
    },
  );
  Widget vetButton = TextButton(
    child: Text("Veterinarian"),
    onPressed: () async {
      await FirebaseFirestore.instance
          .collection('vets')
          .doc(user!.uid)
          .set({'profile_exists': 'no'});



      await FirebaseFirestore.instance
          .collection('vets')
          .doc(user.uid)
          .update({'profile_type': 'vet'});
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => CreateVetProfile(),
      ));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hey!"),
    content: Text("What are you using this App For?"),
    actions: [
      petButton,
      vetButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
