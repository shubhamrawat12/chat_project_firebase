import 'package:chat_project_firebase/helper/helper_function.dart';
import 'package:chat_project_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{

  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;


  //login
  Future loginWithUserNameandPassword(String email,String password)async{

   try{

    User? user =(await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;

    if(user!=null){

      return true;
    }
   } on FirebaseAuthException catch(e){
    return e.message;
   }
  }



  //register
  Future registerUserWithEmailandPassword(String fullname,String email,String password)async{
   try{

    User? user =(await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;

    if(user!=null){
      //call or database service to update the user data 
      await DatabaseService(uid: user.uid).savingUserData(fullname, email);
      return true;
    }
   } on FirebaseAuthException catch(e){
    return e.message;
   }
  }



  //signout

  Future signout()async{
    try{
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");
      await firebaseAuth.signOut();
      
    }catch(e){
      return null;
    }
  }





}