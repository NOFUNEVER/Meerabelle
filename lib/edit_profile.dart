import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:meerabelle/add_pet.dart';
import 'home_widget.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, required this.pdex}) : super(key: key);
  int pdex;
  void _incrementCounter() {}

  @override
  State<EditProfile> createState() => _EditProfileState(this.pdex);
}

/// This is the private State class that goes with HomePage.
class _EditProfileState extends State<EditProfile> {
  int pdex=0;
  int dex = 0;
  List? files;
  File? file;
  User? user = FirebaseAuth.instance.currentUser;
  UploadTask? task;
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _nopetsController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();

  _EditProfileState(this.pdex);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final fName = file != null ? basename(file!.path) : 'No File Selected';
    var phone;
    var firstName;
    var lastName;
    var address;
    var nopets;
    var dob;

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)

            .get()

            .then((value) {

          _phoneController.text = value.data()!['Phone Number'];
          _firstNameController.text = value.data()!['First Name'];
          _lastNameController.text = value.data()!['Last Name'];
          _addressController.text = value.data()!['Address'];
          _nopetsController.text = value.data()!['Num Pets'];
          _dobController.text = value.data()!['DOB'];






        }),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Edit Profile '),
            ),
            body: Padding(
              padding:EdgeInsets.all(15.0),
              child: Card( child: Scrollbar(
               isAlwaysShown: true,
                child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'First Name',
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
                        controller: _firstNameController,
                        onChanged: (String value) {
                          firstName = value;
                        },
                        onSaved: (String? value) {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 10.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,

                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 3.0),
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
                        controller: _lastNameController,
                        onChanged: (String value) {
                          lastName = value;
                        },
                        onSaved: (String? value) {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 10.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 3.0),
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
                        controller: _phoneController,
                        onChanged: (String value) {
                          phone = value;
                        },
                        keyboardType: TextInputType.phone,
                        onSaved: (String? value) {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 10.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 3.0),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                        validator: (value) {
                          dob = value;
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: _dobController,
                        onChanged: (String value) {
                          dob = value;
                        },

                        onSaved: (String? value) {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 10.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 3.0),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                        validator: (value) {
                          address = value;
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: _addressController,
                        onChanged: (String value) {
                          address = value;
                        },


                        onSaved: (String? value) {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 10.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Number of Pets',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 3.0),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                        validator: (value) {
                          nopets = value;
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: _nopetsController,
                        onChanged: (String value) {
                          nopets = value;
                        },

                        keyboardType: TextInputType.phone,
                        onSaved: (String? value) {},
                      ),
                    ),

                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }

                        selectFile();
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

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({'DOB': dob});

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({'Address': address});
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({'Num Pets': nopets});


                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomePage(petdex: pdex, dex: 0),
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
        });
  }

  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
//      allowedExtensions: ['jpg', 'img', 'jpeg', 'png'],
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
