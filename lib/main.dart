import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubercloneapp/AllScreens/loginScreen.dart';
import 'package:ubercloneapp/AllScreens/registrationScreen.dart';
import 'package:ubercloneapp/DataHandler/appData.dart';

import 'AllScreens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef=FirebaseDatabase.instance.reference().child("users");


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>AppData(),
      child: MaterialApp(
        title: 'Uber clone',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FirebaseAuth.instance.currentUser==null? LoginScreen(): MainScreen(),
        debugShowCheckedModeBanner: false ,
      ),
    );
  }
}
