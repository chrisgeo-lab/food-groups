import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math' show Random;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<String> validCode(String code, context) async {
  String error = '';
  if(code.isEmpty){
    FocusScope.of(context).unfocus();
    return error;
  }
  if(code.length != 4){
    error = 'Make sure that your code has four letters';
  }
  else if(!await inDatabase(code)){
    // TODO: check if already in database
    error = 'That code doesn\'t exist';
  }
  return error;
}

Future<bool> inDatabase(code) async {
  dynamic value;
  DatabaseReference _ref = FirebaseDatabase.instance.reference();
  value = await FirebaseDatabase.instance.reference().child('sessions/$code').once().then((DataSnapshot snapshot) {
  print('Connected to second database and read ${snapshot.value}');

  if(snapshot.value != null) return true;
  return false;
  });

  // check if in database, if not then add
  return value;
}

Future<void> addUser(code) async {
  DatabaseReference _ref = FirebaseDatabase.instance.reference().child('sessions/$code/users');
  await _ref.once().then((DataSnapshot snapshot){
    print('${snapshot.value}');
    if(snapshot.value == null){
      _ref.set(1);
    }
    else{
      _ref.set(snapshot.value + 1);
    }
  });
}

Future<String> generateCode() async {
  String ret;
  while(true){
    ret = randomAlpha(4).toUpperCase();
    // DUMMY CODE SO FIREBASE DOESNT GET CRAZY
    // ret = 'HAHA';
    if(await inDatabase(ret)) {
      continue;
    }
    else {
      DatabaseReference _code = FirebaseDatabase.instance.reference().child('sessions/$ret');
      FirebaseDatabase.instance.reference().child('sessions/$ret/started').set(false);
      addUser(ret);
      break;
    }
    /* TODO: add code to database and remember to lock */
  }
  return ret;
}

void freeCode(code) async {
  print('removing ${code}');
  FirebaseDatabase.instance.reference().child('sessions/$code').remove();
}

Future<void> startSession(code) async {
  return FirebaseDatabase.instance.reference().child('sessions/$code/started').set(true);
}

 Future<void> sessionReady(code) async {
  FirebaseDatabase.instance
      .reference()
      .child('sessions/$code/started')
      .onValue
      .listen((event) {
    // process event
    if(event.snapshot.value == true){
      return;
    }
  });
}

Stream<Event> refStart(code) {
  return FirebaseDatabase.instance.reference().child('sessions/$code').onValue;
}

