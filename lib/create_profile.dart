import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:meerabelle/add_pet.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key? key}) : super(key: key);

  void _incrementCounter() {}

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

/// This is the private State class that goes with HomePage.
class _CreateProfileState extends State<CreateProfile> {
  int dex = 0;
  List? files;
  File? file;
  User? user = FirebaseAuth.instance.currentUser;
  UploadTask? task;

  _CreateProfileState();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final fName = file != null ? basename(file!.path) : 'No File Selected';
    var phone;
    var firstName;
    var lastName;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('...a few quick questions to get started',   style: TextStyle(fontSize:17)  ),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(5.0),

            child: SingleChildScrollView(child:
            Form(
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
                        labelText: 'First Name',
                        contentPadding: const EdgeInsets.only(
                            left: 30, top: 0.0, bottom: 0.0),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 3.0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),

                      validator: (value) {
                        firstName = value;
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
                        top: 40.0, left: 40.0, right: 40.0, bottom: 20.0),
                    child: TextFormField(
                      // The validator receives the text that the user has entered.
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        contentPadding:
                            EdgeInsets.only(left: 30, top: 0.0, bottom: 0.0),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 3.0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                      validator: (value) {
                        lastName = value;
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
                        top: 40.0, left: 40.0, right: 40.0, bottom: 20.0),
                    child: TextFormField(
                      // The validator receives the text that the user has entered.
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        contentPadding:
                            EdgeInsets.only(left: 30, top: 0.0, bottom: 0.0),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 3.0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                      validator: (value) {
                        phone = value;
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      onSaved: (String? value) {},
                    ),
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () async {
                      selectFile();
                    },
                    child: const Text("Add Profile Picture",
                        style: TextStyle(fontSize: 15)),
                  ),
                  Text(fName, style: const TextStyle(fontSize: 15)),
                  task != null ? buildUploadStatus(task!) : Container(),
                  const SizedBox(height: 50),
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
                            .doc(user!.uid)
                            .update({'First Name': firstName});

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'Last Name': lastName});
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'Phone Number': phone});

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => AddPet(),
                        ));
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
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
        final destination = 'files/' + user!.uid + "/" + 'profile_pic';
        task = FirebaseApi.uploadFile(destination, files[i]);
        setState(() {});

        if (task == null) return;

        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

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
