import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'add_pet.dart';
import 'charts.dart';
import 'diet_meds.dart';
import 'edit_pet.dart';
import 'login.dart';
import 'main.dart';
import 'pet_home.dart';
import 'records.dart';
import 'stats_drawer.dart';
import 'edit_profile.dart';

/// This is the stateful widget that the main application instantiates.
/// a
class HomePage extends StatefulWidget {
  int dex;
  int petdex;

  HomePage({Key? key, required this.petdex, required this.dex})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(this.petdex, this.dex);
}

/// This is the private State class that goes with HomePage.
class _HomePageState extends State<HomePage> {
  int dex = 0;
  int petdex = 1;
  User? user = FirebaseAuth.instance.currentUser;
  var petsList;
  var drawerlist = [];
 // String currentPet = 'Meera';
  int _currentIndex = 0;
  final List _children = [];
  var bar = '';
  final Storage storage = Storage();
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

  _HomePageState(this.petdex, this.dex);

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
            .collection('users')
            .doc(user!.uid)
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
              centerTitle: true,
              title: Row(children: [
                const Text('Meerabelle Pet Companion App', style: TextStyle(fontSize:17)),

                FutureBuilder(
                    future: storage.profURL('profile_pic'),
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return Container(

                        margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child:     GestureDetector(
                          onTap: () async {


                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    insetPadding: EdgeInsets.all(80),
                                    title: Text('Edit profile or Logout?'),
                                    content: setuplogouteditContainer(),
                                  );
                                });

                           // Navigator.pushReplacement(
                            //    context, MaterialPageRoute(builder: (context) => EditProfile(pdex:petdex),
                           // ));


                      },
                      child: CircleAvatar(
                      radius: 23.0,
                      backgroundImage:
                      NetworkImage(snapshot.data.toString()),
                      ),
                      ),


                      );
                    }),



              ]),
            ),
            body: SizedBox.expand(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: <Widget>[
                  Container(child: PetHome(curPet: petdex)),
                  Container(child: StatsDrawer(curPet: petdex)),
                  Container(child: MyCharts(petdex:petdex, petlist: drawerlist)),
                  Container(child: DietMeds(curPet: petdex)),
                  Container(child: MyRecords(petdex: petdex, temp: '')),
                ],
              ),
            ),
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
                          Text('Pets'),
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
                                    HomePage(petdex: index, dex: 0),
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
                          title: const Text('Add Pet'),
                          onTap: () {
                            // Update the state of the app
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => AddPet(),
                            ));
                            // Then close the drawer
                            //   Navigator.pop(context);
                          },
                        ),

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
                    title: Text('Home'), icon: const Icon(Icons.home)),
                BottomNavyBarItem(
                    title: const Text('Stats Drawer'),
                    icon: Icon(Icons.linear_scale)),
                BottomNavyBarItem(
                    title: const Text('Charts'), icon: Icon(Icons.add_chart)),
                BottomNavyBarItem(
                    title: const Text('Food/Meds'),
                    icon: Icon(Icons.food_bank)),
                BottomNavyBarItem(
                    title: const Text('Records'), icon: Icon(Icons.assignment)),
              ],
            ),
          );

        });
  }
  poop() async {

  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  Widget setuplogouteditContainer() {
    User? user = FirebaseAuth.instance.currentUser;
    poop();
    return Container(
      height: 200.0, // Change as per your requirement
      width: 100.0, // Change as per your requirement
      child: Scaffold(
        body: Padding(
          // Even Padding On All Sides
          padding: const EdgeInsets.all(10.0),
          child: Card(
              child: ListView(
              children: <Widget>[


                  ListTile(
                    title: Text('Edit Profile'),
                    onTap: () {
                       Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => MyApp(),
                       ));
                    },
                  ),

                ListTile(
                  title: Text('Logout'),
                  onTap: () {
                  _signOut();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => LoginScreen(),
                  ));
                  },
                )
 ]



              )),
        ),
      ),
    );
  }

}

class Storage {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<ListResult> listFiles(drawerlist) async {
    ListResult results =
        await storage.ref('files/' + user!.uid + '/').listAll();
    results.items.forEach((Reference ref) {
      print('Found File : $ref');
    });
    return results;
  }
  Future<String> profURL(String recordName) async {
    String profURL = await storage
        .ref('files/' + user!.uid +'/'+ recordName)
        .getDownloadURL();

    return profURL;
  }
  Future<String> downloadURL(String recordName, drawerlist,petdex) async {
    String downloadURL = await storage
        .ref('files/' + user!.uid + '/' + drawerlist.elementAt(petdex)['name'].toString() + '/' + recordName)
        .getDownloadURL();

    return downloadURL;
  }
}

class Vets {
  late String vuid, vname, address, phone, email; // = '';

}
