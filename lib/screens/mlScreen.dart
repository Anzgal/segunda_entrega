import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';


class MLScreen extends StatefulWidget {
  @override
  _MLScreenState createState() => _MLScreenState();
}

class _MLScreenState extends State<MLScreen> {
  File pickedImage;
  var text = '';

  bool imageLoaded = false;

  Future pickImage() async {
    var awaitImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = awaitImage;
      imageLoaded = true;
    });

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);

    final ImageLabeler cloudLabeler =
    FirebaseVision.instance.cloudImageLabeler(CloudImageLabelerOptions(confidenceThreshold: 0.7));

    final List<ImageLabel> cloudLabels =
    await cloudLabeler.processImage(visionImage);

    for (ImageLabel label in cloudLabels) {
      final double confidence = label.confidence;
      setState(() {

        text = text + " " + label.text + " " + confidence.toStringAsFixed(2) + "\n";

        print(text);
      });
    }

    cloudLabeler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 100.0),
          imageLoaded
              ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(blurRadius: 20),
                  ],
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                height: 250,
                child: Image.file(
                  pickedImage,
                  fit: BoxFit.cover,
                ),
              ))
              : Container(),
          SizedBox(height: 10.0),
          Center(
            child: FlatButton.icon(
              icon: Icon(
                Icons.add_photo_alternate,
                size: 80,
              ),
              label: Text(''),
              textColor: Colors.red,
              onPressed: () async {
                pickImage();
              },
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(height: 10.0),
          text == ''
              ? Text('Escoger una imagen para iniciar el reconocimiento')
              : Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  text,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}