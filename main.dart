import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_group/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
        primaryColor: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
      title: 'Welcome to Flutter',
      routes: {
        '/': (context)  => FutureBuilder(
          future: _fbApp,
            builder: (context, snapshot){
              if(snapshot.hasError){
                print('Error: ${snapshot.error.toString()}');
                return Text("Error");
              }
              else if(snapshot.hasData){
                return Home();
              }
              else {
                return Center(
                  child: Scaffold(
                    body: Center(
                      child: SpinKitThreeBounce(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
            }
        ),
        '/home': (context) => Home(),
      },
    );
  }
}