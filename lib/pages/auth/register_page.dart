// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_project_firebase/helper/helper_function.dart';
import 'package:chat_project_firebase/pages/auth/login_page.dart';
import 'package:chat_project_firebase/pages/home_page.dart';
import 'package:chat_project_firebase/service/auth_service.dart';
import 'package:chat_project_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading=false;
  final formKey=GlobalKey<FormState>();
  String email="";
  String password="";
  String fullName="";
  AuthService authService=AuthService(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_isLoading? Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor)): SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 80),
              child: Form(
                key: formKey,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Groupie,",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    const Text("Create your account now to chat and explore",
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400)),
                    Image.asset("assets/register.png"),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        labelText: "Full Name",
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        )
                      ),
                      onChanged: (val){
                        setState(() {
                          fullName=val;
                        });
                      },
              
                      //check the validation
                     validator: (val){
                      if(val!.isNotEmpty){
                        return null;
                      }else{
                        return "Name cannot be empty ";
                      }
                     },
              
              
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        )
                      ),
                      onChanged: (val){
                        setState(() {
                          email=val;
                        });
                      },
              
                      //check the validation
                      validator: (val){
                        return  RegExp( r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&*+-/=?^-{|}~]+@[a-zA-Z0-9]+\.[-a-zA-Z]+")
                        .hasMatch(val!)?null: "Please enter a valid email";
                      },
              
              
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        )
                      ) ,
                      validator: (val){
                        if(val!.length<6){
                          return "Password must be at least 6 character ";
                        }else{
                          return null;
                        }
                      },
                      onChanged: (val){
                        setState(() {
                          password=val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          )
                        ),
                        onPressed: (){
                          register();
                        },
                        child: const Text("Register",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(           
                        text: "Already have an account ? ",
                        style: const TextStyle(color: Colors.black,fontSize: 14,),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Login Now ",
                            style: const TextStyle(color: Colors.black,decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap =(){
                              nextScreen(context, const LoginPage());
                            }),
                          
                        ],
                        
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        );
  }
  
  register() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password).then((value)async{
        log(value.toString(), name: "register response");
        if(value==true){
          //saving the shared preference state
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePage());
        }else{
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading=false;
          });
        }

      });
    }
  }
}