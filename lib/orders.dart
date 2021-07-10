import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text('ORDERS', style: TextStyle(fontWeight: FontWeight.bold))),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("orders").snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        elevation: 30,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          right: MediaQuery.of(context).size.height * 0.01,
                          left: MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                        color: Theme.of(context).accentColor,
                                        child: ListTile(
                                          title: Text('Order ID',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          subtitle: Text(
                                              snapshot.data
                                                  .docs[index]['orderId']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          trailing: Container(
                                              width: 30,
                                              child: IconButton(
                                                  icon: Icon(Icons.delete,
                                                      size: 32,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('orders')
                                                        .doc(snapshot
                                                                .data.docs[
                                                            index]['orderId'])
                                                        .delete();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        duration: Duration(seconds: 1),
                                                        content: Row(
                                                          children: [
                                                            Icon(Icons.delete),
                                                            SizedBox(width: MediaQuery.of(context).size.height * 0.04),
                                                            Text('Deleted')
                                                          ])));
                                                  })),
                                        )))
                              ],
                            ),
                            ListTile(
                              title: Text('User ID',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              trailing: Text(
                                  snapshot.data.docs[index]['userId']),
                            ),
                            ExpansionTile(
                                title: Text('Item List',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                trailing: Text('TAP TO VIEW'),
                                children: [
                                  for (var i = 0;
                                      i <
                                          snapshot
                                              .data
                                              .docs[index]['itemQty']
                                              .length;
                                      i++)
                                    Row(
                                      children: [
                                        Expanded(
                                            child: ListTile(
                                                title: Text(snapshot
                                                        .data.docs[index]
                                                    ['itemNames'][i]))),
                                        Expanded(
                                            child: ListTile(
                                                title: Text(
                                                    snapshot.data
                                                            .docs[index]
                                                        ['itemQty'][i],
                                                    textAlign:
                                                        TextAlign.center))),
                                        Expanded(
                                            child: ListTile(
                                                title: Text(
                                                    '₹' +
                                                        (double.parse(snapshot
                                                                            .data
                                                                            .docs[index]
                                                                        ['itemPrices']
                                                                    [i]) *
                                                                double.parse(snapshot
                                                                        .data
                                                                        .docs[index]
                                                                    [
                                                                    'itemQty'][i]))
                                                            .toString(),
                                                    textAlign: TextAlign.center)))
                                      ],
                                    )
                                ]),
                            Row(
                              children: [
                                Expanded(
                                    child: ListTile(
                                        title: Text('Items',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)))),
                                Expanded(
                                  child: ListTile(
                                      title: Text(
                                          snapshot
                                              .data
                                              .docs[index]['itemQty']
                                              .length
                                              .toString(),
                                          style: TextStyle(color: Colors.blue),
                                          textAlign: TextAlign.left)),
                                ),
                                Expanded(
                                    child: ListTile(
                                        title: Text('Total',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center))),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                        '₹' +
                                            snapshot.data
                                                .docs[index]['totalPrice']
                                                .toString(),
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ));
                  });
            }));
  }
}
