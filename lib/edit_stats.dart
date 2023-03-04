import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meerabelle/vet_search.dart';
import 'package:path/path.dart';

class EditStats extends StatefulWidget {
  int curPet;

  EditStats({Key? key, required this.curPet}) : super(key: key);

  @override
  State<EditStats> createState() => _EditStatsState(this.curPet);
}

class _EditStatsState extends State<EditStats> {
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


  List<DocumentSnapshot> petsList = [];
  List? files;
  File? file;
  var TOT_PROT;
  var ALB;
  var breed;
  var name;
  var sex;
  var age;
  var weight;
  var species;
  var color;
  var popcon;
  bool spec_enable = false;
  var BIL,
      GLUC,
      CHOL,
      GLUC_REF,
      CREAT,
      CREAT_REF,
      BUN,
      BUN_REF,
      BUN_CRE_RATIO,
      BUN_CRE_RATIO_REF,
      PHOS,
      PHOS_REF,
      CALCIUM,
      CALCIUM_REF,
      SODIUM_REF,
      POTASSIUM,
      POT_REF,
      NA_K_RATIO,
      NA_K_REF,
      CHLORIDE,
      CHLORIDE_REF;
  var TOT_PROT_REF,
      Globulin,
      ALB_GLOB_RATIO,
      ALT,
      ALP,
      GGT,
      Bilirubin,
      Cholesterol,
      SODIUM,
      NAK,
      Osmolality;

  TextEditingController _protController = new TextEditingController();
  TextEditingController _nakController = new TextEditingController();
  TextEditingController _albController = new TextEditingController();
  TextEditingController _globController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _bilController = new TextEditingController();
  TextEditingController _cholController = new TextEditingController();
  TextEditingController _potassiumController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();

  TextEditingController _glucoseController = new TextEditingController();
  TextEditingController _bunController = new TextEditingController();
  TextEditingController _bcrController = new TextEditingController();
  TextEditingController _phosphorusController = new TextEditingController();
  TextEditingController _calciumController = new TextEditingController();
  TextEditingController _creatinineController = new TextEditingController();
  TextEditingController _sodiumController = new TextEditingController();
  TextEditingController _weightController = new TextEditingController();

  TextEditingController _fixedController = new TextEditingController();
  late FocusNode speciesFocusNode;

  @override
  initState() {
    super.initState();
    speciesFocusNode = FocusNode();
    User? user = FirebaseAuth.instance.currentUser;
  }

  final Storage storage = Storage();

  _EditStatsState(this.curPet);

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
          print('' + petsList.elementAt(curPet)['name'].toString());

          _glucoseController.text =
              petsList.elementAt(curPet)['glucose'].toString();
          _glucoseController.selection = TextSelection.fromPosition(
              TextPosition(offset: _glucoseController.text.length));

          _creatinineController.text =
              petsList.elementAt(curPet)['creatinine'].toString();
          _creatinineController.selection = TextSelection.fromPosition(
              TextPosition(offset: _creatinineController.text.length));

          _bunController.text = petsList.elementAt(curPet)['BUN'].toString();
          _bunController.selection = TextSelection.fromPosition(
              TextPosition(offset: _bunController.text.length));

          _bcrController.text =
              petsList.elementAt(curPet)['BUN Creatinine Ratio'].toString();
          _bcrController.selection = TextSelection.fromPosition(
              TextPosition(offset: _bcrController.text.length));

          _phosphorusController.text =
              petsList.elementAt(curPet)['phosphorus'].toString();
          _phosphorusController.selection = TextSelection.fromPosition(
              TextPosition(offset: _phosphorusController.text.length));

          _calciumController.text =
              petsList.elementAt(curPet)['calcium'].toString();
          _calciumController.selection = TextSelection.fromPosition(
              TextPosition(offset: _calciumController.text.length));

          _sodiumController.text =
              petsList.elementAt(curPet)['sodium'].toString();
          _sodiumController.selection = TextSelection.fromPosition(
              TextPosition(offset: _phosphorusController.text.length));
//
          _potassiumController.text =
              petsList.elementAt(curPet)['potassium'].toString();
          _potassiumController.selection = TextSelection.fromPosition(
              TextPosition(offset: _potassiumController.text.length));

          _nakController.text =
              petsList.elementAt(curPet)['NA:K Ratio'].toString();
          _nakController.selection = TextSelection.fromPosition(
              TextPosition(offset: _nakController.text.length));

          _protController.text =
              petsList.elementAt(curPet)['total protein'].toString();
          _protController.selection = TextSelection.fromPosition(
              TextPosition(offset: _protController.text.length));

          _albController.text =
              petsList.elementAt(curPet)['albumin'].toString();
          _albController.selection = TextSelection.fromPosition(
              TextPosition(offset: _albController.text.length));

          _globController.text =
              petsList.elementAt(curPet)['globulin'].toString();
          _globController.selection = TextSelection.fromPosition(
              TextPosition(offset: _globController.text.length));

          _bilController.text =
              petsList.elementAt(curPet)['bilirubin'].toString();
          _bilController.selection = TextSelection.fromPosition(
              TextPosition(offset: _bilController.text.length));

          _cholController.text =
              petsList.elementAt(curPet)['cholesterol'].toString();
          _cholController.selection = TextSelection.fromPosition(
              TextPosition(offset: _cholController.text.length));

          _ageController.text = petsList.elementAt(curPet)['age'].toString();
          _ageController.selection = TextSelection.fromPosition(
              TextPosition(offset: _ageController.text.length));

          _weightController.text =
              petsList.elementAt(curPet)['weight'].toString();
          _weightController.selection = TextSelection.fromPosition(
              TextPosition(offset: _weightController.text.length));

          _fixedController.text =
              petsList.elementAt(curPet)['fixed'].toString();
          _fixedController.selection = TextSelection.fromPosition(
              TextPosition(offset: _fixedController.text.length));

          _nameController.text = petsList.elementAt(curPet)['name'].toString();
          _nameController.selection = TextSelection.fromPosition(
              TextPosition(offset: _nameController.text.length));
        }),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body:

         //   SingleChildScrollView(
         //     child:

              Column(
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              //Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _glucoseController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                          _glucoseController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.red),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,

                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      suffix: Text('mg/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      filled: false,
                                      labelText: 'Glucose',
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
                                      GLUC = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _glucoseController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      GLUC = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'glucose': GLUC});

                                    },
                                    onChanged: (String value) {
                                      GLUC = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _creatinineController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _creatinineController
                                              .text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.yellow),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      suffix: Text('mg/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Creatinine',
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
                                      CREAT = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _creatinineController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      CREAT = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'creatinine': CREAT});

                                    },
                                    onChanged: (String value) {
                                      CREAT = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 20.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _bunController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _bunController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.green),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      suffix: Text('mg/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'BUN',
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
                                      BUN = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _bunController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      BUN = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'BUN': BUN});

                                    },
                                    onChanged: (String value) {
                                      BUN = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              //Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _bcrController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _bcrController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,

                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'BUN CREAT RATIO',
                                      labelStyle: const TextStyle(
                                        fontSize: 8,
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
                                      BUN_CRE_RATIO = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _bcrController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      BUN_CRE_RATIO = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({
                                        'BUN Creatinine Ratio': BUN_CRE_RATIO
                                      });

                                    },
                                    onChanged: (String value) {
                                      BUN_CRE_RATIO = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _phosphorusController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _phosphorusController
                                              .text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.green),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      suffix: Text('mg/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Phosphorus',
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
                                      PHOS = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _phosphorusController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      PHOS = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'phosphorus': PHOS});

                                    },
                                    onChanged: (String value) {
                                      PHOS = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 20.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {

                                  _calciumController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                          _calciumController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.green),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      suffix: Text('mg/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Calcium',
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
                                      CALCIUM = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _calciumController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      CALCIUM = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'calcium': CALCIUM});

                                    },
                                    onChanged: (String value) {
                                      CALCIUM = value;
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
                      Expanded(
                        child: Container(
                          height: 87,
                          padding: const EdgeInsets.only(
                              left: 20.0, bottom: 5.0, top: 10.0, right: 7.0),
                          child: Card(
                            color: Colors.black.withOpacity(.8),
                            elevation: 19,
                            child: GestureDetector(
                              onLongPress: () {


                                _sodiumController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: _sodiumController.text.length));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    bottom: 7.0,
                                    top: 7.0,
                                    right: 7.0),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.green),
                                  // The validator receives the text that the user has entered.
                                  textAlign: TextAlign.center,
                                  enabled: true,
                                  decoration: InputDecoration(
                                    suffix: Text('mmol/L'),
                                    suffixStyle: TextStyle(
                                        fontSize: 7, color: Colors.white),
                                    fillColor: Colors.white.withOpacity(.6),
                                    filled: false,
                                    labelText: 'Sodium',
                                    labelStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 3.0),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 3.0),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    SODIUM = value;
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: _sodiumController,
                                  onFieldSubmitted: (String? value) async {
                                    //  setState(() => species);
                                    SODIUM = value;
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection('pets')
                                        .doc(petsList
                                        .elementAt(curPet)['name']
                                        .toString())
                                        .update({'sodium': SODIUM});

                                  },
                                  onChanged: (String value) {
                                    SODIUM = value;
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
                      FutureBuilder(
                          future: storage.downloadURL('profile_pic'),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            return Container(
                              height: 87,
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
                              margin: const EdgeInsets.only(
                                  left: 5.0,
                                  bottom: 5.0,
                                  top: 10.0,
                                  right: 5.0),
                              child: GestureDetector(
                                onTap: () async {
                                  selectFile(petsList
                                      .elementAt(curPet)['name']
                                      .toString()); //do what you want here
                                },
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage:
                                  NetworkImage(snapshot.data.toString()),
                                ),
                              ),
                            );
                          }),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 5.0, bottom: 5.0, top: 10.0, right: 20.0),
                          child: Card(
                            color: Colors.black.withOpacity(.8),
                            elevation: 19,
                            child: GestureDetector(
                              onLongPress: () {


                                _potassiumController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                        _potassiumController.text.length));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    bottom: 7.0,
                                    top: 7.0,
                                    right: 7.0),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.yellow),
                                  // The validator receives the text that the user has entered.
                                  textAlign: TextAlign.center,
                                  enabled: true,
                                  decoration: InputDecoration(
                                    suffix: Text('mmol/L'),
                                    suffixStyle: TextStyle(
                                        fontSize: 7, color: Colors.white),
                                    fillColor: Colors.white.withOpacity(.6),
                                    filled: false,
                                    labelText: 'Potassium',
                                    labelStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 3.0),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 3.0),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    POTASSIUM = value;
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: _potassiumController,
                                  onFieldSubmitted: (String? value) async {
                                    //  setState(() => species);
                                    POTASSIUM = value;
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection('pets')
                                        .doc(petsList
                                        .elementAt(curPet)['name']
                                        .toString())
                                        .update({'potassium': POTASSIUM});

                                  },
                                  onChanged: (String value) {
                                    POTASSIUM = value;
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
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              //Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _nakController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _nakController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,

                                    decoration: InputDecoration(
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'NA:K RATIO',
                                      labelStyle: const TextStyle(
                                        fontSize: 12,
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
                                      NAK = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _nakController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      NAK = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'NA:K Ratio': NAK});

                                    },
                                    onChanged: (String value) {
                                      NAK = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _protController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _protController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.green),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      suffix: Text('g/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Total Protein',
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
                                      TOT_PROT = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _protController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      TOT_PROT = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'total protein': TOT_PROT});

                                    },
                                    onChanged: (String value) {
                                      TOT_PROT = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 20.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _albController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _albController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.green),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      suffix: Text('g/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Albumin',
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
                                      ALB = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _albController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      ALB = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'albumin': ALB});

                                    },
                                    onChanged: (String value) {
                                      ALB = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              //Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _globController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _globController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.red),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,

                                    decoration: InputDecoration(
                                      suffix: Text('g/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Globulin',
                                      labelStyle: const TextStyle(
                                        fontSize: 8,
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
                                      Globulin = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _globController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      Globulin = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'globulin': Globulin});

                                    },
                                    onChanged: (String value) {
                                      Globulin = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _bilController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _bilController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.green),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      suffix: Text('mg/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Bilirubin',
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
                                      BIL = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _bilController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      BIL = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'bilirubin': BIL});

                                    },
                                    onChanged: (String value) {
                                      BIL = value;
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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5.0, top: 10.0, right: 20.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {


                                  _cholController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _cholController.text.length));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 7.0,
                                      top: 7.0,
                                      right: 7.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.green),
                                    // The validator receives the text that the user has entered.
                                    textAlign: TextAlign.center,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      suffix: Text('mg/dl'),
                                      suffixStyle: TextStyle(
                                          fontSize: 7, color: Colors.white),
                                      fillColor: Colors.white.withOpacity(.6),
                                      filled: false,
                                      labelText: 'Cholesterol',
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
                                      CHOL = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: _cholController,
                                    onFieldSubmitted: (String? value) async {
                                      //  setState(() => species);
                                      CHOL = value;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('pets')
                                          .doc(petsList
                                          .elementAt(curPet)['name']
                                          .toString())
                                          .update({'cholesterol': CHOL});

                                    },
                                    onChanged: (String value) {
                                      CHOL = value;
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
                  Container(
                    padding: const EdgeInsets.only(
                        left: 40.0, bottom: 40.0, top: 10.0, right: 40.0),
                    child: Card(
                      color: Color(0xFFFFFDE7),
                      elevation: 19,
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 20,
                                  margin: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 20.0,
                                      right: 20.0,
                                      bottom: 20.0),
                                  child: GestureDetector(
                                    onLongPress: () {

                                    },
                                    child: TextFormField(
                                      // The validator receives the text that the user has entered.
                                      textAlign: TextAlign.center,
                                      enabled: true,
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                        labelStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 3.0),
                                          borderRadius:
                                          BorderRadius.circular(25.0),
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
                ],
              ),

         //   ),


          );
        });
  }

  void _incrementCounter() {}








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
