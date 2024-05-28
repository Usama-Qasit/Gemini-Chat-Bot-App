

import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabel extends StatefulWidget {
  const ImageLabel({super.key});

  @override
  State<ImageLabel> createState() => _ImageLabelState();
}

class _ImageLabelState extends State<ImageLabel> {

  XFile ? pickedImage;
  String myText = '';
  bool scanning = false;

  final ImagePicker imagePicker = ImagePicker();

  getImage(ImageSource ourSource) async {
    XFile? result = await imagePicker.pickImage(source: ourSource);

    if (result != null) {
      setState(() {
        pickedImage = result;
      });

      performTextLabelling();
    }
  }


  performTextLabelling() async {
    if (!mounted) return;
    setState(() {
      scanning = true;
    });
    try {
      final inputImage = InputImage.fromFilePath(pickedImage!.path);

      final imageLabeler = GoogleMlKit.vision.imageLabeler();

      final List labels = await imageLabeler.processImage(inputImage);

      for (var label in labels) {
        myText += '${label.label} (${(label.confidence * 100).toStringAsFixed(2)}%)\n';


        setState(() {
          scanning = false;
        });
        imageLabeler.close();
      }
    } catch (e) {
      print('Error during text recognition : $e');
    }
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Image Labeling")),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            pickedImage == null
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ClayContainer(
                height: 400, child: Center(child: Text("No Image Selected")),),
            ) :
            Center(child: Image.file(File(pickedImage!.path),height: 400,),),

            const SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(onPressed: () {
                  getImage(ImageSource.gallery);
                },
                    icon: const Icon(Icons.photo),

                    label: const Text("Gallery")),

                ElevatedButton.icon(onPressed: () {
                  getImage(ImageSource.camera);
                },
                    icon: const Icon(Icons.camera),
                    label: const Text("Camera"))
              ],
            ),
            const SizedBox(height: 20),
            const Center(child: Text("Recognized label",style: TextStyle(fontSize: 23),),),
            const SizedBox(height: 30,),

            scanning ?
            const Padding(padding: EdgeInsets.only(top: 20),
              child: SpinKitThreeBounce(color: Colors.black, size: 20,),
            ) :
            Center(child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(myText, textAlign: TextAlign.center,),
              ],
            ),),
            const SizedBox(height: 20,),
          ],

        ),
      );
    }
  }


