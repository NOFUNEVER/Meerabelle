import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'vet_home_widget.dart';
import 'vet_home.dart';

import 'home_widget.dart';

/// This is a very simple class, used to
/// demo the `SearchPage` package
class Clients {
  String cname, clname, phone;

  Clients(this.cname, this.clname, this.phone);
}

class ClientSearchPage extends StatefulWidget {
  int dex;
  int petdex;

  ClientSearchPage({Key? key, required this.petdex, required this.dex})
      : super(key: key);

  @override
  State<ClientSearchPage> createState() =>
      _ClientSearchPageState(this.petdex, this.dex);
}

class _ClientSearchPageState extends State<ClientSearchPage> {
  int dex;
  int petdex;
  var vetsList;
  var petsList;
  var drawerlist = [];
  var vetdrawerlist = [];
  var clientlist = [];

  _ClientSearchPageState(this.petdex, this.dex);

  List<Clients> clients = [];

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('vets')
            .doc(user!.uid)
            .collection("clients")
            .get()
            .then((value) {
          clientlist = value.docs;
          drawerlist = clientlist;

          print(clientlist[0].id);
          FirebaseFirestore.instance
              .collection('vets')
              .doc(user!.uid)
              .collection('clients')
              .doc(clientlist.elementAt(0).id)
              .collection("pets")
              .get()
              .then((val2) {
            petsList = val2.docs;
            vetdrawerlist = petsList;
            print('lololol ');
            print(vetdrawerlist);
          });
          print(' ' + drawerlist.elementAt(0)['name'].toString());
        }),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(title: Text('Client Lookup'), actions: <Widget>[
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
                  stream: FirebaseFirestore.instance
                      .collection("vets")
                      .doc(user!.uid)
                      .collection("clients")
                      .snapshots(),
                  builder: (context, snapshot) {
                    QuerySnapshot? snap =
                        snapshot.data as QuerySnapshot<Object?>?;

                    return ListView.separated(
                      itemCount: drawerlist.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black,
                      ),
                      itemBuilder: (context, index) {
                        Clients client = Clients(
                          drawerlist.elementAt(index)['First Name'].toString(),
                          drawerlist.elementAt(index)['Last Name'].toString(),
                          drawerlist
                              .elementAt(index)['Phone Number']
                              .toString(),
                        );

                        if (clients.length < drawerlist.length) {
                          clients.add(client);
                        }

                        client.cname = drawerlist
                            .elementAt(index)['First Name']
                            .toString();
                        client.phone = drawerlist
                            .elementAt(index)['Phone Number']
                            .toString();
                        client.clname =
                            drawerlist.elementAt(index)['Last Name'].toString();

                        return ListTile(
                          title: Text(client.cname + " " + client.clname),
//                      subtitle: Text(client.address),
                          trailing: Text(client.phone),
                          onTap: () {

                        DocumentSnapshot snap = clientlist[index];

                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              VetPage(petdex: petdex, dex: 0,client: snap.id),
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
                delegate: SearchPage<Clients>(
                  onQueryUpdate: (s) => print(s),
                  items: clients,
                  searchLabel: 'Search people',
                  suggestion: const Center(
                    child: Text('Filter people by  clientname, surname or age'),
                  ),
                  failure: const Center(
                    child: Text('No clients found :('),
                  ),
                  filter: (client) => [
                    client.cname,
                    client.clname,
                    client.phone,
                  ],
                  builder: (client) => Card( child: ListTile(
                    title: Text(client.cname + ' ' + client.clname),
                    //       subtitle: Text(client.address),
                    trailing: Text('${client.phone}'),
                  ),
                )
                ),
              ),
              child: Icon(Icons.search),
            ),
          );
        });
  }
}
