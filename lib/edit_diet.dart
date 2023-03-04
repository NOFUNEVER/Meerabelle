import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';

class EditDiet extends StatefulWidget {
  EditDiet({Key? key}) : super(key: key);

  void _incrementCounter() {}

  @override
  State<EditDiet> createState() => _EditDietState();
}

/// This is the private State class that goes with HomePallergy3.
class _EditDietState extends State<EditDiet> {
  int dex = 0;
  List? files;
  File? file;
  User? user = FirebaseAuth.instance.currentUser;
  UploadTask? task;


  _EditDietState();

  final _formKey = GlobalKey<FormState>();

  @override

  Widget build(BuildContext context) {
    final fName = file != null ? basename(file!.path) : 'No File Selected';
    var name;
    var allergy1;
    
    var allergy2;
    var allergy3;
    var med1;
    var med2;
    var med3;
    var popcon;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Pet'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  name = value;
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (String? value) {}, ),
            ),

            Container(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'med2'),
                validator: (value) {
                  med2 = value;
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (String? value) {}, ),
            ),

            Container(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'allergy2'),
                validator: (value) {
                  allergy2 = value;
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                onSaved: (String? value) {}, ),
            ),
            Container(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'allergy3'),
                validator: (value) {
                  allergy3 = value;
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                onSaved: (String? value) {}, ),
            ),

            Container(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'med1'),
                validator: (value) {
                  med1 = value;
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                onSaved: (String? value) {}, ),
            ),


            Container(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'med3'),
                validator: (value) {
                  med3 = value;
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                onSaved: (String? value) {}, ),
            ),

            Container(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'allergy1'),
                validator: (value) {
                  allergy1 = value;
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                onSaved: (String? value) {}, ),
            ),

            Container(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Fixed/Spayed'),
                validator: (value) {
                  popcon = value;
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                onSaved: (String? value) {}, ),
            ),


            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {

                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }

                selectFile(name);
              },
              child: const Text("Add Profile Picture", style: TextStyle(fontSize: 11)),
            ),
            Text(fName, style: const TextStyle(fontSize: 11)),
            task != null ? buildUploadStatus(task!) : Container(),




            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                  User? user = FirebaseAuth.instance.currentUser;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid).collection('pets').doc(name)
                      .set({'name': name});

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid).collection('pets').doc(name)
                      .update({'med2': med2});


                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid).collection('pets').doc(name)
                      .update({'allergy2': allergy2});

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid).collection('pets').doc(name)
                      .update({'allergy3': allergy3});

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid).collection('pets').doc(name)
                      .update({'med1': med1});


                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid).collection('pets').doc(name)
                      .update({'allergy1': allergy1});
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid).collection('pets').doc(name)
                      .update({'fixed': popcon});
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid).collection('pets').doc(name)
                      .update({'med3': med3});


                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid).collection('pets').doc(name)
                      .update({'profile_url': ''});

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(petdex:0,dex: 0),
                  ));


                },
                child: const Text('Submit'),
              ),
            ),



          ],
        ),
      ),
    );
  }





  Future selectFile(String name) async {

    User? user = FirebaseAuth.instance.currentUser;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'img', 'jpeg', 'png'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      file = files[0];
      setState(() => file);

      // Upload file

      for (var i = 0; i < files.length; i++) {
        final fileName = basename(files[i].path);
        final destination = 'files/' + user!.uid + "/" + name + '/profile_pic';
        task = FirebaseApi.uploadFile(destination, files[i]);
        setState(() {});

        if (task == null) return;

        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid).collection('pets').doc('Meera')
            .update({'profile_url': urlDownload});
        print('Download-Link: $urlDownload');
      }
    } else {
      // User canceled the picker
    }
    setState(() {});

  } //selectFile
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentallergy3 = (progress * 100).toStringAsFixed(2);

          return Text(
            '$percentallergy3 %',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        } else {
          return Container();
        }
      });

  void _incrementCounter() {}
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

class Storage {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseStorage storage = FirebaseStorage.instance;


  Future<ListResult> listFiles() async {
    ListResult results = await storage.ref('files/' + user!.uid + '/').listAll();
    results.items.forEach((Reference ref) {
      print('Found File : $ref');
    });
    return results;
  }

  Future<String> downloadURL(String recordName) async {
    String downloadURL = await storage.ref('files/' + user!.uid + '/' + recordName).getDownloadURL();


    return downloadURL;

  }


}