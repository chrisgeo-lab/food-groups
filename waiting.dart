import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_group/pages/selection.dart';
import 'dart:async';

import 'package:food_group/session.dart';

class Waiting extends StatefulWidget {
  final String code;
  final bool sessionLeader;
  const Waiting({Key key, this.code, this.sessionLeader}) : super(key: key);

  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  Widget build(BuildContext context) {
    // TODO: Potentially add number of users connected
    // TODO: Add listener for when leader starts
    // TODO: Maybe turn some code into reusable functions (exit to home for example)
    if(widget.sessionLeader){
      return Scaffold(
        appBar: AppBar(
          title: Text('Food Group'),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.grey[200],
              ),
              onPressed: () {
                // TODO: remove leader, code and other users from database - update other users pages
                freeCode(widget.code);
                Navigator.pushReplacementNamed(
                    context,
                    '/',
                );
                },
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 125, 0, 0),
            child: Column(
              children: <Widget>[
                Text(
                  "code:",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  widget.code,
                  style: TextStyle(
                    fontSize: 75.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'users: ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                StreamBuilder(
                  stream: refStart(widget.code),
                    builder: (BuildContext context, snapshot) {
                      int users = snapshot.data.snapshot.value['users'];
                      return Text(
                        '$users',
                        style: TextStyle(
                          fontSize: 75.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Colors.blue,
                        ),
                      );
                    }
                ),
                SizedBox(
                  height: 70.0,
                ),
                ElevatedButton(
                  child: Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  style:OutlinedButton.styleFrom(
                    minimumSize: Size(
                      150,
                      50,
                    ),
                    primary: Colors.grey[500],
                    backgroundColor: Colors.grey[900],
                    // backgroundColor: Colors.teal,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                  onPressed: (){
                      startSession(widget.code);
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Selection(
                        code: widget.code,
                        sessionLeader: widget.sessionLeader,
                      )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    return StreamBuilder(
        stream: refStart(widget.code),
        builder: (BuildContext context, snapshot){
          if(snapshot.hasError || snapshot.data.snapshot.value == null){
            return Scaffold(
              appBar: AppBar(
                title: Text('Food Group'),
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey[200],
                    ),
                    onPressed: () {
                      // TODO: remove user from database
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                      );
                    },
                  )
                ],
              ),
              body: AlertDialog(
                  title: Text(
                      'Oops...'
                  ),
                  content: Text(
                    'This session has been closed',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: (){
                        Navigator.popAndPushNamed(context, '/');
                      },
                      child: Text(
                        'ok',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
            );
          }
          bool started = snapshot.data.snapshot.value['started'];
          print('started value: $started');
          if(snapshot.connectionState == ConnectionState.active && started){
            return Selection(
              code: widget.code,
              sessionLeader: widget.sessionLeader,
            );
          }
          else{
            return Scaffold(
              appBar: AppBar(
                title: Text('Food Group'),
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey[200],
                    ),
                    onPressed: () {
                      // TODO: remove user from database
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                      );
                    },
                  )
                ],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 125, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "code:",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        widget.code,
                        style: TextStyle(
                          fontSize: 75.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        'Waiting for host to start...',
                        style: TextStyle(
                          color: Colors.grey[200],
                        ),
                      ),
                      SpinKitThreeBounce(
                        color: Colors.white,
                        size: 25.0,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
    );
  }
}
