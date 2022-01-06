import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  var counter;
  final database = FirebaseDatabase.instance.reference();
  final _database = FirebaseFirestore.instance;
  late User _user = FirebaseAuth.instance.currentUser!;
  var _description;
  var _price;
  var _url;
  var _name;
  late var imgFile;
  final imgPicker = ImagePicker();

  Future<dynamic> postFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final XFile? imgGallery = await imgPicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    print("Image Location = $imgFile}");
    var reference =
        FirebaseStorage.instance.ref().child(imgGallery!.path).child(fileName);
    var storageTaskSnapshot = await reference.putFile(imgFile);
    print(" downloaded Url = ${storageTaskSnapshot.ref.getDownloadURL()}");
    var dowUrl = await storageTaskSnapshot.ref.getDownloadURL();
    print("The Returned value = $dowUrl");
    return dowUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Your Product"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  scrollPadding: EdgeInsets.all(5.0),
                  decoration: InputDecoration(
                    labelText: "NAME",
                    labelStyle: Theme.of(context).textTheme.headline1,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    _name = value;
                  },
                )),
            SizedBox(
              height: 30.0,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  scrollPadding: EdgeInsets.all(5.0),
                  decoration: InputDecoration(
                    labelText: "DESCRIPTION",
                    labelStyle: Theme.of(context).textTheme.headline1,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    _description = value;
                  },
                )),
            SizedBox(
              height: 30.0,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                  scrollPadding: EdgeInsets.all(5.0),
                  decoration: InputDecoration(
                    labelText: "PRICE",
                    labelStyle: Theme.of(context).textTheme.headline1,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    _price = value;
                  },
                )),
            SizedBox(
              height: 40.0,
            ),
            Center(
              child: Container(
                height: 50.0,
                width: 200.0,
                child: Material(
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        _url = await postFile();
                        print("URL AT LAUNCH = $_url");
                        // final XFile? imgGallery = await imgPicker.pickImage(
                        //     source: ImageSource.gallery, imageQuality: 50);
                        // setState(() {
                        //   imgFile = imgGallery!.path;
                        // });
                        // print("Image Location = $imgFile}");
                        // /*  Navigator.of(context).pop();*/
                      },
                      child: Text("Select Image",
                          style: Theme.of(context).textTheme.headline2),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Center(
              child: Container(
                height: 50.0,
                width: 200.0,
                child: Material(
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          await _database.collection("${_user.uid}").add({
                            "name": _name,
                            "description": _description,
                            "price": _price,
                            "image url ": _url
                          });
                        } catch (e) {
                          print(e);
                        }
                        Navigator.pop(context);
                      },
                      child: Text("Add Product",
                          style: Theme.of(context).textTheme.headline2),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
