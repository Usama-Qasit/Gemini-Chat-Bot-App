



import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognition extends StatefulWidget {
  const TextRecognition({super.key});

  @override
  State<TextRecognition> createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {

  XFile? pickedImage;
  String mytext = '';
  bool scanning = false;

  final ImagePicker  imagePicker = ImagePicker();


  getImage(ImageSource ourSource) async {

    XFile? result = await imagePicker.pickImage(source: ourSource);

    if(result != null)
      {
        setState(() {

          pickedImage= result;
        });

        performTextRecognition();
      }


  }



  performTextRecognition()async{

    setState(() {
      scanning =true;

    });


    try{

      final inputImage = InputImage.fromFilePath(pickedImage!.path);

      final textRecognizer = GoogleMlKit.vision.textRecognizer();

      final recognizedText = await textRecognizer.processImage(inputImage);


      setState(() {
        mytext = recognizedText.text;
        scanning = false;
      });

      textRecognizer.close();

    }catch(e){
      
      print("Error during text recognition: $e");

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Text Recognition App")),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [

          pickedImage == null
           ?  const Padding(padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
          child: ClayContainer(height: 400,child: Center(child: Text("No Image Selected")),),
          ):
              Padding(padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 30),
              child: Image.file(File(pickedImage!.path),height: 400,)),
          const SizedBox(height: 20,),

           Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(onPressed: (){getImage(ImageSource.gallery);},
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery")),

              ElevatedButton.icon(onPressed: (){getImage(ImageSource.camera);},
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera")),


            ],
          ),

          const SizedBox(height: 15,),

          const Center(child: Text("Recognized Text",style: TextStyle(fontSize: 23),)),
          const SizedBox(height: 20,),

          scanning?
          const Padding(padding: EdgeInsets.only(top: 10),
            child: Center(child: SpinKitThreeBounce(color: Colors.blue,size: 15,)),
          ):
          Center(
            child: AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(mytext,textAlign: TextAlign.center,)
                ]),
          )
        ],
      ),
    );
  }
}
