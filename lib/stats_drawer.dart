import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meerabelle/vet_search.dart';
import 'package:path/path.dart';
import "edit_stats.dart";

class StatsDrawer extends StatefulWidget {
  int curPet;

  StatsDrawer({Key? key, required this.curPet}) : super(key: key);

  @override
  State<StatsDrawer> createState() => _StatsDrawerState(this.curPet);
}

class _StatsDrawerState extends State<StatsDrawer> {
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
  var breed_enable = false;
  var name_enable = false;
  var age_enable = false;
  var sex_enable = false;
  var weight_enable = false;
  var color_enable = false;
  var gluc_enable = false;
  var cre_enable = false;
  var bun_enable = false;
  var bcr_enable = false;
  var phos_enable = false;
  var calc_enable = false;
  var pot_enable = false;
  var sod_enable = false;
  var chol_enable = false;
  var bili_enable = false;
  var glob_enable = false;
  var alb_enable = false;
  var nak_enable = false;
  var prot_enable = false;

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

  _StatsDrawerState(this.curPet);

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
                            height: 87,
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 5.0, top: 10.0, right: 5.0),
                            child: Card(
                              color: Colors.black.withOpacity(.8),
                              //Color(0xFFFFFDE7),
                              elevation: 19,
                              child: GestureDetector(
                                onLongPress: () {
                                  if (gluc_enable == false) {
                                    gluc_enable = true;
                                    setState(() => gluc_enable);
                                  }

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
                                    enabled: gluc_enable,

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
                                      gluc_enable = false;
                                      setState(() => gluc_enable);
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
                                  if (cre_enable == false) {
                                    cre_enable = true;
                                    setState(() => cre_enable);
                                  }

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
                                    enabled: cre_enable,
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
                                      cre_enable = false;
                                      setState(() => cre_enable);
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
                                  if (bun_enable == false) {
                                    bun_enable = true;
                                    setState(() => bun_enable);
                                  }

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
                                    enabled: bun_enable,
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
                                      bun_enable = false;
                                      setState(() => bun_enable);
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
                                  if (bcr_enable == false) {
                                    bcr_enable = true;
                                    setState(() => bcr_enable);
                                  }

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
                                    enabled: bcr_enable,

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
                                      bcr_enable = false;
                                      setState(() => bcr_enable);
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
                                  if (phos_enable == false) {
                                    phos_enable = true;
                                    setState(() => phos_enable);
                                  }

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
                                    enabled: phos_enable,
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
                                      phos_enable = false;
                                      setState(() => phos_enable);
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
                                  if (calc_enable == false) {
                                    calc_enable = true;
                                    setState(() => calc_enable);
                                  }

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
                                    enabled: calc_enable,
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
                                      calc_enable = false;
                                      setState(() => calc_enable);
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
                                if (sod_enable == false) {
                                  sod_enable = true;
                                  setState(() => sod_enable);
                                }

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
                                  enabled: sod_enable,
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
                                    sod_enable = false;
                                    setState(() => sod_enable);
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
                                if (pot_enable == false) {
                                  pot_enable = true;
                                  setState(() => pot_enable);
                                }

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
                                  enabled: pot_enable,
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
                                    pot_enable = false;
                                    setState(() => pot_enable);
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
                                  if (nak_enable == false) {
                                    nak_enable = true;
                                    setState(() => nak_enable);
                                  }

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
                                    enabled: nak_enable,

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
                                      nak_enable = false;
                                      setState(() => nak_enable);
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
                                  if (prot_enable == false) {
                                    prot_enable = true;
                                    setState(() => prot_enable);
                                  }

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
                                    enabled: prot_enable,
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
                                      prot_enable = false;
                                      setState(() => prot_enable);
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
                                  if (alb_enable == false) {
                                    alb_enable = true;
                                    setState(() => alb_enable);
                                  }

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
                                    enabled: alb_enable,
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
                                      alb_enable = false;
                                      setState(() => alb_enable);
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
                                  if (glob_enable == false) {
                                    glob_enable = true;
                                    setState(() => glob_enable);
                                  }

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
                                    enabled: glob_enable,

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
                                      glob_enable = false;
                                      setState(() => glob_enable);
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
                                  if (bili_enable == false) {
                                    bili_enable = true;
                                    setState(() => bili_enable);
                                  }

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
                                    enabled: bili_enable,
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
                                      bili_enable = false;
                                      setState(() => bili_enable);
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
                                  if (chol_enable == false) {
                                    chol_enable = true;
                                    setState(() => chol_enable);
                                  }

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
                                    enabled: chol_enable,
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
                                      chol_enable = false;
                                      setState(() => chol_enable);
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
                              Container(
                                width: 90,
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    bottom: 5.0,
                                    top: 5.0,
                                    right: 2.0),
                                child: ElevatedButton(
                                  onPressed: () async {

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditStats(
                                              curPet: curPet),
                                        ));

                                    // selectFile();
                                  },
                                  child: const Text("Quick Edit ",
                                      style: TextStyle(fontSize: 8)),
                                ),
                              ),
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
                                        species = value;
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
                                width: 90,
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    bottom: 5.0,
                                    top: 5.0,
                                    right: 10.0),
                                child: ElevatedButton(
                                  onPressed: () async {

                                    AlertDialog(
                                      title: Text('Call or Email'),
                                      content: calloremailContainer(context),
                                    );




                                  },
                                  child: const Text("Plot  ",
                                      style: TextStyle(fontSize: 8)),
                                ),
                              ),
                            ]),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _incrementCounter() {}


  calloremailContainer(BuildContext context) {
    // set up the buttons
    String? label;
    User? user = FirebaseAuth.instance.currentUser;
    Widget dateForm = TextFormField(

      textAlign: TextAlign.center,
      decoration: const InputDecoration(labelText: 'Month and Year Label'),
      validator: (value) {
         label = value;
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (String? value) {},
      onChanged:(String value) {
        label =value;

      },
    );
    Widget submitButton = TextButton(
      child: const Text("Plot"),
      onPressed: () async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('creatinine').set(  {label.toString(): double.parse(_creatinineController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('glucose').set({label.toString(): double.parse(_glucoseController.text )},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('BUN').set({label.toString(): double.parse(_bunController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('BUN Creatinine Ratio').set({label.toString(): double.parse(_bcrController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('phosphorus').set({label.toString(): double.parse(_phosphorusController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('calcium').set({label.toString(): double.parse(_calciumController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('sodium').set({label.toString(): double.parse(_sodiumController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('potassium').set({label.toString(): double.parse(_potassiumController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('NA:K Ratio').set({label.toString(): double.parse(_nakController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('total protein').set({label.toString(): double.parse(_protController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('albumin').set({label.toString(): double.parse(_albController.text)},SetOptions(merge : true)   );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('globulin').set({label.toString(): double.parse(_globController.text)},SetOptions(merge : true)   );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(_nameController.text)
            .collection('data')
            .doc('cholesterol').set({label.toString(): double.parse(_cholController.text)} ,SetOptions(merge : true)   );

        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog coe = AlertDialog(
      title: Text("Please Enter  Label Month (string) year(num)"),
      content: dateForm,
      actions: [

        submitButton,
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
