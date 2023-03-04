import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'create_vet_profile.dart';
import 'create_profile.dart';

class EditPet extends StatefulWidget {
  int pdex;
  EditPet({Key? key, required this.pdex}) : super(key: key);

  void _incrementCounter() {}

  @override
  State<EditPet> createState() => new _EditPetState(this.pdex);
}

/// This is the private State class that goes with HomePage.
class _EditPetState extends State<EditPet> {
  int pdex=0;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  int dex = 0;
  List? files;
  File? file;
  User? user = FirebaseAuth.instance.currentUser;
  UploadTask? task;
  TextEditingController _nameController = new TextEditingController();

   TextEditingController _speciesController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();
   TextEditingController _breedController = new TextEditingController();

   TextEditingController _colorController = new TextEditingController();
   TextEditingController _weightController = new TextEditingController();
   TextEditingController _sexController = new TextEditingController();
   TextEditingController _fixedController = new TextEditingController();
  List<DocumentSnapshot> petsList = [];

//  varString species;//
  // = user.instance.last_name;
  var breed;
  var name;
  var sex;
  var age;
  var weight;
  var species;
  var color;
  var popcon;

  @override
  void initState() {



    //  _speciesController.text = species;
    //  _ageController.text = age;
    //  _breedController.text = breed;
    //  _colorController.text =color;
    //  _weightController.text=weight;
    //  _sexController.text=sex;
    //  _fixedController.text=popcon;

    return super.initState();
  }

  @override
  //void _handleSubmitted() {
  //  final FormState? form = _formKey.currentState;
  //  if (!form!.validate()) {
  //    showInSnackBar('Please fix the errors in red before submitting.');
  //  } else {
  //    showInSnackBar('snackchat');
  //    name = firstName;
  //    User.instance.last_name = lastName;

  //    User.instance.save().then((result) {
  //      print("Saving done: ${result}.");
  //    });
  //  }
  // }

  _EditPetState(this.pdex);



  @override
  Widget build(BuildContext context) {
    final fName = file != null ? basename(file!.path) : 'No File Selected';

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('pets')
            .get()
            //      .get()a

            .then((value) {
          petsList = value.docs;
          _nameController.text = petsList.elementAt(pdex)['name'].toString();
          _speciesController.text = petsList.elementAt(pdex)['species'].toString();
          _ageController.text = petsList.elementAt(pdex)['age'].toString();
          _weightController.text = petsList.elementAt(pdex)['weight'].toString();
          _colorController.text = petsList.elementAt(pdex)['color'].toString();
          _sexController.text = petsList.elementAt(pdex)['sex'].toString();

          _breedController.text = petsList.elementAt(pdex)['breed'].toString();
          _fixedController.text = petsList.elementAt(pdex)['fixed'].toString();


          print('farts ' + petsList.elementAt(0)['name'].toString());
        }),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Pet Details'),
            ),
            body: Card( child:SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 40.0, right: 40.0, bottom: 20.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Name',
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
                        controller: _nameController,
                           onChanged: (String value) {
                               name = value;
                             },
                        onSaved: (String? value) {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,

                        decoration: InputDecoration(
                          labelText: 'species',
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
                        controller: _speciesController,
                        onChanged: (String value) {
                          name = value;
                        },
                        onSaved: (String? value) {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Sex',
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
                        controller: _sexController,
                        onChanged: (String value) {
                          name = value;
                        },
                        keyboardType: TextInputType.text,
                        onSaved: (String? value) {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
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
                        controller: _ageController,
                        onChanged: (String value) {
                          name = value;
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
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Weight',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
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
                        controller: _weightController,
                        onChanged: (String value) {
                          name = value;
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
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Color',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
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
                        controller: _colorController,
                        onChanged: (String value) {
                          name = value;
                        },

                        keyboardType: TextInputType.text,
                        onSaved: (String? value) {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                      child: TextFormField(
                        // The validator receives the text that the user has entered.
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Breed',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
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
                        controller: _breedController,
                        onChanged: (String value) {
                          name = value;
                        },
                        keyboardType: TextInputType.text,
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
                          labelText: 'Fixed/Spayed',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
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
                        controller: _fixedController,
                        onChanged: (String value) {
                          name = value;
                        },


                        keyboardType: TextInputType.text,
                        onSaved: (String? value) {},
                      ),
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
            ), );
        });
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
showAlertDialog(BuildContext context) {
  // set up the buttons

  User? user = FirebaseAuth.instance.currentUser;
  Widget petButton = TextButton(
    child: Text("Pet Parent"),
    onPressed: () async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'profile_type': 'pet'});

      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => CreateProfile(),
      ));
    },
  );
  Widget vetButton = TextButton(
    child: Text("Veterinarian"),
    onPressed: () async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'profile_type': 'vet'});
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => CreateVetProfile(),
      ));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hey!"),
    content: Text("What are you using this App For?"),
    actions: [
      petButton,
      vetButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
