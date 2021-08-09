import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_group/session.dart';
import 'package:food_group/pages/waiting.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Image logo;
  String code = "";

  @override
  void initState(){
    super.initState();
    logo = Image.asset(
      'assets/carrot.png',
      width: 100,
      height: 200,
    );

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();

      precacheImage(logo.image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Group'),
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      logo,
                      Text(
                        'Food Group',
                          style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0,
                          // shadows: <Shadow>[
                          //   Shadow(
                          //     offset: Offset(3.0, 3.0),
                          //     blurRadius: 3.0,
                          //     color: Colors.grey[900],
                          //   ),
                          // ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: 100,
                width: 300,
                alignment: Alignment.center,
                child: TextField(
                  scrollPadding: EdgeInsets.all(8),
                  onSubmitted: (code) async {
                    if(!code.isEmpty){
                      print('input: $code');
                      // validate code
                      String error = '';
                      error = await validCode('$code', context);
                      // send to waiting page
                      if(error.isEmpty){
                        addUser(code);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Waiting(
                            code: code,
                            sessionLeader: false,
                          )),
                        );
                      }
                      else {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                                'Oops...'
                            ),
                            content: Text(
                              error,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
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
                    }
                  },
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 2.0,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue)
                      ,
                    ),
                    contentPadding: EdgeInsets.all(0),
                    labelText: "Code",
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      color: Colors.blue,
                    ),
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(Radius.circular(100)),
                    // ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: CustomButton(
                  label: "Create Party",
                  onPressed: () async {
                    // TODO
                    print("creating session...");
                    code = await generateCode();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Waiting(
                        code: code,
                        sessionLeader: true,
                      )),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  CustomButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(
          250,
          40,
        ),
        primary: Colors.grey[500],
        backgroundColor: Colors.grey[900],
        // backgroundColor: Colors.teal,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ),
    );
  }
}

