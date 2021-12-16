import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'charts.dart';
import 'pet_home.dart';
import 'records.dart';
import 'add_pet.dart';
import 'diet_meds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'vet_home.dart';

/// This is the stateful widget that the main application instantiates.
/// a
class VetPage extends StatefulWidget {
  int dex;
  int petdex;

  VetPage({Key? key, required this.petdex, required this.dex}) : super(key: key);

  @override
  State<VetPage> createState() => _VetPageState(this.petdex, this.dex);
}

/// This is the private State class that goes with VetPage.
class _VetPageState extends State<VetPage> {
  int dex = 0;
  int petdex =1;
  User? user = FirebaseAuth.instance.currentUser;


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
  _VetPageState(this.petdex,this.dex);

  static const TextStyle optionStyle =
  TextStyle(fontSize: 29, fontWeight: FontWeight.bold);






  void _onItemTapped(int index) {
    setState(() {
      dex = index;
    });
  }




  @override
  Widget build(BuildContext context) {
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
            Container( child: VetHome(curPet: petdex)),
            Container( child: DietMeds(curPet: petdex)),
            Container(child: MyRecords(petdex:petdex, temp: '')),
          ],
        ),),
      //_widgetOptions.elementAt(dex),







      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Pets'),
            ),
            ListTile(
              title: const Text('Meera'),
              onTap: () {
                // Update the state of the app
                setState(() => petdex = 1);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => VetPage(petdex:petdex,dex:0),
                ));
                // Update the state of the
                //    Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Lilith'),
              onTap: () {
                setState(() => petdex = 0);
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => VetPage(petdex:0,dex:0),
                ));
                // Update the state of the app



                // Then close the drawer
                //   Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Add Pet'),
              onTap: () {
                // Update the state of the app
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => AddPet(),
                ));
                // Then close the drawer
                //   Navigator.pop(context);
              },
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
        //  BottomNavyBarItem(
        //      title: Text('Charts'),
       //       icon: Icon(Icons.linear_scale)
      //    ),
          BottomNavyBarItem(
              title: Text('Food/Medication'),
              icon: Icon(Icons.food_bank)
          ),
          BottomNavyBarItem(
              title: Text('Records'),
              icon: Icon(Icons.assignment)
          ),
        ],
      ),

    );
  }


}
