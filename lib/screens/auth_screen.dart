import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chat/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  AuthResult authResult;
  var _isLoading = false;

  void _submitAuthForm(String email, String userName, File image,  String password,

      bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
//        this checks the user if he is signed in
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
//        this creates a new user
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
//        child creates a folder and second child creates the file under that folder
        final ref = FirebaseStorage.instance.ref().child('user_images').child(authResult.user.uid+'.jpg');
//        this puts the image in the file when it is complete
        await ref.putFile(image).onComplete;

//      this gets the url to the image stored in firebase storage
        final url = await ref.getDownloadURL();

//        storing the image as part of the users collection
        await Firestore.instance.collection('users').document(authResult.user.uid).setData({
          'username':userName,
          'email':email,
          'imageUrl':url
        });

      }

    } on PlatformException catch (err) {
      String message = 'An error occured, Please check your credentials';

      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }catch (err){
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
