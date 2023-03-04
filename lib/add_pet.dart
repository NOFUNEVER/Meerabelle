import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';

class AddPet extends StatefulWidget {
  AddPet({Key? key}) : super(key: key);

  void _incrementCounter() {}

  @override
  State<AddPet> createState() => _AddPetState();
}

/// This is the private State class that goes with HomePage.
class _AddPetState extends State<AddPet> {
  int dex = 0;
  List? files;
  File? file;
  User? user = FirebaseAuth.instance.currentUser;
  UploadTask? task;

  _AddPetState();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final fName = file != null ? basename(file!.path) : 'No File Selected';
    var breed;
    ;
    var name;
    var sex;
    var age;
    var weight;
    var species;
    var color;
    var popcon;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Pet'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Container(
                        margin: const EdgeInsets.only(
                            top: 40.0, left: 40.0, right: 40.0, bottom: 20.0),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            contentPadding: const EdgeInsets.only(
                                left: 30, top: 0.0, bottom: 0.0),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent, width: 3.0),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          validator: (value) {
                            name = value;
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (String? value) {},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Species',
                            contentPadding: const EdgeInsets.only(
                                left: 30, top: 0.0, bottom: 0.0),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent, width: 3.0),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          validator: (value) {
                            species = value;
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (String? value) {},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Sex',
                            contentPadding: const EdgeInsets.only(
                                left: 30, top: 0.0, bottom: 0.0),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent, width: 3.0),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          validator: (value) {
                            sex = value;
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          onSaved: (String? value) {},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            contentPadding: EdgeInsets.only(
                                left: 30, top: 0.0, bottom: 0.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 3.0),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          validator: (value) {
                            age = value;
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          onSaved: (String? value) {},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Weight',
                            contentPadding: EdgeInsets.only(
                                left: 30, top: 0.0, bottom: 0.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 3.0),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          validator: (value) {
                            weight = value;
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          onSaved: (String? value) {},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Color',
                            contentPadding: EdgeInsets.only(
                                left: 30, top: 0.0, bottom: 0.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 3.0),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          validator: (value) {
                            color = value;
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          onSaved: (String? value) {},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Breed',
                            contentPadding: EdgeInsets.only(
                                left: 30, top: 0.0, bottom: 0.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 3.0),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          validator: (value) {
                            breed = value;
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          onSaved: (String? value) {},
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Fixed/Spayed',
                            contentPadding: EdgeInsets.only(
                                left: 30, top: 0.0, bottom: 0.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 3.0),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          validator: (value) {
                            popcon = value;
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          onSaved: (String? value) {},
                        ),
                      ),
                      const SizedBox(height: 30),
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
                        child: const Text("Add Profile Picture",
                            style: TextStyle(fontSize: 11)),
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
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            }
                            User? user = FirebaseAuth.instance.currentUser;

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('pets')
                                .doc(name)
                                .set({'name': name});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('pets')
                                .doc(name)
                                .update({'species': species});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('pets')
                                .doc(name)
                                .update({'sex': sex});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('pets')
                                .doc(name)
                                .update({'age': age});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('pets')
                                .doc(name)
                                .update({'weight': weight});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('pets')
                                .doc(name)
                                .update({'breed': breed});
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('pets')
                                .doc(name)
                                .update({'fixed': popcon});
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('pets')
                                .doc(name)
                                .update({'color': color});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('pets')
                                .doc(name)
                                .update({'profile_url': ''});

                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  HomePage(petdex: 0, dex: 0),
                            ));
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.

                            //Navigator.pop(context);

                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  HomePage(petdex: 0, dex: 0),
                            ));
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
            .doc(user.uid)
            .collection('pets')
            .doc('Meera')
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
          final percentage = (progress * 100).toStringAsFixed(2);

          return Text(
            '$percentage %',
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
    ListResult results =
        await storage.ref('files/' + user!.uid + '/').listAll();
    results.items.forEach((Reference ref) {
      print('Found File : $ref');
    });
    return results;
  }

  Future<String> downloadURL(String recordName) async {
    String downloadURL = await storage
        .ref('files/' + user!.uid + '/' + recordName)
        .getDownloadURL();

    return downloadURL;
  }
}
