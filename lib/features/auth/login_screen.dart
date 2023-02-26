import 'package:code/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;
  bool _loading = false;


  Future<void> _signInWithGoogle() async {
    showToast("loading..", isLoading: true);
    setState(() {
      _loading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final data = {
          'name': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
        };
        await docRef.set(data, SetOptions(merge: true));
        Navigator.pushReplacementNamed(context, '/homeScreen');
    
      }
    } catch (e) {
      showToast("error while logging in", isError: true);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Center(
        child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _signInWithGoogle,
                        icon: Icon(Icons.login),
                        label: Text('Sign in with Google'),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton.icon(
                        onPressed: ()=>Navigator.pushReplacementNamed(context, '/homeScreen'),
                        icon: Icon(Icons.skateboarding_rounded),
                        label: Text('Skip'),
                      ),
                    ],
                  )
            // : Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text('Welcome, ${_user!.displayName}!'),
            //       // SizedBox(height: 20.0),
            //       ElevatedButton(
            //         onPressed: () async {
            //           await _auth.signOut();
            //           setState(() {
            //             _user = null;
            //           });
            //         },
            //         child: Text('Sign Out'),
            //       ),
            //     ],
            //   ),
      ),
    );
  }
}
