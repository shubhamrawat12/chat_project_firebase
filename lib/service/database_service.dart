

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  //refernce for our collections
  final CollectionReference userCollection= FirebaseFirestore.instance.collection("users");
  final CollectionReference groupcollection= FirebaseFirestore.instance.collection("groups");


  //saving the user data

  Future savingUserData(String fullname,String email)async{
    return await userCollection.doc(uid).set({
      "fullName": fullname,
      "email":email,
      "groups":[],
      "profilePic":"",
      "uid": uid, 
    });

  }

  //getting user data

  Future gettingUserData(String email)async{
    QuerySnapshot snapshot=await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get user groups

  getUserGroups()async{
    return userCollection.doc(uid).snapshots();
  }

  //creating a group
  Future createGroup(String userName,String id,String groupName)async{
    DocumentReference groupdocumentReference=await groupcollection.add({
      "groupName":groupName,
      "groupIcon":"",
      "admin":"${id}_$userName",
      "members":[],
      "groupId":"",
      "recentMessage":"",
      "recentMessageSender":"",

    });
    //update the members

    await groupdocumentReference.update({
      "members":FieldValue.arrayUnion(["${id}_$userName"]),
      "groupId": groupdocumentReference.id,
    });

    DocumentReference userDocumentReference=userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });
    
  }
  //getting the chats
  getChats(String groupId)async{
    return groupcollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }
  Future getGroupAdmin(String groupId)async{
    DocumentReference d=groupcollection.doc(groupId);
    DocumentSnapshot documentSnapshot=await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId)async{
    return groupcollection.doc(groupId).snapshots();
  }

  //search
  searchByName(String groupName){
    return groupcollection.where("groupName",isEqualTo: groupName).get();
  }
  //function->bool
  Future<bool>isUserJoined(
    String groupName,String groupId,String userName)async {
      DocumentReference userDocumentReference=userCollection.doc(uid);
      DocumentSnapshot documentSnapshot=await userDocumentReference.get();

      List<dynamic> groups =await documentSnapshot['groups'];
      if(groups.contains("${groupId}_$groupName")){
        return true;
      }else{
        return false;
      }
    }

    //toggling the group join/exit
    Future toggleGroupJoin(String groupId,String userName,String groupName)async{
      //doc reference
      DocumentReference userDocumentReference=userCollection.doc(uid);
      DocumentReference groupdocumentReference=groupcollection.doc(groupId);

      DocumentSnapshot documentSnapshot =await userDocumentReference.get();
      List<dynamic> groups=await documentSnapshot['groups'];

      //if user has our groups-> then remove ten or also in other part re join
      if(groups.contains("${groupId}_$groupName")){
        await userDocumentReference.update({
          "groups":FieldValue.arrayRemove(["${groupId}_$groupName"]),
        });
        await userDocumentReference.update({
          "members":FieldValue.arrayRemove(["${groupId}_$groupName"]),
        });
      }else{
        await userDocumentReference.update({
          "groups":FieldValue.arrayUnion(["${groupId}_$groupName"]),
        });
        await groupdocumentReference.update({
          "members":FieldValue.arrayUnion(["${groupId}_$groupName"]),
        });

      }
    }

    //send message 

    sendMessage(String groupId, Map<String, dynamic> chatMessagesData)async{
      groupcollection.doc(groupId).collection("message").add(chatMessagesData);
      groupcollection.doc(groupId).update({
        "recentMessage":chatMessagesData['message'],
        "recentMessageSender":chatMessagesData['sender'],
        "recentMessageTime":chatMessagesData['time'].toString(),

      });
    }



}