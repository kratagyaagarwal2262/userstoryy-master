import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _database = FirebaseDatabase.instance.reference();
  final _firestoreDatabase = FirebaseFirestore.instance;
  final tilesList = <Map<String, dynamic>>[];
  int databaseLength = 2;

  final User _user = FirebaseAuth.instance.currentUser!;
  var child;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Story"),
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      'product',
                    );
                  },
                  child: Text("Add Product"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Text("LogOut"),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            // StreamBuilder(
            //     stream:
            //         _firestoreDatabase.collection("${_user.uid}").snapshots(),
            //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //       if (!snapshot.hasData) {
            //         return Container(
            //           child: Center(child: Text("NO DATA YET.")),
            //         );
            //       } else {
            //         return Expanded(
            //           flex: 1,
            //           child: ListView(
            //             shrinkWrap: true,
            //             children: List.generate(
            //               snapshot.data!.docs.length,
            //               (index) => ListTile(
            //                 leading: Image.asset('assets/images/Google.png'),
            //                 title: Text(
            //                   snapshot.data!.docs[index]["name"],
            //                   style: Theme.of(context).textTheme.bodyText2,
            //                 ),
            //                 trailing: Text(
            //                     snapshot.data!.docs[index]["price"].toString()),
            //                 subtitle:
            //                     Text(snapshot.data!.docs[index]["description"]),
            //               ),
            //             ),
            //           ),
            //         );
            //       }
            //     }),
            Expanded(
              flex: 1,
              child: PaginateFirestore(
                itemBuilderType: PaginateBuilderType.listView,
                itemBuilder: (BuildContext context, snapshot, index) {
                  return ListTile(
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                        maxWidth: 64,
                        maxHeight: 64,
                      ),
                      child: snapshot[index]["image url "] == null
                          ? Image.network(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                            )
                          : Image.network(
                              snapshot[index]["image url "].toString(),
                            ),
                    ),
                    title: Text(
                      snapshot[index]["name"],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    trailing: Text(snapshot[index]["price"].toString()),
                    subtitle: Text(snapshot[index]["description"]),
                  );
                },
                query: _firestoreDatabase.collection("${_user.uid}"),
                isLive: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    /*_streamSubscription.cancel();*/
    super.deactivate();
  }
}
