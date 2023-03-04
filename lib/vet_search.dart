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
            appBar: AppBar(title: Text('Search Vets'), actions: <Widget>[
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
            body: Padding(
              // Even Padding On All Sides
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection("vets").snapshots(),
                  builder: (context, snapshot) {
                    QuerySnapshot? snap =
                        snapshot.data as QuerySnapshot<Object?>?;

                    return ListView.separated(
                      itemCount: drawerlist.length - 1,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black,
                      ),
                      itemBuilder: (context, index) {
                        Vets vet = Vets(
                          drawerlist
                              .elementAt(index)['business name']
                              .toString(),
                          drawerlist.elementAt(index)['Address'].toString(),
                          drawerlist.elementAt(index)['email'].toString(),
                          drawerlist
                              .elementAt(index)['Phone Number']
                              .toString(),
                        );

                        var contains = vets.where((element) => element.address == vet.address);
                        if(contains.isEmpty) {
                          vets.add(vet);
                        }
                        vet.vname = drawerlist
                            .elementAt(index)['business name']
                            .toString();
                        vet.address =
                            drawerlist.elementAt(index)['Address'].toString();

                        return ListTile(
                          title: Text(vet.vname),
                          subtitle: Text(vet.address),
                          trailing: Text(vet.phone),
                          onTap: () async {
                            DocumentSnapshot snap = vetsList[index];
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('pets')
                                .doc(vetdrawerlist
                                    .elementAt(petdex)
                                    .data()['name'])
                                .collection('approved_vets')
                                .doc(snap.id)
                                .set({'role': 'assigned vet'});
//
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('approved_vets')
                                .doc(snap.id)
                                .set({'role': 'assigned vet'});


                         var dat =   await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid).get().then((val){

                              return val.data();

                            });

                            var dat2 =   await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('pets')
                                .doc(
                                vetdrawerlist
                                    .elementAt(petdex)
                                    .data()['name']

                            ).get().then((val){

                              return val.data();

                            });
                          //  copy(petdex, vetdrawerlist[index]);
                                FirebaseFirestore.instance
                                  .collection('vets')
                                 .doc(snap.id)
                                .collection('clients')
                               .doc(user!.uid)

                             .set(  dat!  );



                            FirebaseFirestore.instance
                                .collection('vets')
                                .doc(snap.id)
                                .collection('clients')
                                .doc(user!.uid)
                                .collection('pets')
                            .doc(  vetdrawerlist
                                .elementAt(petdex)
                                .data()['name'] )

                                .set(  dat2!  );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Granting ' +
                                      vet.vname +
                                      ' permission to upload ' +
                                      vetdrawerlist
                                          .elementAt(petdex)['name']
                                          .toString() +
                                      "'s records")),
                            );
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VetSearchPage(petdex: petdex, dex: 0),
                            ));
                            //   snap.id});
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Search people',
              onPressed: () => showSearch(
                context: context,
                delegate: SearchPage<Vets>(
                  onQueryUpdate: (s) => print(s),
                  items:vets,
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
                  builder: (vet) => Card( child: ListTile(
                    title: Text(vet.vname),
                    subtitle: Text(vet.address),
                    trailing: Text('${vet.phone} no'),
                    onTap: () async {

                      var index = vetsList.indexWhere((element) => element["business name"] == vet.vname);
                      DocumentSnapshot snap = vetsList[index];
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .collection('pets')
                          .doc(vetdrawerlist
                          .elementAt(petdex)
                          .data()['name'])
                          .collection('approved_vets')
                          .doc(snap.id)
                          .set({'role': 'assigned vet'});
//
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .collection('approved_vets')
                          .doc(snap.id)
                          .set({'role': 'assigned vet'});


                      var dat =   await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid).get().then((val){

                        return val.data();

                      });

                      var dat2 =   await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .collection('pets')
                          .doc(
                          vetdrawerlist
                              .elementAt(petdex)
                              .data()['name']

                      ).get().then((val){

                        return val.data();

                      });
                      //  copy(petdex, vetdrawerlist[index]);
                      FirebaseFirestore.instance
                          .collection('vets')
                          .doc(snap.id)
                          .collection('clients')
                          .doc(user!.uid)

                          .set(  dat!  );



                      FirebaseFirestore.instance
                          .collection('vets')
                          .doc(snap.id)
                          .collection('clients')
                          .doc(user!.uid)
                          .collection('pets')
                          .doc(  vetdrawerlist
                          .elementAt(petdex)
                          .data()['name'] )

                          .set(  dat2!  );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Granting ' +
                                vet.vname +
                                ' permission to upload ' +
                                vetdrawerlist
                                    .elementAt(petdex)['name']
                                    .toString() +
                                "'s records")),
                      );
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            VetSearchPage(petdex: petdex, dex: 0),
                      ));
                      //   snap.id});




                    },
                  ),
                ),
                ),
              ),
              child: Icon(Icons.search),
            ),
          );
        });
  }
}

//Modified from
//https://stackoverflow.com/questions/61476761/how-can-i-copy-documents-from-one-collection-to-the-other-only-once-flutter-fire
void copy(int petdex, var vetdrawerlist) async {
  User? user = FirebaseAuth.instance.currentUser;


 // Map<String, dynamic> pet_snap = await FirebaseFirestore.instance
   //   .collection('users')
     // .doc(user!.uid)
   //   .collection('pets')
    //  .doc(vetdrawerlist.elementAt(petdex).data()['name'])
    //  .get()
    //  .then((value) {
   // return value;
//  }) as Map<String, dynamic>;
  var user_snap = await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get()
      .then((value) {
    return value;
  }) ;

  // await FirebaseFirestore.instance
  //     .collection('vets')
  //    .doc(user_snap);




 //await FirebaseFirestore.instance
   //   .collection('vets')
    //  .doc( vetdrawerlist  )
     // .collection("clients")
     //.add(user_snap);
 // await FirebaseFirestore.instance
  //    .collection('vets')
    //  .doc( vetdrawerlist  )
     // .collection("clients")
    //  .doc(user_snap.toString())
     // .collection('pets')
    //  .add(pet_snap);

}
