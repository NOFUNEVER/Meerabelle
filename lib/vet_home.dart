import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meerabelle/vet_search.dart';
import 'package:path/path.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Clients {
  String cname, address, email, phone;

  Clients(this.cname, this.address, this.email, this.phone);
}

class VetHome extends StatefulWidget {
  int curPet;
  String? client ='';
  VetHome({Key? key, required this.curPet, required this.client}) : super(key: key);

  @override
  State<VetHome> createState() => _VetHomeState(this.curPet, this.client);
}

class _VetHomeState extends State<VetHome> {
  UploadTask? task;
  String? client = '';
  User? user = FirebaseAuth.instance.currentUser;
  int curPet = 0;
  File? file;
  String cur_url = '';
  String cur_age = ' ';
  String cur_weight = '';
  String cur_sex = '';
  String cur_color = '';
  String cur_species = '';
  String cur_status = '';
  String cur_breed = '';
  var breed_enable = false;
  var name_enable = false;
  var age_enable = false;
  var sex_enable = false;
  var weight_enable = false;
  var color_enable = false;
  var drawerlist = [];
  var client_dat;

  List<DocumentSnapshot> petsList = [];
  List<DocumentSnapshot> vetsList = [];
  List? files;
  var breed;
  var name;
  var sex;
  var age;
  var weight;
  var species;
  var color;
  var popcon;
  bool spec_enable = false;
  String t = "";
  var vetyList = [];
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _cnameController = new TextEditingController();
  TextEditingController _speciesController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();
  TextEditingController _breedController = new TextEditingController();
  TextEditingController _colorController = new TextEditingController();
  TextEditingController _weightController = new TextEditingController();
  TextEditingController _sexController = new TextEditingController();
  TextEditingController _fixedController = new TextEditingController();
  late FocusNode speciesFocusNode;

  @override
  initState() {
    super.initState();
    speciesFocusNode = FocusNode();
  }

  final Storage storage = Storage();

  _VetHomeState(this.curPet, this.client);

  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String id = user!.uid;
    final fName = file != null ? basename(file!.path) : 'No File Selected';
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('vets')
            .doc(user.uid)
            .collection('clients')
            .doc(client)
            .collection('pets')
            .get()
            .then((value) {
          petsList = value.docs;
            // print(petsList.elementAt(curPet)['name'].toString());
          drawerlist = petsList;

          FirebaseFirestore.instance
              .collection('vets')
              .doc(user.uid)
              .collection('clients')
              .doc(client).get().then((value) {
              client_dat = value;
              print( ' asdfasdfasfasdfasdfasdfasdfsd'  +         client_dat['First Name'].toString());
          });

          _nameController.text = petsList.elementAt(curPet)['name'].toString();
          _nameController.selection = TextSelection.fromPosition(
              TextPosition(offset: _nameController.text.length));



          _speciesController.text =
              petsList.elementAt(curPet)['species'].toString();
          _speciesController.selection = TextSelection.fromPosition(
              TextPosition(offset: _speciesController.text.length));

          _ageController.text = petsList.elementAt(curPet)['age'].toString();
          _ageController.selection = TextSelection.fromPosition(
              TextPosition(offset: _ageController.text.length));

          _weightController.text =
              petsList.elementAt(curPet)['weight'].toString();
          _weightController.selection = TextSelection.fromPosition(
              TextPosition(offset: _weightController.text.length));

          _colorController.text =
              petsList.elementAt(curPet)['color'].toString();
          _colorController.selection = TextSelection.fromPosition(
              TextPosition(offset: _colorController.text.length));

          _sexController.text = petsList.elementAt(curPet)['sex'].toString();
          _sexController.selection = TextSelection.fromPosition(
              TextPosition(offset: _sexController.text.length));

          _breedController.text =
              petsList.elementAt(curPet)['breed'].toString();
          _breedController.selection = TextSelection.fromPosition(
              TextPosition(offset: _breedController.text.length));

          _fixedController.text =
              petsList.elementAt(curPet)['fixed'].toString();
          _fixedController.selection = TextSelection.fromPosition(
              TextPosition(offset: _fixedController.text.length));

          _cnameController.text =client_dat['First Name'].toString() +" "+ client_dat[ 'Last Name'].toString();
          _cnameController.selection = TextSelection.fromPosition(
              TextPosition(offset: _nameController.text.length));


          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('pets')
              .doc(_nameController.text)
              .collection('approved_vets')
              .get()
              .then((value) async {
            vetsList = value.docs;
          });
        }),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (spec_enable == false) {
                                    spec_enable = true;
                                    setState(() => spec_enable);
                                  }

                                  _speciesController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                          _speciesController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: spec_enable,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Species',
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
                                      species = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _speciesController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      species = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'species': species});
                                      spec_enable = false;
                                      setState(() => spec_enable);
                                    },
                                    onChanged: (String value) {
                                      species = value;
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (breed_enable == false) {
                                    breed_enable = true;
                                    setState(() => breed_enable);
                                  }

                                  _breedController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                          _breedController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: breed_enable,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Breed',
                                      labelStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(18.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(18.0),
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
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      breed = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'breed': breed});
                                      breed_enable = false;
                                      setState(() => breed_enable);
                                    },
                                    onChanged: (String value) {
                                      breed = value;
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 20.0),
                            child: Card(
                              color: Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (color_enable == false) {
                                    color_enable = true;
                                    setState(() => color_enable);
                                  }

                                  _speciesController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                          _speciesController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: color_enable,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Color',
                                      labelStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(18.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 3.0),
                                        borderRadius:
                                        BorderRadius.circular(18.0),
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
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      color = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'color': color});
                                      color_enable = false;
                                      setState(() => color_enable);
                                    },
                                    onChanged: (String value) {
                                      color = value;
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
                                left: 20.0, bottom: 5.0, top: 10.0, right: 7.0),
                            child: Card(
                              color: Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (age_enable == false) {
                                    age_enable = true;
                                    setState(() => age_enable);
                                  }

                                  _ageController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _ageController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: age_enable,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Age',
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
                                      age = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _ageController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      age = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'Age': age});
                                      age_enable = false;
                                      setState(() => age_enable);
                                    },
                                    onChanged: (String value) {
                                      age = value;
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 7.0, bottom: 5.0, top: 10.0, right: 7.0),
                            child: Card(
                              color: Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (weight_enable == false) {
                                    weight_enable = true;
                                    setState(() => weight_enable);
                                  }

                                  _weightController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                          _weightController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: weight_enable,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Weight',
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
                                      weight = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _weightController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      weight = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'weight': weight});
                                      weight_enable = false;
                                      setState(() => weight_enable);
                                    },
                                    onChanged: (String value) {
                                      weight = value;
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 7.0, bottom: 5.0, top: 10.0, right: 20.0),
                            child: Card(
                              color: Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (sex_enable == false) {
                                    sex_enable = true;
                                    setState(() => sex_enable);
                                  }

                                  _sexController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _sexController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: sex_enable,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Sex',
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
                                      sex = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _sexController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      sex = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'sex': sex});
                                      sex_enable = false;
                                      setState(() => sex_enable);
                                    },
                                    onChanged: (String value) {
                                      sex = value;
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
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future: storage.clientURL(
                              'profile_pic', drawerlist, curPet,client),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(.3),
                                      spreadRadius: 5)
                                ],
                              ),
                              margin: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                              child: GestureDetector(
                                onTap: () async {

                                },
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage:
                                  NetworkImage(snapshot.data.toString()),
                                ),
                              ),
                            );
                          }),
                      FutureBuilder(
                          future: storage.petURL(
                              'profile_pic', drawerlist, curPet,client),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(.3),
                                      spreadRadius: 5)
                                ],
                              ),
                              margin: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                              child: GestureDetector(

                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage:
                                  NetworkImage(snapshot.data.toString()),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 30.0, bottom: 40.0, top: 10.0, right: 30.0),
                    child: Card(
                      color: Color(0xFFFFFDE7),
                      elevation: 19,
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Expanded(
                                child: Container(
                                  height: 60,
                                  width: 20,
                                  margin: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 20.0,
                                      right: 20.0,
                                      bottom: 20.0),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      if (name_enable == false) {
                                        name_enable = true;
                                        setState(() => name_enable);
                                      }
                                    },
                                    child: TextFormField(
                                      // The validator receives the text that the user has entered.
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 8),
                                      enabled: name_enable,
                                      decoration: InputDecoration(
                                        labelText: 'Client',
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 3.0),
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 3.0),
                                          borderRadius:
                                          BorderRadius.circular(25.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        name = value;
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      controller: _cnameController,
                                      onChanged: (String value) {
                                        name = value;
                                      },
                                      onFieldSubmitted: (String? value) async {
                                        //  setState(() => species);
                                        name = value;
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user.uid)
                                            .collection('pets')
                                            .doc(petsList
                                            .elementAt(curPet)['name']
                                            .toString())
                                            .update({'name': name});
                                      },
                                      onSaved: (String? value) {},
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    bottom: 5.0,
                                    top: 5.0,
                                    right: 5.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                     selectUpload(  petsList
                                         .elementAt(curPet)['name']
                                         .toString()  , client);

                                  },
                                  child: const Text("Send PDF",
                                      style: TextStyle(fontSize: 8)),
                                ),


                              ),

                              Expanded(
                                child: Container(
                                  height: 55,
                                  width: 20,
                                  margin: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 20.0,
                                      right: 20.0,
                                      bottom: 20.0),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      if (name_enable == false) {
                                        name_enable = true;
                                        setState(() => name_enable);
                                      }
                                    },
                                    child: TextFormField(
                                      // The validator receives the text that the user has entered.
                                      textAlign: TextAlign.center,
                                      enabled: name_enable,
                                      decoration: InputDecoration(
                                        labelText: 'Patient',
                                        labelStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 3.0),
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 3.0),
                                          borderRadius:
                                          BorderRadius.circular(10.0),
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
                                      onFieldSubmitted: (String? value) async {
                                        //  setState(() => species);
                                        name = value;
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user.uid)
                                            .collection('pets')
                                            .doc(petsList
                                            .elementAt(curPet)['name']
                                            .toString())
                                            .update({'name': name});
                                      },
                                      onSaved: (String? value) {},
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ]),
                    ),
                  ),

                  Text(fName, style: const TextStyle(fontSize: 15)),
                  task != null ? buildUploadStatus(task!) : Container(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        });
  }

  void _incrementCounter() {}

  Future currAge() async {
    User? user = FirebaseAuth.instance.currentUser;

  //  print(user!.uid);

    var docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
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
      //    allowMultiple: false,
      //   type: FileType.any,
//      allowedExtensions: ['jpg', 'img', 'jpeg', 'png'],
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
  Future selectUpload(name ,client) async {
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
        final destination = 'files/' + client + "/" + name + '/' + user!.uid + '/' '$fileName';
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

  poop() async {
    var tmp;
    for (int i = 0; i < vetsList.length; i++) {
      tmp = await FirebaseFirestore.instance
          .collection('vets')
          .doc(vetsList.elementAt(i).id)
          .get();

      if (vetyList.length < vetsList.length) {
        vetyList.add(tmp);
      }
    }
  }

  Widget setupVetContactContainer() {
    User? user = FirebaseAuth.instance.currentUser;
    poop();
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Scaffold(
        body: Padding(
          // Even Padding On All Sides
          padding: const EdgeInsets.all(10.0),
          child: Card(
              child: ListView.separated(
                itemCount: vetyList.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black,
                ),
                itemBuilder: (context, index) {
                  //       print(index);
                  //     print(vetyList.elementAt(index).data());

                  Vets vet = Vets(
                    vetyList.elementAt(index)['business name'].toString(),
                    vetyList.elementAt(index)['Address'].toString(),
                    vetyList.elementAt(index)['email'].toString(),
                    vetyList.elementAt(index)['Phone Number'].toString(),
                  );
                  vet.vname = vetyList.elementAt(index)['business name'].toString();
                  vet.address = vetyList.elementAt(index)['Address'].toString();
                  vet.phone = vetyList.elementAt(index)['Phone Number'].toString();
                  return ListTile(
                    title: Text(vet.vname),
                    subtitle: Text(vet.address),
                    trailing: Text(vet.phone),
                    onTap: () {
                      AlertDialog(
                        title: Text('Call or Email'),
                        content: calloremailContainer(context, vet),
                      );
                    },
                  );
                },
              )),
        ),
      ),
    );
  }

  calloremailContainer(BuildContext context, vet) {
    // set up the buttons

    User? user = FirebaseAuth.instance.currentUser;
    Widget callButton = TextButton(
      child: const Text("Call"),
      onPressed: () async {
        print(vet.phone);
        launch("tel://" + vet.phone.toString());
      },
    );
    Widget emailButton = TextButton(
      child: const Text("Email"),
      onPressed: () async {
        final Email email = Email(
          body: 'Hello Dr.',
          subject: 'Email subject',
          recipients: [vet.email],
//          cc: ['cc@example.com'],
          //        bcc: ['bcc@example.com'],
          //      attachmentPaths: ['/path/to/attachment.zip'],
          isHTML: true, //false,
        );

        await FlutterEmailSender.send(email);
      },
    );

    // set up the AlertDialog
    AlertDialog coe = AlertDialog(
      title: Text("How would you like to reach your vet?"),
      content: Text("Call or Email"),
      actions: [
        callButton,
        emailButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return coe;
      },
    );
  }
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

  Future<ListResult> listFiles(drawerlist, petdex) async {
    ListResult results = await storage
        .ref('files/' +
        user!.uid +
        '/' +
        drawerlist.elementAt(petdex)['name'].toString() +
        '/')
        .listAll();
    results.items.forEach((Reference ref) {
      print('Found File : $ref');
    });
    return results;
  }

  Future<String> downloadURL(String recordName, drawerlist, petdex) async {
    String downloadURL = await storage
        .ref('files/' +
        user!.uid +
        '/' +
        drawerlist.elementAt(petdex)['name'].toString() +
        '/' +
        recordName)
        .getDownloadURL();

    return downloadURL;
  }


  Future<String> clientURL(String recordName, drawerlist, petdex,
      client) async {
    String test = 'files/' +
        client +

        '/' +
        recordName;
    //   print ("client url " + test);

    String clientURL = await storage
        .ref('files/' +
        client +

        '/' +
        recordName)
        .getDownloadURL();

    return clientURL;
  }

  Future<String> petURL(String recordName, drawerlist, petdex, client) async {
    String test = 'files/' +
        client +
        '/' +
        drawerlist.elementAt(petdex)['name'].toString() +
        '/' +
        recordName;
    // print ("pet url" + test);

    String petURL = await storage
        .ref('files/' +
        client +
        '/' +
        drawerlist.elementAt(petdex)['name'].toString() +
        '/' +
        recordName)
        .getDownloadURL();

    return petURL;
  }

}
