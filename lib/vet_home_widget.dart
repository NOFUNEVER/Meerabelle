import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meerabelle/client_search.dart';
import 'edit_pet.dart';
import 'vet_records.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'vet_home.dart';
import 'vet_diet_meds.dart';

/// This is the stateful widget that the main application instantiates.
/// a
class VetPage extends StatefulWidget {
  int dex;
  int petdex;
  String? client;

  VetPage({Key? key, required this.petdex, required this.dex, required this.client}) : super(key: key);

  @override
  State<VetPage> createState() => _VetPageState(this.petdex, this.dex, this.client);
}

/// This is the private State class that goes with VetPage.
class _VetPageState extends State<VetPage> {
  int dex = 0;
  int petdex =1;
  String? client ="";
  User? user = FirebaseAuth.instance.currentUser;
  var petsList;
  var drawerlist = [];

  String currentPet='Meera';
  int _currentIndex = 0;
  final List _children = [];



  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  _VetPageState(this.petdex,this.dex,this.client);

  static const TextStyle optionStyle =
  TextStyle(fontSize: 29, fontWeight: FontWeight.bold);






  void _onItemTapped(int index) {
    setState(() {
      dex = index;
    });
  }




  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('vets')
            .doc(user!.uid)
            .collection('clients')
            .doc(client)
            .collection('pets')
            .get()
        //      .get()a

            .then((value) {
          petsList = value.docs;

          drawerlist = petsList;

          print('s ' + drawerlist.elementAt(petdex)['name'].toString());
        }),
        builder: (context, snapshot) {



    return Scaffold(
      appBar: AppBar(
        title: const Text('Meerabelle'),
      ),
      body:    SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container( child: VetHome(curPet: petdex, client: client)),
            Container(child: VetRecords(petdex:petdex, temp: '')),
            Container( child: VetDietMeds(curPet: petdex)),
            Container( child: ClientSearchPage(dex:dex ,petdex: petdex)),
          ],
        ),),
      //_widgetOptions.elementAt(dex),







      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.

        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Column(
          children: <Widget>[
            //    Expanded(
            Container(
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const <Widget>[
                    Text('Client Pets'),
                  ],
                ),
              ),
              color: Colors.blueAccent,
            ), // Divider //

            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black,
                ),
                itemCount: drawerlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return Ink(
                    color: true ? Colors.lightBlueAccent : null,
                    //    children: <Widget>[
                    child: ListTile(
                      title: Text(drawerlist.elementAt(index)['name']),
                      onTap: () {
                        setState(() => petdex = index);
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              VetPage(petdex: index, dex: 0,client:client),
                        ));
                        // Navigator.pop(context);

                        // Update the state of the
                        //    Navigator.pop(context);
                      },
                    ),
                  );
                },
                padding: EdgeInsets.only(top: 0),
              ),
            ),

            Expanded(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.only(top: 0),
                children: [

                  ListTile(
                    tileColor: Colors.lightGreen,
                    title: const Text('Edit Pet'),
                    onTap: () {
                      // Update the state of the app
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditPet(pdex: petdex),
                      ));
                      // Then close the drawer
                      //   Navigator.pop(context);
                    },
                  ),
                  Divider(), //
                ],
              ),
            ),
          ],
        ),
      ),







      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home)
          ),
          BottomNavyBarItem(
              title: Text('Charts'),
              icon: Icon(Icons.linear_scale)
          ),
          BottomNavyBarItem(
              title: Text('Food/Medication'),
              icon: Icon(Icons.food_bank)
          ),
          BottomNavyBarItem(
              title: Text('Clients'),
              icon: Icon(Icons.search)
          ),
        ],
      ),

    );

  });



  }


}
