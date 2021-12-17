import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'pdf_view.dart';

class VetRecords extends StatefulWidget {
  final String? temp;
  int petdex;
  VetRecords({Key? key, required this.petdex, required this.temp}) : super(key: key);

  //@override
  @override
  State<VetRecords> createState() => _VetRecordsState(this.petdex, this.temp.toString());
}

class _VetRecordsState extends State<VetRecords> {
  //File? file;
  List? files;
  File? file;
  User? user = FirebaseAuth.instance.currentUser;
  UploadTask? task;
  String temp = '';
  int petdex =0;

  _VetRecordsState(this.petdex, this.temp);



  Widget build(BuildContext context) {
    final fName = file != null ? basename(file!.path) : 'No File Selected';
    final Storage storage = Storage();


    return Scaffold(
      body: Padding(padding:EdgeInsets.all(25.0),
        child: Card(child:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


             Text("Items will not appear in list untill accepted by client"),
            SizedBox(height: 30),

            FutureBuilder(
                future: storage.listFiles(),
                builder:
                    (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    snapshot.data!.items.remove('profile_pic');
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 220,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() => temp = snapshot.data!.items[index].name);

                                },
                                child: Text(snapshot.data!.items[index].name),
                              ),
                            );
                          }),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    snapshot.data!.items.remove('profile_pic');
                    //  return CircularProgressIndicator();
                  }
                  return Container();
                }),
            FutureBuilder(
                future: storage.downloadURL( temp ),

                //future: storage.downloadURL('elim_1.jpg'),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {

                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => PdfView(petdex: petdex,temp: snapshot.data),
                      ));
                    });
                    //  return Container(width:99, height:160,
                    //  child: SfPdfViewer.network(
                    //   snapshot.data!,
                    // ),

                    //Image.network(snapshot.data!,
                    // fit:BoxFit.cover,
                    //)

                    //  );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    //  return CircularProgressIndicator();
                  }
                  return Container();
                }),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () async {
                selectFile();
              },
              child: const Text("Upload ", style: TextStyle(fontSize: 15)),
            ),
            Text(fName, style: const TextStyle(fontSize: 15)),
            task != null ? buildUploadStatus(task!) : Container(),
            const SizedBox(height: 50),
          ],
        ),

        ),
      ),
    );


  }

  Future selectFile() async {


    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      file = files[0];
      setState(() => file);

      // Upload file

      for (var i = 0; i < files.length; i++) {
        final fileName = basename(files[i].path);
        final destination = 'files/' + user!.uid + "/" + '$fileName';
        task = FirebaseApi.uploadFile(destination, files[i]);
        setState(() {});

        if (task == null) return;

        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        print('Download-Link: $urlDownload');
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
    ListResult results = await storage.ref('files/' + user!.uid + '/').listAll();
    results.items.forEach((Reference ref) {
      print('Found File : $ref');
    });
    results.items.remove('profile_pic');
    return results;
  }

  Future<String> downloadURL(String recordName) async {
    String downloadURL = await storage.ref('files/' + user!.uid + '/' + recordName).getDownloadURL();


    return downloadURL;

  }


}