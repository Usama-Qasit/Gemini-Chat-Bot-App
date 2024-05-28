
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextSummarizer extends StatefulWidget {
  const TextSummarizer({super.key});

  @override
  State<TextSummarizer> createState() => _TextSummarizerState();
}

class _TextSummarizerState extends State<TextSummarizer> {

  final TextEditingController inputText =  TextEditingController();
  final TextEditingController suggestion = TextEditingController();

  String summary = '';
  bool scanning = false;


  final apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBOc2ts8zgx0DxK5_tL1x4PWdzSrvNOGQ0';


  Map<String, String> header = {
    'Content-Type': 'application/json',
  };


  getdata(myText,howtoSummarize)async{
    setState(() {
      scanning =true;
    });

    var data = {"contents":[{"parts":[{"text":"$howtoSummarize - $myText"}]}]};

    await http.post(
      Uri.parse(apiUrl),
      headers: header,
      body: jsonEncode(data)).then((response){

      if(response.statusCode == 200){
        var result = jsonDecode(response.body);


        setState(() {
          summary = result['candidates'][0]['content']['parts'][0]['text'];
        });
      }else{
        print('Request failed with status: ${response.statusCode}');
      }
    }).catchError((error){
      print('Error: $error');
    });

    setState(() {
      scanning = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Center(child: Text("Text Summarizer")),
    ),
      body:  Padding(
          padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              controller: inputText,
              maxLines: 15,
              decoration: const InputDecoration(
                hintText: "Enter text to summarize",
              ),
            ),

            const SizedBox(height: 12,),

            TextField(
              controller: suggestion,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: "How to summarize",
              ),
            ),
            const SizedBox(height: 15,),
            
            ElevatedButton(
                onPressed: ()async{
                  getdata(inputText.text,suggestion.text);
                },
                child: const Text("Summarize Text")),

            const SizedBox(height: 40,),
            
            scanning?
                const Padding(padding: EdgeInsets.only(top: 20),
                  child: Center(child: CircularProgressIndicator(),),
                ):
                Padding(padding: const EdgeInsets.only(top: 23),
                child: Text(summary,style: const TextStyle(fontSize : 15, fontWeight: FontWeight.bold),),),

          ],
        ),
      ),
    );
  }
}
