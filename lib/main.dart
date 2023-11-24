import 'package:chat_project_firebase/helper/helper_function.dart';
import 'package:chat_project_firebase/pages/home_page.dart';
import 'package:chat_project_firebase/shared/constraints.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn=false;



  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async{
    await HelperFunction.getUserLoggedInStatus().then((value){
      if(value!=null){
        setState(() {
          _isSignedIn =value;
        });
      }

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constraints().primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn? const HomePage() : const LoginPage(),

    );
  }
}


