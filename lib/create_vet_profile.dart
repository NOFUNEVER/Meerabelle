import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:meerabelle/add_pet.dart';
import 'vet_home_widget.dart';

class CreateVetProfile extends StatefulWidget {
  CreateVetProfile({Key? key}) : super(key: key);

  void _incrementCounter() {}

  @override
  State<CreateVetProfile> createState() => _CreateVetProfileState();
}

/// This is the private State class that goes with HomePage.
class _CreateVetProfileState extends State<CreateVetProfile> {
  int dex = 0;
  List? files;
  File? file;
  User? user = FirebaseAuth.instance.currentUser;
  UploadTask? task;

  _CreateVetProfileState();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final fName = file != null ? basename(file!.path) : 'No File Selected';
    var business_name;
    var dr_onstaff;
    var dr_onstaff2;
    var address;
    var website;
    var phone;
    var firstName;
    var lastName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child:  Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Card( child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        labelText: 'Name of Practice '),
                    validator: (value) {
                      business_name = value;
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String? value) {},
                  ),
                ),
                Container(
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    textAlign: TextAlign.center,
                    decoration:
                        const InputDecoration(labelText: 'Dr. On Staff '),
                    validator: (value) {
                      dr_onstaff = value;
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String? value) {},
                  ),
                ),
                Container(
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    textAlign: TextAlign.center,
                    decoration:
                        const InputDecoration(labelText: 'Dr. On Staff '),
                    validator: (value) {
                      dr_onstaff2 = value;
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String? value) {},
                  ),
                ),
                Container(
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      address = value;
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String? value) {},
                  ),
                ),
                Container(
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    textAlign: TextAlign.center,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
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
                Container(
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Web Site'),
                    validator: (value) {
                      website = value;
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
                  child: const Text("Business Profile Picture",
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
                          .collection('vets')
                          .doc(user!.uid)
                          .update({'business name': business_name});

                      await FirebaseFirestore.instance
                          .collection('vets')
                          .doc(user.uid)
                          .update({'Address': address});
                      await FirebaseFirestore.instance
                          .collection('vets')
                          .doc(user.uid)
                          .update({'Phone Number': phone});
                      await FirebaseFirestore.instance
                          .collection('vets')
                          .doc(user.uid)
                          .update({'Website': website});
                      await FirebaseFirestore.instance
                          .collection('vets')
                          .doc(user.uid)
                          .update({'Dr On Staff #1 ': dr_onstaff});
                      await FirebaseFirestore.instance
                          .collection('vets')
                          .doc(user.uid)
                          .update({'Dr On Staff #2': dr_onstaff2});

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            VetPage(petdex: 0, dex: 0, client: ''),
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
