import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'proscreen.dart';
import 'addscreen.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.add_circle, size: 32),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Addscreen()));
                })
          ],
          title:
              Text('PRODUCTS', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("products").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      elevation: 5.0,
                      child: Column(
                        children: [
                          Expanded(
                              child: CachedNetworkImage(
                                  imageUrl: snapshot.data.docs[index]
                                      .data()['Image'])),
                          ListTile(
                              title: Text(
                                  snapshot.data.docs[index].data()['Name']),
                              subtitle: Text('₹' +
                                  snapshot.data.docs[index]
                                      .data()['Price']
                                      .toString()),
                              trailing: Container(
                                width: 25,
                                child: PopupMenuButton(
                                  onSelected: (dynamic value) {
                                    if (value == "Edit") {
                                      print(snapshot.data.docs[index]
                                          .data()['Image']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Proscreen(
                                                  docId: snapshot
                                                      .data.docs[index].id,
                                                  image: snapshot
                                                      .data.docs[index]
                                                      .data()['Image'],
                                                  name: snapshot
                                                      .data.docs[index]
                                                      .data()['Name'],
                                                  price: snapshot
                                                      .data.docs[index]
                                                      .data()['Price']
                                                      .toString(),
                                                  type: snapshot
                                                      .data.docs[index]
                                                      .data()['productType'])));
                                    }
                                    if (value == "Delete")
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                  title: Text('Delete Item',
                                                      textAlign:
                                                          TextAlign.center),
                                                  content: Text(
                                                      'Are you sure you want to delete this item?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "products")
                                                              .doc(snapshot.data
                                                                  .docs[index]
                                                                  .id)
                                                              .delete();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('YES')),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('NO')),
                                                  ]));
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'Edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ));
                });
          }),
    );
  }
}
