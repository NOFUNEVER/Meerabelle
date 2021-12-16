import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';

import 'home_widget.dart';

/// This is a very simple class, used to
/// demo the `SearchPage` package
class Vets {
  String vname, address, email, phone;

  Vets(this.vname, this.address, this.email, this.phone);
}

class VetSearchPage extends StatefulWidget {
  int dex;
  int petdex;

  VetSearchPage({Key? key, required this.petdex, required this.dex})
      : super(key: key);

  @override
  State<VetSearchPage> createState() =>
      _VetSearchPageState(this.petdex, this.dex);
}

class _VetSearchPageState extends State<VetSearchPage> {
  int dex;
  int petdex;
  var vetsList;
  var petsList;
  var drawerlist = [];
  var vetdrawerlist = [];

  _VetSearchPageState(this.petdex, this.dex);

  List<Vets> vets = [];

/*
  static List<Vets> vets = [
    Vets('Mike', 'Barron', '',''),
    Vets('Todd', 'Black', '30',''),
    Vets('Ahmad', 'Edwards', '55',''),
    Vets('Anthony', 'Johnson', '67',''),
    Vets('Annette', 'Brooks', '39',''),
  ];
  */

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('vets').get().then((value) {
          vetsList = value.docs;
          drawerlist = vetsList;

          FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('pets')
              .get()
              .then((val2) {
            petsList = val2.docs;
            vetdrawerlist = petsList;
            print('lololol ');
            print(vetdrawerlist);
          });
          print('s ' + drawerlist.elementAt(0)['name'].toString());
        }),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(title: Text('Search Page'), actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.backspace,
                  color: Colors.white,
                  semanticLabel: 'Back',
                ),
                onPressed: () {
                  // Navigator.of(context).popUntil((route) => route.isFirst);

                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomePage(petdex: 0, dex: 3)));
                },
              ),
            ]),
            body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("vets").snapshots(),
              builder: (context, snapshot) {
                QuerySnapshot? snap = snapshot.data as QuerySnapshot<Object?>?;

                return ListView.separated(
                  itemCount: drawerlist.length - 1,
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black,
                  ),
                  itemBuilder: (context, index) {
                    Vets vet = Vets(
                      drawerlist.elementAt(index)['business name'].toString(),
                      drawerlist.elementAt(index)['Address'].toString(),
                      drawerlist.elementAt(index)['email'].toString(),
                      drawerlist.elementAt(index)['Phone Number'].toString(),
                    );
                    vet.vname =
                        drawerlist.elementAt(index)['business name'].toString();
                    vet.address =
                        drawerlist.elementAt(index)['Address'].toString();

                    return ListTile(
                      title: Text(vet.vname),
                      subtitle: Text(vet.address),
                      trailing: Text(vet.phone),
                      onTap: () {
                        DocumentSnapshot snap = vetsList[index];
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('pets')
                            .doc('Meera')
                            .collection('approved_vets')
                            .doc(snap.id)
                            .set({'role': 'assigned vet'});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Granting ' + vet.vname + ' permission to upload ' + vetdrawerlist.elementAt(petdex)['name'].toString()   + "'s records")),
                        );
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomePage(petdex: petdex, dex: 0),
                        ));
                      //   snap.id});
                      },
                    );
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Search people',
              onPressed: () => showSearch(
                context: context,
                delegate: SearchPage<Vets>(
                  onQueryUpdate: (s) => print(s),
                  items: vets,
                  searchLabel: 'Search people',
                  suggestion: const Center(
                    child: Text('Filter people by  vname, surname or age'),
                  ),
                  failure: const Center(
                    child: Text('No vet found :('),
                  ),
                  filter: (vet) => [
                    vet.vname,
                    vet.address,
                    vet.email,
                    vet.phone,
                  ],
                  builder: (vet) => ListTile(
                    title: Text(vet.vname),
                    subtitle: Text(vet.address),
                    trailing: Text('${vet.phone} no'),
                  ),
                ),
              ),
              child: Icon(Icons.search),
            ),
          );
        });
  }
}
