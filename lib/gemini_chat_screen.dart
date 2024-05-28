

import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  Map<String, String> header = {
    'Content-Type': 'application/json',
  };



  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];


  getdata(ChatMessage m)async{
    typing.add(geminiUser);
    allMessages.insert(0, m);
    setState(() {

      });

    var data = {"contents":[{"parts":[{"text":m.text}]}]};
    
    await http.post(Uri.parse(ourUrl),headers: header,body: jsonEncode(data))
        .then((value){
          if(value.statusCode == 200){
            var result = jsonDecode(value.body);
            print(result['candidates'][0]['content']['parts'][0]['text']);


            ChatMessage m1= ChatMessage(
              text: result['candidates'][0]['content']['parts'][0]['text'],
                user: geminiUser,
                createdAt: DateTime.now());
    allMessages.insert(0, m1);

          }else{
            print("Error Occured");
          }
    })
        .catchError((e){});
    typing.remove(geminiUser);

    setState(() {

    });

  }

  ChatUser currentUSer = ChatUser(id: "0",firstName: "User");

  ChatUser geminiUser = ChatUser(id: "1",firstName: "Gemini");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text("Gemini Chat Bot",style: TextStyle(fontWeight: FontWeight.w500),)),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI(){
    return DashChat(
      typingUsers: typing,
        currentUser: currentUSer,
        onSend: (ChatMessage m){
          setState(() {
            getdata(m);
          });
        },
        messages: allMessages);
  }



}
