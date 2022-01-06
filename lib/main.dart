import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:userstoryy/authenticatoin/forgotpassword.dart';
import 'package:userstoryy/authenticatoin/login.dart';
import 'package:userstoryy/authenticatoin/register.dart';
import 'package:userstoryy/pages/home.dart';
import 'package:userstoryy/pages/product.dart';
import 'package:userstoryy/service/alternateloading.dart';
import 'Dialog/dialog_helper.dart';
import 'error/error.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'register': (context) => Register(),
        'password': (context) => Password(),
        'error': (context) => Errors(),
        'product': (context) => Product(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent[700],
        accentColor: Colors.white,
        textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            headline2: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
            headline3: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            bodyText1: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
            bodyText2: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent[700])),
      )));
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late User? user;

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> initialisation = Firebase.initializeApp();
    return WillPopScope(
      child: FutureBuilder(
          future: initialisation,
          builder: (context, snapshot) {
            if (snapshot.hasError) Navigator.of(context).pushNamed('error');
            if (snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    user = snapshot.data as User?;
                    if (user == null) {
                      return LogIn();
                    } else {
                      return Home();
                    }
                  }
                  return Alternateloading();
                },
              );
            }
            return Errors();
          }),
      onWillPop: () async {
        return await DialogHelper.exit(context);
      },
    );
  }
}
