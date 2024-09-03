import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/models/user_models.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth
  });

  void _saveDataToContactsSubcollection(
      UserModel senderUserData,
      UserModel recieverUserData,
      String text,
      DateTime timeSent,
      String recieverUserId,
      ) async{

  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
}) async{
    //users -> sender id -> reciever id -> message -> message id -> store message
    try{
      var timeSent =DateTime.now();
      UserModel recieverUserData ;
      var userDataMap = await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      //users -> reciever user id -> chats-> current User id -> set data

    }
        catch(e){
      showSnackBar(context: context, content: e.toString());
        }
}
}
