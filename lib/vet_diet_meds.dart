import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class VetDietMeds extends StatefulWidget {
  int curPet;

  VetDietMeds({Key? key, required this.curPet}) : super(key: key);

  @override
  State<VetDietMeds> createState() => _VetDietMedsState(this.curPet);
}

class _VetDietMedsState extends State<VetDietMeds> {
  UploadTask? task;
  User? user = FirebaseAuth.instance.currentUser;
  int curPet = 0;
  String cur_url = '';
  String cur_age = ' ';
  String cur_weight = '';
  String cur_sex = '';
  String cur_color = '';
  String cur_species = '';
  String cur_status = '';
  String cur_breed = '';
  var food;
  var allergy;
  var meds;
  var meds_enable = false;
  var allergy_enable = false;
  bool food_enable= false;

  late FocusNode _focusNode;
  List<DocumentSnapshot> petsList = [];
  List? files;
  File? file;
  var breed;
  var name;
  var sex;
  var age;
  var weight;
  var species;
  var color;
  var popcon;

  TextEditingController _foodController = new TextEditingController();
  TextEditingController _allergiesController = new TextEditingController();
  TextEditingController _medsController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }
  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }
  final Storage storage = Storage();

  _VetDietMedsState(this.curPet);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String id = user!.uid;

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .get()
        //      .get()a

            .then((value) {
          petsList = value.docs;
          print('farts ' + petsList.elementAt(curPet)['name'].toString());
          _allergiesController.text = petsList.elementAt(curPet)['allergies'].toString();
          _foodController.text = petsList.elementAt(curPet)['food'].toString();
          _medsController.text = petsList.elementAt(curPet)['medications'].toString();

        }),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body:SingleChildScrollView(
              child:

              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                bottom: 5.0,
                                top: 10.0,
                                right: 5.0),
                            child: Card(
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (food_enable == false) {
                                    food_enable = true;
                                    setState(() => food_enable);
                                  }

                                  _foodController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                          _foodController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    focusNode: _focusNode,
                                    autofocus:false ,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () async {
                                      print("edit");


                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'food': food});
                                      food_enable = false;
                                      setState(() => food_enable);

                                    },

                                    // keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: food_enable,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Food',
                                      labelStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      food= value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _foodController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      food = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'food': food});
                                      food_enable = false;
                                      setState(() => food_enable);
                                    },
                                    onChanged: (String value) {
                                      food = value;
                                      //    setValues();
                                    },
                                    onSaved: (String? value) {
                                      //  setValues();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                bottom: 5.0,
                                top: 10.0,
                                right: 5.0),
                            child: Card(
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (allergy_enable == false) {
                                    allergy_enable = true;
                                    setState(() => allergy_enable);
                                  }

                                  _allergiesController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                          _allergiesController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    focusNode: _focusNode,
                                    autofocus:false ,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () async {
                                      print("edit");


                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'food': food});
                                      allergy_enable = false;
                                      setState(() => allergy_enable);

                                    },

                                    // keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: allergy_enable,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Allergies',
                                      labelStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      allergy= value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _allergiesController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      allergy = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'allergies': allergy});
                                      allergy_enable = false;
                                      setState(() => allergy_enable);
                                    },
                                    onChanged: (String value) {
                                      allergy = value;
                                      //    setValues();
                                    },
                                    onSaved: (String? value) {
                                      //  setValues();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                bottom: 5.0,
                                top: 10.0,
                                right: 5.0),
                            child: Card(
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (meds_enable == false) {
                                    meds_enable = true;
                                    setState(() => meds_enable);
                                  }

                                  _medsController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                          _medsController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    focusNode: _focusNode,
                                    autofocus:false ,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () async {
                                      print("edit");


                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'food': food});
                                      meds_enable = false;
                                      setState(() => meds_enable);

                                    },

                                    // keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: meds_enable,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Medications',
                                      labelStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      meds= value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _medsController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      meds = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'medications': meds});
                                      meds_enable = false;
                                      setState(() => meds_enable);
                                    },
                                    onChanged: (String value) {
                                      meds = value;
                                      //    setValues();
                                    },
                                    onSaved: (String? value) {
                                      //  setValues();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.

                          User? user = FirebaseAuth.instance.currentUser;
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('pets')
                              .doc(petsList
                              .elementAt(curPet)['name']
                              .toString())
                              .update({'food': food});
                          food_enable = false;
                          setState(() => food_enable);

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('pets')
                              .doc(petsList
                              .elementAt(curPet)['name']
                              .toString())
                              .update({'medications': meds});
                          meds_enable = false;
                          setState(() => meds_enable);

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('pets')
                              .doc(petsList
                              .elementAt(curPet)['name']
                              .toString())
                              .update({'allergies': allergy});
                          allergy_enable = false;
                          setState(() => allergy_enable);

                        },
                        child: const Text('Submit'),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FutureBuilder(
                            future: storage.downloadURL('profile_pic'),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              return Container(
                                margin: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    selectFile(petsList
                                        .elementAt(curPet)['name']
                                        .toString()); //do what you want here
                                  },
                                  child: CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage:
                                    NetworkImage(snapshot.data.toString()),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),

                  ],
                ),
              ),),
          );
        });
  }

  Future currAge() async {
    User? user = FirebaseAuth.instance.currentUser;

    print(user!.uid);

    var docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('pets')
        .doc(petsList.elementAt(curPet)['name'].toString())
        .get()
        .then((value) {
      cur_age = value.data()!['age'];

      print(cur_age);
    });
  }

  Future currWeight() async {
    User? user = FirebaseAuth.instance.currentUser;

    print(user!.uid);

    var docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('pets')
        .doc(petsList.elementAt(curPet)['name'].toString())
        .get()
        .then((value) {
      cur_weight = value.data()!['weight'];

      print(cur_weight);
    });
  }

  Future currSex() async {
    User? user = FirebaseAuth.instance.currentUser;

    print(user!.uid);

    var docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('pets')
        .doc(petsList.elementAt(curPet)['name'].toString())
        .get()
        .then((value) {
      cur_sex = value.data()!['sex'];

      print(cur_sex);
    });
  }

  Future currBreed() async {
    User? user = FirebaseAuth.instance.currentUser;

    print(user!.uid);

    var docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('pets')
        .doc(petsList.elementAt(curPet)['name'].toString())
        .get()
        .then((value) {
      cur_breed = value.data()!['fixed'];

      print(cur_breed);
    });
  }

  Future currStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    print(user!.uid);

    var docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('pets')
        .doc(petsList.elementAt(curPet)['name'].toString())
        .get()
        .then((value) {
      cur_status = value.data()!['breed'];

      print(cur_status);
    });
  }

  Future setValues() async{
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



  }


  Future currColor() async {
    User? user = FirebaseAuth.instance.currentUser;

    print(user!.uid);

    var docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('pets')
        .doc(petsList.elementAt(curPet)['name'].toString())
        .get()
        .then((value) {
      cur_color = value.data()!['color'];

      print(cur_color);
    });
  }

  Future currURL() async {
    User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('pets')
        .doc(petsList.elementAt(curPet)['name'].toString())
        .get()
        .then((value) {
      cur_url = value.data()!['profile_url'];
    });
    setState(() => cur_url);
  }

  Future selectFile(String name) async {
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
    await storage.ref('files/' + user!.uid + '/Meera/').listAll();
    results.items.forEach((Reference ref) {
      print('Found File : $ref');
    });
    return results;
  }

  Future<String> downloadURL(String recordName) async {
    String downloadURL = await storage
        .ref('files/' + user!.uid + '/Meera/' + recordName)
        .getDownloadURL();

    return downloadURL;
  }
}
